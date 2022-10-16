import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { users, Prisma } from '@prisma/client';
import { Request, Response } from 'express';
import { GetUserQuery } from 'src/interfaces/user.interface';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async user(
    usersWhereUniqueInput: Prisma.usersWhereUniqueInput,
  ): Promise<users | null> {
    try {
      return await this.prisma.users.findUnique({
        where: usersWhereUniqueInput,
      });
    } catch (error) {
      return error;
    }
  }

  async users(params: {
    skip?: number;
    take?: number;
    cursor?: Prisma.usersWhereUniqueInput;
    where?: Prisma.usersWhereInput;
    orderBy?: Prisma.usersOrderByWithRelationInput;
  }): Promise<users[]> {
    const { skip, take, cursor, where, orderBy } = params;
    try {
      return await this.prisma.users.findMany({
        skip,
        take,
        cursor,
        where,
        orderBy,
      });
    } catch (error) {
      return error;
    }
  }

  async createUser(data: Prisma.usersCreateInput): Promise<users> {
    try {
      return await this.prisma.users.create({
        data,
      });
    } catch (error) {
      return error;
    }
  }

  async updateUser(params: {
    where: Prisma.usersWhereUniqueInput;
    data: Prisma.usersUpdateInput;
  }): Promise<users> {
    const { where, data } = params;
    try {
      return await this.prisma.users.update({
        data,
        where,
      });
    } catch (error) {
      return error;
    }
  }

  async deleteUser(where: Prisma.usersWhereUniqueInput): Promise<users> {
    try {
      return await this.prisma.users.delete({
        where,
      });
    } catch (error) {
      return error;
    }
  }

  async getAllUsers(dto: GetUserQuery, res: Response) {
    const pageSize = 20;
    const cursor = Number(dto.cursor) || 1;
    try {
      const data = await this.prisma.users.findMany({
        take: pageSize,
        cursor: { id: cursor },
        where: {
          AND: [
            { status: dto.status },
            {
              blocked_blocked_useridTousers: { none: {} },
            },
            {
              blocked_blocked_blockedidTousers: { none: {} },
            },
            {OR: [{username: {contains: dto.findBy}}, {email: {contains: dto.findBy}}]}
          ],
          
        },
      });
      return res.status(200).json(data);
    } catch (error) {
      return res.status(400).json(error);
    }
  }
}
