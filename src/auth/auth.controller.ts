import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { FortyTwoAuthGuard } from './fortyTwo-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}
  @Get('')
  @UseGuards(FortyTwoAuthGuard)
  async Auth(@Req() req: any) {
    //return req.query
  }
  @Get('/42/callback')
  @UseGuards(FortyTwoAuthGuard)
  async Callback(@Req() req: any) {
    return this.authService.authenticate(req);
  }
}
