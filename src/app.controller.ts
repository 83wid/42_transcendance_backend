import { Body, Controller, Get, Param, Post, Query, Req, Res, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { JwtAuthGuard } from './auth/jwt-auth.guard';
import { Response, Request } from 'express';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}
  @UseGuards(JwtAuthGuard)
  @Get('')
  gethello() {
    return 'hello bitch';
  }
  @Get('profile/:username?')
  @UseGuards(JwtAuthGuard)
  getProfile(@Req() req: Request, @Res() res: Response, @Param() params: any) {
    // return req.user;    
    return this.appService.profile(req, res, params)
  }
}
