import { Injectable } from "@nestjs/common";
import { Request, Response } from "express";
import {
  CreateConversation,
  DeleteConversation,
  GetConversation,
  LeaveConvesation,
  MessageDTO,
  ToggleMuteUser,
  PaginationDTO,
} from "src/interfaces/user.interface";
import { PrismaService } from "src/prisma/prisma.service";
@Injectable()
export class ChatService {
  constructor(private prismaService: PrismaService) {}

  async getConversation(res: Response, userId: number, conversationId: number) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { AND: [{ id: conversationId }, { members: { some: { userid: userId } } }] },
        include: {
          members: {
            include: {
              users: {
                select: { username: true, intra_id: true, img_url: true, email: true },
              },
            },
          },
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation not found" });
      return res.status(200).json(conversation);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async getConversationMessages(res: Response, userId: number, conversationId: number, query: PaginationDTO) {
    const Pagination = { take: query.pageSize || 20 };
    query.cursor && Object.assign(Pagination, { cursor: { id: query.cursor } });
    try {
      const messages = await this.prismaService.conversation.findFirst({
        where: { AND: [{ id: conversationId }, { members: { some: { userid: userId } } }] },
        select: {
          message: {
            orderBy: { created_at: "desc" },
            include: { members: { select: { users: true } } },
            ...Pagination,
          },
        },
      });
      if (!messages) return res.status(404).json({ messages: "conversation not found" });
      return res.status(200).json(messages);
    } catch (error) {
      console.log(error);

      return res.status(500).json({ message: "server error" });
    }
  }

  async getAllConversation(res: Response, userId: number, query: PaginationDTO) {
    const Pagination = { take: query.pageSize || 20 };
    query.cursor && Object.assign(Pagination, { cursor: { id: query.cursor } });
    try {
      const conversations = await this.prismaService.conversation.findMany({
        ...Pagination,
        where: { members: { some: { userid: userId } } },
        orderBy: { updated_at: "desc" },
        include: {message: {orderBy: {created_at: "desc"}, take: 1}}
      });
      return res.status(200).json(conversations);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }
  async createConversation(res: Response, userId: number, dto: CreateConversation) {
    const members = [userId, ...dto.members];
    try {
      const users = await this.prismaService.users.findMany({
        where: {
          AND: [
            { intra_id: { in: members } },
            { NOT: { blocked_blocked_blockedidTousers: { some: { userid: userId } } } },
            { NOT: { blocked_blocked_useridTousers: { some: { blockedid: userId } } } },
          ],
        },
        select: { intra_id: true },
      });
      if (users.length < 2) return res.status(400).json({ message: "can't create conversation" });
      const ids = users.map((u) => {
        return { userid: u.intra_id };
      });
      if (ids.length === 2) {
        const conversationIsExist = await this.prismaService.conversation.findFirst({
          where: {
            AND: [{ type: "DIRECT" }, { members: { every: { userid: { in: [ids[0].userid, ids[1].userid] } } } }],
          },
          include: {
            members: { include: { users: { select: { username: true, intra_id: true, img_url: true, email: true } } } },
          },
        });
        if (conversationIsExist) return res.status(200).json(conversationIsExist);
      }
      const type = ids.length === 2 ? "DIRECT" : "GROUP";
      const conversation = await this.prismaService.conversation.create({
        data: {
          adminid: userId,
          type,
          title: "test",
          members: {
            createMany: {
              data: ids,
            },
          },
        },
        include: { members: { include: { users: { select: { username: true, intra_id: true, img_url: true, email: true } } } } },
      });
      return res.status(200).json(conversation);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async sendMessage(res: Response, userId: number, dto: MessageDTO) {
    try {
      if (dto.conversationId) {
        const conversation = await this.prismaService.conversation.findFirst({
          where: { AND: [{ id: dto.conversationId }, { members: { some: { userid: userId } } }] },
        });
        if (!conversation) return res.status(400).json({ message: "Bad Request" });
        const newMessage = await this.prismaService.members.update({
          where: { conversationid_userid: { conversationid: conversation.id, userid: userId } },
          data: { message: { create: { message: dto.message, conversationid: conversation.id } } },
        });
        return res.status(200).json(newMessage);
      }
      return res.status(400).json({ message: "Bad Request" });
      // const newMessage = await this.prismaService.message.create({

      // })
      // return res.status(200).json(newMessage);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async toggleMuteUser(res: Response, userId: number, dto: ToggleMuteUser) {
    try {
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async leaveConversation(res: Response, userId: number, dto: LeaveConvesation) {
    try {
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async deleteConversation(res: Response, userId: number, dto: DeleteConversation) {
    try {
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }
}
