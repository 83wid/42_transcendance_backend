import {
  Controller,
  Req,
  Res,
  Get,
  UseGuards,
  Param,
  Put,
} from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { Response, Request } from 'express';
import { ProfileService } from './profile.service';

@Controller('profile')
export class ProfileController {
  constructor(private profileService: ProfileService) {}
  @Get('/:username?')
  @UseGuards(JwtAuthGuard)
  getProfile(
    @Req() req: Request,
    @Res() res: Response,
    @Param('username') username: string,
  ) {
    // return req.user;
    return this.profileService.profile(req, res, username);
  }
  // @Put('update')
  // @UseGuards(JwtAuthGuard)
  // async updateUser(@Req() req: any, @Res() res: Response) {
  //   // console.log(req.body);
  //   const user = await this.profileService.updateProfile({
  //     data: req.body,
  //     where: { intra_id: req.user.sub },
  //   });
  //   return res.status(201).json(user);
  // }
}
