import {
  SubscribeMessage,
  WebSocketGateway,
  OnGatewayInit,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
  MessageBody,
} from '@nestjs/websockets';
import { Logger } from '@nestjs/common';
import { Socket, Server } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class AppGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;
  users: number = 0;
  private logger: Logger = new Logger('AppGateway');
  afterInit(server: Server) {
    this.logger.debug('AppGateway init');
  }
  handleConnection(client: Socket, ...args: any[]) {
    this.logger.debug(`socket new client ${client.id} connected`);
  }
  handleDisconnect(client: Socket) {
    this.logger.debug(`socket client ${client.id} disconnect`);
  }

  @SubscribeMessage('events')
  handleEvent(@MessageBody() data: any): any {
    this.logger.debug(`enents data ${data.message}`)
    return {message: 'done'};
  }
}
