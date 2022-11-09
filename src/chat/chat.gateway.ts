import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer, WsException, WsResponse } from "@nestjs/websockets";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { PrismaService } from "src/prisma/prisma.service";
import { SocketGateway } from "src/socket/socket.gateway";
import { CreateConversation, GetConversation, GetMessages, PaginationDTO, SendMessage } from "src/interfaces/user.interface";
import { UseFilters, UsePipes, ValidationPipe } from "@nestjs/common";
import { WSValidationPipe } from "../socket/handleErrors";
import { conversation as Conversation, members as Members, users as Users, message as Message } from "@prisma/client";

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
      const message = (await this.chatService.sendMessage(client.user, data)) as Message & { users: Users };
      client.to(`chatRoom_${data.id}`).emit("newMessage", message);
      return message;
    } catch (error) {
      throw new WsException(error);
    }
  }

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("getConversation")
  async handleGetConversations(client: Socket, data: GetConversation) {
    try {
      const conversation = (await this.chatService.getConversation(client.user, data)) as Conversation & {
        members: (Members & { users: Users })[];
      };
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
      const messages = (await this.chatService.getConversationMessages(client.user, data)) as (Message & { users: Users })[];
      return messages;
    } catch (error) {
      throw new WsException(error);
    }
  }

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("createConversation")
  async handleCreateConversation(client: Socket, data: CreateConversation) {
    try {
      const conversation = (await this.chatService.createConversation(client.user, data)) as Conversation & {
        members: (Members & { users: Users })[];
      };
      await client.join(`chatRoom_${conversation.id}`);
      const ids = conversation.members
        .map((m) => this.socketGateway.getSocketIdFromUserId(m.userid))
        .filter((i) => i !== undefined);
      console.log(ids);
      client.to(ids).emit("newConversation", conversation);
      return conversation;
    } catch (error) {
      throw new WsException(error);
    }
  }
}
