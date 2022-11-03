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
import { AuthService } from './auth/auth.service';
import { NotificationsModule } from './notifications/notifications.module';
import { NotificationsGateway } from './notifications/notifications.gateway';
import { PrismaService } from './prisma/prisma.service';
import { SocketModule } from './socket/socket.module';
import { AchievementsService } from './achievements/achievements.service';
import { SocketGateway } from './socket/socket.gateway';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, load: [config] }),
    PrismaModule,
    AuthModule,
    UsersModule,
    FriendsModule,
    JwtModule.register({
      secret: jwtConstants.secret,
    }),
    ChatModule,
    ProfileModule,
    GameModule,
    NotificationsModule,
    AchievementsModule,
  ],
  controllers: [AppController],
  providers: [
    AuthService,
    PrismaService,
    AppService,
    JwtStategy,
    FriendsService,
    ChatService,
    AchievementsService,
    NotificationsGateway,
  ],
})
export class AppModule {}
