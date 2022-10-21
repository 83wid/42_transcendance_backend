import { Injectable } from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  QueueInterface,
  RegisterToQueueBody,
  CreateGameBody,
  LeaveGameBody,
  InvitePlayGame,
  AcceptePlayGame,
  RejectPlayGame,
  GetGameQuery,
} from 'src/interfaces/user.interface';
import { GameGateway } from './game.gateway';

@Injectable()
export class GameService {
  private queue: QueueInterface[] = [
    { GameLevel: 'EASY', users: [1, 4, 9] },
    { GameLevel: 'NORMAL', users: [2, 5, 8] },
    { GameLevel: 'DIFFICULT', users: [3, 6, 9] },
  ];
  constructor(
    private prisma: PrismaService,
    private gameGateway: GameGateway,
  ) {}

  /**
   *
   * @param query
   * @param res
   * @returns
   */
  async getGame(req: Request, res: Response, query: GetGameQuery) {
    const gameId = Number(query.gameId);
    console.log(gameId);

    try {
      let game: any;
      if (gameId)
        game = await this.prisma.game.findFirst({
          where: { id: gameId, status: 'PLAYING' },
          include: { players: { include: { users: true } } },
        });
      else
        game = await this.prisma.players
          .findFirst({
            where: { userid: req.user.sub, game: { status: 'PLAYING' } },
          })
          .game({
            include: { players: { include: { users: true } } },
          });
      if (!game) return res.status(404).json({ message: 'game not found' });
      return res.status(200).json(game);
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }

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
    if (dto.userId === req.user.sub)
      return res.status(400).json({ message: "you can't play with yourself" });
    try {
      const user = await this.prisma.users.findUnique({
        where: { id: dto.userId },
      });
      const error = !user
        ? 'user not found'
        : user.status === 'PLAYING'
        ? `${user.username} is playing now`
        : user.status === 'OFFLINE'
        ? `${user.username} is offline now`
        : null;
      if (error) return res.status(400).json({ message: error });
      const userInGame = await this.prisma.players.findFirst({
        where: {
          userid: req.user.sub,
          game: { status: 'PLAYING' },
          // NOT: { game: { OR:[{status: 'END'}, {status: 'WAITING'}] } },
        },
      });
      if (userInGame)
        return res
          .status(400)
          .json({ message: "you can't play multi games at same time" });
      const newGame = await this.prisma.game.create({
        data: {
          level: dto.gameLevel,
          status: 'PLAYING',
          createdat: new Date(),
          players: {
            create: [{ userid: dto.userId }, { userid: req.user.sub }],
          },
        },
      });
      //! delet this update (^_^)
      await this.prisma.users.updateMany({
        where: { OR: [{ intra_id: req.user.sub }, { intra_id: dto.userId }] },
        data: { status: 'PLAYING' },
      });
      //todo emit user to play game
      return res.status(200).json({ game: newGame });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'server error' });
    }
  }
  /**
   *
   * @param req
   * @param res
   * @param dto
   * @returns
   */
  async inviteUserToGame(req: Request, res: Response, dto: InvitePlayGame) {
    try {
      if (dto.userId === req.user.sub)
        return res.status(400).json({ message: "you can't invite yourself" });
      const user = await this.prisma.users.findUnique({
        where: { intra_id: dto.userId },
      });
      if (!user) return res.status(400).json({ message: 'user not found' });
      console.log(req.user.sub);
      const oldInvite = await this.prisma.gameinvites.findFirst({
        where: {
          AND: [
            { fromid: req.user.sub },
            { userid: dto.userId },
            { accepted: false },
          ],
        },
      });
      if (oldInvite)
        return res
          .status(400)
          .json({ message: 'you already invite this user to play game' });
      const gameInvite = await this.prisma.game
        .create({
          data: {
            status: 'WAITING',
            createdat: new Date(),
            players: {
              create: [{ userid: dto.userId }, { userid: req.user.sub }],
            },
            gameinvites: {
              create: { fromid: req.user.sub, userid: dto.userId },
            },
          },
        })
        .gameinvites();
      console.log(gameInvite);

      const notif = await this.prisma.notification.create({
        data: {
          userid: user.intra_id,
          type: 'GAME_INVITE',
          fromid: req.user.sub,
          targetid: gameInvite[0].id,
          content: 'invet you to play game',
          createdat: new Date(),
        },
      });
      //todo emit notif to user
      return res.status(200).json({ message: 'invitation success send' });
    } catch (error) {
      console.log(error);

      return res.status(500).json({ message: 'server error' });
    }
  }

  /**
   * accepte game invitaion
   * @param req
   * @param res
   */
  async accepteGame(req: Request, res: Response, dto: AcceptePlayGame) {
    try {
      console.log(dto);

      const invite = await this.prisma.gameinvites.findUnique({
        where: { id: dto.inviteId },
      });
      if (!invite || invite.accepted || invite.userid !== req.user.sub)
        return res.status(404).json({ message: 'invitation not found' });
      const users = await this.prisma.users.findMany({
        where: {
          OR: [{ intra_id: invite.userid }, { intra_id: invite.fromid }],
        },
      });
      const currentUser = users.find((u) => u.intra_id === req.user.sub);
      const senderUser = users.find((u) => u.intra_id === invite.fromid);
      const error =
        senderUser.status === 'OFFLINE'
          ? `${senderUser.username} is offline now`
          : senderUser.status === 'PLAYING'
          ? `${senderUser.username} is playing game now`
          : currentUser.status === 'PLAYING'
          ? "you can't play multi games at same time"
          : null;
      if (error) return res.status(400).json({ message: error });
      const game = await this.prisma.gameinvites.update({
        where: { id: invite.id },
        data: {
          accepted: true,
          game: { update: { status: 'PLAYING' } },
          users_gameinvites_fromidTousers: { update: { status: 'PLAYING' } },
          users_gameinvites_useridTousers: { update: { status: 'PLAYING' } },
        },
      });
      //todo emit invite.fromId to play game
      return res.status(200).json(game);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'error server' });
    }
  }
  /**
   * Reject play game
   * @param req
   * @param res
   * @param dto
   * @returns
   */
  async rejectGame(req: Request, res: Response, dto: RejectPlayGame) {
    try {
      console.log(dto);

      const invite = await this.prisma.gameinvites.findUnique({
        where: { id: dto.inviteId },
      });
      if (!invite || invite.accepted || invite.userid !== req.user.sub)
        return res.status(404).json({ message: 'invitation not found' });
      await this.prisma.game.delete({ where: { id: invite.gameid } });
      return res.status(200).json({ message: 'success reject' });
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }

  /**
   *
   * @param req
   * @param res
   */
  async endGame(req: Request, res: Response) {}

  /**
   *
   * @param res
   * @param dto
   * @returns
   */
  async leaveGame(res: Response, dto: LeaveGameBody) {
    try {
      const game = await this.prisma.game.findFirst({
        where: { id: dto.gameId, NOT: { status: 'END' } },
      });
      if (!game) return res.status(400).json({ message: 'game not found' });
      const update = await this.prisma.game
        .update({
          where: { id: dto.gameId },
          data: {
            status: 'END',
            updatedat: new Date(),
          },
        })
        .players();
      //! delet this update (^_^)
      await this.prisma.users.updateMany({
        where: {
          OR: [{ intra_id: update[0].userid }, { intra_id: update[1].userid }],
        },
        data: { status: 'ONLINE' },
      });

      return res.status(201).json({ message: 'succes leave game' });
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
      this.gameGateway.userStartGame(5111);
      const userInGame = await this.prisma.players.findFirst({
        where: {
          userid: req.user.sub,
          game: { status: 'PLAYING' },
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
        return res.status(201).json({
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
      return res.status(201).json({ message: 'success leave queue' });
    } catch (error) {
      return res.status(500).json({ message: 'server error' });
    }
  }
}
