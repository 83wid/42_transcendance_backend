import {
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { PrismaService } from 'src/prisma/prisma.service';
import { Server, Socket } from 'socket.io';
import { ReadNotification } from 'src/interfaces/user.interface';
import { SocketGateway } from 'src/socket/socket.gateway';

@WebSocketGateway()
export class NotificationsGateway {
  constructor(private prismaService: PrismaService, private socketGateway: SocketGateway) {}
  @WebSocketServer()
  private server: Server;
  @SubscribeMessage('readNotification')
  async handleMessage(client: Socket, payload: ReadNotification) {
    console.log(client.user);
    try {
      await this.prismaService.notification.update({
        where: { id: payload.id },
        data: { read: true },
      });
    } catch (error) {
      this.server.to(client.id).emit('error_notification', error);
      console.log(error);
    }
  }

  notificationsToUser(notif: {}){
    this.server.emit('nowNotification', notif)
  }
}
