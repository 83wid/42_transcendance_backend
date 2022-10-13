import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { GameService } from './game.service';
import {
  RegisterToQueueBody,
  LeaveGameBody,
} from 'src/interfaces/user.interface';

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
    return this.gameService.getCurrentGames(Number(req.query.cursor) || 1, res);
  }

  @Post('registerqueue')
  @UseGuards(JwtAuthGuard)
  registerQueue(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: RegisterToQueueBody,
  ) {
    return this.gameService.registerToQueue(req, res, dto);
  }

  @Get('leavequeue')
  @UseGuards(JwtAuthGuard)
  leaveQueue(@Req() req: Request, @Res() res: Response) {
    return this.gameService.leaveQueue(req, res);
  }

  @Post('leaveGame')
  @UseGuards(JwtAuthGuard)
  leaveGame(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: LeaveGameBody,
  ) {
    return this.gameService.leaveGame(req, res, dto);
  }
}
