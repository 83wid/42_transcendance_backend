import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { GameService } from './game.service';

@Controller('game')
export class GameController {
  constructor(private gameService: GameService) {}

  @Get('/history')
  @UseGuards(JwtAuthGuard)
  getUserGame(@Req() req: Request, @Res() res: Response) {
    return this.gameService.getUserHistoryGame(req, res);
  }
  @Get('current')
  @UseGuards(JwtAuthGuard)
  getCurrentGames(@Req() req: Request, @Res() res: Response) {
    // console.log(Number(req.query.cursor));
    // return this.usersService.getAllUsers(Number(req.query.cursor) || 1 , res);
    return this.gameService.getCurrentGames(Number(req.query.cursor) || 1, res);
  }
}
