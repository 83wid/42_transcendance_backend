import { Body, Controller, Get, Post, Res, UseGuards } from '@nestjs/common';
import { friendRequestBody } from '../interfaces/user.interface';
import { FriendsService } from './friends.service';

@Controller('friends')
export class FriendsController {
  constructor(private friendsService: FriendsService) {}

  // Handle all requests to /friends

  /*
   ** Send new Friend Request
   ** @param {string} senderId
   ** @param {string} receiverId
   ** @return {object} response
   */
  @Post('sendrequest')
  sendRequest(@Body() dto: friendRequestBody) {
    return this.friendsService.sendRequest(dto);
  }

  @Post('acceptrequest')
  acceptRequest() {
    return this.friendsService.acceptRequest();
  }

  @Post('rejectrequest')
  rejectRequest() {
    return this.friendsService.rejectRequest();
  }

  @Get('')
  getFriends() {
    return this.friendsService.getFriends();
  }

  @Post('blockfriend')
  blockFriend() {
    return this.friendsService.blockFriend();
  }
}
