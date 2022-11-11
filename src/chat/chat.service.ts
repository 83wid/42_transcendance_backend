import { Injectable } from "@nestjs/common";
import { Request, Response } from "express";
import {
  CreateConversation,
  DeleteConversation,
  LeaveConvesation,
  MessageDTO,
  ToggleMuteUser,
  PaginationDTO,
  ConversationDataReturn,
  JoinConversation,
  // AddMember,
  ToggleBanUser,
  GetConversation,
  GetMessages,
  // SendMessage,
  ConversationUpdate,
  Conversation,
  addAdminConversation,
} from "src/interfaces/user.interface";
import { PrismaService } from "src/prisma/prisma.service";
import * as bcrypt from "bcrypt";
import { plainToInstance } from "class-transformer";
import { ChatGateway } from "./chat.gateway";
import { Prisma } from "@prisma/client";
@Injectable()
export class ChatService {
  constructor(private prismaService: PrismaService, private chatGateway: ChatGateway) {}
  private salt = 10;

  // TODO update
  async getConversation(res: Response, userId: number, dto: GetConversation & Conversation) {
    try {
      const currentDate = new Date();
      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [{ id: dto.id }, { members: { some: { userid: userId, active: true, ban: false, endban: { lt: currentDate } } } }],
        },
        include: { members: { include: { users: true } } },
      });

      if (!conversation) return res.status(400).json({ message: "conversation not found" });
      if (conversation.protected && !dto.password) return res.status(404).json({ message: "unauthorized" });
      if (conversation.protected && !(await bcrypt.compare(dto.password, conversation.password)))
        return res.status(404).json({ message: "unauthorized" });
      this.chatGateway.handleMemberJoinRoomChat(userId, conversation.id);
      return res.status(201).json(conversation);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }
  // TODO update
  async getConversationMessages(res: Response, userId: number, dto: GetMessages) {
    // Todo check if user socket has room chat
    const Pagination = { take: dto.pageSize || 20 };
    dto.cursor && Object.assign(Pagination, { cursor: { id: dto.cursor } });
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { id: dto.id, members: { some: { userid: userId, active: true, ban: false } } },
      });
      if (!conversation) return res.status(400).json({ messages: "conversation not found" });
      const messages = await this.prismaService.message.findMany({
        where: {
          conversationid: conversation.id,
          users: {
            AND: [
              { blocked_blocked_blockedidTousers: { none: { userid: userId } } },
              { blocked_blocked_useridTousers: { none: { blockedid: userId } } },
            ],
          },
        },
        orderBy: { created_at: "desc" },
        include: { users: true },
        ...Pagination,
      });
      return res.status(200).json(messages);
    } catch (error) {
      console.log(error);

      return res.status(500).json({ message: "server error" });
    }
  }

  // TODO update
  async getAllConversation(res: Response, userId: number, query: PaginationDTO) {
    try {
      const Pagination = { take: query.pageSize || 20 };
      query.cursor && Object.assign(Pagination, { cursor: { id: query.cursor } });
      const currentDate = new Date();
      const conversations = await this.prismaService.conversation.findMany({
        ...Pagination,
        where: { members: { some: { userid: userId, active: true, ban: false, endban: { lt: currentDate } } } },
        orderBy: { updated_at: "desc" },
        include: {
          members: { include: { users: true } },
        },
      });
      return res.status(200).json(conversations);
    } catch (error) {
      return res.status(500).json({ message: "server error" });
    }
  }
  // ? done
  async createConversation(res: Response, userId: number, dto: CreateConversation) {
    // return new Promise(async (resolve, reject) => {
    console.log(dto);

    try {
      const title = dto.title || "";
      var ids = [];
      const hashPassword = dto.password ? await bcrypt.hash(dto.password, this.salt) : null;
      if (dto.members) {
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
        ids =
          users.map((u) => {
            return { userid: u.intra_id, isadmin: false };
          }) || [];
      }
      ids.push({ userid: userId, isadmin: true });
      const conversation = await this.prismaService.conversation.create({
        data: {
          type: "GROUP",
          title,
          password: hashPassword,
          protected: hashPassword ? true : false,
          public: dto.public,
          members: { createMany: { data: ids } },
        },
        include: { members: { include: { users: true } } },
      });
      return res.status(200).json(plainToInstance(ConversationDataReturn, conversation));
      // return res.send(conversation)
    } catch (error) {
      console.log(error);

      return res.status(500).json({ message: "server error" });
    }
    // });
  }

  async joinConversation(res: Response, userId: number, dto: JoinConversation & Conversation) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: { id: dto.id, public: true, type: "GROUP" },
      });
      if (!conversation) res.status(404).json({ message: "conversation not found" });
      if (conversation.protected) {
        if (!dto.password) return res.status(404).json({ message: "Permission denied" });
        const passwordMatch = await bcrypt.compare(dto.password, conversation.password);
        if (!passwordMatch) return res.status(404).json({ message: "Permission denied" });
      }
      const join = await this.prismaService.conversation.update({
        where: { id: dto.id },
        data: {
          members: {
            upsert: {
              where: { conversationid_userid: { userid: userId, conversationid: dto.id } },
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

  async updateConversation(res: Response, userId: number, dto: ConversationUpdate & Conversation) {
    try {
      if (dto.protected && !dto.password) return res.status(401).json({ message: "Bad Request" });
      const conversation = await this.prismaService.conversation.findFirst({
        where: { id: dto.id, type: "GROUP", members: { some: { userid: userId, isadmin: true, active: true } } },
      });
      if (!conversation) return res.status(400).json({ message: "conversation not found" });
      const dataUpdate: Prisma.conversationUpdateInput = {
        protected: dto.protected,
        title: dto.title,
        password: dto.protected ? await bcrypt.hash(dto.password, this.salt) : null,
        public: dto.public,
      };
      if (dto.members) {
        const users = await this.prismaService.users.findMany({
          where: {
            AND: [
              { intra_id: { in: dto.members } },
              { NOT: { blocked_blocked_blockedidTousers: { some: { userid: userId } } } },
              { NOT: { blocked_blocked_useridTousers: { some: { blockedid: userId } } } },
              { NOT: { members: { some: { conversationid: dto.id } } } },
            ],
          },
          select: { intra_id: true },
        });
        const ids = users.map((u) => {
          return { userid: u.intra_id };
        });
        await this.prismaService.conversation.update({
          where: { id: dto.id },
          data: { members: { create: ids } },
        });
      }
      const update = await this.prismaService.conversation.update({
        where: { id: dto.id },
        data: { ...dataUpdate },
        include: { members: { include: { users: true } } },
      });
      return res.status(201).json(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async addAdminConversation(res: Response, userId: number, dto: addAdminConversation & Conversation) {
    try {
      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [
            { id: dto.id },
            { type: "GROUP" },
            { members: { some: { userid: userId, isadmin: true } } },
            { members: { some: { userid: dto.userId, active: true, endban: { lt: new Date() }, endmute: { lt: new Date() } } } },
          ],
        },
        include: { members: { include: { users: true } } },
      });
      if (!conversation) return res.status(404).json({ message: "conversation or member not found" });
      const update = await this.prismaService.conversation.update({
        where: { id: conversation.id },
        data: {
          members: {
            update: {
              where: { conversationid_userid: { conversationid: conversation.id, userid: dto.userId } },
              data: { isadmin: true, mute: false, ban: false, endban: new Date(), endmute: new Date() },
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

  async sendMessage(res: Response, userId: number, dto: MessageDTO & Conversation) {
    try {
      // todo check user socket in chat room
      const currentDate = new Date();
      const member = await this.prismaService.members.findFirst({
        where: {
          conversationid: dto.id,
          userid: userId,
          active: true,
          ban: false,
          mute: false,
          endban: { lt: currentDate },
          endmute: { lt: currentDate },
        },
      });
      if (!member) return res.status(400).json({ message: "Bad Request" });
      const newMessage = await this.prismaService.message.create({
        data: { senderid: userId, conversationid: member.conversationid, message: dto.message },
        include: { users: true },
      });
      return res.status(200).json(newMessage);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async toggleMuteUser(res: Response, userId: number, dto: ToggleMuteUser & Conversation) {
    try {
      console.log(dto, userId, "muteUser");
      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [
            { id: dto.id },
            { type: "GROUP" },
            { active: true },
            { members: { some: { userid: userId, isadmin: true, active: true } } },
            { members: { some: { userid: dto.userId, active: true } } },
          ],
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation or member not found" });
      const update = await this.prismaService.conversation.update({
        where: { id: dto.id },
        data: {
          members: {
            update: {
              where: { conversationid_userid: { conversationid: dto.id, userid: dto.userId } },
              data: { mute: dto.mute, endmute: dto.endmute || new Date() },
            },
          },
        },
        include: { members: { include: { users: true } } },
      });
      return res.status(200).json(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async toggleBanUser(res: Response, userId: number, dto: ToggleBanUser & Conversation) {
    try {
      console.log(dto, "banUser");

      const conversation = await this.prismaService.conversation.findFirst({
        where: {
          AND: [
            { id: dto.id },
            { type: "GROUP" },
            { active: true },
            { members: { some: { userid: userId, isadmin: true, active: true } } },
            { members: { some: { userid: dto.userId, active: true } } },
          ],
        },
      });
      if (!conversation) return res.status(404).json({ message: "conversation or member not found" });
      const update = await this.prismaService.conversation.update({
        where: { id: dto.id },
        data: {
          members: {
            update: {
              where: { conversationid_userid: { userid: dto.userId, conversationid: dto.id } },
              data: { ban: dto.ban, endban: dto.endban || new Date() },
            },
          },
        },
        include: { members: { include: { users: true } } },
      });
      // await this.prismaService.members.update({
      //   where: { conversationid_userid: { conversationid: conversation.id, userid: dto.userId } },
      //   data: { ban: dto.ban, endban: dto.endban || new Date() },
      // });
      return res.status(200).json(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async leaveConversation(res: Response, userId: number, dto: LeaveConvesation) {
    try {
      const member = await this.prismaService.members.findUnique({
        where: { conversationid_userid: { conversationid: dto.id, userid: userId } },
      });
      if (!member || !member.active) return res.status(400).json({ message: "conversation not found" });
      if (member.isadmin) {
        const admins = await this.prismaService.members.findMany({
          where: { conversationid: dto.id, isadmin: true },
        });
        // ?set new admin
        if (!admins.length) {
          const newAdmin = await this.prismaService.members.findFirst({
            where: { conversationid: dto.id, active: true, ban: false, mute: false, userid: { not: userId } },
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
      const update = await this.prismaService.conversation.update({
        where: { id: dto.id },
        data: {
          members: {
            update: {
              where: { conversationid_userid: { userid: userId, conversationid: dto.id } },
              data: { active: false, isadmin: false },
            },
          },
        },
        include: { members: { include: { users: true } } },
      });
      // todo emit update conversation
      return res.status(200).json({ message: "success leave conversation" });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: "server error" });
    }
  }

  async deleteConversation(userId: number, dto: DeleteConversation) {
    return new Promise(async (resolve, reject) => {
      try {
        const conversation = await this.prismaService.conversation.findFirst({
          where: { id: dto.id, members: { some: { userid: userId, isadmin: true, active: true } } },
        });
        if (!conversation) return reject({ message: "conversation not found" });
        const update = await this.prismaService.conversation.update({
          where: { id: dto.id },
          data: { active: false },
          include: { members: true },
        });
        return resolve(update);
      } catch (error) {
        return reject({ message: "server error" });
      }
    });
  }
}
