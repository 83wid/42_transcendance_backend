--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Debian 14.5-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: conversation_type; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.conversation_type AS ENUM (
    'DIRECT',
    'GROUP'
);


ALTER TYPE public.conversation_type OWNER TO nabouzah;

--
-- Name: game_diff; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.game_diff AS ENUM (
    'EASY',
    'NORMAL',
    'DIFFICULT'
);


ALTER TYPE public.game_diff OWNER TO nabouzah;

--
-- Name: level_type; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.level_type AS ENUM (
    'BRONZE',
    'SILVER',
    'GOLD',
    'PLATINUM'
);


ALTER TYPE public.level_type OWNER TO nabouzah;

--
-- Name: notification_t; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.notification_t AS ENUM (
    'FRIEND_REQUEST',
    'GAME_INVITE',
    'OTHER'
);


ALTER TYPE public.notification_t OWNER TO nabouzah;

--
-- Name: status_t; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.status_t AS ENUM (
    'ONLINE',
    'OFFLINE',
    'PLAYING'
);


ALTER TYPE public.status_t OWNER TO nabouzah;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.achievements (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    level public.level_type DEFAULT 'BRONZE'::public.level_type,
    xp integer NOT NULL,
    description text
);


ALTER TABLE public.achievements OWNER TO nabouzah;

--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.achievements_id_seq OWNER TO nabouzah;

--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.achievements_id_seq OWNED BY public.achievements.id;


--
-- Name: blocked; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.blocked (
    id integer NOT NULL,
    userid integer NOT NULL,
    blockedid integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.blocked OWNER TO nabouzah;

--
-- Name: blocked_blockedid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.blocked_blockedid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blocked_blockedid_seq OWNER TO nabouzah;

--
-- Name: blocked_blockedid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.blocked_blockedid_seq OWNED BY public.blocked.blockedid;


--
-- Name: blocked_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.blocked_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blocked_id_seq OWNER TO nabouzah;

--
-- Name: blocked_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.blocked_id_seq OWNED BY public.blocked.id;


--
-- Name: blocked_userid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.blocked_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blocked_userid_seq OWNER TO nabouzah;

--
-- Name: blocked_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.blocked_userid_seq OWNED BY public.blocked.userid;


--
-- Name: conversation; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.conversation (
    id integer NOT NULL,
    name character varying(255),
    type public.conversation_type DEFAULT 'DIRECT'::public.conversation_type
);


ALTER TABLE public.conversation OWNER TO nabouzah;

--
-- Name: conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.conversation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversation_id_seq OWNER TO nabouzah;

--
-- Name: conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.conversation_id_seq OWNED BY public.conversation.id;


--
-- Name: friends; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.friends (
    id integer NOT NULL,
    userid integer NOT NULL,
    friendid integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.friends OWNER TO nabouzah;

--
-- Name: friends_friendid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.friends_friendid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friends_friendid_seq OWNER TO nabouzah;

--
-- Name: friends_friendid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.friends_friendid_seq OWNED BY public.friends.friendid;


--
-- Name: friends_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.friends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friends_id_seq OWNER TO nabouzah;

--
-- Name: friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.friends_id_seq OWNED BY public.friends.id;


--
-- Name: friends_userid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.friends_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friends_userid_seq OWNER TO nabouzah;

--
-- Name: friends_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.friends_userid_seq OWNED BY public.friends.userid;


--
-- Name: game; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.game (
    id integer NOT NULL,
    player integer[],
    level public.game_diff DEFAULT 'NORMAL'::public.game_diff,
    scores integer[]
);


ALTER TABLE public.game OWNER TO nabouzah;

--
-- Name: game_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.game_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_id_seq OWNER TO nabouzah;

--
-- Name: game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.game_id_seq OWNED BY public.game.id;


--
-- Name: group_member; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.group_member (
    id integer NOT NULL,
    user_id integer NOT NULL,
    conversation_id integer NOT NULL,
    joint_date timestamp without time zone DEFAULT now(),
    left_date timestamp without time zone
);


ALTER TABLE public.group_member OWNER TO nabouzah;

--
-- Name: group_member_conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.group_member_conversation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_member_conversation_id_seq OWNER TO nabouzah;

--
-- Name: group_member_conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.group_member_conversation_id_seq OWNED BY public.group_member.conversation_id;


--
-- Name: group_member_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.group_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_member_id_seq OWNER TO nabouzah;

--
-- Name: group_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.group_member_id_seq OWNED BY public.group_member.id;


--
-- Name: group_member_user_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.group_member_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_member_user_id_seq OWNER TO nabouzah;

--
-- Name: group_member_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.group_member_user_id_seq OWNED BY public.group_member.user_id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.invites (
    id integer NOT NULL,
    senderid integer NOT NULL,
    receiverid integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    accepted boolean DEFAULT false
);


ALTER TABLE public.invites OWNER TO nabouzah;

--
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.invites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invites_id_seq OWNER TO nabouzah;

--
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.invites_id_seq OWNED BY public.invites.id;


--
-- Name: invites_receiverid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.invites_receiverid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invites_receiverid_seq OWNER TO nabouzah;

--
-- Name: invites_receiverid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.invites_receiverid_seq OWNED BY public.invites.receiverid;


--
-- Name: invites_senderid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.invites_senderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invites_senderid_seq OWNER TO nabouzah;

--
-- Name: invites_senderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.invites_senderid_seq OWNED BY public.invites.senderid;


--
-- Name: message; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.message (
    id integer NOT NULL,
    sender_id integer NOT NULL,
    content text NOT NULL,
    conversation_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    read_by integer[],
    delivered_to integer[]
);


ALTER TABLE public.message OWNER TO nabouzah;

--
-- Name: message_conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.message_conversation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_conversation_id_seq OWNER TO nabouzah;

--
-- Name: message_conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.message_conversation_id_seq OWNED BY public.message.conversation_id;


--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO nabouzah;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.message_id_seq OWNED BY public.message.id;


--
-- Name: message_sender_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.message_sender_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_sender_id_seq OWNER TO nabouzah;

--
-- Name: message_sender_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.message_sender_id_seq OWNED BY public.message.sender_id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    type public.notification_t DEFAULT 'OTHER'::public.notification_t NOT NULL,
    userid integer NOT NULL,
    fromid integer NOT NULL,
    targetid integer NOT NULL,
    content text,
    createdat timestamp without time zone DEFAULT now() NOT NULL,
    updatedat timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification OWNER TO nabouzah;

--
-- Name: notification_fromid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.notification_fromid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_fromid_seq OWNER TO nabouzah;

--
-- Name: notification_fromid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.notification_fromid_seq OWNED BY public.notification.fromid;


--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO nabouzah;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;


--
-- Name: notification_targetid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.notification_targetid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_targetid_seq OWNER TO nabouzah;

--
-- Name: notification_targetid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.notification_targetid_seq OWNED BY public.notification.targetid;


--
-- Name: notification_userid_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.notification_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_userid_seq OWNER TO nabouzah;

--
-- Name: notification_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.notification_userid_seq OWNED BY public.notification.userid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.users (
    id integer NOT NULL,
    intra_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    img_url character varying(255),
    cover character varying(255),
    status public.status_t DEFAULT 'OFFLINE'::public.status_t,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO nabouzah;

--
-- Name: users_achievements; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.users_achievements (
    id integer NOT NULL,
    userid integer NOT NULL,
    achievementid integer NOT NULL,
    createdat timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users_achievements OWNER TO nabouzah;

--
-- Name: users_achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.users_achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_achievements_id_seq OWNER TO nabouzah;

--
-- Name: users_achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.users_achievements_id_seq OWNED BY public.users_achievements.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO nabouzah;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: achievements id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.achievements ALTER COLUMN id SET DEFAULT nextval('public.achievements_id_seq'::regclass);


--
-- Name: blocked id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.blocked ALTER COLUMN id SET DEFAULT nextval('public.blocked_id_seq'::regclass);


--
-- Name: blocked userid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.blocked ALTER COLUMN userid SET DEFAULT nextval('public.blocked_userid_seq'::regclass);


--
-- Name: blocked blockedid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.blocked ALTER COLUMN blockedid SET DEFAULT nextval('public.blocked_blockedid_seq'::regclass);


--
-- Name: conversation id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.conversation ALTER COLUMN id SET DEFAULT nextval('public.conversation_id_seq'::regclass);


--
-- Name: friends id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends ALTER COLUMN id SET DEFAULT nextval('public.friends_id_seq'::regclass);


--
-- Name: friends userid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends ALTER COLUMN userid SET DEFAULT nextval('public.friends_userid_seq'::regclass);


--
-- Name: friends friendid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends ALTER COLUMN friendid SET DEFAULT nextval('public.friends_friendid_seq'::regclass);


--
-- Name: game id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.game ALTER COLUMN id SET DEFAULT nextval('public.game_id_seq'::regclass);


--
-- Name: group_member id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member ALTER COLUMN id SET DEFAULT nextval('public.group_member_id_seq'::regclass);


--
-- Name: group_member user_id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member ALTER COLUMN user_id SET DEFAULT nextval('public.group_member_user_id_seq'::regclass);


--
-- Name: group_member conversation_id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member ALTER COLUMN conversation_id SET DEFAULT nextval('public.group_member_conversation_id_seq'::regclass);


--
-- Name: invites id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites ALTER COLUMN id SET DEFAULT nextval('public.invites_id_seq'::regclass);


--
-- Name: invites senderid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites ALTER COLUMN senderid SET DEFAULT nextval('public.invites_senderid_seq'::regclass);


--
-- Name: invites receiverid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites ALTER COLUMN receiverid SET DEFAULT nextval('public.invites_receiverid_seq'::regclass);


--
-- Name: message id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- Name: message sender_id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message ALTER COLUMN sender_id SET DEFAULT nextval('public.message_sender_id_seq'::regclass);


--
-- Name: message conversation_id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message ALTER COLUMN conversation_id SET DEFAULT nextval('public.message_conversation_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- Name: notification userid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification ALTER COLUMN userid SET DEFAULT nextval('public.notification_userid_seq'::regclass);


--
-- Name: notification fromid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification ALTER COLUMN fromid SET DEFAULT nextval('public.notification_fromid_seq'::regclass);


--
-- Name: notification targetid; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification ALTER COLUMN targetid SET DEFAULT nextval('public.notification_targetid_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_achievements id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users_achievements ALTER COLUMN id SET DEFAULT nextval('public.users_achievements_id_seq'::regclass);


--
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.achievements (id, name, level, xp, description) FROM stdin;
1	friendly	SILVER	100	description
2	friendly	BRONZE	200	description
3	friendly	GOLD	300	description
4	friendly	PLATINUM	500	description
5	legendary	SILVER	100	description
6	legendary	BRONZE	200	description
7	legendary	GOLD	300	description
8	legendary	PLATINUM	500	description
9	sharpshooter	SILVER	100	description
10	sharpshooter	BRONZE	200	description
11	sharpshooter	GOLD	300	description
12	sharpshooter	PLATINUM	500	description
13	wildfire	SILVER	100	description
14	wildfire	BRONZE	200	description
15	wildfire	GOLD	300	description
16	wildfire	PLATINUM	500	description
17	winner	SILVER	100	description
18	winner	BRONZE	200	description
19	winner	GOLD	300	description
20	winner	PLATINUM	500	description
21	photogenic	GOLD	300	description
22	photogenic	PLATINUM	500	description
\.


--
-- Data for Name: blocked; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.blocked (id, userid, blockedid, created_at) FROM stdin;
\.


--
-- Data for Name: conversation; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.conversation (id, name, type) FROM stdin;
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.friends (id, userid, friendid, created_at) FROM stdin;
\.


--
-- Data for Name: game; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.game (id, player, level, scores) FROM stdin;
\.


--
-- Data for Name: group_member; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.group_member (id, user_id, conversation_id, joint_date, left_date) FROM stdin;
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.invites (id, senderid, receiverid, created_at, accepted) FROM stdin;
1	1	51111	2022-10-08 13:00:43.886578	f
2	2	51111	2022-10-08 13:00:43.886578	f
3	3	51111	2022-10-08 13:00:43.886578	f
4	4	51111	2022-10-08 13:00:43.886578	f
5	5	51111	2022-10-08 13:00:43.886578	f
6	6	51111	2022-10-08 13:00:43.886578	f
7	7	51111	2022-10-08 13:00:43.886578	f
8	8	51111	2022-10-08 13:00:43.886578	f
9	9	51111	2022-10-08 13:00:43.886578	f
10	10	51111	2022-10-08 13:00:43.886578	f
11	11	51111	2022-10-08 13:00:43.886578	f
12	12	51111	2022-10-08 13:00:43.886578	f
13	13	51111	2022-10-08 13:00:43.886578	f
14	14	51111	2022-10-08 13:00:43.886578	f
15	15	51111	2022-10-08 13:00:43.886578	f
16	16	51111	2022-10-08 13:00:43.886578	f
17	17	51111	2022-10-08 13:00:43.886578	f
18	18	51111	2022-10-08 13:00:43.886578	f
19	19	51111	2022-10-08 13:00:43.886578	f
20	20	51111	2022-10-08 13:00:43.886578	f
21	51111	11	2022-10-08 13:00:43.900803	f
22	51111	12	2022-10-08 13:00:43.900803	f
23	51111	13	2022-10-08 13:00:43.900803	f
24	51111	14	2022-10-08 13:00:43.900803	f
25	51111	15	2022-10-08 13:00:43.900803	f
26	51111	16	2022-10-08 13:00:43.900803	f
27	51111	17	2022-10-08 13:00:43.900803	f
28	51111	18	2022-10-08 13:00:43.900803	f
29	51111	19	2022-10-08 13:00:43.900803	f
30	51111	20	2022-10-08 13:00:43.900803	f
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.message (id, sender_id, content, conversation_id, created_at, updated_at, read_by, delivered_to) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.notification (id, type, userid, fromid, targetid, content, createdat, updatedat) FROM stdin;
1	OTHER	51111	1	1	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
2	OTHER	51111	2	2	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
3	OTHER	51111	3	3	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
4	OTHER	51111	4	4	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
5	OTHER	51111	5	5	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
6	OTHER	51111	6	6	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
7	OTHER	51111	7	7	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
8	OTHER	51111	8	8	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
9	OTHER	51111	9	9	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
10	OTHER	51111	10	10	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
11	OTHER	51111	11	11	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
12	OTHER	51111	12	12	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
13	OTHER	51111	13	13	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
14	OTHER	51111	14	14	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
15	OTHER	51111	15	15	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
16	OTHER	51111	16	16	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
17	OTHER	51111	17	17	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
18	OTHER	51111	18	18	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
19	OTHER	51111	19	19	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
20	OTHER	51111	20	20	send you friend request	2022-10-08 13:00:43.901573	2022-10-08 13:00:43.901573
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, img_url, cover, status, created_at, updated_at) FROM stdin;
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.856237	2022-10-08 13:00:43.856237
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
32	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
33	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
34	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
35	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
36	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
37	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
38	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
39	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
40	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
41	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
42	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
43	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
44	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
45	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
46	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
47	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
48	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
49	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
50	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
51	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	OFFLINE	2022-10-08 13:00:43.881686	2022-10-08 13:00:43.881686
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, createdat) FROM stdin;
1	51111	2	2022-10-08 13:00:43.862677
2	51111	4	2022-10-08 13:00:43.862677
3	51111	6	2022-10-08 13:00:43.862677
4	51111	8	2022-10-08 13:00:43.862677
5	51111	10	2022-10-08 13:00:43.862677
6	51111	12	2022-10-08 13:00:43.862677
7	51111	14	2022-10-08 13:00:43.862677
8	51111	16	2022-10-08 13:00:43.862677
9	51111	18	2022-10-08 13:00:43.862677
10	51111	20	2022-10-08 13:00:43.862677
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.achievements_id_seq', 22, true);


--
-- Name: blocked_blockedid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.blocked_blockedid_seq', 1, false);


--
-- Name: blocked_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.blocked_id_seq', 1, false);


--
-- Name: blocked_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.blocked_userid_seq', 1, false);


--
-- Name: conversation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.conversation_id_seq', 1, false);


--
-- Name: friends_friendid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.friends_friendid_seq', 1, false);


--
-- Name: friends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.friends_id_seq', 1, false);


--
-- Name: friends_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.friends_userid_seq', 1, false);


--
-- Name: game_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.game_id_seq', 1, false);


--
-- Name: group_member_conversation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.group_member_conversation_id_seq', 1, false);


--
-- Name: group_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.group_member_id_seq', 1, false);


--
-- Name: group_member_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.group_member_user_id_seq', 1, false);


--
-- Name: invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.invites_id_seq', 30, true);


--
-- Name: invites_receiverid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.invites_receiverid_seq', 1, false);


--
-- Name: invites_senderid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.invites_senderid_seq', 1, false);


--
-- Name: message_conversation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.message_conversation_id_seq', 1, false);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.message_id_seq', 1, false);


--
-- Name: message_sender_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.message_sender_id_seq', 1, false);


--
-- Name: notification_fromid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_fromid_seq', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_id_seq', 20, true);


--
-- Name: notification_targetid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_targetid_seq', 1, false);


--
-- Name: notification_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_userid_seq', 1, false);


--
-- Name: users_achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_achievements_id_seq', 10, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_id_seq', 51, true);


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: blocked blocked_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.blocked
    ADD CONSTRAINT blocked_pkey PRIMARY KEY (id);


--
-- Name: conversation conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.conversation
    ADD CONSTRAINT conversation_pkey PRIMARY KEY (id);


--
-- Name: friends friends_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_pkey PRIMARY KEY (id);


--
-- Name: game game_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_pkey PRIMARY KEY (id);


--
-- Name: group_member group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_pkey PRIMARY KEY (id);


--
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: users_achievements users_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users_achievements
    ADD CONSTRAINT users_achievements_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_intra_id_key; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_intra_id_key UNIQUE (intra_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: blocked blocked_blockedid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.blocked
    ADD CONSTRAINT blocked_blockedid_fkey FOREIGN KEY (blockedid) REFERENCES public.users(intra_id);


--
-- Name: blocked blocked_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.blocked
    ADD CONSTRAINT blocked_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id);


--
-- Name: friends friends_friendid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_friendid_fkey FOREIGN KEY (friendid) REFERENCES public.users(intra_id);


--
-- Name: friends friends_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id);


--
-- Name: group_member group_member_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversation(id);


--
-- Name: group_member group_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(intra_id);


--
-- Name: invites invites_receiverid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_receiverid_fkey FOREIGN KEY (receiverid) REFERENCES public.users(intra_id);


--
-- Name: invites invites_senderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_senderid_fkey FOREIGN KEY (senderid) REFERENCES public.users(intra_id);


--
-- Name: message message_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversation(id);


--
-- Name: message message_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(intra_id);


--
-- Name: notification notification_fromid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_fromid_fkey FOREIGN KEY (fromid) REFERENCES public.users(intra_id);


--
-- Name: notification notification_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id);


--
-- Name: users_achievements users_achievements_achievementid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users_achievements
    ADD CONSTRAINT users_achievements_achievementid_fkey FOREIGN KEY (achievementid) REFERENCES public.achievements(id);


--
-- Name: users_achievements users_achievements_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users_achievements
    ADD CONSTRAINT users_achievements_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id);


--
-- PostgreSQL database dump complete
--

