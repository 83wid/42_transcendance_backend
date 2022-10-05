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
-- Name: achivements; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.achivements (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    level public.level_type DEFAULT 'BRONZE'::public.level_type,
    xp integer NOT NULL,
    description text
);


ALTER TABLE public.achivements OWNER TO nabouzah;

--
-- Name: achivements_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.achivements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.achivements_id_seq OWNER TO nabouzah;

--
-- Name: achivements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.achivements_id_seq OWNED BY public.achivements.id;


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
    updatedat timestamp without time zone NOT NULL
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
    achivements integer[],
    status public.status_t DEFAULT 'OFFLINE'::public.status_t,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO nabouzah;

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
-- Name: achivements id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.achivements ALTER COLUMN id SET DEFAULT nextval('public.achivements_id_seq'::regclass);


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
-- Data for Name: achivements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.achivements (id, name, level, xp, description) FROM stdin;
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
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, img_url, cover, achivements, status, created_at, updated_at) FROM stdin;
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	{19,9,1,1,5}	OFFLINE	2022-10-05 13:08:40.494469	2022-10-05 13:08:40.494469
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{21,7,6,9,13}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{14,1,1,16,14}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{8,2,14,8,13}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{12,12,15,12,11}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{2,13,7,10,15}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{14,4,8,21,19}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{5,1,18,7,4}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{2,2,19,1,2}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{17,9,20,2,16}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{9,17,21,16,14}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{15,22,1,18,21}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{9,4,6,3,8}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{4,19,22,7,21}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{17,3,21,8,1}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{7,13,14,17,18}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{0,18,12,16,14}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{16,19,19,5,13}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{18,1,0,21,2}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{17,13,17,4,14}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{8,2,20,1,14}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{3,1,10,2,3}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{6,21,18,12,19}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{16,6,3,19,15}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{3,13,13,7,16}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{15,20,14,16,16}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{3,9,15,17,8}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{19,16,0,10,1}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{9,19,3,13,15}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{8,17,15,13,11}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	{4,2,2,9,19}	OFFLINE	2022-10-05 13:08:40.507501	2022-10-05 13:08:40.507501
\.


--
-- Name: achivements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.achivements_id_seq', 22, true);


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

SELECT pg_catalog.setval('public.invites_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.notification_id_seq', 1, false);


--
-- Name: notification_targetid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_targetid_seq', 1, false);


--
-- Name: notification_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_userid_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_id_seq', 31, true);


--
-- Name: achivements achivements_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.achivements
    ADD CONSTRAINT achivements_pkey PRIMARY KEY (id);


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
-- PostgreSQL database dump complete
--

