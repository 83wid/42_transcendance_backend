import {
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';
import { Socket, Server } from 'socket.io';
import { Logger } from '@nestjs/common';

@WebSocketGateway()
export class GameGateway implements OnGatewayDisconnect {
  private server: Server;
  private logger: Logger = new Logger('init game gateway');
  /**
   * handle socket desconnect
   * @param client
   */
  handleDisconnect(client: Socket) {
    this.logger.log(`user disconnect ${client.id} user id ${client.user}`);
  }

  @SubscribeMessage('message')
  handleMessage(client: Socket, payload: any): string {
    this.logger.log(`event message ${client.user} ${payload}`);
    this.server.to('online').emit('userStartGame', {gameId: 22})

    return 'Hello world!';
  }
  
  userStartGame(userId: number){
    this.server.to('online').emit('userStartGame', {gameId: 111, userId})
  }

}
