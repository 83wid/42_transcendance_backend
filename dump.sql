--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0 (Debian 15.0-1.pgdg110+1)
-- Dumped by pg_dump version 15.0 (Debian 15.0-1.pgdg110+1)

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
-- Name: game_status; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.game_status AS ENUM (
    'WAITING',
    'PLAYING',
    'END'
);


ALTER TYPE public.game_status OWNER TO nabouzah;

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
    'GAME_ACCEPTE',
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
-- Name: game; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.game (
    id integer NOT NULL,
    status public.game_status DEFAULT 'WAITING'::public.game_status,
    level public.game_diff DEFAULT 'NORMAL'::public.game_diff,
    createdat timestamp without time zone NOT NULL,
    updatedat timestamp without time zone DEFAULT now() NOT NULL
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
-- Name: gameinvites; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.gameinvites (
    id integer NOT NULL,
    userid integer NOT NULL,
    fromid integer NOT NULL,
    gameid integer NOT NULL,
    accepted boolean DEFAULT false
);


ALTER TABLE public.gameinvites OWNER TO nabouzah;

--
-- Name: gameinvites_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.gameinvites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gameinvites_id_seq OWNER TO nabouzah;

--
-- Name: gameinvites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.gameinvites_id_seq OWNED BY public.gameinvites.id;


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
-- Name: invites; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.invites (
    id integer NOT NULL,
    senderid integer NOT NULL,
    receiverid integer NOT NULL,
    accepted boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- Name: notification; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    type public.notification_t DEFAULT 'OTHER'::public.notification_t NOT NULL,
    userid integer NOT NULL,
    fromid integer NOT NULL,
    targetid integer NOT NULL,
    content text,
    read boolean DEFAULT false,
    createdat timestamp without time zone NOT NULL,
    updatedat timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification OWNER TO nabouzah;

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
-- Name: players; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.players (
    id integer NOT NULL,
    userid integer NOT NULL,
    gameid integer NOT NULL,
    score integer DEFAULT 0
);


ALTER TABLE public.players OWNER TO nabouzah;

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.players_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.players_id_seq OWNER TO nabouzah;

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


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
    status public.status_t DEFAULT 'OFFLINE'::public.status_t,
    xp integer DEFAULT 0,
    img_url character varying(255),
    cover character varying(255),
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
-- Name: conversation id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.conversation ALTER COLUMN id SET DEFAULT nextval('public.conversation_id_seq'::regclass);


--
-- Name: friends id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.friends ALTER COLUMN id SET DEFAULT nextval('public.friends_id_seq'::regclass);


--
-- Name: game id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.game ALTER COLUMN id SET DEFAULT nextval('public.game_id_seq'::regclass);


--
-- Name: gameinvites id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.gameinvites ALTER COLUMN id SET DEFAULT nextval('public.gameinvites_id_seq'::regclass);


--
-- Name: group_member id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.group_member ALTER COLUMN id SET DEFAULT nextval('public.group_member_id_seq'::regclass);


--
-- Name: invites id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites ALTER COLUMN id SET DEFAULT nextval('public.invites_id_seq'::regclass);


--
-- Name: message id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


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
1	friendly	SILVER	10	add 10 friends
2	friendly	BRONZE	20	add 20 friends
3	friendly	GOLD	50	add 50 friends
4	friendly	PLATINUM	100	add 100 friends
5	legendary	SILVER	100	win 1 matche with a max score
6	legendary	BRONZE	250	win 2 matches with max a score
7	legendary	GOLD	350	win 3 matches with max a score
8	legendary	PLATINUM	500	winn 4 matches with max a score
9	sharpshooter	SILVER	100	win 2 matches in one day
10	sharpshooter	BRONZE	250	win 3 matches in one day
11	sharpshooter	GOLD	350	win 4 matches in one day
12	sharpshooter	PLATINUM	500	win 5 matches in one day
13	wildfire	SILVER	500	play 5 matches in one day
14	wildfire	BRONZE	1400	play 10 matches in one day
15	wildfire	GOLD	2000	play 15 matches in one day
16	wildfire	PLATINUM	5000	play 20 matches in one day
17	winner	SILVER	500	Be ranked #1 for 1 day
18	winner	BRONZE	1000	Be ranked #1 for 2 day
19	winner	GOLD	3000	Be ranked #1 for 3 day
20	winner	PLATINUM	7000	Be ranked #1 for 4 day
21	photogenic	GOLD	100	change your avatar
22	photogenic	PLATINUM	100	change your cover
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

COPY public.game (id, status, level, createdat, updatedat) FROM stdin;
\.


--
-- Data for Name: gameinvites; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.gameinvites (id, userid, fromid, gameid, accepted) FROM stdin;
\.


--
-- Data for Name: group_member; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.group_member (id, user_id, conversation_id, joint_date, left_date) FROM stdin;
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.invites (id, senderid, receiverid, accepted, created_at) FROM stdin;
1	1	51111	f	2022-10-22 18:27:04.818189
2	2	51111	f	2022-10-22 18:27:04.818189
3	3	51111	f	2022-10-22 18:27:04.818189
4	4	51111	f	2022-10-22 18:27:04.818189
5	5	51111	f	2022-10-22 18:27:04.818189
6	6	51111	f	2022-10-22 18:27:04.818189
7	7	51111	f	2022-10-22 18:27:04.818189
8	8	51111	f	2022-10-22 18:27:04.818189
9	9	51111	f	2022-10-22 18:27:04.818189
10	10	51111	f	2022-10-22 18:27:04.818189
11	11	51111	f	2022-10-22 18:27:04.818189
12	12	51111	f	2022-10-22 18:27:04.818189
13	13	51111	f	2022-10-22 18:27:04.818189
14	14	51111	f	2022-10-22 18:27:04.818189
15	15	51111	f	2022-10-22 18:27:04.818189
16	16	51111	f	2022-10-22 18:27:04.818189
17	17	51111	f	2022-10-22 18:27:04.818189
18	18	51111	f	2022-10-22 18:27:04.818189
19	19	51111	f	2022-10-22 18:27:04.818189
20	20	51111	f	2022-10-22 18:27:04.818189
21	21	51111	f	2022-10-22 18:27:04.818189
22	22	51111	f	2022-10-22 18:27:04.818189
23	23	51111	f	2022-10-22 18:27:04.818189
24	24	51111	f	2022-10-22 18:27:04.818189
25	25	51111	f	2022-10-22 18:27:04.818189
26	26	51111	f	2022-10-22 18:27:04.818189
27	27	51111	f	2022-10-22 18:27:04.818189
28	28	51111	f	2022-10-22 18:27:04.818189
29	29	51111	f	2022-10-22 18:27:04.818189
30	30	51111	f	2022-10-22 18:27:04.818189
31	31	51111	f	2022-10-22 18:27:04.818189
32	32	51111	f	2022-10-22 18:27:04.818189
33	33	51111	f	2022-10-22 18:27:04.818189
34	34	51111	f	2022-10-22 18:27:04.818189
35	35	51111	f	2022-10-22 18:27:04.818189
36	36	51111	f	2022-10-22 18:27:04.818189
37	37	51111	f	2022-10-22 18:27:04.818189
38	38	51111	f	2022-10-22 18:27:04.818189
39	39	51111	f	2022-10-22 18:27:04.818189
40	40	51111	f	2022-10-22 18:27:04.818189
41	41	51111	f	2022-10-22 18:27:04.818189
42	42	51111	f	2022-10-22 18:27:04.818189
43	43	51111	f	2022-10-22 18:27:04.818189
44	44	51111	f	2022-10-22 18:27:04.818189
45	45	51111	f	2022-10-22 18:27:04.818189
46	46	51111	f	2022-10-22 18:27:04.818189
47	47	51111	f	2022-10-22 18:27:04.818189
48	48	51111	f	2022-10-22 18:27:04.818189
49	49	51111	f	2022-10-22 18:27:04.818189
50	50	51111	f	2022-10-22 18:27:04.818189
51	51	51111	f	2022-10-22 18:27:04.818189
52	52	51111	f	2022-10-22 18:27:04.818189
53	53	51111	f	2022-10-22 18:27:04.818189
54	54	51111	f	2022-10-22 18:27:04.818189
55	55	51111	f	2022-10-22 18:27:04.818189
56	56	51111	f	2022-10-22 18:27:04.818189
57	57	51111	f	2022-10-22 18:27:04.818189
58	58	51111	f	2022-10-22 18:27:04.818189
59	59	51111	f	2022-10-22 18:27:04.818189
60	60	51111	f	2022-10-22 18:27:04.818189
61	51111	60	f	2022-10-22 18:27:04.840391
62	51111	61	f	2022-10-22 18:27:04.840391
63	51111	62	f	2022-10-22 18:27:04.840391
64	51111	63	f	2022-10-22 18:27:04.840391
65	51111	64	f	2022-10-22 18:27:04.840391
66	51111	65	f	2022-10-22 18:27:04.840391
67	51111	66	f	2022-10-22 18:27:04.840391
68	51111	67	f	2022-10-22 18:27:04.840391
69	51111	68	f	2022-10-22 18:27:04.840391
70	51111	69	f	2022-10-22 18:27:04.840391
71	51111	70	f	2022-10-22 18:27:04.840391
72	51111	71	f	2022-10-22 18:27:04.840391
73	51111	72	f	2022-10-22 18:27:04.840391
74	51111	73	f	2022-10-22 18:27:04.840391
75	51111	74	f	2022-10-22 18:27:04.840391
76	51111	75	f	2022-10-22 18:27:04.840391
77	51111	76	f	2022-10-22 18:27:04.840391
78	51111	77	f	2022-10-22 18:27:04.840391
79	51111	78	f	2022-10-22 18:27:04.840391
80	51111	79	f	2022-10-22 18:27:04.840391
81	51111	80	f	2022-10-22 18:27:04.840391
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.message (id, sender_id, content, conversation_id, created_at, updated_at, read_by, delivered_to) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.notification (id, type, userid, fromid, targetid, content, read, createdat, updatedat) FROM stdin;
1	FRIEND_REQUEST	51111	1	1	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
2	FRIEND_REQUEST	51111	2	2	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
3	FRIEND_REQUEST	51111	3	3	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
4	FRIEND_REQUEST	51111	4	4	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
5	FRIEND_REQUEST	51111	5	5	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
6	FRIEND_REQUEST	51111	6	6	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
7	FRIEND_REQUEST	51111	7	7	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
8	FRIEND_REQUEST	51111	8	8	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
9	FRIEND_REQUEST	51111	9	9	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
10	FRIEND_REQUEST	51111	10	10	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
11	FRIEND_REQUEST	51111	11	11	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
12	FRIEND_REQUEST	51111	12	12	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
13	FRIEND_REQUEST	51111	13	13	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
14	FRIEND_REQUEST	51111	14	14	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
15	FRIEND_REQUEST	51111	15	15	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
16	FRIEND_REQUEST	51111	16	16	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
17	FRIEND_REQUEST	51111	17	17	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
18	FRIEND_REQUEST	51111	18	18	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
19	FRIEND_REQUEST	51111	19	19	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
20	FRIEND_REQUEST	51111	20	20	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
21	FRIEND_REQUEST	51111	21	21	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
22	FRIEND_REQUEST	51111	22	22	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
23	FRIEND_REQUEST	51111	23	23	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
24	FRIEND_REQUEST	51111	24	24	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
25	FRIEND_REQUEST	51111	25	25	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
26	FRIEND_REQUEST	51111	26	26	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
27	FRIEND_REQUEST	51111	27	27	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
28	FRIEND_REQUEST	51111	28	28	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
29	FRIEND_REQUEST	51111	29	29	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
30	FRIEND_REQUEST	51111	30	30	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
31	FRIEND_REQUEST	51111	31	31	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
32	FRIEND_REQUEST	51111	32	32	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
33	FRIEND_REQUEST	51111	33	33	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
34	FRIEND_REQUEST	51111	34	34	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
35	FRIEND_REQUEST	51111	35	35	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
36	FRIEND_REQUEST	51111	36	36	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
37	FRIEND_REQUEST	51111	37	37	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
38	FRIEND_REQUEST	51111	38	38	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
39	FRIEND_REQUEST	51111	39	39	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
40	FRIEND_REQUEST	51111	40	40	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
41	FRIEND_REQUEST	51111	41	41	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
42	FRIEND_REQUEST	51111	42	42	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
43	FRIEND_REQUEST	51111	43	43	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
44	FRIEND_REQUEST	51111	44	44	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
45	FRIEND_REQUEST	51111	45	45	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
46	FRIEND_REQUEST	51111	46	46	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
47	FRIEND_REQUEST	51111	47	47	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
48	FRIEND_REQUEST	51111	48	48	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
49	FRIEND_REQUEST	51111	49	49	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
50	FRIEND_REQUEST	51111	50	50	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
51	FRIEND_REQUEST	51111	51	51	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
52	FRIEND_REQUEST	51111	52	52	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
53	FRIEND_REQUEST	51111	53	53	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
54	FRIEND_REQUEST	51111	54	54	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
55	FRIEND_REQUEST	51111	55	55	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
56	FRIEND_REQUEST	51111	56	56	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
57	FRIEND_REQUEST	51111	57	57	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
58	FRIEND_REQUEST	51111	58	58	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
59	FRIEND_REQUEST	51111	59	59	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
60	FRIEND_REQUEST	51111	60	60	send you friend request	f	2022-10-22 18:27:04.841442	2022-10-22 18:27:04.841442
61	GAME_INVITE	51111	2	1	invet you to play game	t	2022-10-22 18:31:27.792	2022-10-22 18:31:27.794565
62	GAME_INVITE	2	51111	2	invet you to play game	f	2022-10-22 18:32:12.065	2022-10-22 18:32:12.067265
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.players (id, userid, gameid, score) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, status, xp, img_url, cover, created_at, updated_at) FROM stdin;
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	7385	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	ONLINE	2835	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	ONLINE	3716	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	856	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	ONLINE	2587	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	OFFLINE	869	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	5283	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	OFFLINE	6587	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	OFFLINE	4642	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	ONLINE	7899	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	ONLINE	6159	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	5240	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	ONLINE	1958	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	ONLINE	5895	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	ONLINE	1387	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	ONLINE	4374	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	OFFLINE	2987	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	ONLINE	5116	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	OFFLINE	5683	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	OFFLINE	3630	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	ONLINE	4939	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	4354	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	ONLINE	6715	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	7543	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	ONLINE	3150	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	ONLINE	438	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	ONLINE	2493	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	OFFLINE	1382	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	ONLINE	7560	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	ONLINE	5506	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
32	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	ONLINE	6348	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
33	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	1178	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
34	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	OFFLINE	2875	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
35	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	2884	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
36	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	11	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
37	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	7177	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
38	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	OFFLINE	1429	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
39	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	ONLINE	7111	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
40	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	ONLINE	7051	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
41	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	OFFLINE	3354	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
42	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	ONLINE	2055	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
43	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	6336	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
44	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	ONLINE	3020	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
45	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	OFFLINE	6429	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
46	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	ONLINE	4735	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
47	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	1745	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
48	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	3366	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
49	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	ONLINE	5868	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
50	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	ONLINE	3128	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
51	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	ONLINE	5947	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
52	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	ONLINE	6297	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
53	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	ONLINE	1333	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
54	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	OFFLINE	4198	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
55	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	ONLINE	1987	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
56	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	4669	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
57	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	5409	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
58	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	7397	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
59	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	5368	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
60	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	ONLINE	4709	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
61	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	OFFLINE	975	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
62	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	2859	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
63	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	980	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
64	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	OFFLINE	3726	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
65	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	OFFLINE	2171	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
66	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	4602	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
67	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	ONLINE	5104	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
68	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	6517	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
69	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	ONLINE	4589	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
70	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	ONLINE	7141	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
71	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	ONLINE	3190	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
72	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	ONLINE	4412	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
73	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	OFFLINE	4792	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
74	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	ONLINE	4085	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
75	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	5531	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
76	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	OFFLINE	461	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
77	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	ONLINE	6523	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
78	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	ONLINE	3810	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
79	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	OFFLINE	4326	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
80	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	OFFLINE	5996	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
81	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	ONLINE	4877	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
82	81	alizaynoune81	zaynoune81@ali.ali	ali	zaynoune	ONLINE	4884	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
83	82	alizaynoune82	zaynoune82@ali.ali	ali	zaynoune	OFFLINE	2344	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
84	83	alizaynoune83	zaynoune83@ali.ali	ali	zaynoune	OFFLINE	3492	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
85	84	alizaynoune84	zaynoune84@ali.ali	ali	zaynoune	OFFLINE	4910	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
86	85	alizaynoune85	zaynoune85@ali.ali	ali	zaynoune	ONLINE	2052	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
87	86	alizaynoune86	zaynoune86@ali.ali	ali	zaynoune	OFFLINE	864	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
88	87	alizaynoune87	zaynoune87@ali.ali	ali	zaynoune	ONLINE	2383	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
89	88	alizaynoune88	zaynoune88@ali.ali	ali	zaynoune	ONLINE	2419	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
90	89	alizaynoune89	zaynoune89@ali.ali	ali	zaynoune	OFFLINE	912	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
91	90	alizaynoune90	zaynoune90@ali.ali	ali	zaynoune	OFFLINE	3980	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
92	91	alizaynoune91	zaynoune91@ali.ali	ali	zaynoune	ONLINE	316	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
93	92	alizaynoune92	zaynoune92@ali.ali	ali	zaynoune	ONLINE	1628	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
94	93	alizaynoune93	zaynoune93@ali.ali	ali	zaynoune	OFFLINE	1093	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
95	94	alizaynoune94	zaynoune94@ali.ali	ali	zaynoune	OFFLINE	5384	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
96	95	alizaynoune95	zaynoune95@ali.ali	ali	zaynoune	OFFLINE	7329	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
97	96	alizaynoune96	zaynoune96@ali.ali	ali	zaynoune	OFFLINE	4496	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
98	97	alizaynoune97	zaynoune97@ali.ali	ali	zaynoune	ONLINE	5595	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
99	98	alizaynoune98	zaynoune98@ali.ali	ali	zaynoune	OFFLINE	2033	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
100	99	alizaynoune99	zaynoune99@ali.ali	ali	zaynoune	ONLINE	4801	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
101	100	alizaynoune100	zaynoune100@ali.ali	ali	zaynoune	ONLINE	868	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
102	101	alizaynoune101	zaynoune101@ali.ali	ali	zaynoune	ONLINE	6491	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
103	102	alizaynoune102	zaynoune102@ali.ali	ali	zaynoune	OFFLINE	5814	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
104	103	alizaynoune103	zaynoune103@ali.ali	ali	zaynoune	OFFLINE	3506	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
105	104	alizaynoune104	zaynoune104@ali.ali	ali	zaynoune	OFFLINE	6744	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
106	105	alizaynoune105	zaynoune105@ali.ali	ali	zaynoune	ONLINE	3717	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
107	106	alizaynoune106	zaynoune106@ali.ali	ali	zaynoune	ONLINE	1955	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
108	107	alizaynoune107	zaynoune107@ali.ali	ali	zaynoune	OFFLINE	6298	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
109	108	alizaynoune108	zaynoune108@ali.ali	ali	zaynoune	ONLINE	5861	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
110	109	alizaynoune109	zaynoune109@ali.ali	ali	zaynoune	OFFLINE	2866	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
111	110	alizaynoune110	zaynoune110@ali.ali	ali	zaynoune	ONLINE	7724	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
112	111	alizaynoune111	zaynoune111@ali.ali	ali	zaynoune	ONLINE	3396	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
113	112	alizaynoune112	zaynoune112@ali.ali	ali	zaynoune	ONLINE	3722	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
114	113	alizaynoune113	zaynoune113@ali.ali	ali	zaynoune	ONLINE	5176	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
115	114	alizaynoune114	zaynoune114@ali.ali	ali	zaynoune	ONLINE	953	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
116	115	alizaynoune115	zaynoune115@ali.ali	ali	zaynoune	OFFLINE	7144	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
117	116	alizaynoune116	zaynoune116@ali.ali	ali	zaynoune	ONLINE	6076	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
118	117	alizaynoune117	zaynoune117@ali.ali	ali	zaynoune	OFFLINE	6110	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
119	118	alizaynoune118	zaynoune118@ali.ali	ali	zaynoune	ONLINE	3687	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
120	119	alizaynoune119	zaynoune119@ali.ali	ali	zaynoune	OFFLINE	3182	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
121	120	alizaynoune120	zaynoune120@ali.ali	ali	zaynoune	ONLINE	3342	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
122	121	alizaynoune121	zaynoune121@ali.ali	ali	zaynoune	ONLINE	3162	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
123	122	alizaynoune122	zaynoune122@ali.ali	ali	zaynoune	OFFLINE	3737	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
124	123	alizaynoune123	zaynoune123@ali.ali	ali	zaynoune	ONLINE	804	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
125	124	alizaynoune124	zaynoune124@ali.ali	ali	zaynoune	OFFLINE	372	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
126	125	alizaynoune125	zaynoune125@ali.ali	ali	zaynoune	OFFLINE	5183	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
127	126	alizaynoune126	zaynoune126@ali.ali	ali	zaynoune	OFFLINE	2072	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
128	127	alizaynoune127	zaynoune127@ali.ali	ali	zaynoune	ONLINE	3256	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
129	128	alizaynoune128	zaynoune128@ali.ali	ali	zaynoune	OFFLINE	3561	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
130	129	alizaynoune129	zaynoune129@ali.ali	ali	zaynoune	OFFLINE	5576	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
131	130	alizaynoune130	zaynoune130@ali.ali	ali	zaynoune	OFFLINE	1761	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
132	131	alizaynoune131	zaynoune131@ali.ali	ali	zaynoune	OFFLINE	3221	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
133	132	alizaynoune132	zaynoune132@ali.ali	ali	zaynoune	OFFLINE	1415	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
134	133	alizaynoune133	zaynoune133@ali.ali	ali	zaynoune	OFFLINE	162	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
135	134	alizaynoune134	zaynoune134@ali.ali	ali	zaynoune	OFFLINE	1272	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
136	135	alizaynoune135	zaynoune135@ali.ali	ali	zaynoune	ONLINE	2313	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
137	136	alizaynoune136	zaynoune136@ali.ali	ali	zaynoune	OFFLINE	1301	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
138	137	alizaynoune137	zaynoune137@ali.ali	ali	zaynoune	ONLINE	6954	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
139	138	alizaynoune138	zaynoune138@ali.ali	ali	zaynoune	OFFLINE	780	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
140	139	alizaynoune139	zaynoune139@ali.ali	ali	zaynoune	ONLINE	5361	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
141	140	alizaynoune140	zaynoune140@ali.ali	ali	zaynoune	OFFLINE	1935	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
142	141	alizaynoune141	zaynoune141@ali.ali	ali	zaynoune	OFFLINE	4813	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
143	142	alizaynoune142	zaynoune142@ali.ali	ali	zaynoune	ONLINE	2277	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
144	143	alizaynoune143	zaynoune143@ali.ali	ali	zaynoune	OFFLINE	7777	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
145	144	alizaynoune144	zaynoune144@ali.ali	ali	zaynoune	ONLINE	3429	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
146	145	alizaynoune145	zaynoune145@ali.ali	ali	zaynoune	OFFLINE	2188	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
147	146	alizaynoune146	zaynoune146@ali.ali	ali	zaynoune	OFFLINE	4967	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
148	147	alizaynoune147	zaynoune147@ali.ali	ali	zaynoune	OFFLINE	62	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
149	148	alizaynoune148	zaynoune148@ali.ali	ali	zaynoune	ONLINE	6203	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
150	149	alizaynoune149	zaynoune149@ali.ali	ali	zaynoune	OFFLINE	103	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
151	150	alizaynoune150	zaynoune150@ali.ali	ali	zaynoune	OFFLINE	4848	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
152	151	alizaynoune151	zaynoune151@ali.ali	ali	zaynoune	ONLINE	7120	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
153	152	alizaynoune152	zaynoune152@ali.ali	ali	zaynoune	ONLINE	2346	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
154	153	alizaynoune153	zaynoune153@ali.ali	ali	zaynoune	OFFLINE	4239	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
155	154	alizaynoune154	zaynoune154@ali.ali	ali	zaynoune	OFFLINE	3831	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
156	155	alizaynoune155	zaynoune155@ali.ali	ali	zaynoune	ONLINE	7987	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
157	156	alizaynoune156	zaynoune156@ali.ali	ali	zaynoune	ONLINE	1846	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
158	157	alizaynoune157	zaynoune157@ali.ali	ali	zaynoune	ONLINE	32	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
159	158	alizaynoune158	zaynoune158@ali.ali	ali	zaynoune	OFFLINE	2547	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
160	159	alizaynoune159	zaynoune159@ali.ali	ali	zaynoune	OFFLINE	5412	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
161	160	alizaynoune160	zaynoune160@ali.ali	ali	zaynoune	ONLINE	6434	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
162	161	alizaynoune161	zaynoune161@ali.ali	ali	zaynoune	OFFLINE	7935	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
163	162	alizaynoune162	zaynoune162@ali.ali	ali	zaynoune	ONLINE	4237	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
164	163	alizaynoune163	zaynoune163@ali.ali	ali	zaynoune	ONLINE	7953	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
165	164	alizaynoune164	zaynoune164@ali.ali	ali	zaynoune	ONLINE	6174	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
166	165	alizaynoune165	zaynoune165@ali.ali	ali	zaynoune	ONLINE	2774	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
167	166	alizaynoune166	zaynoune166@ali.ali	ali	zaynoune	ONLINE	3873	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
168	167	alizaynoune167	zaynoune167@ali.ali	ali	zaynoune	ONLINE	4192	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
169	168	alizaynoune168	zaynoune168@ali.ali	ali	zaynoune	OFFLINE	1746	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
170	169	alizaynoune169	zaynoune169@ali.ali	ali	zaynoune	OFFLINE	173	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
171	170	alizaynoune170	zaynoune170@ali.ali	ali	zaynoune	OFFLINE	5711	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
172	171	alizaynoune171	zaynoune171@ali.ali	ali	zaynoune	OFFLINE	3778	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
173	172	alizaynoune172	zaynoune172@ali.ali	ali	zaynoune	ONLINE	1963	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
174	173	alizaynoune173	zaynoune173@ali.ali	ali	zaynoune	ONLINE	7300	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
175	174	alizaynoune174	zaynoune174@ali.ali	ali	zaynoune	ONLINE	4259	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
176	175	alizaynoune175	zaynoune175@ali.ali	ali	zaynoune	OFFLINE	2307	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
177	176	alizaynoune176	zaynoune176@ali.ali	ali	zaynoune	OFFLINE	7913	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
178	177	alizaynoune177	zaynoune177@ali.ali	ali	zaynoune	OFFLINE	5776	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
179	178	alizaynoune178	zaynoune178@ali.ali	ali	zaynoune	OFFLINE	3007	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
180	179	alizaynoune179	zaynoune179@ali.ali	ali	zaynoune	ONLINE	3970	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
181	180	alizaynoune180	zaynoune180@ali.ali	ali	zaynoune	ONLINE	7072	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
182	181	alizaynoune181	zaynoune181@ali.ali	ali	zaynoune	ONLINE	1659	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
183	182	alizaynoune182	zaynoune182@ali.ali	ali	zaynoune	ONLINE	1853	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
184	183	alizaynoune183	zaynoune183@ali.ali	ali	zaynoune	OFFLINE	2276	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
185	184	alizaynoune184	zaynoune184@ali.ali	ali	zaynoune	ONLINE	7223	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
186	185	alizaynoune185	zaynoune185@ali.ali	ali	zaynoune	ONLINE	3803	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
187	186	alizaynoune186	zaynoune186@ali.ali	ali	zaynoune	OFFLINE	4016	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
188	187	alizaynoune187	zaynoune187@ali.ali	ali	zaynoune	OFFLINE	4895	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
189	188	alizaynoune188	zaynoune188@ali.ali	ali	zaynoune	ONLINE	1673	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
190	189	alizaynoune189	zaynoune189@ali.ali	ali	zaynoune	OFFLINE	6096	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
191	190	alizaynoune190	zaynoune190@ali.ali	ali	zaynoune	OFFLINE	7977	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
192	191	alizaynoune191	zaynoune191@ali.ali	ali	zaynoune	OFFLINE	1111	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
193	192	alizaynoune192	zaynoune192@ali.ali	ali	zaynoune	ONLINE	1691	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
194	193	alizaynoune193	zaynoune193@ali.ali	ali	zaynoune	ONLINE	2708	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
195	194	alizaynoune194	zaynoune194@ali.ali	ali	zaynoune	OFFLINE	4190	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
196	195	alizaynoune195	zaynoune195@ali.ali	ali	zaynoune	ONLINE	5346	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
197	196	alizaynoune196	zaynoune196@ali.ali	ali	zaynoune	ONLINE	3616	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
198	197	alizaynoune197	zaynoune197@ali.ali	ali	zaynoune	ONLINE	1681	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
199	198	alizaynoune198	zaynoune198@ali.ali	ali	zaynoune	OFFLINE	5851	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
200	199	alizaynoune199	zaynoune199@ali.ali	ali	zaynoune	ONLINE	6093	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
201	200	alizaynoune200	zaynoune200@ali.ali	ali	zaynoune	OFFLINE	4000	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.790642	2022-10-22 18:27:04.790642
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	ONLINE	2288	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	2022-10-22 18:27:04.781512	2022-10-22 18:27:04.781512
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, createdat) FROM stdin;
1	51111	2	2022-10-22 18:27:04.798285
2	51111	4	2022-10-22 18:27:04.798285
3	51111	6	2022-10-22 18:27:04.798285
4	51111	8	2022-10-22 18:27:04.798285
5	51111	10	2022-10-22 18:27:04.798285
6	51111	12	2022-10-22 18:27:04.798285
7	51111	14	2022-10-22 18:27:04.798285
8	51111	16	2022-10-22 18:27:04.798285
9	51111	18	2022-10-22 18:27:04.798285
10	51111	20	2022-10-22 18:27:04.798285
11	1	1	2022-10-22 18:27:04.817099
12	2	2	2022-10-22 18:27:04.817099
13	3	3	2022-10-22 18:27:04.817099
14	4	4	2022-10-22 18:27:04.817099
15	5	5	2022-10-22 18:27:04.817099
16	6	6	2022-10-22 18:27:04.817099
17	7	7	2022-10-22 18:27:04.817099
18	8	8	2022-10-22 18:27:04.817099
19	9	9	2022-10-22 18:27:04.817099
20	10	10	2022-10-22 18:27:04.817099
21	11	11	2022-10-22 18:27:04.817099
22	12	12	2022-10-22 18:27:04.817099
23	13	13	2022-10-22 18:27:04.817099
24	14	14	2022-10-22 18:27:04.817099
25	15	15	2022-10-22 18:27:04.817099
26	16	16	2022-10-22 18:27:04.817099
27	17	17	2022-10-22 18:27:04.817099
28	18	18	2022-10-22 18:27:04.817099
29	19	19	2022-10-22 18:27:04.817099
30	20	20	2022-10-22 18:27:04.817099
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.achievements_id_seq', 22, true);


--
-- Name: blocked_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.blocked_id_seq', 1, false);


--
-- Name: conversation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.conversation_id_seq', 1, false);


--
-- Name: friends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.friends_id_seq', 1, false);


--
-- Name: game_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.game_id_seq', 2, true);


--
-- Name: gameinvites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.gameinvites_id_seq', 2, true);


--
-- Name: group_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.group_member_id_seq', 1, false);


--
-- Name: invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.invites_id_seq', 81, true);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.message_id_seq', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_id_seq', 62, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.players_id_seq', 4, true);


--
-- Name: users_achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_achievements_id_seq', 30, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_id_seq', 201, true);


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
-- Name: gameinvites gameinvites_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.gameinvites
    ADD CONSTRAINT gameinvites_pkey PRIMARY KEY (id);


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
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


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
-- Name: gameinvites gameinvites_fromid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.gameinvites
    ADD CONSTRAINT gameinvites_fromid_fkey FOREIGN KEY (fromid) REFERENCES public.users(intra_id) ON DELETE CASCADE;


--
-- Name: gameinvites gameinvites_gameid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.gameinvites
    ADD CONSTRAINT gameinvites_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.game(id) ON DELETE CASCADE;


--
-- Name: gameinvites gameinvites_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.gameinvites
    ADD CONSTRAINT gameinvites_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id) ON DELETE CASCADE;


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
    ADD CONSTRAINT notification_fromid_fkey FOREIGN KEY (fromid) REFERENCES public.users(intra_id) ON DELETE CASCADE;


--
-- Name: notification notification_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id) ON DELETE CASCADE;


--
-- Name: players players_gameid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.game(id) ON DELETE CASCADE;


--
-- Name: players players_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id) ON DELETE CASCADE;


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

