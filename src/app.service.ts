import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';
import { Response } from 'express';

@Injectable()
export class AppService {
  constructor(private prisma: PrismaService) {}
  getHello(): string {
    return 'Hello World!';
  }

  // get profile
  async profile(id: number, res: Response) {
    try {
      const data = await this.prisma.users.findUnique({where:{intra_id: id}})
      return res.status(200).json(data)
    } catch (error) {
      return res.status(400).json({
        message: error
      })
    }
  }
}
