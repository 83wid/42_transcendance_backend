-- CREATE DATABASE TRANSCENDANCE;
-- USE TRANSCENDANCE;
CREATE TYPE level_type AS ENUM ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');
CREATE TYPE game_diff AS ENUM ('EASY', 'NORMAL', 'DIFFICULT');
CREATE TYPE game_status AS ENUM('WAITING', 'PLAYING', 'END');
CREATE TYPE conversation_type AS ENUM ('DIRECT', 'GROUP');
CREATE TYPE NOTIFICATION_T AS ENUM (
  'FRIEND_REQUEST',
  'GAME_INVITE',
  'GAME_ACCEPTE',
  'OTHER'
);
CREATE TYPE ACHIEV_NAME AS ENUM(
  'friendly',
  'legendary',
  'sharpshooter',
  'wildfire',
  'winner',
  'photogenic'
);
CREATE TYPE STATUS_T AS ENUM ('ONLINE', 'OFFLINE', 'PLAYING');
-- create function auto update updated_at
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = now();
RETURN NEW;
END;
$$ language 'plpgsql';
-- create function auto increment user.xp by achivements
Create function update_user_xp(
  userId int,
  achievementName ACHIEV_NAME,
  achievementLevel level_type
) returns int language plpgsql as $$
Declare xp integer;
Begin
select xp into xp
from achievements
where name = achievementName
  and level = achievementLevel;
INSERT INTO users(xp)
VALUES(2);
return 2;
End;
$$;
-- CREATE OR REPLACE FUNCTION increment_xp(user_xp, achievementName, achievementLevel) RETURN INT language 'plpgsql' AS $$ BEGIN
-- select xp
-- from achievements
-- where name = achievementName level = achievementLevel return xp + user_xp
-- END $$;
-- create table for users
CREATE TABLE users (
  id SERIAL NOT NULL unique,
  intra_id INT NOT NULL unique,
  username varchar(255) NOT NULL unique,
  email varchar(255) NOT NULL unique,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  status STATUS_T DEFAULT 'OFFLINE',
  xp INT DEFAULT 0,
  img_url varchar(255),
  cover varchar(255),
  created_at timestamp DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  PRIMARY KEY (id)
);
CREATE TRIGGER update_users_changetimestamp BEFORE
UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
-- create table for all conversation
CREATE TABLE conversation (
  id SERIAL NOT NULL unique,
  name varchar(255),
  type conversation_type DEFAULT 'DIRECT',
  PRIMARY KEY (id)
);
-- create table for for group members 
CREATE TABLE group_member (
  id SERIAL NOT NULL unique,
  user_id INT NOT NULL,
  conversation_id INT NOT NULL,
  joint_date timestamp DEFAULT now(),
  left_date timestamp,
  FOREIGN KEY (user_id) REFERENCES users (intra_id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id),
  PRIMARY KEY (id)
);
-- create table for messages
CREATE TABLE message (
  id SERIAL NOT NULL unique,
  sender_id INT NOT NULL,
  content text NOT NULL,
  conversation_id INT NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now(),
  read_by integer [],
  delivered_to integer [],
  PRIMARY KEY (id),
  FOREIGN KEY (sender_id) REFERENCES users (intra_id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id)
);
-- create table for Friends
CREATE TABLE friends (
  id SERIAL NOT NULL,
  userId INT NOT NULL,
  friendId INT NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (friendId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);
-- create table for Friends requests
CREATE TABLE invites (
  id SERIAL NOT NULL,
  senderId INT NOT NULL,
  receiverId INT NOT NULL,
  accepted BOOLEAN DEFAULT false,
  created_at timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (senderId) REFERENCES users (intra_id),
  FOREIGN KEY (receiverId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);
-- create table for Blocked users
CREATE TABLE blocked (
  id SERIAL NOT NULL,
  userId INT NOT NULL,
  blockedId INT NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (blockedId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);
-- create table for test
CREATE TABLE game (
  id SERIAL NOT NULL,
  status game_status DEFAULT 'WAITING',
  level game_diff DEFAULT 'NORMAL',
  started boolean DEFAULT false,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);
-- create table for players
CREATE TABLE players (
  id SERIAL NOT NULL,
  userId INT NOT NULL,
  gameId INT NOT NULL,
  score integer DEFAULT 0,
  ready boolean DEFAULT false,
  FOREIGN KEY (userId) REFERENCES users (intra_id) ON DELETE CASCADE,
  FOREIGN KEY (gameId) REFERENCES game (id) ON DELETE CASCADE,
  PRIMARY KEY (id)
);
-- create table for gameInvites
CREATE TABLE gameInvites(
  id SERIAL NOT NULL,
  userId INT NOT NULL,
  fromId INT NOT NULL,
  gameId INT NOT NULL,
  accepted BOOLEAN DEFAULT false,
  FOREIGN KEY (userId) REFERENCES users (intra_id) ON DELETE CASCADE,
  FOREIGN KEY (fromId) REFERENCES users (intra_id) ON DELETE CASCADE,
  FOREIGN KEY (gameId) REFERENCES game (id) ON DELETE CASCADE,
  PRIMARY KEY (id)
);
-- create table for notification
CREATE TABLE notification (
  id SERIAL,
  type NOTIFICATION_T NOT NULL DEFAULT 'OTHER',
  userId INT NOT NULL,
  fromId INT NOT NULL,
  targetId INT DEFAULT 0,
  content TEXT,
  read BOOLEAN DEFAULT false,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (userId) REFERENCES users (intra_id) ON DELETE CASCADE,
  FOREIGN KEY (fromId) REFERENCES users (intra_id) ON DELETE CASCADE,
  PRIMARY KEY (id)
);
-- create table for messages
CREATE TABLE achievements (
  id SERIAL UNIQUE,
  name ACHIEV_NAME NOT NULL,
  level level_type DEFAULT 'BRONZE',
  xp int NOT NULL,
  description text,
  PRIMARY KEY(name, level)
);
-- create table for users_achievements
CREATE TABLE users_achievements (
  userId INT NOT NULL,
  achievementName ACHIEV_NAME NOT NULL,
  achievementLevel level_type,
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (achievementName, achievementLevel) REFERENCES achievements (name, level),
  created_at timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (userId, achievementName, achievementLevel)
);
INSERT INTO achievements(name, level, xp, description)
VALUES ('friendly', 'SILVER', 10, 'add 10 friends'),
  ('friendly', 'BRONZE', 20, 'add 20 friends'),
  ('friendly', 'GOLD', 50, 'add 50 friends'),
  ('friendly', 'PLATINUM', 100, 'add 100 friends'),
  (
    'legendary',
    'SILVER',
    100,
    'win 1 matche with a max score'
  ),
  (
    'legendary',
    'BRONZE',
    250,
    'win 2 matches with max a score'
  ),
  (
    'legendary',
    'GOLD',
    350,
    'win 3 matches with max a score'
  ),
  (
    'legendary',
    'PLATINUM',
    500,
    'win 4 matches with max a score'
  ),
  (
    'sharpshooter',
    'SILVER',
    100,
    'win 2 matches in one day'
  ),
  (
    'sharpshooter',
    'BRONZE',
    250,
    'win 3 matches in one day'
  ),
  (
    'sharpshooter',
    'GOLD',
    350,
    'win 4 matches in one day'
  ),
  (
    'sharpshooter',
    'PLATINUM',
    500,
    'win 5 matches in one day'
  ),
  (
    'wildfire',
    'SILVER',
    500,
    'play 5 matches in one day'
  ),
  (
    'wildfire',
    'BRONZE',
    1400,
    'play 10 matches in one day'
  ),
  (
    'wildfire',
    'GOLD',
    2000,
    'play 15 matches in one day'
  ),
  (
    'wildfire',
    'PLATINUM',
    5000,
    'play 20 matches in one day'
  ),
  (
    'winner',
    'SILVER',
    500,
    'Be ranked #1 for 1 day'
  ),
  (
    'winner',
    'BRONZE',
    1000,
    'Be ranked #1 for 2 day'
  ),
  ('winner', 'GOLD', 3000, 'Be ranked #1 for 3 day'),
  (
    'winner',
    'PLATINUM',
    7000,
    'Be ranked #1 for 4 day'
  ),
  ('photogenic', 'GOLD', 100, 'change your avatar'),
  (
    'photogenic',
    'PLATINUM',
    100,
    'change your cover'
  );
INSERT INTO users (
    intra_id,
    username,
    email,
    first_name,
    last_name,
    status,
    img_url
  )
SELECT id,
  'alizaynoune' || id,
  'zaynoune' || id || '@ali.ali',
  'ali',
  'zaynoune',
  'OFFLINE',
  'https://joeschmoe.io/api/v1/random'
FROM generate_series(1, 200) AS id;