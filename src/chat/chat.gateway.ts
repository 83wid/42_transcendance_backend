import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer, WsException, WsResponse } from "@nestjs/websockets";
import * as bcrypt from "bcrypt";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { SocketGateway } from "src/socket/socket.gateway";
import { PrismaService } from "src/prisma/prisma.service";
import { UsePipes } from "@nestjs/common";
import { WSValidationPipe } from "src/socket/handleErrors";
import { GetConversation } from "src/interfaces/user.interface";

@WebSocketGateway()
export class ChatGateway {
  constructor(private socketGateway: SocketGateway, private prismaService: PrismaService) {}
  @WebSocketServer()
  private server: Server;
  handleMemberJoinRoomChat(userId: number, conversationId: number) {
    const socketId = this.socketGateway.getSocketIdFromUserId(userId);
    if (socketId) this.server.in(socketId).socketsJoin(`chatRoom_${conversationId}`);
  }

  handleUserInRoom(userId: number, conversationId: number) {
    return new Promise((resolve, reject) => {
      const socketId = this.socketGateway.getSocketIdFromUserId(userId);
      if (!socketId) return reject({ message: "unauthorized" });
      if (!this.server.sockets.adapter.socketRooms(socketId).has(`chatRoom_${conversationId}`))
        return reject({ message: "unauthorized" });
      return resolve(socketId);
    });
  }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("loginConversation")
  // async handleLoginConversation(client: Socket, dto: GetConversation) {
  //   try {
  //     const conversation = await this.prismaService.conversation.findFirst({
  //       where: { id: dto.id, active: true, members: { some: { userid: client.user, active: true, ban: false } } },
  //     });
  //     if (conversation.protected && !dto.password) throw new WsException({ message: "unauthorized" });
  //     if (!(await bcrypt.compare(dto.password, conversation.password))) throw new WsException({ message: "unauthorized" });
  //     await client.join(`chatRoom_${dto.id}`);
  //     return { message: "success login conversation" };
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
    // try {
    //   // return await this.
    // } catch (error) {
    //   throw new WsException(error);
    // }
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("sendMessage")
  // async handleSendMessage(client: Socket, data: SendMessage): Promise<unknown> {
  //   try {
  //     console.log(`new message by => ${client.id}`);
  //     if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
  //     const message = (await this.chatService.sendMessage(client.user, data)) as Message & { users: Users };
  //     const members = await this.prismaService.members.findMany({
  //       where: {
  //         conversationid: data.id,
  //         users: {
  //           AND: [
  //             { blocked_blocked_blockedidTousers: { none: { userid: client.user } } },
  //             { blocked_blocked_useridTousers: { none: { blockedid: client.user } } },
  //           ],
  //         },
  //       },
  //     });
  //     const ids = members.map((m) => this.socketGateway.getSocketIdFromUserId(m.userid)).filter((i) => i !== undefined);
  //     client.to(ids).emit("newMessage", message);
  //     return message;
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("getConversation")
  // async handleGetConversations(client: Socket, data: GetConversation) {
  //   try {
  //     const conversation = (await this.chatService.getConversation(client.user, data)) as Conversation & {
  //       members: (Members & { users: Users })[];
  //     };
  //     await client.join(`chatRoom_${data.id}`);
  //     return conversation;
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("getConversationMessages")
  // async handleGetConversationMessages(client: Socket, data: GetMessages) {
  //   try {
  //     if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
  //     const messages = (await this.chatService.getConversationMessages(client.user, data)) as (Message & { users: Users })[];
  //     return messages;
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }

  // // delete it
  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("createConversation")
  // async handleCreateConversation(client: Socket, data: CreateConversation) {
  //   try {
  //     const conversation = (await this.chatService.createConversation(client.user, data)) as Conversation & {
  //       members: (Members & { users: Users })[];
  //     };
  //     await client.join(`chatRoom_${conversation.id}`);
  //     const ids = conversation.members
  //       .map((m) => this.socketGateway.getSocketIdFromUserId(m.userid))
  //       .filter((i) => i !== undefined);
  //     console.log(ids);
  //     client.to(ids).emit("newConversation", conversation);
  //     return conversation;
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("updateConversation")
  // async handleUpdateConversation(client: Socket, data: ConversationUpdate) {
  //   try {
  //     if (!client.rooms.has(`chatRoom_${data.id}`)) throw new WsException("unauthorized");
  //     const update = (await this.chatService.updateConversation(client.user, data)) as Conversation & { members: Members[] };
  //     const ids = update.members.map((m) => this.socketGateway.getSocketIdFromUserId(m.userid)).filter((i) => i !== undefined);
  //     client.to(ids).emit("newConversation", update);
  //     if (data.password) {
  //       this.server.socketsLeave(`chatRoom_${data.id}`);
  //       await client.join(`chatRoom_${data.id}`);
  //     }
  //     return update;
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("leaveConversation")
  // async handleLeaveConversation(client: Socket, data: LeaveConvesation) {
  //   try {
  //     const update = await this.chatService.leaveConversation(client.user, data);
  //     client.to(`chatRoom_${data.id}`).emit("newConversation", update);
  //     await client.leave(`chatRoom_${data.id}`);
  //     return "success leave conversation";
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }

  // @UsePipes(WSValidationPipe)
  // @SubscribeMessage("deleteConversation")
  // async handleDeleteConversation(client: Socket, data: DeleteConversation) {
  //   try {
  //     const update = (await this.chatService.deleteConversation(client.user, data)) as conversation & { members: members[] };
  //     client.to(`chatRoom_${data.id}`).emit("newConversation", update);
  //     this.server.socketsLeave(`chatRoom_${data.id}`);
  //     return "success delete conversation";
  //   } catch (error) {
  //     throw new WsException(error);
  //   }
  // }
}
