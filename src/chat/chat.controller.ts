import { Controller, Post, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { ChatService } from './chat.service';

@Controller('chat')
export class ChatController {
  constructor(private chatService: ChatService) {}
  @Post('')
  @UseGuards(JwtAuthGuard)
  async getChats(@Req() req: any) {
    console.log(req.query.page);
    return this.chatService.getUserChats({
      skip: Number(req.query.page - 1),
      take: Number(req.query.size),
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
  @Post(':id')
  @UseGuards(JwtAuthGuard)
  async getChatsMessages(@Req() req: any) {
    // return data;
    return this.chatService.getChatMessages({
      //   cursor: {},
      skip: Number(req.query.page - 1),
      take: Number(req.query.size),
      where: {
        conversation_id: Number(req.params.id),
      },
    });
  }
}
