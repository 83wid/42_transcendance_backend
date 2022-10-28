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
        const endGame = await this.prismaService.game.update({
          where: { id: game.id },
          data: { status: 'END', started: false },
          include: {
            players: { include: { users: true }, orderBy: { id: 'asc' } },
          },
        });
        this.server
          .to([endGame.id.toString(), `player${endGame.id.toString()}`])
          .emit('updateGame', endGame);
      }
    } catch (error) {
      console.log(error);
    }
    this.logger.log(`user disconnect ${client.id} user id ${client.user}`);
  }

  @SubscribeMessage('joinWatcher')
  async joinWatcher(client: Socket, payload: { gameId: number }) {
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
    this.server
      .in([gameIdTostring, `player${gameIdTostring}`])
      .emit('countWatchers', {
        total: this.server.sockets.adapter.rooms.get(gameIdTostring).size,
      });
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
        include: {
          players: { include: { users: true }, orderBy: { id: 'asc' } },
        },
      });
      if (game) {
        if (game.players[0].ready && game.players[1].ready) {
          game = await this.prismaService.game.update({
            where: { id: payload.gameId },
            data: { status: 'PLAYING' },
            include: {
              players: { include: { users: true }, orderBy: { id: 'asc' } },
            },
          });
        }
        console.log(game);

        await client.join(`player${game.id.toString()}`);
        this.server.in(`player${game.id.toString()}`).emit('updateGame', game);
      }
    } catch (error) {
      console.log(error);
    }
  }

  @SubscribeMessage('playeGame')
  playeGame(client: Socket, payload: { gameId: number }) {
    client.to(`player${payload.gameId.toString()}`).emit('playeGame');
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
          include: {
            players: { include: { users: true }, orderBy: { id: 'asc' } },
          },
        });
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
      include: {
        players: { include: { users: true }, orderBy: { id: 'asc' } },
      },
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
    console.log(client.user, client.id);
    
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
      const game = await this.prismaService.game.update({
        where: { id: gameId },
        data: {
          players: {
            updateMany: {
              where: { userid: { not: client.user } },
              data: { score: { increment: 1 } },
            },
          },
        },
        include: {
          players: { include: { users: true }, orderBy: { id: 'asc' } },
        },
      });
      this.server
        .in([`player${gameId.toString()}`, gameId.toString()])
        .emit('updateScore', game.players);
    }
  }
}
