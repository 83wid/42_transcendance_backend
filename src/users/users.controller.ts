import {
  Controller,
  Get,
  Param,
  Put,
  Req,
  Res,
  Query,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  Post,
} from "@nestjs/common";
import { JwtAuthGuard } from "src/auth/jwt-auth.guard";
import { UsersService } from "./users.service";
import { Request, Response } from "express";
import { GetUserQuery } from "src/interfaces/user.interface";
import { FileInterceptor } from "@nestjs/platform-express/multer";

@Controller("users")
export class UsersController {
  constructor(private usersService: UsersService) {}
  @Put("update")
  @UseGuards(JwtAuthGuard)
  async updateUser(@Req() req: Request, @Res() res: Response) {
    const user = await this.usersService.updateUser({
      data: req.body,
      where: { intra_id: req.user.sub },
    });
    return res.status(201).json(user);
  }

  @Post("updateAvatar")
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor("file"))
  updateAvatar(@UploadedFile() file: Express.Multer.File, @Req() req: Request, @Res() res: Response) {
    console.log(file, req.body);
    return res.status(200).json({ message: "done" });
  }

  @Get("all")
  @UseGuards(JwtAuthGuard)
  async getAllUsers(@Query() query: GetUserQuery, @Res() res: Response) {
    return this.usersService.getAllUsers(query, res);
  }
  @Get(":username")
  @UseGuards(JwtAuthGuard)
  async findUser(@Param("username") username: string) {
    return this.usersService.user({ username: username });
  }
}
