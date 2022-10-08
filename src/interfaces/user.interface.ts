import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

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
  achivements: number;
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

/***********    Friends & Friends Requests    ***********/
//sendRequest DTO
export class friendRequestBody {
  @IsString()
  @IsNotEmpty()
  requestedId: string;
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
