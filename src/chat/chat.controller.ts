import { Body, Controller, Delete, Get, Param, Post, Put, Query, Req, Res, UseGuards } from "@nestjs/common";
import { Response, Request } from "express";
import { JwtAuthGuard } from "src/auth/jwt-auth.guard";
import { ChatService } from "./chat.service";
import { ChatGateway } from "./chat.gateway";
import {
  CreateConversation,
  // GetConversationBody,
  // MessageDTO,
  ToggleMuteUser,
  LeaveConvesation,
  DeleteConversation,
  PaginationDTO,
  JoinConversation,
  // AddMember,
  addAdminConversation,
  ToggleBanUser,
  ConversationUpdate,
  Conversation,
  GetConversation,
  MessageDTO,
  Search,
  // SendMessage,
  // ConversationParam,
} from "src/interfaces/user.interface";
import { conversation, members, users, message } from "@prisma/client";

@Controller("conversation")
export class ChatController {
  constructor(private chatService: ChatService, private chatGateway: ChatGateway) {}

  @Get("/")
  @UseGuards(JwtAuthGuard)
  getAllConversation(@Req() req: Request, @Res() res: Response, @Query() query: PaginationDTO) {
    return this.chatService.getAllConversation(res, req.user.sub, query);
  }

  @Post("create")
  @UseGuards(JwtAuthGuard)
  async createConversation(@Req() req: Request, @Res() res: Response, @Body() dto: CreateConversation) {
    return await this.chatService.createConversation(res, req.user.sub, dto);
  }

  @Get("search")
  @UseGuards(JwtAuthGuard)
  async seachConversation(@Req() req: Request, @Res() res: Response, @Query() dto: Search) {
    return await this.chatService.searshConversation(res, req.user.sub, dto);
  }

  @Post("/:id")
  @UseGuards(JwtAuthGuard)
  getConversation(@Req() req: Request, @Res() res: Response, @Param() param: Conversation, @Body() dto: GetConversation) {
    return this.chatService.getConversation(res, req.user.sub, { ...param, ...dto });
  }

  @Post("/:id/join")
  @UseGuards(JwtAuthGuard)
  joinConversation(@Req() req: Request, @Res() res: Response, @Param() id: Conversation, @Body() dto: JoinConversation) {
    return this.chatService.joinConversation(res, req.user.sub, { ...id, ...dto });
  }

  @Put("/:id/addadmin")
  @UseGuards(JwtAuthGuard)
  addAdmin(@Req() req: Request, @Res() res: Response, @Param() id: Conversation, @Body() dto: addAdminConversation) {
    return this.chatService.addAdminConversation(res, req.user.sub, { ...dto, ...id });
  }

  @Put("/:id/togglemute")
  @UseGuards(JwtAuthGuard)
  toggleMuteUser(@Req() req: Request, @Res() res: Response, @Param() id: Conversation, @Body() dto: ToggleMuteUser) {
    return this.chatService.toggleMuteUser(res, req.user.sub, { ...dto, ...id });
  }

  @Put("/:id/toggleban")
  @UseGuards(JwtAuthGuard)
  toggleBanUser(@Req() req: Request, @Res() res: Response, @Param() id: Conversation, @Body() dto: ToggleBanUser) {
    return this.chatService.toggleBanUser(res, req.user.sub, { ...dto, ...id });
  }

  @Post("/:id/message")
  @UseGuards(JwtAuthGuard)
  newMessage(@Req() req: Request, @Res() res: Response, @Param() id: Conversation, @Body() dto: MessageDTO) {
    return this.chatService.sendMessage(res, req.user.sub, { ...id, ...dto });
  }

  @Put("/:id/leave")
  @UseGuards(JwtAuthGuard)
  leaveConversation(@Req() req: Request, @Res() res: Response, @Param() dto: Conversation) {
    return this.chatService.leaveConversation(res, req.user.sub, dto);
  }

  @Get("/:id/messages")
  @UseGuards(JwtAuthGuard)
  getConversationMessages(
    @Req() req: Request,
    @Res() res: Response,
    @Param() dto: Conversation,
    @Query() query: PaginationDTO,
    @Body() body: GetConversation
  ) {
    return this.chatService.getConversationMessages(res, req.user.sub, { ...dto, ...query, ...body });
  }

  @Put("/:id/update")
  @UseGuards(JwtAuthGuard)
  async updateConversation(
    @Req() req: Request,
    @Res() res: Response,
    @Param() param: Conversation,
    @Body() body: ConversationUpdate
  ) {
    if (!Object.keys(body).length) return res.status(400).json({ message: "Bad Request" });
    return this.chatService.updateConversation(res, req.user.sub, { ...param, ...body });
  }
  @Delete("/:id/delete")
  @UseGuards(JwtAuthGuard)
  deleteConversation(@Req() req: Request, @Res() res: Response, @Param() dto: Conversation) {
    return this.chatService.deleteConversation(res, req.user.sub, dto);
  }
}
