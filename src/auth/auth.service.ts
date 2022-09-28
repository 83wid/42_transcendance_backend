import { Injectable } from '@nestjs/common';
import { UsersService } from 'src/users/users.service';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    private UserService: UsersService,
    private jwtService: JwtService,
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
    if (!user) {
      const newUser = await this.UserService.createUser({
        intra_id,
        email,
        username,
        first_name,
        last_name,
        img_url,
      });
      const payload = {
        username: newUser.username,
        sub: newUser.intra_id,
        first_name: newUser.first_name,
        last_name: newUser.last_name,
        img_url: newUser.img_url,
        first_log: true,
      };
      return this.jwtService.sign(payload);
    }
    const payload = {
      username: user.username,
      sub: user.intra_id,
      first_name: user.first_name,
      last_name: user.last_name,
      img_url: user.img_url,
      first_log: false,
    };
    return this.jwtService.sign(payload);
  }
}
