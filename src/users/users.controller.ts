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
  UploadedFiles,
} from "@nestjs/common";
import { JwtAuthGuard } from "src/auth/jwt-auth.guard";
import { UsersService } from "./users.service";
import { Request, Response } from "express";
import { GetUserQuery } from "src/interfaces/user.interface";
import { FileFieldsInterceptor, FileInterceptor } from "@nestjs/platform-express/multer";
import { diskStorage } from "multer";
import { existsSync, mkdirSync } from "fs";

@Controller("users")
export class UsersController {
  constructor(private usersService: UsersService) {}
  @Put("update")
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(
    FileFieldsInterceptor(
      [
        { name: "avatar", maxCount: 1 },
        { name: "cover", maxCount: 1 },
      ],
      {
        fileFilter: function (req, file, cb) {
          if (/^image\/(webp|svg|png|gif|jpe?g|jfif|bmp|dpg|ico)$/i.test(file.mimetype)) cb(null, true);
          else cb(null, false);
        },
        storage: diskStorage({
          destination: (req, file, cb) => {
            const uploadPath = process.env.UPLOAD_LOCATION;
            if (!existsSync(uploadPath)) {
              mkdirSync(uploadPath);
            }
            cb(null, uploadPath);
          },
          filename: (req, file, cb) => {
            const filesName = `${file.fieldname}_${req.user.sub}.${file.originalname.split(".").at(-1)}`;
            cb(null, filesName);
          },
        }),
      }
    )
  )
  async updateUser(
    @Req() req: Request,
    @Res() res: Response,
    @UploadedFiles()
    files: { avatar?: Express.Multer.File[]; cover?: Express.Multer.File[] }
  ) {
    const { avatar, cover } = files;
    // http://localhost:3000/upload/avatar_51111.jpeg
    console.log(avatar);

    let data = req.body;
    if (avatar) data.img_url = `${process.env.PUBLIC_URL}/users/image/${avatar[0].filename}`;
    if (cover) data.cover = `${process.env.PUBLIC_URL}/users/image/${cover[0].filename}`;
    console.log(data);

    const user = await this.usersService.updateUser({
      data,
      where: { intra_id: req.user.sub },
    });
    return res.status(201).json(user);
  }
  @Get("/image/:fileName")
  serveAvatar(@Param("fileName") fileName: string, @Res() res: Response) {
    console.log("done");
    res.sendFile(fileName, { root: "upload" });
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
