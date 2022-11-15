import { Body, Controller, Get, Param, Post, Query, Req, Res, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { Response, Request } from 'express';
import { JwtTwoFactorGuard } from './auth/jwt-two-factor.guard';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}
  @UseGuards(JwtTwoFactorGuard)
  @Get('')
  gethello() {
    return 'hello bitch';
  }

}
