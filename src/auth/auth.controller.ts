import { Controller, Get, Post, Req, Res, UseGuards } from "@nestjs/common";
import { Request, Response } from "express";
import { AuthService } from "./auth.service";
import { FortyTwoAuthGuard } from "./fortyTwo-auth.guard";
import { JwtAuthGuard } from "src/auth/jwt-auth.guard";

@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post("/login")
  @UseGuards(FortyTwoAuthGuard)
  async Auth() {
    //return req.query
  }
  @Get("/42/callback")
  @UseGuards(FortyTwoAuthGuard)
  async Callback(@Req() req: Request, @Res() res: Response) {
    const token = await this.authService.authenticate(req);

    // return res.redirect(`http://localhost:3000?token=${token}`);
    return res.redirect(`${req.headers.referer}?token=${token}`);
  }

  @Get("/me")
  @UseGuards(JwtAuthGuard)
  async Login(@Req() req: Request, @Res() res: Response) {
    return await this.authService.authMe(req.user.sub, res);
  }
}
