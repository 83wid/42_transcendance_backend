import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import {AchievementsService} from './achievements.service'

@Controller('achievements')
export class AchievementsController {
  constructor(private achievements:  AchievementsService){}

  @Get('')
  @UseGuards(JwtAuthGuard)
  getAchievements(@Req() req: Request, @Res() res: Response){
    return this.achievements.getAllAchievements(req, res)
  }
  @Get('test')
  @UseGuards(JwtAuthGuard)
  async test(@Req() req: Request, @Res() res: Response){
    const matches = await this.achievements.sharpshooter(req.user.sub)
    return res.status(200).json(matches)
  }
}
