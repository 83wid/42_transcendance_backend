import {
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Matches,
} from 'class-validator';
// import { Response as Res, Request as Req } from 'express';

// Global Interface declare
export {};
declare global {
  namespace Express {
    interface Request {
      user: {
        sub: number;
      };
    }
  }
}

// inject user in Socket interface
declare module 'socket.io' {
  interface Socket {
    user: number;
  }
}

export interface User {
  id: number;
  intra_id: string;
  username: string;
  password: string;
  email: string;
  first_name: string;
  last_name: string;
  created_at: string;
  updated_at: string;
  verified: boolean;
  img_url: string;
  achievements: number;
  group_member: Array<number>;
}

// Frineds Type
export interface Friends {
  id: number;
  sender_id: number;
  receiver_id: number;
  accepted: string;
  created_at: string;
  updated_at: string;
}

/*************** Users DTO **************/
export class GetUserQuery {
  @IsString()
  @IsOptional()
  cursor: string;
  @IsString()
  @IsOptional()
  @IsIn(['ONLINE', 'OFFLINE', 'PLAYING'])
  status: 'ONLINE' | 'OFFLINE' | 'PLAYING';
  @IsString()
  @IsOptional()
  findBy: string;
}

/*************** Users DTO **************/

/************ Profile DTO **************/
export class ProfileBody {
  @IsString()
  id: string;
}

/************ Profile DTO **************/

/***********    Friends & Friends Requests    ***********/
//sendRequest DTO
export class friendRequestBody {
  @IsString()
  @IsNotEmpty()
  id: string;
}
export class acceptRequestBody {
  @IsString()
  @IsNotEmpty()
  id: string;
}

// Unfriend DTO
export class unfriendRequestBody {
  @IsString()
  @IsNotEmpty()
  id: string;
}

// Block User DTO
export class blockRequestBody {
  @IsString()
  @IsNotEmpty()
  id: string;
}
/***********    Friends & Friends Requests    ***********/

/************** QUEUE Interface ***********************/
// queue interface
export interface QueueInterface {
  GameLevel: 'EASY' | 'NORMAL' | 'DIFFICULT';
  users: number[];
}

// register to queue dto
export class RegisterToQueueBody {
  @IsNotEmpty()
  @IsIn(['EASY', 'NORMAL', 'DIFFICULT'])
  gameLevel: 'EASY' | 'NORMAL' | 'DIFFICULT';
}

/************** QUEUE Interface ***********************/

/*************** Game Interface ***********************/
// invite user to play game
export class InvitePlayGame {
  @IsNotEmpty()
  @IsNumber()
  userId: number;
  @IsNotEmpty()
  @IsIn(['EASY', 'NORMAL', 'DIFFICULT'])
  gameLevel: 'EASY' | 'NORMAL' | 'DIFFICULT';
}

// accepte game invite
export class AcceptePlayGame {
  @IsNotEmpty()
  @IsNumber()
  inviteId: number;
}

// reject game invite
export class RejectPlayGame {
  @IsNotEmpty()
  @IsNumber()
  inviteId: number;
}

// create game dto
export class CreateGameBody extends InvitePlayGame {}

// leave game dto
export class LeaveGameBody {
  @IsNotEmpty()
  @IsNumber()
  gameId: number;
}

export class GetGameQuery {
  @IsNotEmpty()
  @Matches('^[0-9]*$')
  gameId: string;
}

/*************** Game Interface ***********************/

/******************** Notifcations ********************/
// get notifications
export class GetNotifcaions {
  @IsNotEmpty()
  @IsNumber()
  userId: number;
}

// socket read notifications
export class ReadNotification {
  @IsNotEmpty()
  @IsNumber()
  id: number;
}

/******************** Notifcations ********************/
