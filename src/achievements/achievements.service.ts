import { Injectable } from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class AchievementsService {
  constructor(private prisma: PrismaService) {}

  async getAllAchievements(req: Request, res: Response) {
    // return res.status(200).json({ ...req.user });
    try {
      const achievList = await this.prisma.users_achievements.findMany({
        where: {
          userid: req.user.sub,
        },include: {achievements: true}
      });

      return res.status(200).json(achievList);
    } catch (error) {
      res.status(500).json({ message: 'sever error' });
    }
  }
}
