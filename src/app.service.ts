import { Injectable, Req, Res } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';
import { Response, Request, query } from 'express';

@Injectable()
export class AppService {
  constructor(private prisma: PrismaService) {}
  getHello(): string {
    return 'Hello World!';
  }

  // get profile
  async profile(req: Request,res: Response, params: any) {
    try {
      const slector = params.username? {username: params.username} : {intra_id: req.user.sub}
      const data = await this.prisma.users.findUnique({
        where: {
          ...slector
      },
        include: {users_achievements: {select: {achievements: true } }},
      })
      const ach = data.users_achievements.map(e => {
        return(Object.values(e)[0])
        
      })
      const ret = {...data, users_achievements: ach}
      
      return res.status(200).json(ret);
    } catch (error) {
      return res.status(400).json({
        message: error,
      });
    }
  }
}
