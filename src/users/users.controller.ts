import {
  Controller,
  Get,
  Param,
  Put,
  Req,
  Res,
  Query,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { UsersService } from './users.service';
import { Response } from 'express';
import { GetUserQuery } from 'src/interfaces/user.interface';

@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}
  @Put('update')
  @UseGuards(JwtAuthGuard)
  async updateUser(@Req() req: any, @Res() res: Response) {
    const user = await this.usersService.updateUser({
      data: req.body,
      where: { intra_id: req.user.sub },
    });
    return res.status(201).json(user);
  }
  @Get('all')
  @UseGuards(JwtAuthGuard)
  async getAllUsers(@Query() query: GetUserQuery, @Res() res: Response) {
    return this.usersService.getAllUsers(query, res);
  }
  @Get(':username')
  @UseGuards(JwtAuthGuard)
  async findUser(@Param('username') username: string) {
    return this.usersService.user({ username: username });
  }
}
