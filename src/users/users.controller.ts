import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}
  @Post('update')
  async updateUser(@Body() data) {
    this.usersService.updateUser({ data, where: { intra_id: data.intra_id } });
  }
  @Get(':id')
  async findUser(@Param() params) {
    return this.usersService.user({ intra_id: params.id });
  }
}
