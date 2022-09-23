import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { JwtAuthGuard } from './auth/jwt-auth.guard';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}
  @UseGuards(JwtAuthGuard)
  @Get('')
  gethello() {
    return 'hello bitch';
  }
  @Get('profile')
  getProfile(@Req() req: any) {
    return req.user;
  }
}
