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
    // return res.status(200).json({message: 'test done'})
    try {
      const games = await this.prisma.game.findMany({
        where: {status: 'END'},
      });

      return res.status(200).json(games);
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }
}
