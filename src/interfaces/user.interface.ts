import { Exclude, Type } from "class-transformer";
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from "class-validator";
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
declare module "socket.io" {
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

/****************** Pagination DTO ******************/
export class PaginationDTO {
  @IsNumber()
  @IsOptional()
  // @Matches(/^\d+$/)
  @Type(() => Number)
  @Min(1)
  cursor: number;
  @IsNumber()
  @IsOptional()
  @Type(() => Number)
  @Min(1)
  // @Matches(/^\d+$/)
  pageSize: number;
}

/****************** Pagination DTO ******************/

/*************** Users DTO **************/
export class GetUserQuery extends PaginationDTO {
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
  GameLevel: "EASY" | "NORMAL" | "DIFFICULT";
  users: number[];
}

// register to queue dto
export class RegisterToQueueBody {
  @IsNotEmpty()
  @IsIn(["EASY", "NORMAL", "DIFFICULT"])
  gameLevel: "EASY" | "NORMAL" | "DIFFICULT";
}

/************** QUEUE Interface ***********************/

/*************** Game Interface ***********************/
// invite user to play game
export class InvitePlayGame {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  userId: number;
  @IsNotEmpty()
  @IsIn(["EASY", "NORMAL", "DIFFICULT"])
  gameLevel: "EASY" | "NORMAL" | "DIFFICULT";
}

// accepte game invite
export class AcceptePlayGame {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  inviteId: number;
}

// reject game invite
export class RejectPlayGame {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  inviteId: number;
}

// create game dto
export class CreateGameBody extends InvitePlayGame {}

// leave game dto
export class LeaveGameBody {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  gameId: number;
}

export class GetGameQuery {
  @IsNotEmpty()
  @Matches(/^\d+$/)
  gameId: string;
}

/*************** Game Interface ***********************/

/******************** Notifcations ********************/
// get notifications
export class GetNotifcaions {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  userId: number;
}

// socket read notifications
export class ReadNotification {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  id: number;
}

/******************** Notifcations ********************/

/******************* CHAT ****************************/
export class GetConversation {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  @Type(() => Number)
  id: number;
}

export class CreateConversation {
  @IsArray()
  @ArrayNotEmpty()
  @IsNumber({}, { each: true })
  @Min(1, { each: true })
  @Type(() => Number)
  members: number[];
  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  @MaxLength(15)
  title: string;
  @IsString()
  @IsOptional()
  @MinLength(6)
  @MaxLength(20)
  password: string;
  @IsNotEmpty()
  @IsBoolean()
  public: boolean;
}

export class MessageDTO {
  @IsOptional()
  @IsNumber()
  @Min(1)
  conversationId: number;
  @IsOptional()
  @IsNumber()
  @Min(1)
  userId: number;
  @IsNotEmpty()
  @IsString()
  @MaxLength(80)
  message: string;
}

export class LeaveConvesation {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  conversationId: number;
}

export class DeleteConversation {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  conversationId: number;
}

export class ToggleMuteUser {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  memberId: number;
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  conversationId: number;
  @IsNotEmpty()
  @IsBoolean()
  mute: boolean;
}

export class JoinConversation {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  conversationId: number;
  @IsString()
  @IsOptional()
  @MinLength(6)
  @MaxLength(20)
  password: string;
}

export class AddMember {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  conversationId: number;
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  userId: number;
}

export class addAdminConversation {
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  conversationId: number;
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  userId: number;
}

export class ConversationDataReturn {
  @Exclude()
  password: string;
}

/******************* CHAT ****************************/
