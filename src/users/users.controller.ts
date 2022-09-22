import { Controller, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}
  @Post('update')
  @UseGuards(JwtAuthGuard)
  async updateUser(@Req() req: any) {
    // console.log(data);
    this.usersService.updateUser({
      data: req.body,
      where: { intra_id: req.user.sub },
    });
  }
  @Get(':username')
  async findUser(@Param('username') username) {
    return this.usersService.user({ username: username });
  }
}
