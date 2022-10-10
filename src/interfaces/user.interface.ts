import { IsNotEmpty, IsNumber, IsString } from 'class-validator';
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

/************* Game DTO ***************/
export class InvitePlayGame {
  @IsNotEmpty()
  @IsString()
  userId: string;
}
export class rejectGame {}

export class acceptGame {}

export class endGame {}

/***********    Friends & Friends Requests    ***********/
//sendRequest DTO
export class friendsBody {
  @IsString()
  @IsNotEmpty()
  id: string;
}
/***********    Friends & Friends Requests    ***********/
