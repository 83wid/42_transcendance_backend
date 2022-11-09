import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer, WsException, WsResponse } from "@nestjs/websockets";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { PrismaService } from "src/prisma/prisma.service";
import { SocketGateway } from "src/socket/socket.gateway";
import { GetConversation, GetMessages, PaginationDTO, SendMessage } from "src/interfaces/user.interface";
import { UseFilters, UsePipes, ValidationPipe } from "@nestjs/common";
import { WSValidationPipe } from "../socket/handleErrors";

@WebSocketGateway()
export class ChatGateway {
  constructor(private chatService: ChatService, private prismaService: PrismaService, private socketGateway: SocketGateway) {}
  @WebSocketServer()
  private server: Server;
  @UsePipes(WSValidationPipe)
  @SubscribeMessage("sendMessage")
  async handleSendMessage(client: Socket, data: SendMessage): Promise<unknown> {
    try {
      if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
      const message = await this.chatService.sendMessage(client.user, data);
      client.to(`chatRoom${data.id}`).emit("newMessage", message);
      return message;
    } catch (error) {
      // console.log(error);
      throw new WsException(error);
    }
  }

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("getConversation")
  async handleGetConversations(client: Socket, data: GetConversation) {
    try {
      const conversation = await this.chatService.getConversation(data.id, data);
      await client.join(`chatRoom_${data.id}`);
      return conversation;
    } catch (error) {
      throw new WsException(error);
    }
  }

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("getConversationMessages")
  async handleGetConversationMessages(client: Socket, data: GetMessages) {
    try {
      if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
      const messages = await this.chatService.getConversationMessages(client.user, data);
      return messages;
    } catch (error) {
      throw new WsException(error);
    }
  }
}
