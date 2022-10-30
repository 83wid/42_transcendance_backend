import { Injectable } from '@nestjs/common';
import { UsersService } from 'src/users/users.service';
import { JwtService } from '@nestjs/jwt';
import { Response } from 'express';
import { PrismaService } from 'src/prisma/prisma.service';
import { pick } from 'lodash';
import { jwtConstants } from './constants';
import { decode } from 'querystring';

@Injectable()
export class AuthService {
  constructor(
    private UserService: UsersService,
    private jwtService: JwtService,
    private prisma: PrismaService,
  ) {}
  async authenticate(req: any) {
    if (!req.user) {
      return '';
    }
    const intra_id = Number(req.user.id);
    const email = req.user.emails[0].value;
    const first_name = req.user.name.givenName;
    const last_name = req.user.name.familyName;
    const username = req.user.username;
    const img_url = req.user.photos[0].value;
    const user = await this.UserService.user({
      intra_id,
    });
    console.log(user);
    
    if (!user) {
      try {
        const newUser = await this.UserService.createUser({
          intra_id,
          email,
          username,
          first_name,
          last_name,
          img_url,
        });
        console.log(newUser);
        
        const payload = {
          username: newUser.username,
          sub: newUser.intra_id,
          first_name: newUser.first_name,
          last_name: newUser.last_name,
          img_url: newUser.img_url,
          first_log: true,
        };

        return this.jwtService.sign(payload);
      } catch (error) {
        console.log(error);
        
        return '';
      }
    }
    const payload = {
      sub: user.intra_id,
    };
    console.log(this.jwtService.sign({ sub: 1 }));
    console.log(this.jwtService.sign({ sub: 2 }));
    return this.jwtService.sign(payload);
  }
  // get auth profile
  async authMe(id: number, res: Response) {
    try {
      const data = await this.prisma.users.findUnique({
        where: { intra_id: id },
      });
      if (!data) return res.status(404).json({ message: 'user not found' });
      console.log(data);

      const ret = pick(data, [
        'id',
        'intra_id',
        'username',
        'email',
        'first_name',
        'last_name',
        'img_url',
        'created_at',
        'updated_at',
      ]);
      console.log(this.jwtService.sign({ sub: 1 }));
      console.log(this.jwtService.sign({ sub: 2 }));
      return res.status(200).json(ret);
    } catch (error) {
      return res.status(400).json({
        message: error,
      });
    }
  }
  verifyJwt(jwt: string): Promise<any> {
    return this.jwtService.verifyAsync(jwt, { secret: jwtConstants.secret });
  }
}
