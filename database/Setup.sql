-- CREATE DATABASE TRANSCENDANCE;
-- USE TRANSCENDANCE;
CREATE TYPE level_type AS ENUM ('bronze', 'silver', 'gold', 'platinum');
CREATE TYPE game_diff AS ENUM ('easy', 'normal', 'difficult');
-- create table for users
CREATE TABLE users (
  id int NOT NULL unique,
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
  id int NOT NULL,
  name varchar(255) NOT NULL unique,
  direct BOOLEAN DEFAULT true,
  PRIMARY KEY (id)
);
-- create table for for group members 
CREATE TABLE group_member (
  user_id int NOT NULL,
  conversation_id int NOT NULL,
  joint_date timestamp NOT NULL,
  left_date timestamp NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id)
);
-- create table for messages
CREATE TABLE message (
  id int NOT NULL,
  sender_id int NOT NULL,
  message text NOT NULL,
  conversation_id int NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  read_by integer [],
  delivered_to integer [],
  PRIMARY KEY (id),
  FOREIGN KEY (sender_id) REFERENCES users (id),
  FOREIGN KEY (conversation_id) REFERENCES conversation (id)
);

CREATE TABLE achivements (
  id int NOT NULL,
  name VARCHAR(25) NOT NULL,
  level level_type DEFAULT 'bronze',
  xp int NOT NULL,
  description text,
  PRIMARY KEY (id)
);

CREATE TABLE friends (
  id int NOT NULL,
  sender_id int NOT NULL,
  receiver_id int NOT NULL,
  created_at timestamp NOT NULL,
  accepted BOOLEAN DEFAULT false,
  FOREIGN KEY (sender_id) REFERENCES users (id),
  FOREIGN KEY (receiver_id) REFERENCES users (id),
  PRIMARY KEY (id)
);

CREATE TABLE game (
  id int NOT NULL,
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