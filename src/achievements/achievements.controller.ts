import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import {AchievementsService} from './achievements.service'

@Controller('achievements')
export class AchievementsController {
  constructor(private appService:  AchievementsService){}

  @Get('')
  @UseGuards(JwtAuthGuard)
  getAchievements(@Req() req: Request, @Res() res: Response){
    return this.appService.getAllAchievements(req, res)
  }
}
