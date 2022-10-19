import {
  SubscribeMessage,
  WebSocketGateway,
  OnGatewayInit,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
  MessageBody,
} from '@nestjs/websockets';
import { Logger, UnauthorizedException, UseGuards } from '@nestjs/common';
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
  server: Server;
  users: { intra_id: number; socketId: string }[];
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
    this.logger.log(`socket new client ${client.id} connected`);
    this.logger.log(client.handshake.headers.authorization);
    try {
      const decoded = await this.authService.verifyJwt(
        client.handshake.headers.authorization,
      );
      const user = await this.prismaService.users.findUnique({
        where: { intra_id: decoded.sub },
      });
      if (!user) return this.disconnect(client);
      client.join('online');
      console.log(user.intra_id, client);
    } catch (error) {
      console.log('error', error);
      return this.disconnect(client);
    }
  }

  /**
   * handle socket disconnect
   * @param client
   */
  handleDisconnect(client: Socket) {
    this.logger.log(`socket client ${client.id} disconnect`);
  }
  @SubscribeMessage('events')
  handleEvent(@MessageBody() data: any): any {
    this.logger.log(`events data ${data}`);
    return { message: 'done' };
  }

  /**
   * disconnnet socket client
   * @param socket
   */
  private disconnect(socket: Socket) {
    socket.emit('Error', new UnauthorizedException());
    socket.disconnect();
  }
}
