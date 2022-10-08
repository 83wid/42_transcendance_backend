import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import {
  acceptRequestBody,
  blockRequestBody,
  friendRequestBody,
  unfriendRequestBody,
} from '../interfaces/user.interface';
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
  @UseGuards(JwtAuthGuard)
  sendRequest(
    @Body() dto: friendRequestBody,
    @Req() req: any,
    @Res() res: Response,
  ) {
    return this.friendsService.sendRequest(dto, Number(req.user.sub), res);
  }

  /*
   ** Get all Invites
   ** @param {string} id
   ** @return {object} response
   */
  @Get('invites')
  @UseGuards(JwtAuthGuard)
  getInvites(@Req() req: any, @Res() res: Response) {
    return this.friendsService.getInvites(Number(req.user.sub), res);
  }

  /*
   ** Accept Friend Request
   ** @param {string} id
   ** @return {object} response
   */
  @Post('acceptrequest')
  @UseGuards(JwtAuthGuard)
  acceptRequest(
    @Req() req: any,
    @Res() res: Response,
    @Body() dto: acceptRequestBody,
  ) {
    return this.friendsService.acceptRequest(dto, Number(req.user.sub), res);
  }

  /*
   ** Reject Friend Request
   ** @param {string} id
   ** @return {object} response
   */
  @Post('rejectrequest')
  @UseGuards(JwtAuthGuard)
  rejectRequest(
    @Req() req: any,
    @Res() res: Response,
    @Body() dto: acceptRequestBody,
  ) {
    return this.friendsService.rejectRequest(dto, Number(req.user.sub), res);
  }

  /*
   ** Unfriend a friend
   ** @param {string} id
   ** @return {object} response
   */
  @Post('unfriend')
  @UseGuards(JwtAuthGuard)
  unfriend(
    @Body() dto: unfriendRequestBody,
    @Req() req: any,
    @Res() res: Response,
  ) {
    return this.friendsService.unfriend(dto, Number(req.user.sub), res);
  }

  /*
   ** Get all Friends
   ** @return {object} response
   */
  @Get('')
  @UseGuards(JwtAuthGuard)
  getFriends(@Req() req: any, @Res() res: Response) {
    return this.friendsService.getFriends(req, res);
  }

  /*
   ** Block a Friend
   ** @param {string} id
   ** @return {object} response
   */
  @Post('blockfriend')
  @UseGuards(JwtAuthGuard)
  blockFriend(
    @Req() req: any,
    @Res() res: Response,
    @Body() dto: blockRequestBody,
  ) {
    return this.friendsService.blockFriend(dto, req, res);
  }

  /*
   ** get friends bu username
   ** @param {string} username
   ** @return {object} response
   */
  @Get('user/:username')
  @UseGuards(JwtAuthGuard)
  getFriendsByUsername(@Req() req: any, @Res() res: Response) {
    return this.friendsService.getFriendsByUsername(req, res);
  }

  /*
   ** get blocked users
   ** @return {object} response
   */

  @Get('blocked')
  @UseGuards(JwtAuthGuard)
  getBlockedUsers(@Req() req: any, @Res() res: Response) {
    return this.friendsService.getBlockedUsers(req, res);
  }

  /*
   ** To do
   ** get friends by username √
   ** get blocked users √
   ** unfriend route
   ** unblock route
   */
}
