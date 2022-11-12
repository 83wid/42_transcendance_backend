import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer, WsException, WsResponse } from "@nestjs/websockets";
import * as bcrypt from "bcrypt";
import { ChatService } from "./chat.service";
import { Socket, Server } from "socket.io";
import { SocketGateway } from "src/socket/socket.gateway";
import { PrismaService } from "src/prisma/prisma.service";
import { UsePipes } from "@nestjs/common";
import { WSValidationPipe } from "src/socket/handleErrors";
import { Conversation, GetConversation } from "src/interfaces/user.interface";
import { members, message, conversation, users } from "@prisma/client";

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

  handleEmitNewMessage(message: message) {
    console.log(message);
    const socketId = this.socketGateway.getSocketIdFromUserId(message.senderid);
    this.server.to(`chatRoom_${message.conversationid}`).except(socketId).emit("newMessage", message);
  }

  handleEmitUpdateConversation(update: conversation & { members: members[] }, userId: number) {
    const socketId = this.socketGateway.getSocketIdFromUserId(userId);
    const ids = update.members.map((m) => this.socketGateway.getSocketIdFromUserId(m.userid)).filter((i) => i !== undefined);
    console.log(ids);
    this.server.to(ids).except(socketId).emit("updateConversation", update);
  }

  handleRemoveSocketIdFromRoom(userId: number, conversationId: number) {
    // this.server.in(this.users[userIndex].socketId).disconnectSockets();
    const socketId = this.socketGateway.getSocketIdFromUserId(userId);
    if (socketId) this.server.in(socketId).socketsLeave(`chatRoom_${conversationId}`);
  }

  // handleEmitMultiUsers(list: users[], conversationId: number, userId: number){}

  @UsePipes(WSValidationPipe)
  @SubscribeMessage("leaveChatRoom")
  async handleLeftCahtRoom(client: Socket, dto: Conversation) {
    try {
      await client.leave(`chatRoom_${dto.id}`);
      console.log(`${client.id} success leave chat room ${dto.id}`);
    } catch (error) {
      throw new WsException(error);
    }
  }
}
