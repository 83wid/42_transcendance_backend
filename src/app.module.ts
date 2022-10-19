import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import config from './helpers/config';
import { JwtStategy } from './auth/jwt.strategy';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from './auth/constants';
import { FriendsService } from './friends/friends.service';
import { ChatService } from './chat/chat.service';
import { ChatModule } from './chat/chat.module';
import { FriendsModule } from './friends/friends.module';
import { ProfileModule } from './profile/profile.module';
import { GameModule } from './game/game.module';
import { AchievementsModule } from './achievements/achievements.module';
import { AppGateway } from './app.gateway';
import { AuthService } from './auth/auth.service';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, load: [config] }),
    AuthModule,
    UsersModule,
    PrismaModule,
    FriendsModule,
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '60s' },
    }),
    ChatModule,
    ProfileModule,
    GameModule,
    AchievementsModule,
  ],
  controllers: [AppController],
  providers: [
    AuthService,
    AppService,
    JwtStategy,
    FriendsService,
    ChatService,
    AppGateway,
  ],
})
export class AppModule {}
