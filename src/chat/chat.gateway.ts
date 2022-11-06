import { SubscribeMessage, WebSocketGateway, WebSocketServer } from "@nestjs/websockets";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { PrismaService } from "src/prisma/prisma.service";
import { SocketGateway } from "src/socket/socket.gateway";

@WebSocketGateway()
export class ChatGateway {
  constructor(private chatService: ChatService, private prismaService: PrismaService, private socketGateway: SocketGateway) {}
  @WebSocketServer()
  private server: Server;
  @SubscribeMessage("sendMessage")
  async handleSendMessage(client: Socket, payload: any): Promise<any> {
    try {
      const data = (await this.chatService.sendMessage(client.user, payload)) as { members: {}[]; message: {}[] };
      // const { data, conversation } = res;
      const ids = data.members
        .map((m: { userid: number }) => {
          if (m.userid === client.user) return null;
          const sockeId = this.socketGateway.getSocketIdFromUserId(m.userid);
          return sockeId ? sockeId : null;
        })
        .filter((i: string) => i !== null);
      this.server.to([...ids, client.id]).emit("updateConversations", data);
      client.to(ids).emit("newMessage", data.message[0]);
      return { data: data.message[0] };
    } catch (error) {
      console.log(error);

      return { error };
    }
  }
}