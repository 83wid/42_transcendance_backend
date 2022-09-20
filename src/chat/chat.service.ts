import { Injectable } from '@nestjs/common';
import { conversation, Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}
  async getUserChats(params: {
    skip?: number;
    take?: number;
    cursor?: Prisma.conversationWhereUniqueInput;
    where?: Prisma.conversationWhereInput;
    orderBy?: Prisma.conversationOrderByWithRelationInput;
  }): Promise<conversation[]> {
    const { skip, take, cursor, where, orderBy } = params;
    return this.prisma.conversation.findMany({
      skip,
      take,
      cursor,
      where,
      orderBy,
    });
  }
}
