import {
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Socket, Server } from 'socket.io';
import { Logger } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@WebSocketGateway()
export class GameGateway implements OnGatewayDisconnect {
  @WebSocketServer()
  private server: Server;
  private watchers: { gameId: number; socketId: string[] }[];
  private logger: Logger = new Logger('init game gateway');

  constructor(private prismaService: PrismaService) {}
  /**
   * handle socket desconnect
   * @param client
   */
  handleDisconnect(client: Socket) {
    // await this.prismaService.users.update({
    //   where: { intra_id: client.user },
    //   data: { status: 'OFFLINE' },
    // });
    this.logger.log(`user disconnect ${client.id} user id ${client.user}`);
  }

  @SubscribeMessage('joinWatcher')
  async joinWatcher(client: Socket, payload: { gameId: number }) {
    this.logger.log('done');
    const gameIdTostring = payload.gameId.toString();
    await client.join(gameIdTostring);
    this.server.in(gameIdTostring).emit('countWatchers', {
      total: this.server.sockets.adapter.rooms.get(gameIdTostring).size,
    });
  }

  async leaveWatcher(client: Socket, payload: { gameId: number }) {
    await client.leave(payload.gameId.toString());
  }

  @SubscribeMessage('message')
  handleMessage(client: Socket, payload: any): string {
    this.logger.log(`event message ${client.user} ${payload}`);
    this.server.to('online').emit('userStartGame', { gameId: 22 });

    return 'Hello world!';
  }

  async userStartGame(userId: number) {
    await this.prismaService.users.update({
      where: { intra_id: userId },
      data: { status: 'PLAYING' },
    });
    this.server.to('online').emit('userStartGame', { gameId: 111, userId });
  }
}
