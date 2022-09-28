-- CREATE DATABASE TRANSCENDANCE;
-- USE TRANSCENDANCE;
CREATE TYPE level_type AS ENUM ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');
CREATE TYPE game_diff AS ENUM ('EASY', 'NORMAL', 'DIFFICULT');
CREATE TYPE conversation_type AS ENUM ('DIRECT', 'GROUP');
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
-- create table for messages
CREATE TABLE friends (
  id SERIAL NOT NULL,
  sender_id SERIAL NOT NULL,
  receiver_id SERIAL NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  accepted BOOLEAN DEFAULT false,
  FOREIGN KEY (sender_id) REFERENCES users (intra_id),
  FOREIGN KEY (receiver_id) REFERENCES users (intra_id),
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