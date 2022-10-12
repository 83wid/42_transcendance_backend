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
    score integer NOT NULL
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
1	END	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:35:32.209927
2	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:33:20.209927
3	WAITING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:35:33.209927
4	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:33:20.209927
5	WAITING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:42:42.209927
6	PLAYING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:37:03.209927
7	PLAYING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:37:37.209927
8	END	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:38:32.209927
9	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:35:50.209927
10	WAITING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:34:48.209927
11	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:40:09.209927
12	PLAYING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:38:06.209927
13	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:39:54.209927
14	WAITING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:30:40.209927
15	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:29:48.209927
16	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:39:18.209927
17	END	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:35:30.209927
18	END	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:35:29.209927
19	WAITING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:39:55.209927
20	WAITING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:33:26.209927
21	WAITING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:31:07.209927
22	WAITING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:38:39.209927
23	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:41:11.209927
24	END	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:39:22.209927
25	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:31:40.209927
26	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:39:33.209927
27	END	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:37:39.209927
28	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:30:54.209927
29	WAITING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:37:17.209927
30	WAITING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:42:35.209927
31	WAITING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:41:09.209927
32	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:39:59.209927
33	WAITING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:32:30.209927
34	PLAYING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:32:21.209927
35	END	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:31:58.209927
36	PLAYING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:34:52.209927
37	WAITING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:37:37.209927
38	END	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:39:41.209927
39	WAITING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:39:55.209927
40	END	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:38:58.209927
41	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:30:42.209927
42	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:31:40.209927
43	PLAYING	NORMAL	2022-10-12 16:29:38.209927	2022-10-12 16:34:40.209927
44	WAITING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:30:59.209927
45	END	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:42:39.209927
46	WAITING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:30:32.209927
47	PLAYING	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:38:39.209927
48	WAITING	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:33:38.209927
49	END	EASY	2022-10-12 16:29:38.209927	2022-10-12 16:37:29.209927
50	END	DIFFICULT	2022-10-12 16:29:38.209927	2022-10-12 16:30:14.209927
51	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:31:45.228578
52	PLAYING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:42:36.228578
53	PLAYING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:37:56.228578
54	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:41:03.228578
55	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:30:33.228578
56	END	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:38:49.228578
57	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:36:50.228578
58	PLAYING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:35:25.228578
59	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:34:09.228578
60	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:42:16.228578
61	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:33:47.228578
62	PLAYING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:37:42.228578
63	PLAYING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:38:16.228578
64	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:39:34.228578
65	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:37:12.228578
66	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:34:55.228578
67	PLAYING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:40:58.228578
68	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:37:06.228578
69	PLAYING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:39:07.228578
70	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:30:31.228578
71	PLAYING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:31:13.228578
72	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:40:52.228578
73	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:31:27.228578
74	END	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:37:54.228578
75	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:36:00.228578
76	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:41:42.228578
77	PLAYING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:36:08.228578
78	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:37:18.228578
79	END	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:37:50.228578
80	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:35:36.228578
81	WAITING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:34:22.228578
82	PLAYING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:30:10.228578
83	PLAYING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:38:46.228578
84	END	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:32:24.228578
85	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:36:13.228578
86	WAITING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:39:31.228578
87	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:41:07.228578
88	WAITING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:36:09.228578
89	PLAYING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:37:16.228578
90	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:32:54.228578
91	END	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:31:09.228578
92	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:34:52.228578
93	WAITING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:40:41.228578
94	END	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:33:08.228578
95	END	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:31:17.228578
96	END	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:34:23.228578
97	PLAYING	DIFFICULT	2022-10-12 16:29:38.228578	2022-10-12 16:41:09.228578
98	WAITING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:39:58.228578
99	WAITING	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:39:12.228578
100	WAITING	NORMAL	2022-10-12 16:29:38.228578	2022-10-12 16:37:21.228578
101	END	EASY	2022-10-12 16:29:38.228578	2022-10-12 16:38:58.228578
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
1	1	51111	f	2022-10-12 16:29:38.176477
2	2	51111	f	2022-10-12 16:29:38.176477
3	3	51111	f	2022-10-12 16:29:38.176477
4	4	51111	f	2022-10-12 16:29:38.176477
5	5	51111	f	2022-10-12 16:29:38.176477
6	6	51111	f	2022-10-12 16:29:38.176477
7	7	51111	f	2022-10-12 16:29:38.176477
8	8	51111	f	2022-10-12 16:29:38.176477
9	9	51111	f	2022-10-12 16:29:38.176477
10	10	51111	f	2022-10-12 16:29:38.176477
11	11	51111	f	2022-10-12 16:29:38.176477
12	12	51111	f	2022-10-12 16:29:38.176477
13	13	51111	f	2022-10-12 16:29:38.176477
14	14	51111	f	2022-10-12 16:29:38.176477
15	15	51111	f	2022-10-12 16:29:38.176477
16	16	51111	f	2022-10-12 16:29:38.176477
17	17	51111	f	2022-10-12 16:29:38.176477
18	18	51111	f	2022-10-12 16:29:38.176477
19	19	51111	f	2022-10-12 16:29:38.176477
20	20	51111	f	2022-10-12 16:29:38.176477
21	21	51111	f	2022-10-12 16:29:38.176477
22	22	51111	f	2022-10-12 16:29:38.176477
23	23	51111	f	2022-10-12 16:29:38.176477
24	24	51111	f	2022-10-12 16:29:38.176477
25	25	51111	f	2022-10-12 16:29:38.176477
26	26	51111	f	2022-10-12 16:29:38.176477
27	27	51111	f	2022-10-12 16:29:38.176477
28	28	51111	f	2022-10-12 16:29:38.176477
29	29	51111	f	2022-10-12 16:29:38.176477
30	30	51111	f	2022-10-12 16:29:38.176477
31	31	51111	f	2022-10-12 16:29:38.176477
32	32	51111	f	2022-10-12 16:29:38.176477
33	33	51111	f	2022-10-12 16:29:38.176477
34	34	51111	f	2022-10-12 16:29:38.176477
35	35	51111	f	2022-10-12 16:29:38.176477
36	36	51111	f	2022-10-12 16:29:38.176477
37	37	51111	f	2022-10-12 16:29:38.176477
38	38	51111	f	2022-10-12 16:29:38.176477
39	39	51111	f	2022-10-12 16:29:38.176477
40	40	51111	f	2022-10-12 16:29:38.176477
41	41	51111	f	2022-10-12 16:29:38.176477
42	42	51111	f	2022-10-12 16:29:38.176477
43	43	51111	f	2022-10-12 16:29:38.176477
44	44	51111	f	2022-10-12 16:29:38.176477
45	45	51111	f	2022-10-12 16:29:38.176477
46	46	51111	f	2022-10-12 16:29:38.176477
47	47	51111	f	2022-10-12 16:29:38.176477
48	48	51111	f	2022-10-12 16:29:38.176477
49	49	51111	f	2022-10-12 16:29:38.176477
50	50	51111	f	2022-10-12 16:29:38.176477
51	51	51111	f	2022-10-12 16:29:38.176477
52	52	51111	f	2022-10-12 16:29:38.176477
53	53	51111	f	2022-10-12 16:29:38.176477
54	54	51111	f	2022-10-12 16:29:38.176477
55	55	51111	f	2022-10-12 16:29:38.176477
56	56	51111	f	2022-10-12 16:29:38.176477
57	57	51111	f	2022-10-12 16:29:38.176477
58	58	51111	f	2022-10-12 16:29:38.176477
59	59	51111	f	2022-10-12 16:29:38.176477
60	60	51111	f	2022-10-12 16:29:38.176477
61	51111	60	f	2022-10-12 16:29:38.192745
62	51111	61	f	2022-10-12 16:29:38.192745
63	51111	62	f	2022-10-12 16:29:38.192745
64	51111	63	f	2022-10-12 16:29:38.192745
65	51111	64	f	2022-10-12 16:29:38.192745
66	51111	65	f	2022-10-12 16:29:38.192745
67	51111	66	f	2022-10-12 16:29:38.192745
68	51111	67	f	2022-10-12 16:29:38.192745
69	51111	68	f	2022-10-12 16:29:38.192745
70	51111	69	f	2022-10-12 16:29:38.192745
71	51111	70	f	2022-10-12 16:29:38.192745
72	51111	71	f	2022-10-12 16:29:38.192745
73	51111	72	f	2022-10-12 16:29:38.192745
74	51111	73	f	2022-10-12 16:29:38.192745
75	51111	74	f	2022-10-12 16:29:38.192745
76	51111	75	f	2022-10-12 16:29:38.192745
77	51111	76	f	2022-10-12 16:29:38.192745
78	51111	77	f	2022-10-12 16:29:38.192745
79	51111	78	f	2022-10-12 16:29:38.192745
80	51111	79	f	2022-10-12 16:29:38.192745
81	51111	80	f	2022-10-12 16:29:38.192745
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
1	FRIEND_REQUEST	51111	1	1	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
2	FRIEND_REQUEST	51111	2	2	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
3	FRIEND_REQUEST	51111	3	3	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
4	FRIEND_REQUEST	51111	4	4	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
5	FRIEND_REQUEST	51111	5	5	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
6	FRIEND_REQUEST	51111	6	6	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
7	FRIEND_REQUEST	51111	7	7	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
8	FRIEND_REQUEST	51111	8	8	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
9	FRIEND_REQUEST	51111	9	9	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
10	FRIEND_REQUEST	51111	10	10	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
11	FRIEND_REQUEST	51111	11	11	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
12	FRIEND_REQUEST	51111	12	12	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
13	FRIEND_REQUEST	51111	13	13	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
14	FRIEND_REQUEST	51111	14	14	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
15	FRIEND_REQUEST	51111	15	15	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
16	FRIEND_REQUEST	51111	16	16	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
17	FRIEND_REQUEST	51111	17	17	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
18	FRIEND_REQUEST	51111	18	18	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
19	FRIEND_REQUEST	51111	19	19	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
20	FRIEND_REQUEST	51111	20	20	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
21	FRIEND_REQUEST	51111	21	21	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
22	FRIEND_REQUEST	51111	22	22	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
23	FRIEND_REQUEST	51111	23	23	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
24	FRIEND_REQUEST	51111	24	24	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
25	FRIEND_REQUEST	51111	25	25	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
26	FRIEND_REQUEST	51111	26	26	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
27	FRIEND_REQUEST	51111	27	27	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
28	FRIEND_REQUEST	51111	28	28	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
29	FRIEND_REQUEST	51111	29	29	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
30	FRIEND_REQUEST	51111	30	30	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
31	FRIEND_REQUEST	51111	31	31	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
32	FRIEND_REQUEST	51111	32	32	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
33	FRIEND_REQUEST	51111	33	33	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
34	FRIEND_REQUEST	51111	34	34	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
35	FRIEND_REQUEST	51111	35	35	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
36	FRIEND_REQUEST	51111	36	36	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
37	FRIEND_REQUEST	51111	37	37	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
38	FRIEND_REQUEST	51111	38	38	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
39	FRIEND_REQUEST	51111	39	39	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
40	FRIEND_REQUEST	51111	40	40	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
41	FRIEND_REQUEST	51111	41	41	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
42	FRIEND_REQUEST	51111	42	42	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
43	FRIEND_REQUEST	51111	43	43	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
44	FRIEND_REQUEST	51111	44	44	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
45	FRIEND_REQUEST	51111	45	45	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
46	FRIEND_REQUEST	51111	46	46	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
47	FRIEND_REQUEST	51111	47	47	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
48	FRIEND_REQUEST	51111	48	48	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
49	FRIEND_REQUEST	51111	49	49	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
50	FRIEND_REQUEST	51111	50	50	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
51	FRIEND_REQUEST	51111	51	51	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
52	FRIEND_REQUEST	51111	52	52	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
53	FRIEND_REQUEST	51111	53	53	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
54	FRIEND_REQUEST	51111	54	54	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
55	FRIEND_REQUEST	51111	55	55	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
56	FRIEND_REQUEST	51111	56	56	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
57	FRIEND_REQUEST	51111	57	57	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
58	FRIEND_REQUEST	51111	58	58	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
59	FRIEND_REQUEST	51111	59	59	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
60	FRIEND_REQUEST	51111	60	60	send you friend request	f	2022-10-12 16:29:38.193786	2022-10-12 16:29:38.193786
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.players (id, userid, gameid, score) FROM stdin;
1	1	1	2
2	2	2	0
3	3	3	0
4	4	4	3
5	5	5	1
6	6	6	3
7	7	7	1
8	8	8	1
9	9	9	1
10	10	10	2
11	11	11	0
12	12	12	1
13	13	13	3
14	14	14	0
15	15	15	1
16	16	16	2
17	17	17	2
18	18	18	0
19	19	19	1
20	20	20	2
21	21	21	3
22	22	22	2
23	23	23	3
24	24	24	2
25	25	25	3
26	26	26	1
27	27	27	2
28	28	28	1
29	29	29	0
30	30	30	3
31	31	31	3
32	32	32	1
33	33	33	2
34	34	34	3
35	35	35	2
36	36	36	3
37	37	37	2
38	38	38	2
39	39	39	2
40	40	40	0
41	41	41	3
42	42	42	2
43	43	43	3
44	44	44	1
45	45	45	2
46	46	46	1
47	47	47	2
48	48	48	2
49	49	49	3
50	50	50	2
51	51111	1	0
52	51111	2	3
53	51111	3	1
54	51111	4	2
55	51111	5	0
56	51111	6	1
57	51111	7	4
58	51111	8	4
59	51111	9	3
60	51111	10	1
61	51111	11	1
62	51111	12	3
63	51111	13	3
64	51111	14	1
65	51111	15	3
66	51111	16	0
67	51111	17	2
68	51111	18	0
69	51111	19	1
70	51111	20	1
71	51111	21	1
72	51111	22	2
73	51111	23	4
74	51111	24	2
75	51111	25	0
76	51111	26	4
77	51111	27	3
78	51111	28	0
79	51111	29	4
80	51111	30	2
81	51111	31	2
82	51111	32	3
83	51111	33	1
84	51111	34	1
85	51111	35	4
86	51111	36	4
87	51111	37	3
88	51111	38	3
89	51111	39	1
90	51111	40	0
91	51111	41	4
92	51111	42	4
93	51111	43	0
94	51111	44	4
95	51111	45	0
96	51111	46	4
97	51111	47	1
98	51111	48	2
99	51111	49	2
100	51111	50	0
101	51	51	3
102	52	52	3
103	53	53	3
104	54	54	0
105	55	55	1
106	56	56	0
107	57	57	1
108	58	58	2
109	59	59	0
110	60	60	3
111	61	61	3
112	62	62	2
113	63	63	1
114	64	64	1
115	65	65	3
116	66	66	1
117	67	67	2
118	68	68	2
119	69	69	1
120	70	70	0
121	71	71	2
122	72	72	2
123	73	73	1
124	74	74	2
125	75	75	3
126	76	76	2
127	77	77	2
128	78	78	2
129	79	79	0
130	80	80	3
131	81	81	1
132	82	82	2
133	83	83	1
134	84	84	1
135	85	85	1
136	86	86	0
137	87	87	1
138	88	88	3
139	89	89	2
140	90	90	2
141	91	91	3
142	92	92	2
143	93	93	3
144	94	94	0
145	95	95	2
146	96	96	0
147	97	97	3
148	98	98	2
149	99	99	2
150	100	100	3
151	101	101	2
152	101	51	1
153	102	52	1
154	103	53	0
155	104	54	1
156	105	55	2
157	106	56	3
158	107	57	2
159	108	58	2
160	109	59	3
161	110	60	2
162	111	61	1
163	112	62	1
164	113	63	0
165	114	64	2
166	115	65	0
167	116	66	2
168	117	67	0
169	118	68	2
170	119	69	3
171	120	70	1
172	121	71	2
173	122	72	2
174	123	73	3
175	124	74	3
176	125	75	2
177	126	76	3
178	127	77	2
179	128	78	1
180	129	79	3
181	130	80	1
182	131	81	3
183	132	82	1
184	133	83	0
185	134	84	3
186	135	85	0
187	136	86	3
188	137	87	1
189	138	88	2
190	139	89	2
191	140	90	0
192	141	91	0
193	142	92	2
194	143	93	0
195	144	94	0
196	145	95	0
197	146	96	2
198	147	97	2
199	148	98	2
200	149	99	3
201	150	100	3
202	151	101	3
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, status, xp, img_url, cover, created_at, updated_at) FROM stdin;
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	OFFLINE	931	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.144987	2022-10-12 16:29:38.144987
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	284	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	OFFLINE	1824	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	OFFLINE	799	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	3650	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	OFFLINE	39	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	OFFLINE	2030	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	4384	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	OFFLINE	2582	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	OFFLINE	771	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	OFFLINE	4999	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	OFFLINE	3143	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	3501	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	OFFLINE	401	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	OFFLINE	4281	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	OFFLINE	2850	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	OFFLINE	2612	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	OFFLINE	7761	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	OFFLINE	4062	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	OFFLINE	2680	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	OFFLINE	1776	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	OFFLINE	3867	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	5178	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	OFFLINE	7079	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	2812	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	OFFLINE	6489	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	OFFLINE	5384	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	OFFLINE	2820	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	OFFLINE	4025	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	OFFLINE	6639	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	OFFLINE	7456	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
32	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	OFFLINE	1520	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
33	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	4517	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
34	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	OFFLINE	2940	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
35	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	7807	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
36	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	5356	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
37	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	2363	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
38	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	OFFLINE	1681	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
39	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	OFFLINE	7822	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
40	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	OFFLINE	728	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
41	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	OFFLINE	7532	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
42	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	OFFLINE	1119	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
43	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	5766	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
44	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	OFFLINE	5930	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
45	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	OFFLINE	5436	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
46	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	OFFLINE	4382	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
47	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	7483	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
48	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	1953	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
49	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	OFFLINE	7731	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
50	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	OFFLINE	6796	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
51	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	OFFLINE	5995	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
52	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	OFFLINE	3310	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
53	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	OFFLINE	386	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
54	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	OFFLINE	6927	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
55	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	OFFLINE	1384	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
56	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	3868	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
57	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	4046	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
58	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	1153	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
59	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	1188	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
60	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	OFFLINE	2430	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
61	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	OFFLINE	2493	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
62	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	5484	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
63	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	2897	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
64	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	OFFLINE	1995	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
65	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	OFFLINE	3663	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
66	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	7180	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
67	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	OFFLINE	7530	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
68	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	4888	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
69	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	OFFLINE	3720	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
70	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	OFFLINE	4893	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
71	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	OFFLINE	2903	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
72	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	OFFLINE	7240	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
73	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	OFFLINE	5432	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
74	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	OFFLINE	3411	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
75	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	3838	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
76	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	OFFLINE	628	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
77	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	OFFLINE	287	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
78	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	OFFLINE	2374	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
79	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	OFFLINE	7555	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
80	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	OFFLINE	108	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
81	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	OFFLINE	2016	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
82	81	alizaynoune81	zaynoune81@ali.ali	ali	zaynoune	OFFLINE	3478	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
83	82	alizaynoune82	zaynoune82@ali.ali	ali	zaynoune	OFFLINE	4041	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
84	83	alizaynoune83	zaynoune83@ali.ali	ali	zaynoune	OFFLINE	767	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
85	84	alizaynoune84	zaynoune84@ali.ali	ali	zaynoune	OFFLINE	1482	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
86	85	alizaynoune85	zaynoune85@ali.ali	ali	zaynoune	OFFLINE	803	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
87	86	alizaynoune86	zaynoune86@ali.ali	ali	zaynoune	OFFLINE	3748	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
88	87	alizaynoune87	zaynoune87@ali.ali	ali	zaynoune	OFFLINE	1545	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
89	88	alizaynoune88	zaynoune88@ali.ali	ali	zaynoune	OFFLINE	2977	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
90	89	alizaynoune89	zaynoune89@ali.ali	ali	zaynoune	OFFLINE	4213	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
91	90	alizaynoune90	zaynoune90@ali.ali	ali	zaynoune	OFFLINE	51	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
92	91	alizaynoune91	zaynoune91@ali.ali	ali	zaynoune	OFFLINE	54	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
93	92	alizaynoune92	zaynoune92@ali.ali	ali	zaynoune	OFFLINE	5257	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
94	93	alizaynoune93	zaynoune93@ali.ali	ali	zaynoune	OFFLINE	7472	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
95	94	alizaynoune94	zaynoune94@ali.ali	ali	zaynoune	OFFLINE	1179	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
96	95	alizaynoune95	zaynoune95@ali.ali	ali	zaynoune	OFFLINE	7971	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
97	96	alizaynoune96	zaynoune96@ali.ali	ali	zaynoune	OFFLINE	31	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
98	97	alizaynoune97	zaynoune97@ali.ali	ali	zaynoune	OFFLINE	5432	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
99	98	alizaynoune98	zaynoune98@ali.ali	ali	zaynoune	OFFLINE	610	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
100	99	alizaynoune99	zaynoune99@ali.ali	ali	zaynoune	OFFLINE	4185	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
101	100	alizaynoune100	zaynoune100@ali.ali	ali	zaynoune	OFFLINE	2781	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
102	101	alizaynoune101	zaynoune101@ali.ali	ali	zaynoune	OFFLINE	7792	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
103	102	alizaynoune102	zaynoune102@ali.ali	ali	zaynoune	OFFLINE	3081	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
104	103	alizaynoune103	zaynoune103@ali.ali	ali	zaynoune	OFFLINE	2972	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
105	104	alizaynoune104	zaynoune104@ali.ali	ali	zaynoune	OFFLINE	7883	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
106	105	alizaynoune105	zaynoune105@ali.ali	ali	zaynoune	OFFLINE	1246	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
107	106	alizaynoune106	zaynoune106@ali.ali	ali	zaynoune	OFFLINE	7477	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
108	107	alizaynoune107	zaynoune107@ali.ali	ali	zaynoune	OFFLINE	6237	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
109	108	alizaynoune108	zaynoune108@ali.ali	ali	zaynoune	OFFLINE	7956	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
110	109	alizaynoune109	zaynoune109@ali.ali	ali	zaynoune	OFFLINE	1223	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
111	110	alizaynoune110	zaynoune110@ali.ali	ali	zaynoune	OFFLINE	100	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
112	111	alizaynoune111	zaynoune111@ali.ali	ali	zaynoune	OFFLINE	5245	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
113	112	alizaynoune112	zaynoune112@ali.ali	ali	zaynoune	OFFLINE	3559	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
114	113	alizaynoune113	zaynoune113@ali.ali	ali	zaynoune	OFFLINE	7688	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
115	114	alizaynoune114	zaynoune114@ali.ali	ali	zaynoune	OFFLINE	1365	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
116	115	alizaynoune115	zaynoune115@ali.ali	ali	zaynoune	OFFLINE	7703	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
117	116	alizaynoune116	zaynoune116@ali.ali	ali	zaynoune	OFFLINE	3019	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
118	117	alizaynoune117	zaynoune117@ali.ali	ali	zaynoune	OFFLINE	4783	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
119	118	alizaynoune118	zaynoune118@ali.ali	ali	zaynoune	OFFLINE	7482	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
120	119	alizaynoune119	zaynoune119@ali.ali	ali	zaynoune	OFFLINE	5762	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
121	120	alizaynoune120	zaynoune120@ali.ali	ali	zaynoune	OFFLINE	1873	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
122	121	alizaynoune121	zaynoune121@ali.ali	ali	zaynoune	OFFLINE	652	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
123	122	alizaynoune122	zaynoune122@ali.ali	ali	zaynoune	OFFLINE	330	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
124	123	alizaynoune123	zaynoune123@ali.ali	ali	zaynoune	OFFLINE	5156	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
125	124	alizaynoune124	zaynoune124@ali.ali	ali	zaynoune	OFFLINE	3687	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
126	125	alizaynoune125	zaynoune125@ali.ali	ali	zaynoune	OFFLINE	3820	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
127	126	alizaynoune126	zaynoune126@ali.ali	ali	zaynoune	OFFLINE	6612	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
128	127	alizaynoune127	zaynoune127@ali.ali	ali	zaynoune	OFFLINE	6770	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
129	128	alizaynoune128	zaynoune128@ali.ali	ali	zaynoune	OFFLINE	4624	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
130	129	alizaynoune129	zaynoune129@ali.ali	ali	zaynoune	OFFLINE	3559	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
131	130	alizaynoune130	zaynoune130@ali.ali	ali	zaynoune	OFFLINE	2848	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
132	131	alizaynoune131	zaynoune131@ali.ali	ali	zaynoune	OFFLINE	7296	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
133	132	alizaynoune132	zaynoune132@ali.ali	ali	zaynoune	OFFLINE	918	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
134	133	alizaynoune133	zaynoune133@ali.ali	ali	zaynoune	OFFLINE	291	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
135	134	alizaynoune134	zaynoune134@ali.ali	ali	zaynoune	OFFLINE	141	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
136	135	alizaynoune135	zaynoune135@ali.ali	ali	zaynoune	OFFLINE	1111	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
137	136	alizaynoune136	zaynoune136@ali.ali	ali	zaynoune	OFFLINE	2378	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
138	137	alizaynoune137	zaynoune137@ali.ali	ali	zaynoune	OFFLINE	5878	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
139	138	alizaynoune138	zaynoune138@ali.ali	ali	zaynoune	OFFLINE	603	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
140	139	alizaynoune139	zaynoune139@ali.ali	ali	zaynoune	OFFLINE	1159	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
141	140	alizaynoune140	zaynoune140@ali.ali	ali	zaynoune	OFFLINE	3203	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
142	141	alizaynoune141	zaynoune141@ali.ali	ali	zaynoune	OFFLINE	7609	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
143	142	alizaynoune142	zaynoune142@ali.ali	ali	zaynoune	OFFLINE	5347	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
144	143	alizaynoune143	zaynoune143@ali.ali	ali	zaynoune	OFFLINE	6486	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
145	144	alizaynoune144	zaynoune144@ali.ali	ali	zaynoune	OFFLINE	6136	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
146	145	alizaynoune145	zaynoune145@ali.ali	ali	zaynoune	OFFLINE	7583	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
147	146	alizaynoune146	zaynoune146@ali.ali	ali	zaynoune	OFFLINE	2064	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
148	147	alizaynoune147	zaynoune147@ali.ali	ali	zaynoune	OFFLINE	6537	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
149	148	alizaynoune148	zaynoune148@ali.ali	ali	zaynoune	OFFLINE	7418	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
150	149	alizaynoune149	zaynoune149@ali.ali	ali	zaynoune	OFFLINE	4203	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
151	150	alizaynoune150	zaynoune150@ali.ali	ali	zaynoune	OFFLINE	5015	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
152	151	alizaynoune151	zaynoune151@ali.ali	ali	zaynoune	OFFLINE	3675	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
153	152	alizaynoune152	zaynoune152@ali.ali	ali	zaynoune	OFFLINE	1937	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
154	153	alizaynoune153	zaynoune153@ali.ali	ali	zaynoune	OFFLINE	6799	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
155	154	alizaynoune154	zaynoune154@ali.ali	ali	zaynoune	OFFLINE	3180	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
156	155	alizaynoune155	zaynoune155@ali.ali	ali	zaynoune	OFFLINE	117	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
157	156	alizaynoune156	zaynoune156@ali.ali	ali	zaynoune	OFFLINE	3596	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
158	157	alizaynoune157	zaynoune157@ali.ali	ali	zaynoune	OFFLINE	5239	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
159	158	alizaynoune158	zaynoune158@ali.ali	ali	zaynoune	OFFLINE	1076	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
160	159	alizaynoune159	zaynoune159@ali.ali	ali	zaynoune	OFFLINE	4347	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
161	160	alizaynoune160	zaynoune160@ali.ali	ali	zaynoune	OFFLINE	2406	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
162	161	alizaynoune161	zaynoune161@ali.ali	ali	zaynoune	OFFLINE	2359	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
163	162	alizaynoune162	zaynoune162@ali.ali	ali	zaynoune	OFFLINE	4125	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
164	163	alizaynoune163	zaynoune163@ali.ali	ali	zaynoune	OFFLINE	3676	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
165	164	alizaynoune164	zaynoune164@ali.ali	ali	zaynoune	OFFLINE	5604	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
166	165	alizaynoune165	zaynoune165@ali.ali	ali	zaynoune	OFFLINE	7543	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
167	166	alizaynoune166	zaynoune166@ali.ali	ali	zaynoune	OFFLINE	5368	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
168	167	alizaynoune167	zaynoune167@ali.ali	ali	zaynoune	OFFLINE	4974	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
169	168	alizaynoune168	zaynoune168@ali.ali	ali	zaynoune	OFFLINE	7491	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
170	169	alizaynoune169	zaynoune169@ali.ali	ali	zaynoune	OFFLINE	5668	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
171	170	alizaynoune170	zaynoune170@ali.ali	ali	zaynoune	OFFLINE	4733	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
172	171	alizaynoune171	zaynoune171@ali.ali	ali	zaynoune	OFFLINE	5608	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
173	172	alizaynoune172	zaynoune172@ali.ali	ali	zaynoune	OFFLINE	3546	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
174	173	alizaynoune173	zaynoune173@ali.ali	ali	zaynoune	OFFLINE	6561	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
175	174	alizaynoune174	zaynoune174@ali.ali	ali	zaynoune	OFFLINE	6331	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
176	175	alizaynoune175	zaynoune175@ali.ali	ali	zaynoune	OFFLINE	4526	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
177	176	alizaynoune176	zaynoune176@ali.ali	ali	zaynoune	OFFLINE	2120	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
178	177	alizaynoune177	zaynoune177@ali.ali	ali	zaynoune	OFFLINE	7234	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
179	178	alizaynoune178	zaynoune178@ali.ali	ali	zaynoune	OFFLINE	383	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
180	179	alizaynoune179	zaynoune179@ali.ali	ali	zaynoune	OFFLINE	6370	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
181	180	alizaynoune180	zaynoune180@ali.ali	ali	zaynoune	OFFLINE	6818	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
182	181	alizaynoune181	zaynoune181@ali.ali	ali	zaynoune	OFFLINE	277	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
183	182	alizaynoune182	zaynoune182@ali.ali	ali	zaynoune	OFFLINE	6088	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
184	183	alizaynoune183	zaynoune183@ali.ali	ali	zaynoune	OFFLINE	6958	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
185	184	alizaynoune184	zaynoune184@ali.ali	ali	zaynoune	OFFLINE	7203	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
186	185	alizaynoune185	zaynoune185@ali.ali	ali	zaynoune	OFFLINE	6412	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
187	186	alizaynoune186	zaynoune186@ali.ali	ali	zaynoune	OFFLINE	318	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
188	187	alizaynoune187	zaynoune187@ali.ali	ali	zaynoune	OFFLINE	1903	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
189	188	alizaynoune188	zaynoune188@ali.ali	ali	zaynoune	OFFLINE	5091	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
190	189	alizaynoune189	zaynoune189@ali.ali	ali	zaynoune	OFFLINE	3335	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
191	190	alizaynoune190	zaynoune190@ali.ali	ali	zaynoune	OFFLINE	1280	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
192	191	alizaynoune191	zaynoune191@ali.ali	ali	zaynoune	OFFLINE	3179	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
193	192	alizaynoune192	zaynoune192@ali.ali	ali	zaynoune	OFFLINE	6428	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
194	193	alizaynoune193	zaynoune193@ali.ali	ali	zaynoune	OFFLINE	4345	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
195	194	alizaynoune194	zaynoune194@ali.ali	ali	zaynoune	OFFLINE	1964	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
196	195	alizaynoune195	zaynoune195@ali.ali	ali	zaynoune	OFFLINE	871	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
197	196	alizaynoune196	zaynoune196@ali.ali	ali	zaynoune	OFFLINE	6116	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
198	197	alizaynoune197	zaynoune197@ali.ali	ali	zaynoune	OFFLINE	3166	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
199	198	alizaynoune198	zaynoune198@ali.ali	ali	zaynoune	OFFLINE	3208	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
200	199	alizaynoune199	zaynoune199@ali.ali	ali	zaynoune	OFFLINE	3040	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
201	200	alizaynoune200	zaynoune200@ali.ali	ali	zaynoune	OFFLINE	6477	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 16:29:38.155607	2022-10-12 16:29:38.155607
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, createdat) FROM stdin;
1	51111	2	2022-10-12 16:29:38.162128
2	51111	4	2022-10-12 16:29:38.162128
3	51111	6	2022-10-12 16:29:38.162128
4	51111	8	2022-10-12 16:29:38.162128
5	51111	10	2022-10-12 16:29:38.162128
6	51111	12	2022-10-12 16:29:38.162128
7	51111	14	2022-10-12 16:29:38.162128
8	51111	16	2022-10-12 16:29:38.162128
9	51111	18	2022-10-12 16:29:38.162128
10	51111	20	2022-10-12 16:29:38.162128
11	1	1	2022-10-12 16:29:38.17555
12	2	2	2022-10-12 16:29:38.17555
13	3	3	2022-10-12 16:29:38.17555
14	4	4	2022-10-12 16:29:38.17555
15	5	5	2022-10-12 16:29:38.17555
16	6	6	2022-10-12 16:29:38.17555
17	7	7	2022-10-12 16:29:38.17555
18	8	8	2022-10-12 16:29:38.17555
19	9	9	2022-10-12 16:29:38.17555
20	10	10	2022-10-12 16:29:38.17555
21	11	11	2022-10-12 16:29:38.17555
22	12	12	2022-10-12 16:29:38.17555
23	13	13	2022-10-12 16:29:38.17555
24	14	14	2022-10-12 16:29:38.17555
25	15	15	2022-10-12 16:29:38.17555
26	16	16	2022-10-12 16:29:38.17555
27	17	17	2022-10-12 16:29:38.17555
28	18	18	2022-10-12 16:29:38.17555
29	19	19	2022-10-12 16:29:38.17555
30	20	20	2022-10-12 16:29:38.17555
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

SELECT pg_catalog.setval('public.game_id_seq', 101, true);


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

SELECT pg_catalog.setval('public.players_id_seq', 202, true);


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

