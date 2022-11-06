import { Body, Controller, Delete, Get, Param, Post, Put, Query, Req, Res, UseGuards } from "@nestjs/common";
import { Response, Request } from "express";
import { JwtAuthGuard } from "src/auth/jwt-auth.guard";
import { ChatService } from "./chat.service";
import {
  CreateConversation,
  GetConversation,
  MessageDTO,
  ToggleMuteUser,
  LeaveConvesation,
  DeleteConversation,
  PaginationDTO,
  JoinConversation,
  AddMember,
  addAdminConversation,
} from "src/interfaces/user.interface";

@Controller("conversation")
export class ChatController {
  constructor(private chatService: ChatService) {}

  @Get("/")
  @UseGuards(JwtAuthGuard)
  getAllConversation(@Req() req: Request, @Res() res: Response, @Query() query: PaginationDTO) {
    return this.chatService.getAllConversation(res, req.user.sub, query);
  }

  @Post("create")
  @UseGuards(JwtAuthGuard)
  createConversation(@Req() req: Request, @Res() res: Response, @Body() dto: CreateConversation) {
    return this.chatService.createConversation(res, req.user.sub, dto);
  }

  @Post("join")
  @UseGuards(JwtAuthGuard)
  joinConversation(@Req() req: Request, @Res() res: Response, @Body() dto: JoinConversation) {
    return this.chatService.joinConversation(res, req.user.sub, dto);
  }

  @Post("addmember")
  @UseGuards(JwtAuthGuard)
  addMember(@Req() req: Request, @Res() res: Response, @Body() dto: AddMember) {
    return this.chatService.addMember(res, req.user.sub, dto);
  }

  @Put("addadmin")
  @UseGuards(JwtAuthGuard)
  addAdmin(@Req() req: Request, @Res() res: Response, @Body() dto: addAdminConversation) {
    return this.chatService.addAdminConversation(res, req.user.sub, dto);
  }

  // @Post("message")
  // @UseGuards(JwtAuthGuard)
  // newMessage(@Req() req: Request, @Res() res: Response, @Body() dto: MessageDTO) {
  //   return this.chatService.sendMessage(res, req.user.sub, dto);
  // }

  @Put("togglemute")
  @UseGuards(JwtAuthGuard)
  toggleMuteUser(@Req() req: Request, @Res() res: Response, @Body() dto: ToggleMuteUser) {
    return this.chatService.toggleMuteUser(res, req.user.sub, dto);
  }

  @Put("leave")
  @UseGuards(JwtAuthGuard)
  leaveConversation(@Req() req: Request, @Res() res: Response, @Body() dto: LeaveConvesation) {
    return this.chatService.leaveConversation(res, req.user.sub, dto);
  }

  @Delete("delete")
  @UseGuards(JwtAuthGuard)
  deleteConversation(@Req() req: Request, @Res() res: Response, @Body() dto: DeleteConversation) {
    return res.status(200).json(dto);
  }

  @Get("/:id/messages")
  @UseGuards(JwtAuthGuard)
  getConversationMessages(
    @Req() req: Request,
    @Res() res: Response,
    @Param() dto: GetConversation,
    @Query() query: PaginationDTO
  ) {
    return this.chatService.getConversationMessages(res, req.user.sub, dto.id, query);
  }

  @Get("/:id")
  @UseGuards(JwtAuthGuard)
  getConversation(@Req() req: Request, @Res() res: Response, @Param() dto: GetConversation) {
    return this.chatService.getConversation(res, req.user.sub, dto.id);
  }
}
