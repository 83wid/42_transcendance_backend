import { Controller, Get, Post, Req, Res, UseGuards } from '@nestjs/common';
import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { FortyTwoAuthGuard } from './fortyTwo-auth.guard';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('/login')
  @UseGuards(FortyTwoAuthGuard)
  async Auth() {
    //return req.query
  }
  @Get('/42/callback')
  @UseGuards(FortyTwoAuthGuard)
  async Callback(@Req() req: Request, @Res() res: Response) {
    const token = await this.authService.authenticate(req);
    // console.log(req.headers, '<<<<<<<<<<<<<<<<');

    return res.redirect(`http://localhost:5000?token=${token}`);
  }

  @Post('/me')
  @UseGuards(JwtAuthGuard)
  async Login(@Req() req: Request, @Res() res: Response) {
    return await this.authService.authprofile(req.user.sub, res);
  }
}
