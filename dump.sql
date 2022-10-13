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
1	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:19:56.274691
2	WAITING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:25:34.274691
3	WAITING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:22:11.274691
4	WAITING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:13:39.274691
5	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:16:42.274691
6	WAITING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:21:30.274691
7	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:23:15.274691
8	WAITING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:17:43.274691
9	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:17:59.274691
10	WAITING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:26:31.274691
11	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:19:34.274691
12	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:19:36.274691
13	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:14:33.274691
14	PLAYING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:13:59.274691
15	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:20:22.274691
16	PLAYING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:26:36.274691
17	PLAYING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:18:03.274691
18	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:21:53.274691
19	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:16:10.274691
20	PLAYING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:18:33.274691
21	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:14:14.274691
22	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:22:18.274691
23	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:18:58.274691
24	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:15:17.274691
25	WAITING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:19:36.274691
26	WAITING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:14:02.274691
27	WAITING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:18:49.274691
28	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:15:37.274691
29	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:19:10.274691
30	PLAYING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:14:41.274691
31	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:23:22.274691
32	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:25:06.274691
33	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:14:10.274691
34	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:16:18.274691
35	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:25:39.274691
36	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:14:17.274691
37	PLAYING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:25:40.274691
38	END	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:17:05.274691
39	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:19:29.274691
40	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:22:25.274691
41	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:17:24.274691
42	WAITING	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:23:21.274691
43	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:23:16.274691
44	WAITING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:18:50.274691
45	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:17:08.274691
46	WAITING	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:16:36.274691
47	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:22:52.274691
48	WAITING	NORMAL	2022-10-13 13:13:34.274691	2022-10-13 13:26:38.274691
49	END	DIFFICULT	2022-10-13 13:13:34.274691	2022-10-13 13:14:58.274691
50	END	EASY	2022-10-13 13:13:34.274691	2022-10-13 13:16:30.274691
51	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:22:22.306796
52	WAITING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:16:28.306796
53	PLAYING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:15:28.306796
54	WAITING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:13:57.306796
55	END	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:26:41.306796
56	END	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:14:32.306796
57	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:20:05.306796
58	END	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:17:46.306796
59	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:16:44.306796
60	WAITING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:25:41.306796
61	WAITING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:25:02.306796
62	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:22:39.306796
63	PLAYING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:24:25.306796
64	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:25:34.306796
65	PLAYING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:24:36.306796
66	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:17:42.306796
67	WAITING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:16:11.306796
68	WAITING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:26:40.306796
69	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:22:11.306796
70	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:15:23.306796
71	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:14:33.306796
72	WAITING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:18:48.306796
73	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:18:55.306796
74	WAITING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:14:10.306796
75	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:15:58.306796
76	END	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:21:02.306796
77	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:22:54.306796
78	END	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:21:52.306796
79	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:19:04.306796
80	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:18:28.306796
81	WAITING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:19:47.306796
82	END	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:23:43.306796
83	END	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:19:30.306796
84	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:18:17.306796
85	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:15:50.306796
86	WAITING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:19:49.306796
87	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:24:07.306796
88	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:25:32.306796
89	END	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:25:29.306796
90	END	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:19:05.306796
91	PLAYING	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:25:36.306796
92	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:16:42.306796
93	WAITING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:16:40.306796
94	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:22:17.306796
95	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:22:43.306796
96	END	DIFFICULT	2022-10-13 13:13:34.306796	2022-10-13 13:26:31.306796
97	PLAYING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:19:18.306796
98	PLAYING	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:21:07.306796
99	WAITING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:14:30.306796
100	WAITING	NORMAL	2022-10-13 13:13:34.306796	2022-10-13 13:24:33.306796
101	END	EASY	2022-10-13 13:13:34.306796	2022-10-13 13:16:36.306796
102	WAITING	DIFFICULT	2022-10-13 13:24:37.621684	2022-10-13 13:24:37.621684
103	PLAYING	DIFFICULT	2022-10-13 13:25:39.208873	2022-10-13 13:25:39.208873
104	PLAYING	DIFFICULT	2022-10-13 13:28:47.7789	2022-10-13 13:28:47.7789
105	PLAYING	EASY	2022-10-13 13:32:17.270273	2022-10-13 13:32:17.270273
106	PLAYING	NORMAL	2022-10-13 13:33:07.499458	2022-10-13 13:33:07.499458
107	PLAYING	NORMAL	2022-10-13 13:42:31.434079	2022-10-13 13:42:31.434079
108	PLAYING	NORMAL	2022-10-13 13:43:13.247994	2022-10-13 13:43:13.247994
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
1	1	51111	f	2022-10-13 13:13:34.206175
2	2	51111	f	2022-10-13 13:13:34.206175
3	3	51111	f	2022-10-13 13:13:34.206175
4	4	51111	f	2022-10-13 13:13:34.206175
5	5	51111	f	2022-10-13 13:13:34.206175
6	6	51111	f	2022-10-13 13:13:34.206175
7	7	51111	f	2022-10-13 13:13:34.206175
8	8	51111	f	2022-10-13 13:13:34.206175
9	9	51111	f	2022-10-13 13:13:34.206175
10	10	51111	f	2022-10-13 13:13:34.206175
11	11	51111	f	2022-10-13 13:13:34.206175
12	12	51111	f	2022-10-13 13:13:34.206175
13	13	51111	f	2022-10-13 13:13:34.206175
14	14	51111	f	2022-10-13 13:13:34.206175
15	15	51111	f	2022-10-13 13:13:34.206175
16	16	51111	f	2022-10-13 13:13:34.206175
17	17	51111	f	2022-10-13 13:13:34.206175
18	18	51111	f	2022-10-13 13:13:34.206175
19	19	51111	f	2022-10-13 13:13:34.206175
20	20	51111	f	2022-10-13 13:13:34.206175
21	21	51111	f	2022-10-13 13:13:34.206175
22	22	51111	f	2022-10-13 13:13:34.206175
23	23	51111	f	2022-10-13 13:13:34.206175
24	24	51111	f	2022-10-13 13:13:34.206175
25	25	51111	f	2022-10-13 13:13:34.206175
26	26	51111	f	2022-10-13 13:13:34.206175
27	27	51111	f	2022-10-13 13:13:34.206175
28	28	51111	f	2022-10-13 13:13:34.206175
29	29	51111	f	2022-10-13 13:13:34.206175
30	30	51111	f	2022-10-13 13:13:34.206175
31	31	51111	f	2022-10-13 13:13:34.206175
32	32	51111	f	2022-10-13 13:13:34.206175
33	33	51111	f	2022-10-13 13:13:34.206175
34	34	51111	f	2022-10-13 13:13:34.206175
35	35	51111	f	2022-10-13 13:13:34.206175
36	36	51111	f	2022-10-13 13:13:34.206175
37	37	51111	f	2022-10-13 13:13:34.206175
38	38	51111	f	2022-10-13 13:13:34.206175
39	39	51111	f	2022-10-13 13:13:34.206175
40	40	51111	f	2022-10-13 13:13:34.206175
41	41	51111	f	2022-10-13 13:13:34.206175
42	42	51111	f	2022-10-13 13:13:34.206175
43	43	51111	f	2022-10-13 13:13:34.206175
44	44	51111	f	2022-10-13 13:13:34.206175
45	45	51111	f	2022-10-13 13:13:34.206175
46	46	51111	f	2022-10-13 13:13:34.206175
47	47	51111	f	2022-10-13 13:13:34.206175
48	48	51111	f	2022-10-13 13:13:34.206175
49	49	51111	f	2022-10-13 13:13:34.206175
50	50	51111	f	2022-10-13 13:13:34.206175
51	51	51111	f	2022-10-13 13:13:34.206175
52	52	51111	f	2022-10-13 13:13:34.206175
53	53	51111	f	2022-10-13 13:13:34.206175
54	54	51111	f	2022-10-13 13:13:34.206175
55	55	51111	f	2022-10-13 13:13:34.206175
56	56	51111	f	2022-10-13 13:13:34.206175
57	57	51111	f	2022-10-13 13:13:34.206175
58	58	51111	f	2022-10-13 13:13:34.206175
59	59	51111	f	2022-10-13 13:13:34.206175
60	60	51111	f	2022-10-13 13:13:34.206175
61	51111	60	f	2022-10-13 13:13:34.246314
62	51111	61	f	2022-10-13 13:13:34.246314
63	51111	62	f	2022-10-13 13:13:34.246314
64	51111	63	f	2022-10-13 13:13:34.246314
65	51111	64	f	2022-10-13 13:13:34.246314
66	51111	65	f	2022-10-13 13:13:34.246314
67	51111	66	f	2022-10-13 13:13:34.246314
68	51111	67	f	2022-10-13 13:13:34.246314
69	51111	68	f	2022-10-13 13:13:34.246314
70	51111	69	f	2022-10-13 13:13:34.246314
71	51111	70	f	2022-10-13 13:13:34.246314
72	51111	71	f	2022-10-13 13:13:34.246314
73	51111	72	f	2022-10-13 13:13:34.246314
74	51111	73	f	2022-10-13 13:13:34.246314
75	51111	74	f	2022-10-13 13:13:34.246314
76	51111	75	f	2022-10-13 13:13:34.246314
77	51111	76	f	2022-10-13 13:13:34.246314
78	51111	77	f	2022-10-13 13:13:34.246314
79	51111	78	f	2022-10-13 13:13:34.246314
80	51111	79	f	2022-10-13 13:13:34.246314
81	51111	80	f	2022-10-13 13:13:34.246314
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
1	FRIEND_REQUEST	51111	1	1	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
2	FRIEND_REQUEST	51111	2	2	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
3	FRIEND_REQUEST	51111	3	3	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
4	FRIEND_REQUEST	51111	4	4	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
5	FRIEND_REQUEST	51111	5	5	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
6	FRIEND_REQUEST	51111	6	6	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
7	FRIEND_REQUEST	51111	7	7	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
8	FRIEND_REQUEST	51111	8	8	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
9	FRIEND_REQUEST	51111	9	9	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
10	FRIEND_REQUEST	51111	10	10	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
11	FRIEND_REQUEST	51111	11	11	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
12	FRIEND_REQUEST	51111	12	12	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
13	FRIEND_REQUEST	51111	13	13	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
14	FRIEND_REQUEST	51111	14	14	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
15	FRIEND_REQUEST	51111	15	15	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
16	FRIEND_REQUEST	51111	16	16	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
17	FRIEND_REQUEST	51111	17	17	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
18	FRIEND_REQUEST	51111	18	18	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
19	FRIEND_REQUEST	51111	19	19	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
20	FRIEND_REQUEST	51111	20	20	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
21	FRIEND_REQUEST	51111	21	21	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
22	FRIEND_REQUEST	51111	22	22	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
23	FRIEND_REQUEST	51111	23	23	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
24	FRIEND_REQUEST	51111	24	24	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
25	FRIEND_REQUEST	51111	25	25	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
26	FRIEND_REQUEST	51111	26	26	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
27	FRIEND_REQUEST	51111	27	27	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
28	FRIEND_REQUEST	51111	28	28	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
29	FRIEND_REQUEST	51111	29	29	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
30	FRIEND_REQUEST	51111	30	30	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
31	FRIEND_REQUEST	51111	31	31	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
32	FRIEND_REQUEST	51111	32	32	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
33	FRIEND_REQUEST	51111	33	33	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
34	FRIEND_REQUEST	51111	34	34	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
35	FRIEND_REQUEST	51111	35	35	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
36	FRIEND_REQUEST	51111	36	36	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
37	FRIEND_REQUEST	51111	37	37	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
38	FRIEND_REQUEST	51111	38	38	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
39	FRIEND_REQUEST	51111	39	39	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
40	FRIEND_REQUEST	51111	40	40	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
41	FRIEND_REQUEST	51111	41	41	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
42	FRIEND_REQUEST	51111	42	42	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
43	FRIEND_REQUEST	51111	43	43	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
44	FRIEND_REQUEST	51111	44	44	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
45	FRIEND_REQUEST	51111	45	45	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
46	FRIEND_REQUEST	51111	46	46	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
47	FRIEND_REQUEST	51111	47	47	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
48	FRIEND_REQUEST	51111	48	48	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
49	FRIEND_REQUEST	51111	49	49	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
50	FRIEND_REQUEST	51111	50	50	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
51	FRIEND_REQUEST	51111	51	51	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
52	FRIEND_REQUEST	51111	52	52	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
53	FRIEND_REQUEST	51111	53	53	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
54	FRIEND_REQUEST	51111	54	54	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
55	FRIEND_REQUEST	51111	55	55	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
56	FRIEND_REQUEST	51111	56	56	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
57	FRIEND_REQUEST	51111	57	57	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
58	FRIEND_REQUEST	51111	58	58	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
59	FRIEND_REQUEST	51111	59	59	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
60	FRIEND_REQUEST	51111	60	60	send you friend request	f	2022-10-13 13:13:34.247584	2022-10-13 13:13:34.247584
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.players (id, userid, gameid, score) FROM stdin;
1	1	1	2
2	2	2	3
3	3	3	0
4	4	4	0
5	5	5	3
6	6	6	3
7	7	7	1
8	8	8	2
9	9	9	0
10	10	10	0
11	11	11	3
12	12	12	3
13	13	13	2
14	14	14	1
15	15	15	0
16	16	16	0
17	17	17	1
18	18	18	1
19	19	19	3
20	20	20	2
21	21	21	2
22	22	22	0
23	23	23	3
24	24	24	2
25	25	25	0
26	26	26	2
27	27	27	2
28	28	28	1
29	29	29	1
30	30	30	1
31	31	31	2
32	32	32	2
33	33	33	2
34	34	34	3
35	35	35	2
36	36	36	2
37	37	37	0
38	38	38	1
39	39	39	0
40	40	40	1
41	41	41	3
42	42	42	2
43	43	43	1
44	44	44	3
45	45	45	0
46	46	46	0
47	47	47	3
48	48	48	3
49	49	49	0
50	50	50	0
51	51111	1	3
52	51111	2	0
53	51111	3	3
54	51111	4	3
55	51111	5	4
56	51111	6	1
57	51111	7	3
58	51111	8	1
59	51111	9	3
60	51111	10	1
61	51111	11	3
62	51111	12	2
63	51111	13	0
64	51111	14	2
65	51111	15	1
66	51111	16	1
67	51111	17	1
68	51111	18	0
69	51111	19	0
70	51111	20	4
71	51111	21	4
72	51111	22	4
73	51111	23	2
74	51111	24	4
75	51111	25	4
76	51111	26	4
77	51111	27	2
78	51111	28	4
79	51111	29	2
80	51111	30	0
81	51111	31	4
82	51111	32	4
83	51111	33	4
84	51111	34	0
85	51111	35	2
86	51111	36	4
87	51111	37	1
88	51111	38	1
89	51111	39	0
90	51111	40	0
91	51111	41	4
92	51111	42	3
93	51111	43	0
94	51111	44	3
95	51111	45	2
96	51111	46	1
97	51111	47	1
98	51111	48	3
99	51111	49	1
100	51111	50	2
101	51	51	0
102	52	52	1
103	53	53	3
104	54	54	1
105	55	55	0
106	56	56	0
107	57	57	1
108	58	58	1
109	59	59	2
110	60	60	3
111	61	61	2
112	62	62	1
113	63	63	1
114	64	64	0
115	65	65	2
116	66	66	2
117	67	67	0
118	68	68	2
119	69	69	0
120	70	70	1
121	71	71	3
122	72	72	3
123	73	73	2
124	74	74	0
125	75	75	1
126	76	76	0
127	77	77	2
128	78	78	3
129	79	79	0
130	80	80	1
131	81	81	0
132	82	82	1
133	83	83	1
134	84	84	3
135	85	85	3
136	86	86	0
137	87	87	2
138	88	88	3
139	89	89	3
140	90	90	1
141	91	91	1
142	92	92	2
143	93	93	1
144	94	94	1
145	95	95	3
146	96	96	2
147	97	97	0
148	98	98	3
149	99	99	2
150	100	100	3
151	101	101	3
152	101	51	0
153	102	52	3
154	103	53	3
155	104	54	0
156	105	55	2
157	106	56	3
158	107	57	3
159	108	58	2
160	109	59	3
161	110	60	2
162	111	61	3
163	112	62	0
164	113	63	3
165	114	64	1
166	115	65	3
167	116	66	2
168	117	67	2
169	118	68	3
170	119	69	3
171	120	70	3
172	121	71	2
173	122	72	2
174	123	73	3
175	124	74	2
176	125	75	2
177	126	76	1
178	127	77	2
179	128	78	0
180	129	79	2
181	130	80	1
182	131	81	2
183	132	82	2
184	133	83	0
185	134	84	3
186	135	85	2
187	136	86	1
188	137	87	1
189	138	88	2
190	139	89	2
191	140	90	0
192	141	91	1
193	142	92	1
194	143	93	2
195	144	94	2
196	145	95	1
197	146	96	0
198	147	97	1
199	148	98	0
200	149	99	2
201	150	100	3
202	151	101	0
203	51111	102	0
204	3	102	0
205	51111	103	0
206	3	103	0
207	51111	104	0
208	3	104	0
209	51111	105	0
210	1	105	0
211	51111	106	0
212	2	106	0
213	2	107	0
214	51111	107	0
215	2	108	0
216	51111	108	0
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, status, xp, img_url, cover, created_at, updated_at) FROM stdin;
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	OFFLINE	3071	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.161644	2022-10-13 13:13:34.161644
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	5977	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	OFFLINE	1775	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	OFFLINE	7134	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	3654	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	OFFLINE	5229	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	OFFLINE	7834	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	6357	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	OFFLINE	3545	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	OFFLINE	5261	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	OFFLINE	2395	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	OFFLINE	5976	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	3970	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	OFFLINE	5835	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	OFFLINE	3559	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	OFFLINE	5369	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	OFFLINE	4844	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	OFFLINE	4493	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	OFFLINE	5285	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	OFFLINE	5590	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	OFFLINE	21	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	OFFLINE	4261	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	3394	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	OFFLINE	4257	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	4154	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	OFFLINE	4023	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	OFFLINE	2819	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	OFFLINE	148	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	OFFLINE	3180	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	OFFLINE	4212	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	OFFLINE	5102	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
32	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	OFFLINE	7567	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
33	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	7594	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
34	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	OFFLINE	2023	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
35	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	1801	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
36	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	6688	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
37	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	7243	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
38	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	OFFLINE	1244	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
39	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	OFFLINE	5119	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
40	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	OFFLINE	6661	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
41	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	OFFLINE	2420	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
42	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	OFFLINE	6430	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
43	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	4994	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
44	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	OFFLINE	4550	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
45	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	OFFLINE	5560	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
46	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	OFFLINE	6531	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
47	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	5211	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
48	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	6402	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
49	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	OFFLINE	2897	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
50	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	OFFLINE	2900	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
51	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	OFFLINE	3377	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
52	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	OFFLINE	1595	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
53	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	OFFLINE	7128	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
54	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	OFFLINE	5159	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
55	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	OFFLINE	4118	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
56	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	6408	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
57	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	988	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
58	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	4576	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
59	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	1465	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
60	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	OFFLINE	3553	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
61	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	OFFLINE	2856	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
62	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	1942	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
63	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	4709	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
64	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	OFFLINE	693	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
65	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	OFFLINE	7841	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
66	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	1662	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
67	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	OFFLINE	3948	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
68	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	107	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
69	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	OFFLINE	2870	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
70	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	OFFLINE	546	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
71	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	OFFLINE	1164	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
72	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	OFFLINE	6368	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
73	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	OFFLINE	6919	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
74	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	OFFLINE	4184	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
75	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	19	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
76	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	OFFLINE	7755	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
77	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	OFFLINE	7673	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
78	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	OFFLINE	5719	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
79	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	OFFLINE	2973	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
80	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	OFFLINE	165	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
81	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	OFFLINE	2633	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
82	81	alizaynoune81	zaynoune81@ali.ali	ali	zaynoune	OFFLINE	5985	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
83	82	alizaynoune82	zaynoune82@ali.ali	ali	zaynoune	OFFLINE	4142	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
84	83	alizaynoune83	zaynoune83@ali.ali	ali	zaynoune	OFFLINE	5264	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
85	84	alizaynoune84	zaynoune84@ali.ali	ali	zaynoune	OFFLINE	2177	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
86	85	alizaynoune85	zaynoune85@ali.ali	ali	zaynoune	OFFLINE	5753	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
87	86	alizaynoune86	zaynoune86@ali.ali	ali	zaynoune	OFFLINE	3039	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
88	87	alizaynoune87	zaynoune87@ali.ali	ali	zaynoune	OFFLINE	6918	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
89	88	alizaynoune88	zaynoune88@ali.ali	ali	zaynoune	OFFLINE	7698	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
90	89	alizaynoune89	zaynoune89@ali.ali	ali	zaynoune	OFFLINE	7936	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
91	90	alizaynoune90	zaynoune90@ali.ali	ali	zaynoune	OFFLINE	4657	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
92	91	alizaynoune91	zaynoune91@ali.ali	ali	zaynoune	OFFLINE	6456	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
93	92	alizaynoune92	zaynoune92@ali.ali	ali	zaynoune	OFFLINE	4075	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
94	93	alizaynoune93	zaynoune93@ali.ali	ali	zaynoune	OFFLINE	6799	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
95	94	alizaynoune94	zaynoune94@ali.ali	ali	zaynoune	OFFLINE	5938	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
96	95	alizaynoune95	zaynoune95@ali.ali	ali	zaynoune	OFFLINE	6713	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
97	96	alizaynoune96	zaynoune96@ali.ali	ali	zaynoune	OFFLINE	7992	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
98	97	alizaynoune97	zaynoune97@ali.ali	ali	zaynoune	OFFLINE	7490	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
99	98	alizaynoune98	zaynoune98@ali.ali	ali	zaynoune	OFFLINE	2486	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
100	99	alizaynoune99	zaynoune99@ali.ali	ali	zaynoune	OFFLINE	1347	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
101	100	alizaynoune100	zaynoune100@ali.ali	ali	zaynoune	OFFLINE	703	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
102	101	alizaynoune101	zaynoune101@ali.ali	ali	zaynoune	OFFLINE	487	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
103	102	alizaynoune102	zaynoune102@ali.ali	ali	zaynoune	OFFLINE	7390	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
104	103	alizaynoune103	zaynoune103@ali.ali	ali	zaynoune	OFFLINE	7286	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
105	104	alizaynoune104	zaynoune104@ali.ali	ali	zaynoune	OFFLINE	3506	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
106	105	alizaynoune105	zaynoune105@ali.ali	ali	zaynoune	OFFLINE	2116	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
107	106	alizaynoune106	zaynoune106@ali.ali	ali	zaynoune	OFFLINE	7351	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
108	107	alizaynoune107	zaynoune107@ali.ali	ali	zaynoune	OFFLINE	4090	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
109	108	alizaynoune108	zaynoune108@ali.ali	ali	zaynoune	OFFLINE	7497	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
110	109	alizaynoune109	zaynoune109@ali.ali	ali	zaynoune	OFFLINE	3314	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
111	110	alizaynoune110	zaynoune110@ali.ali	ali	zaynoune	OFFLINE	5259	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
112	111	alizaynoune111	zaynoune111@ali.ali	ali	zaynoune	OFFLINE	5354	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
113	112	alizaynoune112	zaynoune112@ali.ali	ali	zaynoune	OFFLINE	4062	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
114	113	alizaynoune113	zaynoune113@ali.ali	ali	zaynoune	OFFLINE	5842	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
115	114	alizaynoune114	zaynoune114@ali.ali	ali	zaynoune	OFFLINE	2283	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
116	115	alizaynoune115	zaynoune115@ali.ali	ali	zaynoune	OFFLINE	6919	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
117	116	alizaynoune116	zaynoune116@ali.ali	ali	zaynoune	OFFLINE	4338	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
118	117	alizaynoune117	zaynoune117@ali.ali	ali	zaynoune	OFFLINE	2559	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
119	118	alizaynoune118	zaynoune118@ali.ali	ali	zaynoune	OFFLINE	5898	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
120	119	alizaynoune119	zaynoune119@ali.ali	ali	zaynoune	OFFLINE	2894	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
121	120	alizaynoune120	zaynoune120@ali.ali	ali	zaynoune	OFFLINE	6786	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
122	121	alizaynoune121	zaynoune121@ali.ali	ali	zaynoune	OFFLINE	1007	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
123	122	alizaynoune122	zaynoune122@ali.ali	ali	zaynoune	OFFLINE	857	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
124	123	alizaynoune123	zaynoune123@ali.ali	ali	zaynoune	OFFLINE	5282	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
125	124	alizaynoune124	zaynoune124@ali.ali	ali	zaynoune	OFFLINE	1536	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
126	125	alizaynoune125	zaynoune125@ali.ali	ali	zaynoune	OFFLINE	3029	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
127	126	alizaynoune126	zaynoune126@ali.ali	ali	zaynoune	OFFLINE	7428	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
128	127	alizaynoune127	zaynoune127@ali.ali	ali	zaynoune	OFFLINE	13	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
129	128	alizaynoune128	zaynoune128@ali.ali	ali	zaynoune	OFFLINE	2888	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
130	129	alizaynoune129	zaynoune129@ali.ali	ali	zaynoune	OFFLINE	1536	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
131	130	alizaynoune130	zaynoune130@ali.ali	ali	zaynoune	OFFLINE	5438	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
132	131	alizaynoune131	zaynoune131@ali.ali	ali	zaynoune	OFFLINE	6547	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
133	132	alizaynoune132	zaynoune132@ali.ali	ali	zaynoune	OFFLINE	2877	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
134	133	alizaynoune133	zaynoune133@ali.ali	ali	zaynoune	OFFLINE	7730	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
135	134	alizaynoune134	zaynoune134@ali.ali	ali	zaynoune	OFFLINE	5531	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
136	135	alizaynoune135	zaynoune135@ali.ali	ali	zaynoune	OFFLINE	2883	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
137	136	alizaynoune136	zaynoune136@ali.ali	ali	zaynoune	OFFLINE	2138	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
138	137	alizaynoune137	zaynoune137@ali.ali	ali	zaynoune	OFFLINE	5418	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
139	138	alizaynoune138	zaynoune138@ali.ali	ali	zaynoune	OFFLINE	885	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
140	139	alizaynoune139	zaynoune139@ali.ali	ali	zaynoune	OFFLINE	7166	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
141	140	alizaynoune140	zaynoune140@ali.ali	ali	zaynoune	OFFLINE	1132	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
142	141	alizaynoune141	zaynoune141@ali.ali	ali	zaynoune	OFFLINE	3577	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
143	142	alizaynoune142	zaynoune142@ali.ali	ali	zaynoune	OFFLINE	1610	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
144	143	alizaynoune143	zaynoune143@ali.ali	ali	zaynoune	OFFLINE	3321	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
145	144	alizaynoune144	zaynoune144@ali.ali	ali	zaynoune	OFFLINE	4481	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
146	145	alizaynoune145	zaynoune145@ali.ali	ali	zaynoune	OFFLINE	2772	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
147	146	alizaynoune146	zaynoune146@ali.ali	ali	zaynoune	OFFLINE	6531	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
148	147	alizaynoune147	zaynoune147@ali.ali	ali	zaynoune	OFFLINE	890	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
149	148	alizaynoune148	zaynoune148@ali.ali	ali	zaynoune	OFFLINE	1593	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
150	149	alizaynoune149	zaynoune149@ali.ali	ali	zaynoune	OFFLINE	4574	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
151	150	alizaynoune150	zaynoune150@ali.ali	ali	zaynoune	OFFLINE	5664	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
152	151	alizaynoune151	zaynoune151@ali.ali	ali	zaynoune	OFFLINE	5962	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
153	152	alizaynoune152	zaynoune152@ali.ali	ali	zaynoune	OFFLINE	5562	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
154	153	alizaynoune153	zaynoune153@ali.ali	ali	zaynoune	OFFLINE	5767	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
155	154	alizaynoune154	zaynoune154@ali.ali	ali	zaynoune	OFFLINE	3883	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
156	155	alizaynoune155	zaynoune155@ali.ali	ali	zaynoune	OFFLINE	3636	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
157	156	alizaynoune156	zaynoune156@ali.ali	ali	zaynoune	OFFLINE	5670	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
158	157	alizaynoune157	zaynoune157@ali.ali	ali	zaynoune	OFFLINE	1415	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
159	158	alizaynoune158	zaynoune158@ali.ali	ali	zaynoune	OFFLINE	4992	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
160	159	alizaynoune159	zaynoune159@ali.ali	ali	zaynoune	OFFLINE	3551	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
161	160	alizaynoune160	zaynoune160@ali.ali	ali	zaynoune	OFFLINE	506	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
162	161	alizaynoune161	zaynoune161@ali.ali	ali	zaynoune	OFFLINE	5847	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
163	162	alizaynoune162	zaynoune162@ali.ali	ali	zaynoune	OFFLINE	2390	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
164	163	alizaynoune163	zaynoune163@ali.ali	ali	zaynoune	OFFLINE	780	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
165	164	alizaynoune164	zaynoune164@ali.ali	ali	zaynoune	OFFLINE	3259	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
166	165	alizaynoune165	zaynoune165@ali.ali	ali	zaynoune	OFFLINE	6250	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
167	166	alizaynoune166	zaynoune166@ali.ali	ali	zaynoune	OFFLINE	6849	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
168	167	alizaynoune167	zaynoune167@ali.ali	ali	zaynoune	OFFLINE	2739	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
169	168	alizaynoune168	zaynoune168@ali.ali	ali	zaynoune	OFFLINE	4097	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
170	169	alizaynoune169	zaynoune169@ali.ali	ali	zaynoune	OFFLINE	2120	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
171	170	alizaynoune170	zaynoune170@ali.ali	ali	zaynoune	OFFLINE	729	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
172	171	alizaynoune171	zaynoune171@ali.ali	ali	zaynoune	OFFLINE	186	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
173	172	alizaynoune172	zaynoune172@ali.ali	ali	zaynoune	OFFLINE	7549	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
174	173	alizaynoune173	zaynoune173@ali.ali	ali	zaynoune	OFFLINE	401	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
175	174	alizaynoune174	zaynoune174@ali.ali	ali	zaynoune	OFFLINE	6422	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
176	175	alizaynoune175	zaynoune175@ali.ali	ali	zaynoune	OFFLINE	5883	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
177	176	alizaynoune176	zaynoune176@ali.ali	ali	zaynoune	OFFLINE	7619	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
178	177	alizaynoune177	zaynoune177@ali.ali	ali	zaynoune	OFFLINE	6438	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
179	178	alizaynoune178	zaynoune178@ali.ali	ali	zaynoune	OFFLINE	2475	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
180	179	alizaynoune179	zaynoune179@ali.ali	ali	zaynoune	OFFLINE	970	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
181	180	alizaynoune180	zaynoune180@ali.ali	ali	zaynoune	OFFLINE	3137	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
182	181	alizaynoune181	zaynoune181@ali.ali	ali	zaynoune	OFFLINE	3105	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
183	182	alizaynoune182	zaynoune182@ali.ali	ali	zaynoune	OFFLINE	1019	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
184	183	alizaynoune183	zaynoune183@ali.ali	ali	zaynoune	OFFLINE	2687	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
185	184	alizaynoune184	zaynoune184@ali.ali	ali	zaynoune	OFFLINE	6869	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
186	185	alizaynoune185	zaynoune185@ali.ali	ali	zaynoune	OFFLINE	7588	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
187	186	alizaynoune186	zaynoune186@ali.ali	ali	zaynoune	OFFLINE	621	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
188	187	alizaynoune187	zaynoune187@ali.ali	ali	zaynoune	OFFLINE	7980	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
189	188	alizaynoune188	zaynoune188@ali.ali	ali	zaynoune	OFFLINE	7732	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
190	189	alizaynoune189	zaynoune189@ali.ali	ali	zaynoune	OFFLINE	890	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
191	190	alizaynoune190	zaynoune190@ali.ali	ali	zaynoune	OFFLINE	7114	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
192	191	alizaynoune191	zaynoune191@ali.ali	ali	zaynoune	OFFLINE	7121	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
193	192	alizaynoune192	zaynoune192@ali.ali	ali	zaynoune	OFFLINE	2496	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
194	193	alizaynoune193	zaynoune193@ali.ali	ali	zaynoune	OFFLINE	5218	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
195	194	alizaynoune194	zaynoune194@ali.ali	ali	zaynoune	OFFLINE	3333	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
196	195	alizaynoune195	zaynoune195@ali.ali	ali	zaynoune	OFFLINE	3208	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
197	196	alizaynoune196	zaynoune196@ali.ali	ali	zaynoune	OFFLINE	5478	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
198	197	alizaynoune197	zaynoune197@ali.ali	ali	zaynoune	OFFLINE	5996	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
199	198	alizaynoune198	zaynoune198@ali.ali	ali	zaynoune	OFFLINE	6892	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
200	199	alizaynoune199	zaynoune199@ali.ali	ali	zaynoune	OFFLINE	5916	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
201	200	alizaynoune200	zaynoune200@ali.ali	ali	zaynoune	OFFLINE	595	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-13 13:13:34.178326	2022-10-13 13:13:34.178326
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, createdat) FROM stdin;
1	51111	2	2022-10-13 13:13:34.187235
2	51111	4	2022-10-13 13:13:34.187235
3	51111	6	2022-10-13 13:13:34.187235
4	51111	8	2022-10-13 13:13:34.187235
5	51111	10	2022-10-13 13:13:34.187235
6	51111	12	2022-10-13 13:13:34.187235
7	51111	14	2022-10-13 13:13:34.187235
8	51111	16	2022-10-13 13:13:34.187235
9	51111	18	2022-10-13 13:13:34.187235
10	51111	20	2022-10-13 13:13:34.187235
11	1	1	2022-10-13 13:13:34.205288
12	2	2	2022-10-13 13:13:34.205288
13	3	3	2022-10-13 13:13:34.205288
14	4	4	2022-10-13 13:13:34.205288
15	5	5	2022-10-13 13:13:34.205288
16	6	6	2022-10-13 13:13:34.205288
17	7	7	2022-10-13 13:13:34.205288
18	8	8	2022-10-13 13:13:34.205288
19	9	9	2022-10-13 13:13:34.205288
20	10	10	2022-10-13 13:13:34.205288
21	11	11	2022-10-13 13:13:34.205288
22	12	12	2022-10-13 13:13:34.205288
23	13	13	2022-10-13 13:13:34.205288
24	14	14	2022-10-13 13:13:34.205288
25	15	15	2022-10-13 13:13:34.205288
26	16	16	2022-10-13 13:13:34.205288
27	17	17	2022-10-13 13:13:34.205288
28	18	18	2022-10-13 13:13:34.205288
29	19	19	2022-10-13 13:13:34.205288
30	20	20	2022-10-13 13:13:34.205288
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

SELECT pg_catalog.setval('public.game_id_seq', 108, true);


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

SELECT pg_catalog.setval('public.players_id_seq', 216, true);


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

