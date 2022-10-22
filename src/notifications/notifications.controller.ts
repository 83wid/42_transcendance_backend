import { Body, Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { NotificationsService } from './notifications.service';
import { GetNotifcaions } from 'src/interfaces/user.interface';


@Controller('notifications')
export class NotificationsController {
  constructor(private notificationsService: NotificationsService){}
  @Get('/get')
  @UseGuards(JwtAuthGuard)
  getNotifications(@Req() req: Request, @Res() res: Response){
    return this.notificationsService.getNotifications(req, res)
  }
}
