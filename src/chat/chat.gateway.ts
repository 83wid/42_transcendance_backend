import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer, WsException, WsResponse } from "@nestjs/websockets";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { PrismaService } from "src/prisma/prisma.service";
import { SocketGateway } from "src/socket/socket.gateway";
import {
  ConversationUpdate,
  CreateConversation,
  DeleteConversation,
  GetConversation,
  GetMessages,
  LeaveConvesation,
  PaginationDTO,
  SendMessage,
} from "src/interfaces/user.interface";
import { UseFilters, UsePipes, ValidationPipe } from "@nestjs/common";
import { WSValidationPipe } from "../socket/handleErrors";
import {
  conversation as Conversation,
  members as Members,
  users as Users,
  message as Message,
  conversation,
  members,
} from "@prisma/client";

@WebSocketGateway()
export class ChatGateway {
  constructor(private chatService: ChatService, private prismaService: PrismaService, private socketGateway: SocketGateway) {}
  @WebSocketServer()
  private server: Server;
  @UsePipes(WSValidationPipe)
  @SubscribeMessage("sendMessage")
  async handleSendMessage(client: Socket, data: SendMessage): Promise<unknown> {
    try {
      console.log(`new message by => ${client.id}`);
      if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
      const message = (await this.chatService.sendMessage(client.user, data)) as Message & { users: Users };
      const members = await this.prismaService.members.findMany({
        where: {
          conversationid: data.id,
          users: {
            AND: [
              { blocked_blocked_blockedidTousers: { none: { userid: client.user } } },
              { blocked_blocked_useridTousers: { none: { blockedid: client.user } } },
            ],
          },
        },
      });
      const ids = members.map((m) => this.socketGateway.getSocketIdFromUserId(m.userid)).filter((i) => i !== undefined);
      client.to(ids).emit("newMessage", message);
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

  // delete it
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

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("updateConversation")
  async handleUpdateConversation(client: Socket, data: ConversationUpdate) {
    try {
      if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
      const update = (await this.chatService.updateConversation(client.user, data)) as Conversation & { members: Members[] };
      const ids = update.members.map((m) => this.socketGateway.getSocketIdFromUserId(m.userid)).filter((i) => i !== undefined);
      client.to(ids).emit("newConversation", update);
      if (data.password) {
        this.server.socketsLeave(`chatRoom_${data.id}`);
        await client.join(`chatRoom_${data.id}`);
      }
      return update;
    } catch (error) {
      throw new WsException(error);
    }
  }

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("leaveConversation")
  async handleLeaveConversation(client: Socket, data: LeaveConvesation) {
    try {
      const update = await this.chatService.leaveConversation(client.user, data);
      client.to(`chatRoom_${data.id}`).emit("newConversation", update);
      await client.leave(`chatRoom_${data.id}`);
      return "success leave conversation";
    } catch (error) {
      throw new WsException(error);
    }
  }

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("deleteConversation")
  async handleDeleteConversation(client: Socket, data: DeleteConversation) {
    try {
      const update = (await this.chatService.deleteConversation(client.user, data)) as conversation & { members: members[] };
      client.to(`chatRoom_${data.id}`).emit("newConversation", update);
      this.server.socketsLeave(`chatRoom_${data.id}`);
      return "success delete conversation";
    } catch (error) {
      throw new WsException(error);
    }
  }

  // hendleEmitNewConversation(ids: number[], conversation: any) {
  //   const SocketIds = ids.map((i) => this.socketGateway.getSocketIdFromUserId(i)).filter((i) => i !== undefined);
  //   this.server.to(SocketIds).emit("newConversation", conversation);
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("leaveChatRoom")
  // handleLeaveChatRoom(client: Socket, data: Conversation) {
  //   client.leave(`chatRoom_${data.id}`);
  // }
}
