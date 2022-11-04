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

  async getConversation(res: Response, userId: number, conversationId: number, query: PaginationDTO) {
    const pageSize = Number(query.pageSize) || 20;
    const cursor = Number(query.cursor) || 1;
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { AND: [{ id: conversationId }, { members: { some: { userid: userId } } }] },
        include: {
          members: {
            include: { users: true, message: { cursor: { id: cursor }, take: pageSize, orderBy: { created_at: "desc" } } },
          },
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation not found" });
      return res.status(200).json(conversation);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async getAllConversation(res: Response, userId: number, conversationId: number, query: PaginationDTO) {
    const pageSize = Number(query.pageSize) || 20;
    const cursor = Number(query.cursor) || 1;
    try {
      const conversations = await this.prismaService.conversation.findMany({
        take: pageSize,
        cursor: { id: cursor },
        where: { members: { some: { userid: userId } } },
        orderBy: { updated_at: "desc" },
      });
      return res.status(200).json(conversations);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async createConversation(res: Response, userId: number, dto: CreateConversation) {
    const members = [userId, ...dto.members];
    try {
      const blockeds = await this.prismaService.users.findMany({
        where: {
          intra_id: { in: members },
        },
        select: {
          blocked_blocked_useridTousers: { where: { blockedid: { in: members } }, select: { userid: true, blockedid: true } },
        },
      });
      const test =[] 
      blockeds.forEach(b => {
        b.blocked_blocked_useridTousers.forEach(t => {
          test.push(t.blockedid)
          test.push(t.userid)
        })
      })
      // if (blockeds.length) return res.status(400).json({ message: "can't create conversation" });
      // const users = await this.prismaService.users.findMany({
      //   where: {
      //     AND: [
      //       { intra_id: { in: members } },
      //       { blocked_blocked_useridTousers: { none: { userid: {in: members} }} },
      //       { blocked_blocked_blockedidTousers:  {none: {userid: {in: members}}}},
      //     ],
      //   },
      //   select: { intra_id: true },
      // });
      return res.status(200).json(test);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async sendMessage(res: Response, userId: number, dto: MessageDTO) {
    try {
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
