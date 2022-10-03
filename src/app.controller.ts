import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
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
  @Get('profile')
  @UseGuards(JwtAuthGuard)
  getProfile(@Req() req: any, @Res() res: Response) {
    // return req.user;
    return this.appService.profile(req.user.sub, res)
  }
}
