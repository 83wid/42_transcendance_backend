import { Injectable } from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class GameService {
  constructor(private prisma: PrismaService) {}

  /**
   * get history game from current user
   * @param req Request
   * @param res Response
   * @returns Object
   */
  async getUserHistoryGame(req: Request, res: Response) {
    try {
      const games = await this.prisma.users.findMany({
        where: { intra_id: req.user.sub },
        select: {
          players: {
            where: { game: { status: 'END' } },
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

  async getCurrentGames(cursor: number, res: Response) {
    const pageSize = 40;
    try {
      const games = await this.prisma.game.findMany({
        take: pageSize,
        cursor: { id: cursor },
        where: { status: 'PLAYING' },
        include: {
          players: {
            include: { users: true },
          },
        },
      });

      return res.status(200).json(games);
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }

  async createGame(req: Request, res: Response){

  }

  async inviteUserToGame(req: Request, res: Response){}

  async accepteGame(req: Request, res: Response){}

  async endGame(req: Request, res: Response){}
}
