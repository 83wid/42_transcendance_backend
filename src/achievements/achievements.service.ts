import { Injectable } from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class AchievementsService {
  constructor(private prisma: PrismaService) {}

  async getAllAchievements(req: Request, res: Response) {
    try {
      const achievList = await this.prisma.achievements.findMany({
        include: { users_achievements: { where: { userid: req.user.sub } } },
      });

      return res.status(200).json(achievList);
    } catch (error) {
      res.status(500).json({ message: 'sever error' });
    }
  }
}
