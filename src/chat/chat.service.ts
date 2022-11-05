import { Injectable } from "@nestjs/common";
import { Request, Response } from "express";
import { throwError } from "rxjs";
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
        where: { AND: [{ id: conversationId }, { members: { some: { userid: userId, active: true } } }] },
        include: {
          members: {
            include: {
              users: true,
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
    console.log(Pagination);
    
    try {
      const messages = await this.prismaService.conversation
        .findFirst({
          where: { AND: [{ id: conversationId }, { members: { some: { userid: userId } } }] },
        })
        .message({ orderBy: { created_at: "desc" }, include: { members: { select: { users: true } } }, ...Pagination });
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
        where: { members: { some: { userid: userId, active: true } } },
        orderBy: { updated_at: "desc" },
        include: {
          members: { include: { users: true } },
          message: { orderBy: { created_at: "desc" }, take: 1 },
        },
      });
      return res.status(200).json(conversations);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }
  async createConversation(res: Response, userId: number, dto: CreateConversation) {
    const members = [userId, ...dto.members];
    const title = dto.title || "";
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
            AND: [
              { type: "DIRECT" },
              { active: true },
              { members: { every: { userid: { in: [ids[0].userid, ids[1].userid] } } } },
            ],
          },
          include: {
            members: {
              include: {
                users: true,
              },
            },
            message: { orderBy: { created_at: "desc" }, take: 1 },
          },
        });
        if (conversationIsExist) return res.status(200).json(conversationIsExist);
      }
      const type = ids.length === 2 ? "DIRECT" : "GROUP";
      const conversation = await this.prismaService.conversation.create({
        data: {
          adminid: userId,
          type,
          title,
          members: {
            createMany: {
              data: ids,
            },
          },
        },
        include: {
          members: { include: { users: true } },
          message: { orderBy: { created_at: "desc" }, take: 1 },
        },
      });
      return res.status(200).json(conversation);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async sendMessage(userId: number, dto: MessageDTO) {
    return new Promise(async (resolve, reject) => {
      try {
        if (dto.conversationId) {
          const conversation = await this.prismaService.conversation.findFirst({
            where: {
              AND: [
                { id: dto.conversationId },
                { active: true },
                { members: { some: { userid: userId, mute: false, active: true } } },
              ],
            },
            include: { members: { where: { active: true }, include: { users: true } } },
          });
          if (!conversation) return reject({ message: "Bad Request" });
          const newMessage = await this.prismaService.conversation.update({
            where: { id: conversation.id },
            data: {
              members: {
                update: {
                  where: { conversationid_userid: { userid: userId, conversationid: conversation.id } },
                  data: { message: { create: { message: dto.message, conversationid: conversation.id } } },
                },
              },
            },
            include: {
              members: { include: { users: true } },
              message: { include: { members: { select: { users: true } } }, orderBy: { created_at: "desc" }, take: 1 },
            },
          });
          return resolve(newMessage);
        }
        return reject({ message: "Bad Request" });
      } catch (error) {
        return reject({ message: "server error" });
      }
    });
  }

  async toggleMuteUser(res: Response, userId: number, dto: ToggleMuteUser) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [
            { id: dto.conversationId },
            { type: "GROUP" },
            { active: true },
            { adminid: userId },
            { members: { some: { userid: dto.memberId, mute: { not: dto.mute } } } },
          ],
        },
        include: { members: { where: { userid: dto.memberId } } },
      });
      if (!conversation) return res.status(400).json({ message: "Bad Request" });
      const update = await this.prismaService.conversation.update({
        where: { id: conversation.id },
        data: {
          members: {
            update: {
              where: { conversationid_userid: { conversationid: conversation.id, userid: dto.memberId } },
              data: { mute: dto.mute },
            },
          },
        },
        include: {
          members: { include: { users: { select: { username: true, intra_id: true, img_url: true, email: true } } } },
        },
      });
      return res.status(200).json(update);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async leaveConversation(res: Response, userId: number, dto: LeaveConvesation) {
    try {
      // todo change to updateMany
      console.log(dto);

      const conversation = await this.prismaService.conversation.findFirst({
        where: { AND: [{ id: dto.conversationId }, { members: { some: { userid: userId, active: true } } }] },
        // include: {members: {where: {userid: userId}}}
      });
      // return res.status(201).json(conversation);
      if (!conversation) return res.status(400).json({ message: "Bad Request" });
      if (conversation.type === "DIRECT") {
        await this.prismaService.conversation.update({
          where: { id: conversation.id },
          data: {
            active: false,
            members: {
              update: {
                where: { conversationid_userid: { userid: userId, conversationid: conversation.id } },
                data: { active: false },
              },
            },
          },
        });
        // todo emit update
        return res.status(200).json({ message: "success leave conversation" });
      }
      await this.prismaService.members.update({
        where: { conversationid_userid: { conversationid: conversation.id, userid: userId } },
        data: { active: false },
      });
      // await this.prismaService.
      if (conversation.adminid === userId) {
        const findNewAdmin = await this.prismaService.members.findFirst({
          where: { AND: [{ id: conversation.id }, { active: true }] },
        });
        if (findNewAdmin) {
          const updateAdmin = await this.prismaService.conversation.update({
            where: { id: conversation.id },
            data: { adminid: findNewAdmin.userid },
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
          // TODO emit update
          // return res.status(201).json({ message: "success leave conversation" });
        } else {
          await this.prismaService.conversation.update({
            where: { id: conversation.id },
            data: { active: false },
          });
        }
        //TODO if !findNewAdmin set conversation.active false
        // return res.status(201).json(findNewAdmin);
      }
      return res.status(200).json({ message: "success leave conversation" });
    } catch (error) {
      console.log(error);

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
