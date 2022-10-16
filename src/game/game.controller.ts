import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Res,
  Put,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { GameService } from './game.service';
import {
  RegisterToQueueBody,
  LeaveGameBody,
  CreateGameBody,
  InvitePlayGame,
  AcceptePlayGame,
  RejectPlayGame,
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

  @Post('creategame')
  @UseGuards(JwtAuthGuard)
  createGame(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: CreateGameBody,
  ) {
    return this.gameService.createGame(req, res, dto);
  }

  @Delete('leavequeue')
  @UseGuards(JwtAuthGuard)
  leaveQueue(@Req() req: Request, @Res() res: Response) {
    return this.gameService.leaveQueue(req, res);
  }

  @Put('leaveGame')
  @UseGuards(JwtAuthGuard)
  leaveGame(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: LeaveGameBody,
  ) {
    return this.gameService.leaveGame(req, res, dto);
  }
  @Post('invite')
  @UseGuards(JwtAuthGuard)
  inviteToPlayGame(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: InvitePlayGame,
  ) {
    return this.gameService.inviteUserToGame(req, res, dto);
  }
  @Put('invite/accepte')
  @UseGuards(JwtAuthGuard)
  accepteInvite(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: AcceptePlayGame,
  ) {
    return this.gameService.accepteGame(req, res, dto);
  }

  @Delete('invite/reject')
  @UseGuards(JwtAuthGuard)
  rejecteInvite(
    @Req() req: Request,
    @Res() res: Response,
    @Body() dto: RejectPlayGame,
  ) {
    return this.gameService.rejectGame(req, res, dto);
  }
}
