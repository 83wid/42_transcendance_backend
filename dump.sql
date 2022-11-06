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
-- Name: achiev_name; Type: TYPE; Schema: public; Owner: nabouzah
--

CREATE TYPE public.achiev_name AS ENUM (
    'friendly',
    'legendary',
    'sharpshooter',
    'wildfire',
    'photogenic'
);


ALTER TYPE public.achiev_name OWNER TO nabouzah;

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

--
-- Name: update_conversation(); Type: FUNCTION; Schema: public; Owner: nabouzah
--

CREATE FUNCTION public.update_conversation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
UPDATE conversation
SET updated_at = now()
WHERE conversation.id = NEW.conversationId;
RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_conversation() OWNER TO nabouzah;

--
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: nabouzah
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN NEW.updated_at = now();
RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO nabouzah;

--
-- Name: update_user_xp(); Type: FUNCTION; Schema: public; Owner: nabouzah
--

CREATE FUNCTION public.update_user_xp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
UPDATE users
SET xp = users.xp + achievements.xp
FROM achievements
WHERE users.intra_id = NEW.userId
  AND achievements.name = NEW.achievementName
  AND achievements.level = NEW.achievementLevel;
RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_user_xp() OWNER TO nabouzah;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.achievements (
    id integer NOT NULL,
    name public.achiev_name NOT NULL,
    level public.level_type NOT NULL,
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
    title character varying(40),
    type public.conversation_type DEFAULT 'DIRECT'::public.conversation_type,
    active boolean DEFAULT true,
    public boolean DEFAULT false,
    password character varying(225),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
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
    started boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
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
-- Name: members; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.members (
    id integer NOT NULL,
    conversationid integer NOT NULL,
    userid integer NOT NULL,
    mute boolean DEFAULT false,
    active boolean DEFAULT true,
    blocked boolean DEFAULT false,
    endmute timestamp without time zone DEFAULT now(),
    isadmin boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.members OWNER TO nabouzah;

--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: nabouzah
--

CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.members_id_seq OWNER TO nabouzah;

--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nabouzah
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: message; Type: TABLE; Schema: public; Owner: nabouzah
--

CREATE TABLE public.message (
    id integer NOT NULL,
    message text,
    senderid integer NOT NULL,
    conversationid integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
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
    targetid integer DEFAULT 0,
    content text,
    read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
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
    score integer DEFAULT 0,
    ready boolean DEFAULT false
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
    userid integer NOT NULL,
    achievementname public.achiev_name NOT NULL,
    achievementlevel public.level_type NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users_achievements OWNER TO nabouzah;

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
-- Name: invites id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites ALTER COLUMN id SET DEFAULT nextval('public.invites_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


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
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.achievements (id, name, level, xp, description) FROM stdin;
1	friendly	SILVER	100	add 10 friends
2	friendly	BRONZE	200	add 20 friends
3	friendly	GOLD	500	add 50 friends
4	friendly	PLATINUM	1000	add 100 friends
5	legendary	SILVER	100	win 1 matche with a max score
6	legendary	BRONZE	250	win 2 matches with max a score
7	legendary	GOLD	350	win 3 matches with max a score
8	legendary	PLATINUM	500	win 4 matches with max a score
9	sharpshooter	SILVER	100	win 2 matches in one day
10	sharpshooter	BRONZE	250	win 3 matches in one day
11	sharpshooter	GOLD	350	win 4 matches in one day
12	sharpshooter	PLATINUM	500	win 5 matches in one day
13	wildfire	SILVER	500	play 5 matches in one day
14	wildfire	BRONZE	1400	play 10 matches in one day
15	wildfire	GOLD	2000	play 15 matches in one day
16	wildfire	PLATINUM	5000	play 20 matches in one day
17	photogenic	GOLD	100	change your avatar
18	photogenic	PLATINUM	100	change your cover
\.


--
-- Data for Name: blocked; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.blocked (id, userid, blockedid, created_at) FROM stdin;
\.


--
-- Data for Name: conversation; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.conversation (id, title, type, active, public, password, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.friends (id, userid, friendid, created_at) FROM stdin;
\.


--
-- Data for Name: game; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.game (id, status, level, started, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: gameinvites; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.gameinvites (id, userid, fromid, gameid, accepted) FROM stdin;
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.invites (id, senderid, receiverid, accepted, created_at) FROM stdin;
1	1	51111	f	2022-11-06 20:25:54.685567
2	2	51111	f	2022-11-06 20:25:54.685567
3	3	51111	f	2022-11-06 20:25:54.685567
4	4	51111	f	2022-11-06 20:25:54.685567
5	5	51111	f	2022-11-06 20:25:54.685567
6	6	51111	f	2022-11-06 20:25:54.685567
7	7	51111	f	2022-11-06 20:25:54.685567
8	8	51111	f	2022-11-06 20:25:54.685567
9	9	51111	f	2022-11-06 20:25:54.685567
10	10	51111	f	2022-11-06 20:25:54.685567
11	11	51111	f	2022-11-06 20:25:54.685567
12	12	51111	f	2022-11-06 20:25:54.685567
13	13	51111	f	2022-11-06 20:25:54.685567
14	14	51111	f	2022-11-06 20:25:54.685567
15	15	51111	f	2022-11-06 20:25:54.685567
16	16	51111	f	2022-11-06 20:25:54.685567
17	17	51111	f	2022-11-06 20:25:54.685567
18	18	51111	f	2022-11-06 20:25:54.685567
19	19	51111	f	2022-11-06 20:25:54.685567
20	20	51111	f	2022-11-06 20:25:54.685567
21	21	51111	f	2022-11-06 20:25:54.685567
22	22	51111	f	2022-11-06 20:25:54.685567
23	23	51111	f	2022-11-06 20:25:54.685567
24	24	51111	f	2022-11-06 20:25:54.685567
25	25	51111	f	2022-11-06 20:25:54.685567
26	26	51111	f	2022-11-06 20:25:54.685567
27	27	51111	f	2022-11-06 20:25:54.685567
28	28	51111	f	2022-11-06 20:25:54.685567
29	29	51111	f	2022-11-06 20:25:54.685567
30	30	51111	f	2022-11-06 20:25:54.685567
31	31	51111	f	2022-11-06 20:25:54.685567
32	32	51111	f	2022-11-06 20:25:54.685567
33	33	51111	f	2022-11-06 20:25:54.685567
34	34	51111	f	2022-11-06 20:25:54.685567
35	35	51111	f	2022-11-06 20:25:54.685567
36	36	51111	f	2022-11-06 20:25:54.685567
37	37	51111	f	2022-11-06 20:25:54.685567
38	38	51111	f	2022-11-06 20:25:54.685567
39	39	51111	f	2022-11-06 20:25:54.685567
40	40	51111	f	2022-11-06 20:25:54.685567
41	41	51111	f	2022-11-06 20:25:54.685567
42	42	51111	f	2022-11-06 20:25:54.685567
43	43	51111	f	2022-11-06 20:25:54.685567
44	44	51111	f	2022-11-06 20:25:54.685567
45	45	51111	f	2022-11-06 20:25:54.685567
46	46	51111	f	2022-11-06 20:25:54.685567
47	47	51111	f	2022-11-06 20:25:54.685567
48	48	51111	f	2022-11-06 20:25:54.685567
49	49	51111	f	2022-11-06 20:25:54.685567
50	50	51111	f	2022-11-06 20:25:54.685567
51	51	51111	f	2022-11-06 20:25:54.685567
52	52	51111	f	2022-11-06 20:25:54.685567
53	53	51111	f	2022-11-06 20:25:54.685567
54	54	51111	f	2022-11-06 20:25:54.685567
55	55	51111	f	2022-11-06 20:25:54.685567
56	56	51111	f	2022-11-06 20:25:54.685567
57	57	51111	f	2022-11-06 20:25:54.685567
58	58	51111	f	2022-11-06 20:25:54.685567
59	59	51111	f	2022-11-06 20:25:54.685567
60	60	51111	f	2022-11-06 20:25:54.685567
61	61	51111	f	2022-11-06 20:25:54.685567
62	62	51111	f	2022-11-06 20:25:54.685567
63	63	51111	f	2022-11-06 20:25:54.685567
64	64	51111	f	2022-11-06 20:25:54.685567
65	65	51111	f	2022-11-06 20:25:54.685567
66	66	51111	f	2022-11-06 20:25:54.685567
67	67	51111	f	2022-11-06 20:25:54.685567
68	68	51111	f	2022-11-06 20:25:54.685567
69	69	51111	f	2022-11-06 20:25:54.685567
70	70	51111	f	2022-11-06 20:25:54.685567
71	71	51111	f	2022-11-06 20:25:54.685567
72	72	51111	f	2022-11-06 20:25:54.685567
73	73	51111	f	2022-11-06 20:25:54.685567
74	74	51111	f	2022-11-06 20:25:54.685567
75	75	51111	f	2022-11-06 20:25:54.685567
76	76	51111	f	2022-11-06 20:25:54.685567
77	77	51111	f	2022-11-06 20:25:54.685567
78	78	51111	f	2022-11-06 20:25:54.685567
79	79	51111	f	2022-11-06 20:25:54.685567
80	80	51111	f	2022-11-06 20:25:54.685567
81	81	51111	f	2022-11-06 20:25:54.685567
82	82	51111	f	2022-11-06 20:25:54.685567
83	83	51111	f	2022-11-06 20:25:54.685567
84	84	51111	f	2022-11-06 20:25:54.685567
85	85	51111	f	2022-11-06 20:25:54.685567
86	86	51111	f	2022-11-06 20:25:54.685567
87	87	51111	f	2022-11-06 20:25:54.685567
88	88	51111	f	2022-11-06 20:25:54.685567
89	89	51111	f	2022-11-06 20:25:54.685567
90	90	51111	f	2022-11-06 20:25:54.685567
91	91	51111	f	2022-11-06 20:25:54.685567
92	92	51111	f	2022-11-06 20:25:54.685567
93	93	51111	f	2022-11-06 20:25:54.685567
94	94	51111	f	2022-11-06 20:25:54.685567
95	95	51111	f	2022-11-06 20:25:54.685567
96	96	51111	f	2022-11-06 20:25:54.685567
97	97	51111	f	2022-11-06 20:25:54.685567
98	98	51111	f	2022-11-06 20:25:54.685567
99	99	51111	f	2022-11-06 20:25:54.685567
100	100	51111	f	2022-11-06 20:25:54.685567
101	101	51111	f	2022-11-06 20:25:54.685567
102	102	51111	f	2022-11-06 20:25:54.685567
103	103	51111	f	2022-11-06 20:25:54.685567
104	104	51111	f	2022-11-06 20:25:54.685567
105	105	51111	f	2022-11-06 20:25:54.685567
106	106	51111	f	2022-11-06 20:25:54.685567
107	107	51111	f	2022-11-06 20:25:54.685567
108	108	51111	f	2022-11-06 20:25:54.685567
109	109	51111	f	2022-11-06 20:25:54.685567
110	110	51111	f	2022-11-06 20:25:54.685567
111	111	51111	f	2022-11-06 20:25:54.685567
112	112	51111	f	2022-11-06 20:25:54.685567
113	113	51111	f	2022-11-06 20:25:54.685567
114	114	51111	f	2022-11-06 20:25:54.685567
115	115	51111	f	2022-11-06 20:25:54.685567
116	116	51111	f	2022-11-06 20:25:54.685567
117	117	51111	f	2022-11-06 20:25:54.685567
118	118	51111	f	2022-11-06 20:25:54.685567
119	119	51111	f	2022-11-06 20:25:54.685567
120	120	51111	f	2022-11-06 20:25:54.685567
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.members (id, conversationid, userid, mute, active, blocked, endmute, isadmin, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.message (id, message, senderid, conversationid, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.notification (id, type, userid, fromid, targetid, content, read, created_at, updated_at) FROM stdin;
1	OTHER	51111	1	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
2	OTHER	51111	2	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
3	OTHER	51111	3	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
4	OTHER	51111	4	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
5	OTHER	51111	5	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
6	OTHER	51111	6	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
7	OTHER	51111	7	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
8	OTHER	51111	8	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
9	OTHER	51111	9	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
10	OTHER	51111	10	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
11	OTHER	51111	11	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
12	OTHER	51111	12	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
13	OTHER	51111	13	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
14	OTHER	51111	14	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
15	OTHER	51111	15	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
16	OTHER	51111	16	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
17	OTHER	51111	17	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
18	OTHER	51111	18	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
19	OTHER	51111	19	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
20	OTHER	51111	20	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
21	OTHER	51111	21	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
22	OTHER	51111	22	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
23	OTHER	51111	23	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
24	OTHER	51111	24	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
25	OTHER	51111	25	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
26	OTHER	51111	26	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
27	OTHER	51111	27	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
28	OTHER	51111	28	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
29	OTHER	51111	29	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
30	OTHER	51111	30	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
31	OTHER	51111	31	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
32	OTHER	51111	32	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
33	OTHER	51111	33	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
34	OTHER	51111	34	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
35	OTHER	51111	35	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
36	OTHER	51111	36	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
37	OTHER	51111	37	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
38	OTHER	51111	38	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
39	OTHER	51111	39	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
40	OTHER	51111	40	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
41	OTHER	51111	41	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
42	OTHER	51111	42	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
43	OTHER	51111	43	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
44	OTHER	51111	44	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
45	OTHER	51111	45	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
46	OTHER	51111	46	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
47	OTHER	51111	47	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
48	OTHER	51111	48	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
49	OTHER	51111	49	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
50	OTHER	51111	50	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
51	OTHER	51111	51	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
52	OTHER	51111	52	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
53	OTHER	51111	53	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
54	OTHER	51111	54	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
55	OTHER	51111	55	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
56	OTHER	51111	56	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
57	OTHER	51111	57	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
58	OTHER	51111	58	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
59	OTHER	51111	59	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
60	OTHER	51111	60	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
61	OTHER	51111	61	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
62	OTHER	51111	62	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
63	OTHER	51111	63	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
64	OTHER	51111	64	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
65	OTHER	51111	65	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
66	OTHER	51111	66	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
67	OTHER	51111	67	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
68	OTHER	51111	68	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
69	OTHER	51111	69	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
70	OTHER	51111	70	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
71	OTHER	51111	71	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
72	OTHER	51111	72	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
73	OTHER	51111	73	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
74	OTHER	51111	74	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
75	OTHER	51111	75	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
76	OTHER	51111	76	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
77	OTHER	51111	77	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
78	OTHER	51111	78	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
79	OTHER	51111	79	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
80	OTHER	51111	80	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
81	OTHER	51111	81	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
82	OTHER	51111	82	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
83	OTHER	51111	83	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
84	OTHER	51111	84	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
85	OTHER	51111	85	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
86	OTHER	51111	86	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
87	OTHER	51111	87	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
88	OTHER	51111	88	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
89	OTHER	51111	89	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
90	OTHER	51111	90	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
91	OTHER	51111	91	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
92	OTHER	51111	92	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
93	OTHER	51111	93	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
94	OTHER	51111	94	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
95	OTHER	51111	95	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
96	OTHER	51111	96	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
97	OTHER	51111	97	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
98	OTHER	51111	98	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
99	OTHER	51111	99	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
100	OTHER	51111	100	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
101	OTHER	51111	101	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
102	OTHER	51111	102	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
103	OTHER	51111	103	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
104	OTHER	51111	104	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
105	OTHER	51111	105	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
106	OTHER	51111	106	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
107	OTHER	51111	107	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
108	OTHER	51111	108	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
109	OTHER	51111	109	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
110	OTHER	51111	110	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
111	OTHER	51111	111	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
112	OTHER	51111	112	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
113	OTHER	51111	113	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
114	OTHER	51111	114	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
115	OTHER	51111	115	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
116	OTHER	51111	116	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
117	OTHER	51111	117	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
118	OTHER	51111	118	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
119	OTHER	51111	119	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
120	OTHER	51111	120	0	send you friend request	f	2022-11-06 20:25:54.693472	2022-11-06 20:25:54.693472
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.players (id, userid, gameid, score, ready) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, status, xp, img_url, cover, created_at, updated_at) FROM stdin;
1	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
2	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
3	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
4	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
5	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
6	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
7	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
8	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
9	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
10	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
11	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
12	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
13	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
14	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
15	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
16	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
17	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
18	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
19	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
20	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
21	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
22	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
23	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
24	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
25	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
26	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
27	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
28	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
29	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
30	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
31	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
32	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
33	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
34	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
35	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
36	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
37	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
38	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
39	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
40	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
41	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
42	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
43	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
44	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
45	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
46	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
47	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
48	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
49	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
50	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
51	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
52	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
53	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
54	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
55	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
56	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
57	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
58	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
59	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
60	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
61	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
62	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
63	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
64	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
65	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
66	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
67	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
68	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
69	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
70	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
71	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
72	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
73	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
74	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
75	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
76	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
77	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
78	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
79	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
80	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
81	81	alizaynoune81	zaynoune81@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
82	82	alizaynoune82	zaynoune82@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
83	83	alizaynoune83	zaynoune83@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
84	84	alizaynoune84	zaynoune84@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
85	85	alizaynoune85	zaynoune85@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
86	86	alizaynoune86	zaynoune86@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
87	87	alizaynoune87	zaynoune87@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
88	88	alizaynoune88	zaynoune88@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
89	89	alizaynoune89	zaynoune89@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
90	90	alizaynoune90	zaynoune90@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
91	91	alizaynoune91	zaynoune91@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
92	92	alizaynoune92	zaynoune92@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
93	93	alizaynoune93	zaynoune93@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
94	94	alizaynoune94	zaynoune94@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
95	95	alizaynoune95	zaynoune95@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
96	96	alizaynoune96	zaynoune96@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
97	97	alizaynoune97	zaynoune97@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
98	98	alizaynoune98	zaynoune98@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
99	99	alizaynoune99	zaynoune99@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
100	100	alizaynoune100	zaynoune100@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
101	101	alizaynoune101	zaynoune101@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
102	102	alizaynoune102	zaynoune102@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
103	103	alizaynoune103	zaynoune103@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
104	104	alizaynoune104	zaynoune104@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
105	105	alizaynoune105	zaynoune105@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
106	106	alizaynoune106	zaynoune106@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
107	107	alizaynoune107	zaynoune107@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
108	108	alizaynoune108	zaynoune108@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
109	109	alizaynoune109	zaynoune109@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
110	110	alizaynoune110	zaynoune110@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
111	111	alizaynoune111	zaynoune111@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
112	112	alizaynoune112	zaynoune112@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
113	113	alizaynoune113	zaynoune113@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
114	114	alizaynoune114	zaynoune114@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
115	115	alizaynoune115	zaynoune115@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
116	116	alizaynoune116	zaynoune116@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
117	117	alizaynoune117	zaynoune117@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
118	118	alizaynoune118	zaynoune118@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
119	119	alizaynoune119	zaynoune119@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
120	120	alizaynoune120	zaynoune120@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
121	121	alizaynoune121	zaynoune121@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
122	122	alizaynoune122	zaynoune122@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
123	123	alizaynoune123	zaynoune123@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
124	124	alizaynoune124	zaynoune124@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
125	125	alizaynoune125	zaynoune125@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
126	126	alizaynoune126	zaynoune126@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
127	127	alizaynoune127	zaynoune127@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
128	128	alizaynoune128	zaynoune128@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
129	129	alizaynoune129	zaynoune129@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
130	130	alizaynoune130	zaynoune130@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
131	131	alizaynoune131	zaynoune131@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
132	132	alizaynoune132	zaynoune132@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
133	133	alizaynoune133	zaynoune133@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
134	134	alizaynoune134	zaynoune134@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
135	135	alizaynoune135	zaynoune135@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
136	136	alizaynoune136	zaynoune136@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
137	137	alizaynoune137	zaynoune137@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
138	138	alizaynoune138	zaynoune138@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
139	139	alizaynoune139	zaynoune139@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
140	140	alizaynoune140	zaynoune140@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
141	141	alizaynoune141	zaynoune141@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
142	142	alizaynoune142	zaynoune142@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
143	143	alizaynoune143	zaynoune143@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
144	144	alizaynoune144	zaynoune144@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
145	145	alizaynoune145	zaynoune145@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
146	146	alizaynoune146	zaynoune146@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
147	147	alizaynoune147	zaynoune147@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
148	148	alizaynoune148	zaynoune148@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
149	149	alizaynoune149	zaynoune149@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
150	150	alizaynoune150	zaynoune150@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
151	151	alizaynoune151	zaynoune151@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
152	152	alizaynoune152	zaynoune152@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
153	153	alizaynoune153	zaynoune153@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
154	154	alizaynoune154	zaynoune154@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
155	155	alizaynoune155	zaynoune155@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
156	156	alizaynoune156	zaynoune156@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
157	157	alizaynoune157	zaynoune157@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
158	158	alizaynoune158	zaynoune158@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
159	159	alizaynoune159	zaynoune159@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
160	160	alizaynoune160	zaynoune160@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
161	161	alizaynoune161	zaynoune161@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
162	162	alizaynoune162	zaynoune162@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
163	163	alizaynoune163	zaynoune163@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
164	164	alizaynoune164	zaynoune164@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
165	165	alizaynoune165	zaynoune165@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
166	166	alizaynoune166	zaynoune166@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
167	167	alizaynoune167	zaynoune167@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
168	168	alizaynoune168	zaynoune168@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
169	169	alizaynoune169	zaynoune169@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
170	170	alizaynoune170	zaynoune170@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
171	171	alizaynoune171	zaynoune171@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
172	172	alizaynoune172	zaynoune172@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
173	173	alizaynoune173	zaynoune173@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
174	174	alizaynoune174	zaynoune174@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
175	175	alizaynoune175	zaynoune175@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
176	176	alizaynoune176	zaynoune176@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
177	177	alizaynoune177	zaynoune177@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
178	178	alizaynoune178	zaynoune178@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
179	179	alizaynoune179	zaynoune179@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
180	180	alizaynoune180	zaynoune180@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
181	181	alizaynoune181	zaynoune181@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
182	182	alizaynoune182	zaynoune182@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
183	183	alizaynoune183	zaynoune183@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
184	184	alizaynoune184	zaynoune184@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
185	185	alizaynoune185	zaynoune185@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
186	186	alizaynoune186	zaynoune186@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
187	187	alizaynoune187	zaynoune187@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
188	188	alizaynoune188	zaynoune188@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
189	189	alizaynoune189	zaynoune189@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
190	190	alizaynoune190	zaynoune190@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
191	191	alizaynoune191	zaynoune191@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
192	192	alizaynoune192	zaynoune192@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
193	193	alizaynoune193	zaynoune193@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
194	194	alizaynoune194	zaynoune194@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
195	195	alizaynoune195	zaynoune195@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
196	196	alizaynoune196	zaynoune196@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
197	197	alizaynoune197	zaynoune197@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
198	198	alizaynoune198	zaynoune198@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
199	199	alizaynoune199	zaynoune199@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
200	200	alizaynoune200	zaynoune200@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-06 20:25:54.676846	2022-11-06 20:25:54.676846
201	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	OFFLINE	0	https://cdn.intra.42.fr/users/alzaynou.jpg	\N	2022-11-06 20:25:54.684833	2022-11-06 20:25:54.684833
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (userid, achievementname, achievementlevel, created_at, updated_at) FROM stdin;
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.achievements_id_seq', 18, true);


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
-- Name: gameinvites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.gameinvites_id_seq', 1, false);


--
-- Name: invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.invites_id_seq', 120, true);


--
-- Name: members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.members_id_seq', 1, false);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.message_id_seq', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_id_seq', 120, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.players_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_id_seq', 201, true);


--
-- Name: achievements achievements_id_key; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_id_key UNIQUE (id);


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (name, level);


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
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: members members_id_key; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_id_key UNIQUE (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (conversationid, userid);


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
    ADD CONSTRAINT users_achievements_pkey PRIMARY KEY (userid, achievementname, achievementlevel);


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
-- Name: users trigger_update_timestamp; Type: TRIGGER; Schema: public; Owner: nabouzah
--

CREATE TRIGGER trigger_update_timestamp BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: message update_conversation; Type: TRIGGER; Schema: public; Owner: nabouzah
--

CREATE TRIGGER update_conversation AFTER INSERT ON public.message FOR EACH ROW EXECUTE FUNCTION public.update_conversation();


--
-- Name: users_achievements users_achievements; Type: TRIGGER; Schema: public; Owner: nabouzah
--

CREATE TRIGGER users_achievements AFTER INSERT ON public.users_achievements FOR EACH ROW EXECUTE FUNCTION public.update_user_xp();


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
-- Name: members members_conversationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_conversationid_fkey FOREIGN KEY (conversationid) REFERENCES public.conversation(id);


--
-- Name: members members_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id);


--
-- Name: message message_conversationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_conversationid_fkey FOREIGN KEY (conversationid) REFERENCES public.conversation(id);


--
-- Name: message message_senderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_senderid_fkey FOREIGN KEY (senderid) REFERENCES public.members(id);


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
-- Name: users_achievements users_achievements_achievementname_achievementlevel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users_achievements
    ADD CONSTRAINT users_achievements_achievementname_achievementlevel_fkey FOREIGN KEY (achievementname, achievementlevel) REFERENCES public.achievements(name, level) ON DELETE CASCADE;


--
-- Name: users_achievements users_achievements_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nabouzah
--

ALTER TABLE ONLY public.users_achievements
    ADD CONSTRAINT users_achievements_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(intra_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

