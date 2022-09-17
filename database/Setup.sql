-- CREATE DATABASE TRANSCENDANCE;
-- USE TRANSCENDANCE;
CREATE TYPE level_type AS ENUM ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');
CREATE TYPE game_diff AS ENUM ('EASY', 'NORMAL', 'DIFFICULT');
CREATE TYPE conversation_type AS ENUM ('DIRECT', 'GROUP');
-- create table for users
CREATE TABLE users (
  id SERIAL NOT NULL unique,
  intra_id text NOT NULL unique,
  username varchar(255) NOT NULL unique,
  password varchar(255) NOT NULL,
  email varchar(255) NOT NULL unique,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  verified boolean DEFAULT false,
  achivements integer [],
  PRIMARY KEY (id)
);
-- create table for all conversation
CREATE TABLE conversation (
  id SERIAL NOT NULL,
  name varchar(255) NOT NULL unique,
  type conversation_type DEFAULT 'DIRECT',
  direct BOOLEAN DEFAULT true,
  PRIMARY KEY (id)
);
-- create table for for group members 
CREATE TABLE group_member (
  user_id SERIAL NOT NULL,
  conversation_id SERIAL NOT NULL,
  joint_date timestamp NOT NULL,
  left_date timestamp NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id)
);
-- create table for messages
CREATE TABLE message (
  id SERIAL NOT NULL,
  sender_id SERIAL NOT NULL,
  content text NOT NULL,
  conversation_id SERIAL NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  read_by integer [],
  delivered_to integer [],
  PRIMARY KEY (id),
  FOREIGN KEY (sender_id) REFERENCES users (id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id)
);

CREATE TABLE achivements (
  id SERIAL NOT NULL,
  name VARCHAR(25) NOT NULL,
  level level_type DEFAULT 'bronze',
  xp int NOT NULL,
  description text,
  PRIMARY KEY (id)
);

CREATE TABLE friends (
  id SERIAL NOT NULL,
  sender_id SERIAL NOT NULL,
  receiver_id SERIAL NOT NULL,
  created_at timestamp NOT NULL,
  accepted BOOLEAN DEFAULT false,
  FOREIGN KEY (sender_id) REFERENCES users (id),
  FOREIGN KEY (receiver_id) REFERENCES users (id),
  PRIMARY KEY (id)
);

CREATE TABLE game (
  id SERIAL NOT NULL,
  player integer [],
  level game_diff DEFAULT 'normal',
  scores integer [],
  PRIMARY KEY (id)
) -- populating users table
-- INSERT INTO users (name,email)
-- VALUES
--   ("Chaim Trevino","nec.euismod@yahoo.net"),
--   ("Signe Daniel","enim@protonmail.edu"),
--   ("Clarke Summers","eget.nisi.dictum@google.ca"),
--   ("Harper Callahan","quisque.purus@outlook.com"),
--   ("Alec Kelley","vel.turpis.aliquam@outlook.edu");