import {
  MessageBody,
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
  private racquetSize: number = 3;
  private planeSize: number = 31;
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
      if (game) {
        if (
          this.server.sockets.adapter.rooms.get(`player${game.id.toString()}`)
            ?.size
        )
          this.server
            .to([`player${game.id.toString()}`, game.id.toString()])
            .emit('ProblemConnection');
        else
          await this.prismaService.game.update({
            where: { id: game.id },
            data: { status: 'END', started: false },
          });
      }
    } catch (error) {
      console.log(error);
    }
    this.logger.log(`user disconnect ${client.id} user id ${client.user}`);
  }

  @SubscribeMessage('joinWatcher')
  async joinWatcher(client: Socket, payload: { gameId: number }) {
    this.logger.log('done', payload.gameId);
    const gameIdTostring = payload.gameId.toString();
    await client.join(gameIdTostring);
    this.server
      .in([gameIdTostring, `player${gameIdTostring}`])
      .emit('countWatchers', {
        total: this.server.sockets.adapter.rooms.get(gameIdTostring).size,
      });
  }

  @SubscribeMessage('leaveWatcher')
  async leaveWatcher(client: Socket, payload: { gameId: number }) {
    const gameIdTostring = payload.gameId.toString();
    await client.leave(gameIdTostring);
    const countWatchers =
      this.server.sockets.adapter.rooms.get(gameIdTostring).size;
    this.server
      .in([gameIdTostring, `player${gameIdTostring}`])
      .emit('countWatchers', {
        total: this.server.sockets.adapter.rooms.get(gameIdTostring).size,
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
        this.server.in(`player${game.id.toString()}`).emit('updateGame', game);
      }
    } catch (error) {
      console.log(error);
    }
  }

  @SubscribeMessage('Connection')
  Connection(client: Socket, payload: { gameId: number }) {
    client.to(`player${payload.gameId.toString()}`).emit('Connection');
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
        console.log('done<<<<<<<<<<<<<<');

        this.server
          .in([payload.gameId.toString(), `player${payload.gameId.toString()}`])
          .emit('updateGame', game);
        this.server
          .in([payload.gameId.toString(), `player${payload.gameId.toString()}`])
          .emit('ballPosition', {
            ballPosition: { x: 0, y: 0 },
            currentStep: { x: 0, y: 1 },
          });
      }
    } catch (error) {
      console.log(error);
    }
  }

  @SubscribeMessage('ballRacquetPosition')
  ballRacquetPosition(
    client: Socket,
    payload: {
      ballPosition: { x: number; y: number };
      currentStep: { x: number; y: number };
      racquetPosition: { x: number; y: number };
      gameId: number;
    },
  ) {
    const { ballPosition, currentStep, racquetPosition, gameId } = payload;
    console.log('ballRacquetPosition done');

    client
      .in([`player${gameId.toString()}`, gameId.toString()])
      .emit('ballPosition', { ballPosition, currentStep });
    client
      .in([`player${gameId.toString()}`, gameId.toString()])
      .emit('racquetPosition', { racquetPosition });
  }

  @SubscribeMessage('leaveGame')
  async playerLeaveGame(client: Socket, payload: { gameId: number }) {
    const game = await this.prismaService.game.findUnique({
      where: { id: payload.gameId },
      include: { players: { include: { users: true } } },
    });
    client
      .to([payload.gameId.toString(), `player${payload.gameId.toString()}`])
      .emit('updateGame', game);
    client.leave(`player${payload.gameId.toString()}`);
  }

  @SubscribeMessage('raquetMove')
  async raquetMove(
    client: Socket,
    payload: { racquet: number; gameId: number; playerIndex: number },
  ) {
    const { racquet, gameId, playerIndex } = payload;
    this.server
      .in([gameId.toString(), `player${gameId.toString()}`])
      .emit('raquetMove', { racquet, playerIndex });
  }

  @SubscribeMessage('gameCalculation')
  async gameCalculation(client: Socket, payload: any) {
    const racquetHalf = this.racquetSize / 2;
    const { ballPosition, racquetPosition, gameId } = payload;
    const userId = this.socketGateway.getUserIdFromSocketId(client.id);
    console.log(
      userId,
      'userId<<<<<<<<<<<<<',
      client.id,
      'SocketId<<<<<<<<<<<<<<<',
    );
    // console.log(
    //   'gameCalculation .>>>',
    //   payload,
    //   this.racquetSize,
    //   this.planeSize,
    //   ballPosition.x >= racquetPosition.x - racquetHalf &&
    //     ballPosition.x <= racquetPosition.x - racquetHalf,
    // );
    if (
      ballPosition.x >= racquetPosition.x - racquetHalf &&
      ballPosition.x <= racquetPosition.x + racquetHalf
    ) {
      let stepX =
        ((racquetPosition.x - racquetHalf + (racquetPosition.x + racquetHalf)) /
          2 -
          ballPosition.x) /
        10;
      this.server
        .in([`player${gameId.toString()}`, gameId.toString()])
        .emit('ballPosition', {
          ballPosition,
          currentStep: { x: stepX, y: -1 },
        });
    } else {
      this.server
        .in([`player${gameId.toString()}`, gameId.toString()])
        .emit('ballPosition', {
          ballPosition: { x: 0, y: 0 },
          currentStep: { x: 0, y: 1 },
        });

      if (userId) {
        // const player = await this.prismaService.players.updateMany({
        //   where: { AND: [{ gameid: gameId }, { userid: { not: userId } }] },
        //   data: { score: { increment: 1 } },
        // });
        console.log(
          userId,
          'userId<<<<<<<<<<<<<',
          client.id,
          'SocketId<<<<<<<<<<<<<<<',
        );
        const game = await this.prismaService.game
          .update({
            where: { id: gameId },
            data: {
              players: {
                updateMany: {
                  where: { userid: { not: userId } },
                  data: { score: { increment: 1 } },
                },
              },
            },
          })
          ?.players({ include: { users: true } });
        this.server
          .in([`player${gameId.toString()}`, gameId.toString()])
          .emit('updateScore', game);
      }
    }
  }
}
