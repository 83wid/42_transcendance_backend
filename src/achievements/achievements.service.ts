import { Injectable } from "@nestjs/common";
import { Request, Response } from "express";
import { PrismaService } from "src/prisma/prisma.service";

@Injectable()
export class AchievementsService {
  constructor(private prismaService: PrismaService) {}

  async getAllAchievements(req: Request, res: Response) {
    try {
      const achievList = await this.prismaService.achievements.findMany({
        include: { users_achievements: { where: { userid: req.user.sub } } },
      });

      return res.status(200).json(achievList);
    } catch (error) {
      res.status(500).json({ message: "sever error" });
    }
  }

  async friendly(req: Request, Res: Response) {}
  async legendary(req: Request, Res: Response) {}
  async sharpshooter(req: Request, Res: Response) {}
  async wildfire(req: Request, Res: Response) {}
  async winner(req: Request, Res: Response) {}
  async photogenic(userId: number, level: "GOLD" | "PLATINUM") {
    const achiev = await this.prismaService.achievements.findFirst({
      where: {AND:[{name: 'photogenic'}, {level}]}
    })
    // await this.prismaService.users_achievements.upsert({
    //   create: {userid: userId, achievementid: achiev.id},
    //   update: {},
    //   where: {}
    // })
    await this.prismaService.users.update({
      where: {intra_id: userId},
      data: {users_achievements: {upsert: {
        create: {achievementid: achiev.id},
        update: {},
        where: {id: 1}
    }}}
    })
  }
}
