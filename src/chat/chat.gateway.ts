import { SubscribeMessage, WebSocketGateway } from "@nestjs/websockets";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { PrismaService } from "src/prisma/prisma.service";

@WebSocketGateway()
export class ChatGateway {
  constructor(private chatService: ChatService, private prismaService: PrismaService) {}
  private server: Server;
  @SubscribeMessage("joinChatRom")
  async handleMessage(client: Socket, payload: any) {
    console.log(`${client.user} join to room chat ${payload}`);
    try {
      const conve = await this.prismaService.conversation.findFirst({
        where: {AND: [{id: payload}, {members: {some: {userid: client.user, active: true}}}]}
      })
      if (conve) client.join(`chatRoom_${payload}`)      
    } catch (error) {
      return {error}
    }
  }

  @SubscribeMessage("sendMessage")
  async handleSendMessage(client: Socket, payload: any): Promise<any> {
    try {
      const data = await this.chatService.sendMessage(client.user, payload);
      client.to(`chatRoom_${payload.conversationId}`).emit('newMessage', data)
      return { data };
    } catch (error) {
      return { error };
    }
  }
}
