import {
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';
// import { Response as Res, Request as Req } from 'express';

// Global Interface declare
export {};
declare global {
  namespace Express {
    interface Request {
      user: any;
    }
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
}

// accepte game invite
export class AcceptePlayGame{
  @IsNotEmpty()
  @IsNumber()
  inviteId: number
}

// reject game invite
export class RejectPlayGame{
  @IsNotEmpty()
  @IsNumber()
  inviteId: number
}

// create game dto
export class CreateGameBody extends InvitePlayGame {
  @IsNotEmpty()
  @IsIn(['EASY', 'NORMAL', 'DIFFICULT'])
  gameLevel: 'EASY' | 'NORMAL' | 'DIFFICULT';
}

// leave game dto
export class LeaveGameBody {
  @IsNotEmpty()
  @IsNumber()
  gameId: number;
}

/*************** Game Interface ***********************/
