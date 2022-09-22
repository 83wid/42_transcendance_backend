import { Injectable } from '@nestjs/common';
import { conversation, message, Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}
  async getUserChats(params: {
    skip?: number;
    take?: number;
    cursor?: Prisma.conversationWhereUniqueInput;
    where?: Prisma.conversationWhereInput;
    include?: Prisma.conversationInclude;
    orderBy?: Prisma.conversationOrderByWithRelationInput;
  }): Promise<conversation[]> {
    const { skip, take, cursor, where, include, orderBy } = params;
    return this.prisma.conversation.findMany({
      skip,
      take,
      cursor,
      where,
      include,
      orderBy,
    });
  }

  async getChatMessages(params: {
    skip?: number;
    take?: number;
    cursor?: Prisma.messageWhereUniqueInput;
    where?: Prisma.messageWhereInput;
    orderBy?: Prisma.messageOrderByWithRelationInput;
  }): Promise<message[]> {
    const { skip, take, cursor, where, orderBy } = params;
    return this.prisma.message.findMany({
      skip,
      take,
      cursor,
      where,
      orderBy,
    });
  }
}
