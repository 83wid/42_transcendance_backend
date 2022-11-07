import { Injectable } from "@nestjs/common";
import { Request, Response } from "express";
import {
  CreateConversation,
  DeleteConversation,
  GetConversationBody,
  LeaveConvesation,
  MessageDTO,
  ToggleMuteUser,
  PaginationDTO,
  ConversationDataReturn,
  JoinConversation,
  AddMember,
  addAdminConversation,
  ToggleBanUser,
  ConversationUpdate,
  ConversationParam,
} from "src/interfaces/user.interface";
import { PrismaService } from "src/prisma/prisma.service";
import * as bcrypt from "bcrypt";
import { plainToInstance } from "class-transformer";
import { Prisma, conversation } from "@prisma/client";

@Injectable()
export class ChatService {
  constructor(private prismaService: PrismaService) {}
  private salt = 10;

  // TODO update
  async getConversation(res: Response, userId: number, dto: GetConversationBody & ConversationParam) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { AND: [{ id: dto.id }, { members: { some: { userid: userId, active: true } } }] },
        include: {
          members: {
            include: {
              users: true,
            },
          },
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation not found" });
      if (conversation.password) {
        if (!dto.password || !(await bcrypt.compare(dto.password, conversation.password)))
          return res.status(401).json({ message: "unauthorized" });
      }
      return res.status(200).json(conversation);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }
  // TODO update
  async getConversationMessages(res: Response, userId: number, conversationId: number, query: PaginationDTO) {
    const Pagination = { take: query.pageSize || 20 };
    query.cursor && Object.assign(Pagination, { cursor: { id: query.cursor } });
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
  // TODO update
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
  // ? done
  async createConversation(res: Response, userId: number, dto: CreateConversation) {
    const members = [userId, ...dto.members];
    const title = dto.title || "";
    try {
      const hashPassword = dto.password ? await bcrypt.hash(dto.password, this.salt) : null;
      const users = await this.prismaService.users.findMany({
        where: {
          AND: [
            { intra_id: { in: dto.members } },
            { NOT: { blocked_blocked_blockedidTousers: { some: { userid: userId } } } },
            { NOT: { blocked_blocked_useridTousers: { some: { blockedid: userId } } } },
          ],
        },
        select: { intra_id: true },
      });
      if (!users.length) return res.status(400).json({ message: "can't create conversation" });
      const ids = users.map((u) => {
        return { userid: u.intra_id, isadmin: false };
      });
      ids.push({ userid: userId, isadmin: true });
      const conversation = await this.prismaService.conversation.create({
        data: {
          type: "GROUP",
          title,
          password: hashPassword,
          public: dto.public,
          members: { createMany: { data: ids } },
        },
        include: { members: { include: { users: true } } },
      });
      return res.status(200).json(plainToInstance(ConversationDataReturn, conversation));
      // return res.send(conversation)
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }

  async joinConversation(res: Response, userId: number, dto: JoinConversation) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { id: dto.conversationId, public: true, type: "GROUP" },
      });
      if (!conversation) res.status(404).json({ message: "conversation not found" });
      if (conversation) {
        if (!dto.password) return res.status(404).json({ message: "Permission denied" });
        const passwordMatch = await bcrypt.compare(dto.password, conversation.password);
        if (!passwordMatch) return res.status(404).json({ message: "Permission denied" });
      }
      const join = await this.prismaService.conversation.update({
        where: { id: dto.conversationId },
        data: {
          members: {
            upsert: {
              where: { conversationid_userid: { userid: userId, conversationid: dto.conversationId } },
              create: { userid: userId },
              update: { active: true },
            },
          },
        },
        include: { members: { include: { users: true } } },
      });
      return res.send(plainToInstance(ConversationDataReturn, join));
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async addMember(res: Response, userId: number, dto: AddMember) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { id: dto.conversationId, type: "GROUP", members: { some: { userid: userId, isadmin: true, active: true } } },
      });
      if (!conversation) return res.status(404).json({ message: "conversation not found" });
      const user = await this.prismaService.users.findFirst({
        where: {
          AND: [
            { intra_id: userId },
            { NOT: { blocked_blocked_blockedidTousers: { some: { userid: userId } } } },
            { NOT: { blocked_blocked_useridTousers: { some: { blockedid: userId } } } },
          ],
        },
      });
      if (!user) return res.status(404).json({ message: "user nout found" });
      const update = await this.prismaService.conversation.update({
        where: { id: conversation.id },
        data: {
          members: {
            upsert: {
              where: { conversationid_userid: { userid: dto.userId, conversationid: dto.conversationId } },
              create: { userid: dto.userId },
              update: { active: true },
            },
          },
        },
        include: { members: { include: { users: true } } },
      });
      return res.send(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async updateConversation(res: Response, userId: number, dto: ConversationUpdate & ConversationParam) {
    const { id, password } = dto;
    delete dto.id;
    delete dto.password;
    console.log(dto);

    try {
      if (!Object.keys(dto).length) return res.status(400).json({ message: "Bad Request" });
      if (dto.newPassword) dto.newPassword = await bcrypt.hash(dto.newPassword, this.salt);
      const conversation = await this.prismaService.conversation.findFirst({
        where: { id, type: "GROUP", members: { some: { userid: userId, isadmin: true, active: true } } },
        include: { members: true },
      });
      if (!conversation) return res.status(404).json({ message: "conversation not found" });
      if (conversation.password && (!password || !(await bcrypt.compare(password, conversation.password))))
        return res.status(401).json({ message: "unauthorized" });
      const dataUpdate: Prisma.conversationUpdateInput = {};
      Object.assign(dataUpdate, { password: dto.newPassword, title: dto.title });
      console.log(dto.members);
      if (dto.members) {
        const users = await this.prismaService.users.findMany({
          where: {
            AND: [
              { intra_id: { in: dto.members } },
              { NOT: { blocked_blocked_blockedidTousers: { some: { userid: userId } } } },
              { NOT: { blocked_blocked_useridTousers: { some: { blockedid: userId } } } },
              { NOT: { members: { some: { conversationid: conversation.id } } } },
            ],
          },
          select: { intra_id: true },
        });
        console.log(users);

        const ids = users.map((u) => {
          return { userid: u.intra_id };
        });
        await this.prismaService.conversation.update({
          where: { id: conversation.id },
          data: { members: { create: ids } },
        });
      }
      const update = await this.prismaService.conversation.update({
        where: { id },
        data: { ...dataUpdate },
        include: { members: true },
      });
      return res.send(update);
    } catch (error) {
      console.log(error);

      return res.status(500).json({ message: "server error" });
    }
  }

  async addAdminConversation(res: Response, userId: number, dto: addAdminConversation) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [
            { id: dto.conversationId },
            { type: "GROUP" },
            { members: { some: { userid: userId, isadmin: true } } },
            { members: { some: { userid: dto.userId, active: true, endban: { lt: new Date() }, endmute: { lt: new Date() } } } },
          ],
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation or member not found" });
      const update = await this.prismaService.members.update({
        where: { conversationid_userid: { userid: dto.userId, conversationid: conversation.id } },
        data: { isadmin: true, mute: false, ban: false },
      });
      return res.send(update);
    } catch (error) {
      console.log(error);
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
            { members: { some: { userid: userId, isadmin: true } } },
            { members: { some: { userid: dto.userId, isadmin: false } } },
          ],
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation or member not found" });
      const update = await this.prismaService.members.update({
        where: { conversationid_userid: { conversationid: conversation.id, userid: dto.userId } },
        data: { mute: dto.mute, endmute: dto.muteAt || new Date() },
      });
      return res.status(200).json(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async toggleBanUser(res: Response, userId: number, dto: ToggleBanUser) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [
            { id: dto.conversationId },
            { type: "GROUP" },
            { members: { some: { userid: userId, isadmin: true } } },
            { members: { some: { userid: dto.userId, isadmin: false } } },
          ],
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation or member not found" });
      const update = await this.prismaService.members.update({
        where: { conversationid_userid: { conversationid: conversation.id, userid: dto.userId } },
        data: { ban: dto.ban, endban: dto.banAt || new Date() },
      });
      return res.status(200).json(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async leaveConversation(res: Response, userId: number, dto: LeaveConvesation) {
    try {
      const member = await this.prismaService.members.findUnique({
        where: { conversationid_userid: { conversationid: dto.conversationId, userid: userId } },
      });
      if (!member || !member.active) return res.status(404).json({ message: "conversation not found" });
      const update = await this.prismaService.members.update({
        where: { id: member.id },
        data: { active: false, isadmin: false },
      });
      if (member.isadmin) {
        const admins = await this.prismaService.members.findMany({
          where: { conversationid: dto.conversationId, isadmin: true },
        });
        // ?set new admin
        if (!admins.length) {
          const newAdmin = await this.prismaService.members.findFirst({
            where: { conversationid: dto.conversationId, active: true, ban: false, mute: false },
            orderBy: { created_at: "asc" },
          });
          if (newAdmin) {
            await this.prismaService.members.update({
              where: { id: newAdmin.id },
              data: { isadmin: true },
            });
          }
        }
      }
      return res.status(201).json(update); //.json({ message: "success leave conversation" });
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
