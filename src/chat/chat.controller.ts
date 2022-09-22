import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { ChatService } from './chat.service';

@Controller('chat')
export class ChatController {
  constructor(private chatService: ChatService) {}
  @Get('')
  @UseGuards(JwtAuthGuard)
  async getChats(@Req() req: any) {
    return this.chatService.getUserChats({
      skip: 0,
      take: 5,
      //   cursor: {},
      where: {
        group_member: {
          some: {
            user_id: Number(req.user.sub),
          },
        },
      },
      include: { group_member: true },
    });
  }
  @Get(':id')
  @UseGuards(JwtAuthGuard)
  async getChatsMessages(@Param('id') id: number) {
    // return data;
    return this.chatService.getChatMessages({
      skip: 0,
      take: 5,
      //   cursor: {},
      where: {
        conversation_id: Number(id),
      },
    });
  }
}
