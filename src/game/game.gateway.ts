import {
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Socket, Server } from 'socket.io';
import { Logger } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { SocketGateway } from 'src/socket/socket.gateway';

@WebSocketGateway()
export class GameGateway implements OnGatewayDisconnect {
  @WebSocketServer()
  private server: Server;
  private watchers: { gameId: number; socketId: string[] }[];
  private logger: Logger = new Logger('init game gateway');

  constructor(
    private prismaService: PrismaService,
    private socketGateway: SocketGateway,
  ) {}
  /**
   * handle socket desconnect
   * @param client
   */
  async handleDisconnect(client: Socket) {
    // await this.prismaService.users.update({
    //   where: { intra_id: client.user },
    //   data: { status: 'OFFLINE' },
    // });
    console.log(this.server.sockets.adapter.rooms, '<<<<<<<<<<disconnect');
    try {
      const game = await this.prismaService.game.findFirst({
        where: {
          AND: [
            { players: { some: { userid: client.user } } },
            { status: 'PLAYING' },
            { started: true },
          ],
        },
      });
      console.log(game);
      if (game) {
        if (
          this.server.sockets.adapter.rooms.get(`player${game.id.toString()}`)
            ?.size
        )
        this.server.to(`player${game.id.toString()}`).emit('ProblemConnection')
        else await this.prismaService.game.update({
          where: {id: game.id},
          data: {status: 'END', started: false},
        })
      }
    } catch (error) {
      console.log(error);
    }
    this.logger.log(`user disconnect ${client.id} user id ${client.user}`);
  }

  @SubscribeMessage('joinWatcher')
  async joinWatcher(client: Socket, payload: { gameId: number }) {
    this.logger.log('done');
    const gameIdTostring = payload.gameId.toString();
    await client.join(gameIdTostring);
    const countWatchers =
      this.server.sockets.adapter.rooms.get(gameIdTostring).size;
    this.server.in(gameIdTostring).emit('countWatchers', {
      total: countWatchers > 2 ? countWatchers - 2 : 0,
    });
  }

  @SubscribeMessage('leaveWatcher')
  async leaveWatcher(client: Socket, payload: { gameId: number }) {
    const gameIdTostring = payload.gameId.toString();
    await client.leave(gameIdTostring);
    const countWatchers =
      this.server.sockets.adapter.rooms.get(gameIdTostring).size;
    this.server.in(gameIdTostring).emit('countWatchers', {
      total: countWatchers > 2 ? countWatchers - 2 : 0,
    });
  }

  @SubscribeMessage('message')
  handleMessage(client: Socket, payload: any): string {
    this.logger.log(`event message ${client.user} ${payload}`);
    this.server.to('online').emit('userStartGame', { gameId: 22 });

    return 'Hello world!';
  }

  async userStartGame(userId_1: number, userId_2: number) {
    await this.prismaService.users.updateMany({
      where: { OR: [{ intra_id: userId_1 }, { intra_id: userId_2 }] },
      data: { status: 'PLAYING' },
    });
    this.server.to('online').emit('userStartGame', { userId_1 });
    this.server.to('online').emit('userStartGame', { userId_2 });
  }

  @SubscribeMessage('playerReady')
  async playerReady(client: Socket, payload: { gameId: number }) {
    try {
      await this.prismaService.players.updateMany({
        where: { AND: [{ userid: client.user }, { gameid: payload.gameId }] },
        data: { ready: true },
      });
      let game = await this.prismaService.game.findFirst({
        where: { AND: [{ id: payload.gameId }, { NOT: { status: 'END' } }] },
        include: { players: { include: { users: true } } },
      });
      if (game) {
        if (game.players[0].ready && game.players[1].ready) {
          await this.prismaService.game.update({
            where: { id: payload.gameId },
            data: { status: 'PLAYING' },
          });
          game.status = 'PLAYING';
        }
        await client.join(`player${game.id.toString()}`);
        console.log(this.server.sockets.adapter.rooms, '<<<<<<<<<<join game');
        this.server.in(game.id.toString()).emit('updateGame', game);
      }
    } catch (error) {
      console.log(error);
    }
  }

  @SubscribeMessage('reConnection')
  async reConnection(client: Socket, payload: { gameId: number }) {
    try {
      const game = await this.prismaService.game.findFirst({
        where: {
          AND: [
            { id: payload.gameId },
            { players: { some: { userid: client.user } } },
            { status: 'PLAYING' },
          ],
        },
      });
      if (game){
        await client.join(`player${game.id.toString()}`);
        client.to(`player${game.id.toString()}`).emit('ReConnection')
      }
    } catch (error) {
      console.log(error);
    }
  }

  @SubscribeMessage('startGame')
  async startGame(client: Socket, payload: { gameId: number }) {
    try {
      let game = await this.prismaService.game.findFirst({
        where: {
          AND: [
            { id: payload.gameId },
            { players: { some: { userid: client.user } } },
            { NOT: { status: 'END' } },
            { started: false },
          ],
        },
      });
      if (game) {
        game = await this.prismaService.game.update({
          where: { id: game.id },
          data: { started: true, createdat: new Date(), updatedat: new Date() },
          include: { players: { include: { users: true } } },
        });
        // emit to watcher and players
        this.server.in(payload.gameId.toString()).emit('updateGame', game);
      }
    } catch (error) {
      console.log(error);
    }
  }

  @SubscribeMessage('leaveGame')
  async playerLeaveGame(client: Socket, payload: { gameId: number }) {
    const game = await this.prismaService.game.findUnique({
      where: { id: payload.gameId },
      include: { players: { include: { users: true } } },
    });
    this.server.to(payload.gameId.toString()).emit('updateGame', game);
    this.server
      .in(payload.gameId.toString())
      .socketsLeave(payload.gameId.toString());
  }
}
