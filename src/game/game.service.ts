import { Injectable } from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class GameService {
  constructor(private prisma: PrismaService) {}

  /**
   * get all game's user
   * @param req Request
   * @param res Request
   */
  async getUserGames(req: Request, res: Response) {
    try {
      const games = await this.prisma.users.findMany({
        where: { intra_id: req.user.sub },
        select: {
          players: {
            select: {
              game: {
                include: {
                  players: {
                    include: {
                      users: {
                        select: {
                          intra_id: true,
                          username: true,
                          email: true,
                          first_name: true,
                          last_name: true,
                          img_url: true,
                          status: true,
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      });

      return res.status(200).json(games[0]?.players || {});
    } catch (error) {
      console.log(error);

      return res.status(500).json({ message: 'server error' });
    }
  }
}
