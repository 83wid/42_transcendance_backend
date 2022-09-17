import { Injectable } from '@nestjs/common';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class AuthService {
  constructor(private UserService: UsersService) {}
  async authenticate(req: any) {
    if (!req.user) {
      return {
        message: 'User not found',
      };
    }
    const intra_id = req.user.id;
    const email = req.user.emails[0].value;
    const first_name = req.user.name.givenName;
    const last_name = req.user.name.familyName;
    const username = req.user.username;
    const img_url = req.user.photos[0].value;
    const user = await this.UserService.user({
      email,
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
      console.log('new user', newUser);
      return newUser;
    }
    console.log('old user', req.user);
    return user;
  }
}
