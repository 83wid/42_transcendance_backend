-- CREATE DATABASE TRANSCENDANCE;
-- USE TRANSCENDANCE;
CREATE TYPE level_type AS ENUM ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');

CREATE TYPE game_diff AS ENUM ('EASY', 'NORMAL', 'DIFFICULT');

CREATE TYPE game_status AS ENUM('WAITING', 'PLAYING', 'END');

CREATE TYPE conversation_type AS ENUM ('DIRECT', 'GROUP');

CREATE TYPE NOTIFICATION_T AS ENUM ('FRIEND_REQUEST', 'GAME_INVITE', 'GAME_ACCEPTE' , 'OTHER');

CREATE TYPE STATUS_T AS ENUM ('ONLINE', 'OFFLINE', 'PLAYING');

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
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

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
  createdAt timestamp NOT NULL,
  updatedAt timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

-- create table for players
CREATE TABLE players (
  id SERIAL NOT NULL,
  userId INT NOT NULL,
  gameId INT NOT NULL,
  score integer DEFAULT 0,
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
  targetId INT NOT NULL,
  content TEXT,
  read BOOLEAN DEFAULT false,
  createdAt timestamp NOT NULL,
  updatedAt timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (userId) REFERENCES users (intra_id) ON DELETE CASCADE,
  FOREIGN KEY (fromId) REFERENCES users (intra_id) ON DELETE CASCADE,
  PRIMARY KEY (id)
);

-- create table for messages
CREATE TABLE achievements (
  id SERIAL NOT NULL,
  name VARCHAR(25) NOT NULL,
  level level_type DEFAULT 'BRONZE',
  xp int NOT NULL,
  description text,
  PRIMARY KEY (id)
);

-- create table for users_achievements
CREATE TABLE users_achievements (
  id SERIAL NOT NULL,
  userId INT NOT NULL,
  achievementId INT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (achievementId) REFERENCES achievements (id),
  createdAt timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

INSERT INTO
  achievements(name, level, xp, description)
VALUES
  ('friendly', 'SILVER', 10, 'add 10 friends'),
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
    'winn 4 matches with max a score'
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

INSERT INTO
  users (
    intra_id,
    username,
    email,
    first_name,
    last_name,
    status,
    xp,
    img_url,
    cover
  )
VALUES
  (
    51111,
    'alizaynou',
    'alzaynou@student.1337.ma',
    'Ali',
    'Zaynoune',
    'ONLINE',
    floor(random() * 8800) :: int,
    'https://cdn.intra.42.fr/users/alzaynou.jpg',
    'https://random.imagecdn.app/1800/800'
  );

INSERT INTO
  users (
    intra_id,
    username,
    email,
    first_name,
    last_name,
    status,
    xp,
    img_url,
    cover
  )
SELECT
  id,
  'alizaynoune' || id,
  'zaynoune' || id || '@ali.ali',
  'ali',
  'zaynoune',
  (array ['ONLINE', 'OFFLINE']) [floor(random() * 2 + 1)] :: STATUS_T,
  floor(random() * 8000) :: int,
  'https://joeschmoe.io/api/v1/random',
  'https://random.imagecdn.app/1800/800'
FROM
  generate_series(1, 200) AS id;

INSERT INTO
  users_achievements (userId, achievementId)
SELECT
  51111,
  id * 2
FROM
  generate_series(1, 10) AS id;

INSERT INTO
  users_achievements (userId, achievementId)
SELECT
  id,
  id
FROM
  generate_series(1, 20) AS id;

INSERT INTO
  invites (senderId, receiverId)
SELECT
  id,
  51111
FROM
  generate_series(1, 60) AS id;

INSERT INTO
  invites (senderId, receiverId)
SELECT
  51111,
  id
FROM
  generate_series(60, 80) AS id;

INSERT INTO
  notification (
    userId,
    fromId,
    type,
    targetId,
    content,
    createdAt
  )
SELECT
  51111,
  id,
  'FRIEND_REQUEST',
  id,
  'send you friend request',
  now()
FROM
  generate_series(1, 60) AS id;

-- INSERT INTO
--   game (level, status, updatedAt)
-- SELECT
--   (array['EASY', 'NORMAL', 'DIFFICULT'])[floor(random() * 3 + 1)]::game_diff,
--   (array['WAITING', 'PLAYING', 'END'])[floor(random() * 3 + 1)]::game_status,
--   NOW() + (floor(random() * 800) :: int) * interval '1 seconds'
-- FROM
--   generate_series(1, 50) AS id;
-- INSERT INTO
--   players (userId, gameId, score)
-- SELECT
--   id,
--   id,
--   floor(random() * 4)
-- FROM
--   generate_series(1, 50) AS id;
-- INSERT INTO
--   players (userId, gameId, score)
-- SELECT
--   51111,
--   id,
--   floor(random() * 5)
-- FROM
--   generate_series(1, 50) AS id;
-- INSERT INTO
--   game (level, status, updatedAt)
-- SELECT
--   (array['EASY', 'NORMAL', 'DIFFICULT'])[floor(random() * 3 + 1)]::game_diff,
--   (array['WAITING', 'PLAYING', 'END'])[floor(random() * 3 + 1)]::game_status,
--   NOW() + (floor(random() * 800) :: int) * interval '1 seconds'
-- FROM
--   generate_series(50, 100) AS id;
-- INSERT INTO
--   players (userId, gameId, score)
-- SELECT
--   id,
--   id,
--   floor(random() * 4)
-- FROM
--   generate_series(51, 101) AS id;
-- INSERT INTO
--   players (userId, gameId, score)
-- SELECT
--   id,
--   id - 50,
--   floor(random() * 4)
-- FROM
--   generate_series(101, 151) AS id;