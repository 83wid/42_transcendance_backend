import { Injectable } from '@nestjs/common';
import { friendRequestBody } from '../interfaces/user.interface';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FriendsService {
  constructor(private prizma: PrismaService) {}

  //Send new Friend Request
  sendRequest(dto: friendRequestBody) {
    console.log(dto);

    return {
      message: 'Send new Friend Request',
    };
  }
  //Accept Friend Request
  acceptRequest() {
    return {
      message: 'Accept Friend Request',
    };
  }
  //Reject Friend Request
  rejectRequest() {
    return {
      message: 'Reject Friend Request',
    };
  }
  //Get all Friends
  getFriends() {
    return {
      message: 'Get Friends',
    };
  }
  //Block Friend
  blockFriend() {
    return {
      message: 'Block Friends',
    };
  }
}
