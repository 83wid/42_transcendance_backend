import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  async authenticate(req: any) {
    if (!req.user) {
      return {
        message: 'User not found',
      };
    }
    // const email = req.user.emails[0].value;
    // const name = req.user.username;
    // const user = await this.prisma.user.findUnique({
    //   where: {
    //     email,
    //   },
    // });
    // if (!user) {
    //   const newUser = await this.prisma.user.create({
    //     data: {
    //       email,
    //       name,
    //     },
    //   });
    //   console.log('new user', newUser);
    // }
    console.log('old user', req.user);
    return req.user;
  }
}
