import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { Response, Request } from 'express';

@Injectable()
export class ProfileService {
  constructor(private prisma: PrismaService) {}

  /**
   * @param {Request} req Request
   * @param {Response} res Response
   * @param {string} username
   * @returns {Promise<Response>}
   **/
  async profile(req: Request, res: Response, username: string): Promise<Response> {
    console.log(username)
    
    try {
      const slector = username
        ? { username: username }
        : { intra_id: req.user.sub };
      const user = await this.prisma.users.findUnique({
        where: {
          ...slector,
        },
        include: { users_achievements: { select: { achievements: true } } },
      });
      if (!user) throw 'user not found';
      if (username) {
        const isFriend = await this.prisma.friends.findFirst({
          where: {
            OR: [
              {
                AND: [{ userid: req.user.sub }, { friendid: user.intra_id }],
              },
              {
                AND: [{ userid: user.intra_id }, { friendid: req.user.sub }],
              },
            ],
          },
        });

        if (isFriend) return res.status(200).json({relationship: {isFriend: true},...user});
        else {
          const relationship = await this.prisma.invites.findFirst({
            where: {
              OR: [
                {
                  AND: [
                    { receiverid: req.user.sub },
                    { senderid: user.intra_id },
                  ],
                },
                {
                  AND: [
                    { receiverid: user.intra_id },
                    { senderid: req.user.sub },
                  ],
                },
              ],
            },
          });
          if (relationship)
            return res.status(200).json({ relationship, ...user });
          else {
            const isBlocked = await this.prisma.blocked.findFirst({
              where: {
                OR: [
                  {
                    AND: [
                      { userid: req.user.sub },
                      { blockedid: user.intra_id },
                    ],
                  },
                  {
                    AND: [
                      { userid: user.intra_id },
                      { blockedid: req.user.sub },
                    ],
                  },
                ],
              },
            });
            return res
              .status(isBlocked ? 404 : 200)
              .json(isBlocked ? { message: 'user not found' } : user);
          }
        }
      } else return res.status(200).json(user);
    } catch (error) {
      return res.status(400).json({
        message: error,
      });
    }
  }
}
