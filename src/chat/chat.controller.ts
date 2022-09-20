import { Body, Controller, Get, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { ChatService } from './chat.service';

@Controller('chat')
export class ChatController {
  constructor(private chatService: ChatService) {}
  @Get('')
  @UseGuards(JwtAuthGuard)
  async getChats(@Body() data: any) {
    // return data;
    return this.chatService.getUserChats({
      skip: 0,
      take: 5,
      //   cursor: {},
      where: {
        group_member: {
          some: {
            user_id: Number(data.intra_id),
          },
        },
      },
    });
  }
}
