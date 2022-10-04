-- CREATE DATABASE TRANSCENDANCE;
-- USE TRANSCENDANCE;
CREATE TYPE level_type AS ENUM ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');

CREATE TYPE game_diff AS ENUM ('EASY', 'NORMAL', 'DIFFICULT');

CREATE TYPE conversation_type AS ENUM ('DIRECT', 'GROUP');

CREATE TYPE notification_type AS ENUM('FRIEND_REQUEST', 'GAME_INVITE', 'OTHER');

CREATE TYPE user_status AS ENUM('ONLINE', 'OFFLINE', 'PLAYING');

-- create table for users
CREATE TABLE users (
  id SERIAL NOT NULL unique,
  intra_id SERIAL NOT NULL unique,
  username varchar(255) NOT NULL unique,
  -- password varchar(255) NOT NULL,
  email varchar(255) NOT NULL unique,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  img_url varchar(255),
  -- verified boolean DEFAULT false,
  achivements integer [],
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
  user_id SERIAL NOT NULL,
  conversation_id SERIAL NOT NULL,
  joint_date timestamp DEFAULT now(),
  left_date timestamp,
  FOREIGN KEY (user_id) REFERENCES users (intra_id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id),
  PRIMARY KEY (id)
);

-- create table for messages
CREATE TABLE message (
  id SERIAL NOT NULL unique,
  sender_id SERIAL NOT NULL,
  content text NOT NULL,
  conversation_id SERIAL NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now(),
  read_by integer [],
  delivered_to integer [],
  PRIMARY KEY (id),
  FOREIGN KEY (sender_id) REFERENCES users (intra_id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id)
);

-- create table for messages
CREATE TABLE achivements (
  id SERIAL NOT NULL,
  name VARCHAR(25) NOT NULL,
  level level_type DEFAULT 'BRONZE',
  xp int NOT NULL,
  description text,
  PRIMARY KEY (id)
);

-- create table for Friends
CREATE TABLE friends (
  id SERIAL NOT NULL,
  userId SERIAL NOT NULL,
  friendId SERIAL NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (friendId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);

-- create table for Friends requests
CREATE TABLE invites (
  id SERIAL NOT NULL,
  senderId SERIAL NOT NULL,
  receiverId SERIAL NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  accepted BOOLEAN DEFAULT false,
  FOREIGN KEY (senderId) REFERENCES users (intra_id),
  FOREIGN KEY (receiverId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);

-- create table for Blocked users
CREATE TABLE blocked (
  id SERIAL NOT NULL,
  userId SERIAL NOT NULL,
  blockedId SERIAL NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (blockedId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);

-- create table for messages
CREATE TABLE game (
  id SERIAL NOT NULL,
  player integer [],
  level game_diff DEFAULT 'NORMAL',
  scores integer [],
  PRIMARY KEY (id)
);

-- create table for notification
CREATE TABLE notification (
  id SERIAL,
  type notification_type NOT NULL DEFAULT 'OTHER',
  userId SERIAL NOT NULL,
  fromId SERIAL NOT NULL,
  targetId SERIAL NOT NULL,
  content TEXT,
  createdAt timestamp NOT NULL DEFAULT now(),
  updatedAt timestamp NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (intra_id),
  FOREIGN KEY (fromId) REFERENCES users (intra_id),
  PRIMARY KEY (id)
);

-- VALUES
--   (
--     generate_series(1, 10),
--     'ali' || (ARRAY['@', '.', '_', ','])[round(random()*3)] || 'zaynoune' || trunc(random() * 1000),
--     'ali' || (ARRAY['@', '.', '_', ','])[round(random()*3)] || '@zaynoune.com' || trunc(random() * 1000),
--     'ali',
--     'zaynoune'
--   )
INSERT INTO
  achivements(name, level, xp, description)
VALUES
  ('friendly', 'SILVER', 100, 'description'),
  ('friendly', 'BRONZE', 200, 'description'),
  ('friendly', 'GOLD', 300, 'description'),
  ('friendly', 'PLATINUM', 500, 'description'),
  ('legendary', 'SILVER', 100, 'description'),
  ('legendary', 'BRONZE', 200, 'description'),
  ('legendary', 'GOLD', 300, 'description'),
  ('legendary', 'PLATINUM', 500, 'description'),
  ('sharpshooter', 'SILVER', 100, 'description'),
  ('sharpshooter', 'BRONZE', 200, 'description'),
  ('sharpshooter', 'GOLD', 300, 'description'),
  ('sharpshooter', 'PLATINUM', 500, 'description'),
  ('wildfire', 'SILVER', 100, 'description'),
  ('wildfire', 'BRONZE', 200, 'description'),
  ('wildfire', 'GOLD', 300, 'description'),
  ('wildfire', 'PLATINUM', 500, 'description'),
  ('winner', 'SILVER', 100, 'description'),
  ('winner', 'BRONZE', 200, 'description'),
  ('winner', 'GOLD', 300, 'description'),
  ('winner', 'PLATINUM', 500, 'description'),
  ('photogenic', 'GOLD', 300, 'description'),
  ('photogenic', 'PLATINUM', 500, 'description');

INSERT INTO
  users(
    intra_id,
    username,
    email,
    first_name,
    last_name,
    img_url,
  )
SELECT
  nb,
  'alizaynoune' || nb,
  'aliZayoune' || nb || '@ali.ali',
  'ali' || nb,
  'zaynoune' || nb,
  'https://joeschmoe.io/api/v1/random'
FROM
  generate_series(1, 30) nb;