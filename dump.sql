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
    createdat timestamp without time zone DEFAULT now() NOT NULL,
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
    createdat timestamp without time zone DEFAULT now() NOT NULL,
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
-- Data for Name: group_member; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.group_member (id, user_id, conversation_id, joint_date, left_date) FROM stdin;
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.invites (id, senderid, receiverid, accepted, created_at) FROM stdin;
1	1	51111	f	2022-10-13 15:37:25.813087
2	2	51111	f	2022-10-13 15:37:25.813087
3	3	51111	f	2022-10-13 15:37:25.813087
4	4	51111	f	2022-10-13 15:37:25.813087
5	5	51111	f	2022-10-13 15:37:25.813087
6	6	51111	f	2022-10-13 15:37:25.813087
7	7	51111	f	2022-10-13 15:37:25.813087
8	8	51111	f	2022-10-13 15:37:25.813087
9	9	51111	f	2022-10-13 15:37:25.813087
10	10	51111	f	2022-10-13 15:37:25.813087
11	11	51111	f	2022-10-13 15:37:25.813087
12	12	51111	f	2022-10-13 15:37:25.813087
13	13	51111	f	2022-10-13 15:37:25.813087
14	14	51111	f	2022-10-13 15:37:25.813087
15	15	51111	f	2022-10-13 15:37:25.813087
16	16	51111	f	2022-10-13 15:37:25.813087
17	17	51111	f	2022-10-13 15:37:25.813087
18	18	51111	f	2022-10-13 15:37:25.813087
19	19	51111	f	2022-10-13 15:37:25.813087
20	20	51111	f	2022-10-13 15:37:25.813087
21	21	51111	f	2022-10-13 15:37:25.813087
22	22	51111	f	2022-10-13 15:37:25.813087
23	23	51111	f	2022-10-13 15:37:25.813087
24	24	51111	f	2022-10-13 15:37:25.813087
25	25	51111	f	2022-10-13 15:37:25.813087
26	26	51111	f	2022-10-13 15:37:25.813087
27	27	51111	f	2022-10-13 15:37:25.813087
28	28	51111	f	2022-10-13 15:37:25.813087
29	29	51111	f	2022-10-13 15:37:25.813087
30	30	51111	f	2022-10-13 15:37:25.813087
31	31	51111	f	2022-10-13 15:37:25.813087
32	32	51111	f	2022-10-13 15:37:25.813087
33	33	51111	f	2022-10-13 15:37:25.813087
34	34	51111	f	2022-10-13 15:37:25.813087
35	35	51111	f	2022-10-13 15:37:25.813087
36	36	51111	f	2022-10-13 15:37:25.813087
37	37	51111	f	2022-10-13 15:37:25.813087
38	38	51111	f	2022-10-13 15:37:25.813087
39	39	51111	f	2022-10-13 15:37:25.813087
40	40	51111	f	2022-10-13 15:37:25.813087
41	41	51111	f	2022-10-13 15:37:25.813087
42	42	51111	f	2022-10-13 15:37:25.813087
43	43	51111	f	2022-10-13 15:37:25.813087
44	44	51111	f	2022-10-13 15:37:25.813087
45	45	51111	f	2022-10-13 15:37:25.813087
46	46	51111	f	2022-10-13 15:37:25.813087
47	47	51111	f	2022-10-13 15:37:25.813087
48	48	51111	f	2022-10-13 15:37:25.813087
49	49	51111	f	2022-10-13 15:37:25.813087
50	50	51111	f	2022-10-13 15:37:25.813087
51	51	51111	f	2022-10-13 15:37:25.813087
52	52	51111	f	2022-10-13 15:37:25.813087
53	53	51111	f	2022-10-13 15:37:25.813087
54	54	51111	f	2022-10-13 15:37:25.813087
55	55	51111	f	2022-10-13 15:37:25.813087
56	56	51111	f	2022-10-13 15:37:25.813087
57	57	51111	f	2022-10-13 15:37:25.813087
58	58	51111	f	2022-10-13 15:37:25.813087
59	59	51111	f	2022-10-13 15:37:25.813087
60	60	51111	f	2022-10-13 15:37:25.813087
61	51111	60	f	2022-10-13 15:37:25.836255
62	51111	61	f	2022-10-13 15:37:25.836255
63	51111	62	f	2022-10-13 15:37:25.836255
64	51111	63	f	2022-10-13 15:37:25.836255
65	51111	64	f	2022-10-13 15:37:25.836255
66	51111	65	f	2022-10-13 15:37:25.836255
67	51111	66	f	2022-10-13 15:37:25.836255
68	51111	67	f	2022-10-13 15:37:25.836255
69	51111	68	f	2022-10-13 15:37:25.836255
70	51111	69	f	2022-10-13 15:37:25.836255
71	51111	70	f	2022-10-13 15:37:25.836255
72	51111	71	f	2022-10-13 15:37:25.836255
73	51111	72	f	2022-10-13 15:37:25.836255
74	51111	73	f	2022-10-13 15:37:25.836255
75	51111	74	f	2022-10-13 15:37:25.836255
76	51111	75	f	2022-10-13 15:37:25.836255
77	51111	76	f	2022-10-13 15:37:25.836255
78	51111	77	f	2022-10-13 15:37:25.836255
79	51111	78	f	2022-10-13 15:37:25.836255
80	51111	79	f	2022-10-13 15:37:25.836255
81	51111	80	f	2022-10-13 15:37:25.836255
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
1	FRIEND_REQUEST	51111	1	1	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
2	FRIEND_REQUEST	51111	2	2	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
3	FRIEND_REQUEST	51111	3	3	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
4	FRIEND_REQUEST	51111	4	4	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
5	FRIEND_REQUEST	51111	5	5	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
6	FRIEND_REQUEST	51111	6	6	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
7	FRIEND_REQUEST	51111	7	7	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
8	FRIEND_REQUEST	51111	8	8	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
9	FRIEND_REQUEST	51111	9	9	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
10	FRIEND_REQUEST	51111	10	10	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
11	FRIEND_REQUEST	51111	11	11	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
12	FRIEND_REQUEST	51111	12	12	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
13	FRIEND_REQUEST	51111	13	13	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
14	FRIEND_REQUEST	51111	14	14	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
15	FRIEND_REQUEST	51111	15	15	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
16	FRIEND_REQUEST	51111	16	16	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
17	FRIEND_REQUEST	51111	17	17	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
18	FRIEND_REQUEST	51111	18	18	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
19	FRIEND_REQUEST	51111	19	19	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
20	FRIEND_REQUEST	51111	20	20	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
21	FRIEND_REQUEST	51111	21	21	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
22	FRIEND_REQUEST	51111	22	22	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
23	FRIEND_REQUEST	51111	23	23	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
24	FRIEND_REQUEST	51111	24	24	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
25	FRIEND_REQUEST	51111	25	25	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
26	FRIEND_REQUEST	51111	26	26	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
27	FRIEND_REQUEST	51111	27	27	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
28	FRIEND_REQUEST	51111	28	28	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
29	FRIEND_REQUEST	51111	29	29	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
30	FRIEND_REQUEST	51111	30	30	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
31	FRIEND_REQUEST	51111	31	31	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
32	FRIEND_REQUEST	51111	32	32	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
33	FRIEND_REQUEST	51111	33	33	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
34	FRIEND_REQUEST	51111	34	34	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
35	FRIEND_REQUEST	51111	35	35	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
36	FRIEND_REQUEST	51111	36	36	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
37	FRIEND_REQUEST	51111	37	37	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
38	FRIEND_REQUEST	51111	38	38	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
39	FRIEND_REQUEST	51111	39	39	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
40	FRIEND_REQUEST	51111	40	40	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
41	FRIEND_REQUEST	51111	41	41	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
42	FRIEND_REQUEST	51111	42	42	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
43	FRIEND_REQUEST	51111	43	43	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
44	FRIEND_REQUEST	51111	44	44	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
45	FRIEND_REQUEST	51111	45	45	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
46	FRIEND_REQUEST	51111	46	46	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
47	FRIEND_REQUEST	51111	47	47	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
48	FRIEND_REQUEST	51111	48	48	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
49	FRIEND_REQUEST	51111	49	49	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
50	FRIEND_REQUEST	51111	50	50	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
51	FRIEND_REQUEST	51111	51	51	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
52	FRIEND_REQUEST	51111	52	52	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
53	FRIEND_REQUEST	51111	53	53	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
54	FRIEND_REQUEST	51111	54	54	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
55	FRIEND_REQUEST	51111	55	55	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
56	FRIEND_REQUEST	51111	56	56	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
57	FRIEND_REQUEST	51111	57	57	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
58	FRIEND_REQUEST	51111	58	58	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
59	FRIEND_REQUEST	51111	59	59	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
60	FRIEND_REQUEST	51111	60	60	send you friend request	f	2022-10-13 15:37:25.837063	2022-10-13 15:37:25.837063
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
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	OFFLINE	2825	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.773093	2022-10-13 15:37:25.773093
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	7562	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	ONLINE	6644	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	ONLINE	7855	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	5272	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	ONLINE	1644	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	ONLINE	4903	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	5026	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	ONLINE	4679	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	ONLINE	5164	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	ONLINE	4967	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	OFFLINE	6055	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	1361	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	OFFLINE	5238	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	ONLINE	3789	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	ONLINE	5569	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	OFFLINE	6797	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	ONLINE	1735	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	OFFLINE	3439	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	ONLINE	4644	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	ONLINE	1244	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	ONLINE	3888	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	2876	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	OFFLINE	4785	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	3379	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	ONLINE	3070	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	OFFLINE	14	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	OFFLINE	3818	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	ONLINE	3859	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	OFFLINE	4122	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	OFFLINE	1579	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
32	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	OFFLINE	1264	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
33	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	6474	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
34	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	ONLINE	5252	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
35	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	435	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
36	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	3958	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
37	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	7355	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
38	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	ONLINE	1351	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
39	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	OFFLINE	5443	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
40	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	OFFLINE	3164	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
41	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	ONLINE	745	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
42	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	ONLINE	7698	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
43	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	1595	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
44	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	OFFLINE	167	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
45	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	ONLINE	5117	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
46	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	ONLINE	347	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
47	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	2087	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
48	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	4294	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
49	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	ONLINE	7977	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
50	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	OFFLINE	2121	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
51	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	OFFLINE	1146	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
52	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	ONLINE	3551	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
53	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	ONLINE	7466	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
54	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	ONLINE	4967	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
55	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	ONLINE	6840	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
56	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	5520	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
57	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	7934	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
58	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	2545	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
59	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	2777	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
60	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	OFFLINE	4918	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
61	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	ONLINE	916	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
62	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	7256	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
63	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	500	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
64	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	ONLINE	2164	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
65	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	ONLINE	510	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
66	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	7540	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
67	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	OFFLINE	4552	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
68	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	6546	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
69	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	ONLINE	6930	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
70	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	OFFLINE	100	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
71	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	OFFLINE	7606	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
72	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	OFFLINE	4056	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
73	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	ONLINE	49	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
74	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	ONLINE	3832	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
75	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	7713	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
76	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	ONLINE	1674	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
77	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	OFFLINE	4042	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
78	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	ONLINE	7580	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
79	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	ONLINE	5630	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
80	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	ONLINE	4880	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
81	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	ONLINE	2759	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
82	81	alizaynoune81	zaynoune81@ali.ali	ali	zaynoune	ONLINE	2439	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
83	82	alizaynoune82	zaynoune82@ali.ali	ali	zaynoune	OFFLINE	5372	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
84	83	alizaynoune83	zaynoune83@ali.ali	ali	zaynoune	OFFLINE	7375	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
85	84	alizaynoune84	zaynoune84@ali.ali	ali	zaynoune	OFFLINE	7283	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
86	85	alizaynoune85	zaynoune85@ali.ali	ali	zaynoune	OFFLINE	1184	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
87	86	alizaynoune86	zaynoune86@ali.ali	ali	zaynoune	ONLINE	5513	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
88	87	alizaynoune87	zaynoune87@ali.ali	ali	zaynoune	ONLINE	3487	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
89	88	alizaynoune88	zaynoune88@ali.ali	ali	zaynoune	ONLINE	2120	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
90	89	alizaynoune89	zaynoune89@ali.ali	ali	zaynoune	OFFLINE	4499	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
91	90	alizaynoune90	zaynoune90@ali.ali	ali	zaynoune	ONLINE	478	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
92	91	alizaynoune91	zaynoune91@ali.ali	ali	zaynoune	ONLINE	2466	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
93	92	alizaynoune92	zaynoune92@ali.ali	ali	zaynoune	OFFLINE	803	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
94	93	alizaynoune93	zaynoune93@ali.ali	ali	zaynoune	ONLINE	4035	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
95	94	alizaynoune94	zaynoune94@ali.ali	ali	zaynoune	OFFLINE	5919	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
96	95	alizaynoune95	zaynoune95@ali.ali	ali	zaynoune	ONLINE	5820	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
97	96	alizaynoune96	zaynoune96@ali.ali	ali	zaynoune	ONLINE	1194	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
98	97	alizaynoune97	zaynoune97@ali.ali	ali	zaynoune	OFFLINE	3933	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
99	98	alizaynoune98	zaynoune98@ali.ali	ali	zaynoune	ONLINE	480	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
100	99	alizaynoune99	zaynoune99@ali.ali	ali	zaynoune	ONLINE	117	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
101	100	alizaynoune100	zaynoune100@ali.ali	ali	zaynoune	ONLINE	5589	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
102	101	alizaynoune101	zaynoune101@ali.ali	ali	zaynoune	ONLINE	7283	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
103	102	alizaynoune102	zaynoune102@ali.ali	ali	zaynoune	ONLINE	5651	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
104	103	alizaynoune103	zaynoune103@ali.ali	ali	zaynoune	ONLINE	2111	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
105	104	alizaynoune104	zaynoune104@ali.ali	ali	zaynoune	OFFLINE	4738	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
106	105	alizaynoune105	zaynoune105@ali.ali	ali	zaynoune	ONLINE	112	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
107	106	alizaynoune106	zaynoune106@ali.ali	ali	zaynoune	ONLINE	2078	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
108	107	alizaynoune107	zaynoune107@ali.ali	ali	zaynoune	ONLINE	6801	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
109	108	alizaynoune108	zaynoune108@ali.ali	ali	zaynoune	ONLINE	6207	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
110	109	alizaynoune109	zaynoune109@ali.ali	ali	zaynoune	OFFLINE	4831	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
111	110	alizaynoune110	zaynoune110@ali.ali	ali	zaynoune	OFFLINE	4602	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
112	111	alizaynoune111	zaynoune111@ali.ali	ali	zaynoune	OFFLINE	4007	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
113	112	alizaynoune112	zaynoune112@ali.ali	ali	zaynoune	OFFLINE	37	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
114	113	alizaynoune113	zaynoune113@ali.ali	ali	zaynoune	ONLINE	3677	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
115	114	alizaynoune114	zaynoune114@ali.ali	ali	zaynoune	OFFLINE	5485	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
116	115	alizaynoune115	zaynoune115@ali.ali	ali	zaynoune	ONLINE	5258	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
117	116	alizaynoune116	zaynoune116@ali.ali	ali	zaynoune	OFFLINE	6445	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
118	117	alizaynoune117	zaynoune117@ali.ali	ali	zaynoune	OFFLINE	6541	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
119	118	alizaynoune118	zaynoune118@ali.ali	ali	zaynoune	OFFLINE	5669	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
120	119	alizaynoune119	zaynoune119@ali.ali	ali	zaynoune	ONLINE	4284	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
121	120	alizaynoune120	zaynoune120@ali.ali	ali	zaynoune	OFFLINE	1349	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
122	121	alizaynoune121	zaynoune121@ali.ali	ali	zaynoune	ONLINE	4669	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
123	122	alizaynoune122	zaynoune122@ali.ali	ali	zaynoune	OFFLINE	3596	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
124	123	alizaynoune123	zaynoune123@ali.ali	ali	zaynoune	ONLINE	5117	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
125	124	alizaynoune124	zaynoune124@ali.ali	ali	zaynoune	ONLINE	5792	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
126	125	alizaynoune125	zaynoune125@ali.ali	ali	zaynoune	ONLINE	4079	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
127	126	alizaynoune126	zaynoune126@ali.ali	ali	zaynoune	OFFLINE	28	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
128	127	alizaynoune127	zaynoune127@ali.ali	ali	zaynoune	ONLINE	3792	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
129	128	alizaynoune128	zaynoune128@ali.ali	ali	zaynoune	ONLINE	2882	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
130	129	alizaynoune129	zaynoune129@ali.ali	ali	zaynoune	OFFLINE	2130	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
131	130	alizaynoune130	zaynoune130@ali.ali	ali	zaynoune	ONLINE	5464	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
132	131	alizaynoune131	zaynoune131@ali.ali	ali	zaynoune	OFFLINE	6842	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
133	132	alizaynoune132	zaynoune132@ali.ali	ali	zaynoune	ONLINE	2638	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
134	133	alizaynoune133	zaynoune133@ali.ali	ali	zaynoune	ONLINE	1553	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
135	134	alizaynoune134	zaynoune134@ali.ali	ali	zaynoune	ONLINE	173	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
136	135	alizaynoune135	zaynoune135@ali.ali	ali	zaynoune	ONLINE	4308	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
137	136	alizaynoune136	zaynoune136@ali.ali	ali	zaynoune	OFFLINE	7200	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
138	137	alizaynoune137	zaynoune137@ali.ali	ali	zaynoune	OFFLINE	4320	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
139	138	alizaynoune138	zaynoune138@ali.ali	ali	zaynoune	ONLINE	3511	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
140	139	alizaynoune139	zaynoune139@ali.ali	ali	zaynoune	OFFLINE	6644	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
141	140	alizaynoune140	zaynoune140@ali.ali	ali	zaynoune	OFFLINE	4113	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
142	141	alizaynoune141	zaynoune141@ali.ali	ali	zaynoune	ONLINE	1110	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
143	142	alizaynoune142	zaynoune142@ali.ali	ali	zaynoune	ONLINE	3135	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
144	143	alizaynoune143	zaynoune143@ali.ali	ali	zaynoune	ONLINE	3937	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
145	144	alizaynoune144	zaynoune144@ali.ali	ali	zaynoune	OFFLINE	1970	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
146	145	alizaynoune145	zaynoune145@ali.ali	ali	zaynoune	ONLINE	6723	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
147	146	alizaynoune146	zaynoune146@ali.ali	ali	zaynoune	OFFLINE	3851	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
148	147	alizaynoune147	zaynoune147@ali.ali	ali	zaynoune	ONLINE	4037	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
149	148	alizaynoune148	zaynoune148@ali.ali	ali	zaynoune	OFFLINE	464	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
150	149	alizaynoune149	zaynoune149@ali.ali	ali	zaynoune	ONLINE	3632	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
151	150	alizaynoune150	zaynoune150@ali.ali	ali	zaynoune	OFFLINE	278	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
152	151	alizaynoune151	zaynoune151@ali.ali	ali	zaynoune	OFFLINE	1720	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
153	152	alizaynoune152	zaynoune152@ali.ali	ali	zaynoune	ONLINE	7948	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
154	153	alizaynoune153	zaynoune153@ali.ali	ali	zaynoune	ONLINE	4984	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
155	154	alizaynoune154	zaynoune154@ali.ali	ali	zaynoune	ONLINE	1162	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
156	155	alizaynoune155	zaynoune155@ali.ali	ali	zaynoune	OFFLINE	7670	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
157	156	alizaynoune156	zaynoune156@ali.ali	ali	zaynoune	OFFLINE	7886	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
158	157	alizaynoune157	zaynoune157@ali.ali	ali	zaynoune	ONLINE	6701	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
159	158	alizaynoune158	zaynoune158@ali.ali	ali	zaynoune	OFFLINE	83	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
160	159	alizaynoune159	zaynoune159@ali.ali	ali	zaynoune	OFFLINE	4113	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
161	160	alizaynoune160	zaynoune160@ali.ali	ali	zaynoune	ONLINE	3124	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
162	161	alizaynoune161	zaynoune161@ali.ali	ali	zaynoune	OFFLINE	5936	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
163	162	alizaynoune162	zaynoune162@ali.ali	ali	zaynoune	OFFLINE	5483	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
164	163	alizaynoune163	zaynoune163@ali.ali	ali	zaynoune	ONLINE	5107	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
165	164	alizaynoune164	zaynoune164@ali.ali	ali	zaynoune	OFFLINE	5697	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
166	165	alizaynoune165	zaynoune165@ali.ali	ali	zaynoune	ONLINE	7986	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
167	166	alizaynoune166	zaynoune166@ali.ali	ali	zaynoune	ONLINE	323	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
168	167	alizaynoune167	zaynoune167@ali.ali	ali	zaynoune	ONLINE	3987	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
169	168	alizaynoune168	zaynoune168@ali.ali	ali	zaynoune	OFFLINE	1916	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
170	169	alizaynoune169	zaynoune169@ali.ali	ali	zaynoune	ONLINE	1883	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
171	170	alizaynoune170	zaynoune170@ali.ali	ali	zaynoune	OFFLINE	6373	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
172	171	alizaynoune171	zaynoune171@ali.ali	ali	zaynoune	ONLINE	212	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
173	172	alizaynoune172	zaynoune172@ali.ali	ali	zaynoune	OFFLINE	3787	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
174	173	alizaynoune173	zaynoune173@ali.ali	ali	zaynoune	ONLINE	203	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
175	174	alizaynoune174	zaynoune174@ali.ali	ali	zaynoune	ONLINE	41	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
176	175	alizaynoune175	zaynoune175@ali.ali	ali	zaynoune	ONLINE	800	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
177	176	alizaynoune176	zaynoune176@ali.ali	ali	zaynoune	OFFLINE	2336	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
178	177	alizaynoune177	zaynoune177@ali.ali	ali	zaynoune	ONLINE	3279	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
179	178	alizaynoune178	zaynoune178@ali.ali	ali	zaynoune	OFFLINE	1806	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
180	179	alizaynoune179	zaynoune179@ali.ali	ali	zaynoune	ONLINE	7784	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
181	180	alizaynoune180	zaynoune180@ali.ali	ali	zaynoune	OFFLINE	6218	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
182	181	alizaynoune181	zaynoune181@ali.ali	ali	zaynoune	ONLINE	1806	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
183	182	alizaynoune182	zaynoune182@ali.ali	ali	zaynoune	OFFLINE	7732	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
184	183	alizaynoune183	zaynoune183@ali.ali	ali	zaynoune	ONLINE	4611	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
185	184	alizaynoune184	zaynoune184@ali.ali	ali	zaynoune	OFFLINE	4014	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
186	185	alizaynoune185	zaynoune185@ali.ali	ali	zaynoune	ONLINE	2974	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
187	186	alizaynoune186	zaynoune186@ali.ali	ali	zaynoune	ONLINE	5236	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
188	187	alizaynoune187	zaynoune187@ali.ali	ali	zaynoune	ONLINE	1102	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
189	188	alizaynoune188	zaynoune188@ali.ali	ali	zaynoune	ONLINE	6911	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
190	189	alizaynoune189	zaynoune189@ali.ali	ali	zaynoune	ONLINE	1577	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
191	190	alizaynoune190	zaynoune190@ali.ali	ali	zaynoune	ONLINE	4134	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
192	191	alizaynoune191	zaynoune191@ali.ali	ali	zaynoune	ONLINE	585	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
193	192	alizaynoune192	zaynoune192@ali.ali	ali	zaynoune	ONLINE	6013	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
194	193	alizaynoune193	zaynoune193@ali.ali	ali	zaynoune	OFFLINE	3178	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
195	194	alizaynoune194	zaynoune194@ali.ali	ali	zaynoune	OFFLINE	2226	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
196	195	alizaynoune195	zaynoune195@ali.ali	ali	zaynoune	ONLINE	2053	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
197	196	alizaynoune196	zaynoune196@ali.ali	ali	zaynoune	OFFLINE	3301	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
198	197	alizaynoune197	zaynoune197@ali.ali	ali	zaynoune	ONLINE	1248	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
199	198	alizaynoune198	zaynoune198@ali.ali	ali	zaynoune	ONLINE	4041	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
200	199	alizaynoune199	zaynoune199@ali.ali	ali	zaynoune	OFFLINE	4637	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
201	200	alizaynoune200	zaynoune200@ali.ali	ali	zaynoune	ONLINE	7311	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 15:37:25.785578	2022-10-13 15:37:25.785578
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, createdat) FROM stdin;
1	51111	2	2022-10-13 15:37:25.793034
2	51111	4	2022-10-13 15:37:25.793034
3	51111	6	2022-10-13 15:37:25.793034
4	51111	8	2022-10-13 15:37:25.793034
5	51111	10	2022-10-13 15:37:25.793034
6	51111	12	2022-10-13 15:37:25.793034
7	51111	14	2022-10-13 15:37:25.793034
8	51111	16	2022-10-13 15:37:25.793034
9	51111	18	2022-10-13 15:37:25.793034
10	51111	20	2022-10-13 15:37:25.793034
11	1	1	2022-10-13 15:37:25.812289
12	2	2	2022-10-13 15:37:25.812289
13	3	3	2022-10-13 15:37:25.812289
14	4	4	2022-10-13 15:37:25.812289
15	5	5	2022-10-13 15:37:25.812289
16	6	6	2022-10-13 15:37:25.812289
17	7	7	2022-10-13 15:37:25.812289
18	8	8	2022-10-13 15:37:25.812289
19	9	9	2022-10-13 15:37:25.812289
20	10	10	2022-10-13 15:37:25.812289
21	11	11	2022-10-13 15:37:25.812289
22	12	12	2022-10-13 15:37:25.812289
23	13	13	2022-10-13 15:37:25.812289
24	14	14	2022-10-13 15:37:25.812289
25	15	15	2022-10-13 15:37:25.812289
26	16	16	2022-10-13 15:37:25.812289
27	17	17	2022-10-13 15:37:25.812289
28	18	18	2022-10-13 15:37:25.812289
29	19	19	2022-10-13 15:37:25.812289
30	20	20	2022-10-13 15:37:25.812289
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

SELECT pg_catalog.setval('public.game_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.notification_id_seq', 60, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.players_id_seq', 1, false);


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
-- Name: players players_gameid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.game(id);


--
-- Name: players players_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id);


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

