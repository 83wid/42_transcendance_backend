import { Injectable, Scope } from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  QueueInterface,
  RegisterToQueueBody,
  CreateGameBody,
  LeaveGameBody,
} from 'src/interfaces/user.interface';

@Injectable()
export class GameService {
  private queue: QueueInterface[] = [
    { GameLevel: 'EASY', users: [1] },
    { GameLevel: 'NORMAL', users: [2] },
    { GameLevel: 'DIFFICULT', users: [3] },
  ];
  constructor(private prisma: PrismaService) {}

  /**
   * get history games from current user
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

  /**
   * create a new game
   * @param req Request
   * @param res Response
   * @param dto {gameLeve, userId}
   */
  async createGame(req: Request, res: Response, dto: CreateGameBody) {
    // return res.status(201).json(dto);
    try {
      const newGame = await this.prisma.game.create({
        data: {
          level: dto.gameLevel,
          status: 'PLAYING',
          players: {
            create: [{ userid: dto.userId }, { userid: req.user.sub }],
          },
        },
      });
      return res.status(201).json(newGame);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'server error' });
    }
  }

  async inviteUserToGame(req: Request, res: Response) {}

  async accepteGame(req: Request, res: Response) {}

  async endGame(req: Request, res: Response) {}

  async leaveGame(req: Request, res: Response, dto: LeaveGameBody) {
    try {
      const game = await this.prisma.game.findFirst({
        where: { id: dto.gameId, NOT: { status: 'END' } },
      });
      if (!game) return res.status(400).json({ message: 'game not found' });
      const update = await this.prisma.game.update({
        where: { id: dto.gameId },
        data: { status: 'END' },
      });

      return res.status(200).json(update);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'server error' });
    }
  }

  /**
   * add user to queue
   * @param req Request
   * @param res Response
   * @param dto gameLeve
   * @returns any
   */
  async registerToQueue(req: Request, res: Response, dto: RegisterToQueueBody) {
    try {
      const userInGame = await this.prisma.players.findFirst({
        where: {
          userid: req.user.sub,
          game: { OR: [{ status: 'PLAYING' }, { status: 'WAITING' }] },
        },
      });

      console.log(userInGame);
      if (userInGame)
        return res.status(400).json({
          message:
            'you are already in a game please leave it befor register in other',
        });
      const findUserInQueue = this.queue.find((q) =>
        q.users.find((u) => u === req.user.sub),
      );
      if (findUserInQueue)
        return res
          .status(400)
          .json({ message: 'your already register in a queue' });
      const findQueue = this.queue.find((q) => q.GameLevel === dto.gameLevel);
      if (findQueue.users.length === 0) {
        findQueue.users.push(req.user.sub);
        return res.status(200).json({
          message:
            'success register in queue pealse waiting to find other player',
        });
      }
      const userId = findQueue.users.shift();
      console.log(this.queue);
      return await this.createGame(req, res, {
        gameLevel: dto.gameLevel,
        userId,
      });
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }

  /**
   * delete user form queue
   * @param req Request
   * @param res Response
   * @returns any
   */
  async leaveQueue(req: Request, res: Response) {
    try {
      const findUserInQueue = this.queue.find((q) =>
        q.users.find((u) => u === req.user.sub),
      );
      if (!findUserInQueue)
        return res
          .status(400)
          .json({ message: 'your not registered in queue' });
      this.queue = this.queue.map((q) => {
        q.users = q.users.filter((u) => u !== req.user.sub);
        return q;
      });
      return res.status(200).json({ message: 'success leave queue' });
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }
}
