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

  async friendly(userId: number) {
    const friends = await this.prismaService.friends.count({
      where: { OR: [{ userid: userId }, { friendid: userId }] },
    });
    const achievLevel =
      friends >= 10 && friends < 20
        ? "SILVER"
        : friends >= 20 && friends < 50
        ? "BRONZE"
        : friends >= 50 && friends < 100
        ? "GOLD"
        : "PLATINUM";

    await this.prismaService.users_achievements.upsert({
      where: {
        userid_achievementname_achievementlevel: { userid: userId, achievementname: "friendly", achievementlevel: achievLevel },
      },
      create: { userid: userId, achievementname: "friendly", achievementlevel: achievLevel },
      update: {},
    });
  }
  async legendary(req: Request, Res: Response) {}
  async sharpshooter(req: Request, Res: Response) {}
  async wildfire(req: Request, Res: Response) {}
  async winner(req: Request, Res: Response) {}
  async photogenic(userId: number, level: "GOLD" | "PLATINUM") {
    try {
      await this.prismaService.users_achievements.upsert({
        where: {
          userid_achievementname_achievementlevel: { userid: userId, achievementname: "photogenic", achievementlevel: level },
        },
        create: { userid: userId, achievementname: "photogenic", achievementlevel: level },
        update: {},
      });
    } catch (error) {
      console.log(error);
    }
  }
}
