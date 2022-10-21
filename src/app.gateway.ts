import {
  SubscribeMessage,
  WebSocketGateway,
  OnGatewayInit,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
  MessageBody,
} from '@nestjs/websockets';
import { Logger, UnauthorizedException } from '@nestjs/common';
import { Socket, Server } from 'socket.io';
import { AuthService } from 'src/auth/auth.service';
import { PrismaService } from './prisma/prisma.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class AppGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  constructor(
    private authService: AuthService,
    private prismaService: PrismaService,
  ) {}

  @WebSocketServer()
  private server: Server;
  private users: { intra_id: number; socketId: string }[] = [];
  private logger: Logger = new Logger('AppGateway');

  /**
   * handle after init socket
   * @param server
   */
  afterInit(server: Server) {
    this.logger.log('AppGateway init');
  }

  /**
   * handle socket connection
   * @param client
   * @param args
   * @returns
   */
  async handleConnection(client: Socket, ...args: any[]) {
    this.logger.log(
      `socket new client ${client.id} connected token ${client.handshake.headers.authorization}`,
    );
    try {
      const decoded = await this.authService.verifyJwt(
        client.handshake.headers.authorization,
      );
      const user = await this.prismaService.users.findUnique({
        where: { intra_id: decoded.sub },
      });
      if (!user) return this.disconnect(client);
      await this.prismaService.users.update({
        where: { intra_id: user.intra_id },
        data: { status: 'ONLINE' },
      });
      await client.join('online');
      this.users.push({ intra_id: user.intra_id, socketId: client.id });

      client.to('online').emit('userChangeStatus', {
        intra_id: user.intra_id,
        status: 'ONLINE',
      });
      client.user = user.intra_id;
    } catch (error) {
      console.log('error', error);
      console.log(`token =====> `, client.handshake.headers.authorization);

      return this.disconnect(client);
    }
  }

  /**
   * handle socket disconnect
   * @param client
   */
  async handleDisconnect(client: Socket) {
    console.log(this.server.sockets.adapter.rooms);
    const userIndex = this.users.findIndex((u) => u.socketId === client.id);
    if (userIndex > -1) {
      const { intra_id } = this.users[userIndex];
      await this.prismaService.users.update({
        where: { intra_id },
        data: { status: 'OFFLINE' },
      });
      this.users.splice(userIndex, 1);
      this.server
        .to('online')
        .emit('userChangeStatus', { intra_id, status: 'OFFLINE' });
    }
    console.log(this.server.sockets.adapter.rooms);
    this.logger.log(`socket client ${client.id} disconnect`);
  }
  // ! for test pleas remove it
  @SubscribeMessage('events')
  handleEvent(client: Socket, data: any): any {
    this.logger.log(`events data ${data.message} ${client.id}`);
    return { message: 'done' };
  }

  /**
   * disconnnet socket client
   * @param socket
   */
  private disconnect(socket: Socket) {
    socket.emit('error', new UnauthorizedException());
    socket.disconnect();
  }
}
