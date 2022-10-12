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
1	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:42.297524
2	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:02:53.297524
3	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:07:46.297524
4	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:56:18.297524
5	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:58:48.297524
6	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:00:20.297524
7	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:37.297524
8	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:54.297524
9	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:56:21.297524
10	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:59:39.297524
11	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:04.297524
12	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:03:50.297524
13	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:08:40.297524
14	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:34.297524
15	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:08:22.297524
16	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:07:15.297524
17	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:04:29.297524
18	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:06:38.297524
19	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:04:44.297524
20	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:59:01.297524
21	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:56:18.297524
22	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:04:13.297524
23	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:02:40.297524
24	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:31.297524
25	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:00:56.297524
26	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:03:22.297524
27	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:56:00.297524
28	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:01:32.297524
29	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:58:10.297524
30	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:08:02.297524
31	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:58:25.297524
32	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:05:22.297524
33	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:56:38.297524
34	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:05:30.297524
35	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:03:43.297524
36	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:04:16.297524
37	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:01:11.297524
38	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:04:07.297524
39	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:57:33.297524
40	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:01:59.297524
41	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:02:35.297524
42	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:01:01.297524
43	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:56:53.297524
44	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:05:04.297524
45	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:05:00.297524
46	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:06:31.297524
47	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 14:55:55.297524
48	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:06:08.297524
49	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:03:42.297524
50	END	NORMAL	2022-10-12 14:55:24.297524	2022-10-12 15:00:27.297524
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
1	1	51111	f	2022-10-12 14:55:24.250215
2	2	51111	f	2022-10-12 14:55:24.250215
3	3	51111	f	2022-10-12 14:55:24.250215
4	4	51111	f	2022-10-12 14:55:24.250215
5	5	51111	f	2022-10-12 14:55:24.250215
6	6	51111	f	2022-10-12 14:55:24.250215
7	7	51111	f	2022-10-12 14:55:24.250215
8	8	51111	f	2022-10-12 14:55:24.250215
9	9	51111	f	2022-10-12 14:55:24.250215
10	10	51111	f	2022-10-12 14:55:24.250215
11	11	51111	f	2022-10-12 14:55:24.250215
12	12	51111	f	2022-10-12 14:55:24.250215
13	13	51111	f	2022-10-12 14:55:24.250215
14	14	51111	f	2022-10-12 14:55:24.250215
15	15	51111	f	2022-10-12 14:55:24.250215
16	16	51111	f	2022-10-12 14:55:24.250215
17	17	51111	f	2022-10-12 14:55:24.250215
18	18	51111	f	2022-10-12 14:55:24.250215
19	19	51111	f	2022-10-12 14:55:24.250215
20	20	51111	f	2022-10-12 14:55:24.250215
21	21	51111	f	2022-10-12 14:55:24.250215
22	22	51111	f	2022-10-12 14:55:24.250215
23	23	51111	f	2022-10-12 14:55:24.250215
24	24	51111	f	2022-10-12 14:55:24.250215
25	25	51111	f	2022-10-12 14:55:24.250215
26	26	51111	f	2022-10-12 14:55:24.250215
27	27	51111	f	2022-10-12 14:55:24.250215
28	28	51111	f	2022-10-12 14:55:24.250215
29	29	51111	f	2022-10-12 14:55:24.250215
30	30	51111	f	2022-10-12 14:55:24.250215
31	31	51111	f	2022-10-12 14:55:24.250215
32	32	51111	f	2022-10-12 14:55:24.250215
33	33	51111	f	2022-10-12 14:55:24.250215
34	34	51111	f	2022-10-12 14:55:24.250215
35	35	51111	f	2022-10-12 14:55:24.250215
36	36	51111	f	2022-10-12 14:55:24.250215
37	37	51111	f	2022-10-12 14:55:24.250215
38	38	51111	f	2022-10-12 14:55:24.250215
39	39	51111	f	2022-10-12 14:55:24.250215
40	40	51111	f	2022-10-12 14:55:24.250215
41	41	51111	f	2022-10-12 14:55:24.250215
42	42	51111	f	2022-10-12 14:55:24.250215
43	43	51111	f	2022-10-12 14:55:24.250215
44	44	51111	f	2022-10-12 14:55:24.250215
45	45	51111	f	2022-10-12 14:55:24.250215
46	46	51111	f	2022-10-12 14:55:24.250215
47	47	51111	f	2022-10-12 14:55:24.250215
48	48	51111	f	2022-10-12 14:55:24.250215
49	49	51111	f	2022-10-12 14:55:24.250215
50	50	51111	f	2022-10-12 14:55:24.250215
51	51	51111	f	2022-10-12 14:55:24.250215
52	52	51111	f	2022-10-12 14:55:24.250215
53	53	51111	f	2022-10-12 14:55:24.250215
54	54	51111	f	2022-10-12 14:55:24.250215
55	55	51111	f	2022-10-12 14:55:24.250215
56	56	51111	f	2022-10-12 14:55:24.250215
57	57	51111	f	2022-10-12 14:55:24.250215
58	58	51111	f	2022-10-12 14:55:24.250215
59	59	51111	f	2022-10-12 14:55:24.250215
60	60	51111	f	2022-10-12 14:55:24.250215
61	51111	60	f	2022-10-12 14:55:24.270313
62	51111	61	f	2022-10-12 14:55:24.270313
63	51111	62	f	2022-10-12 14:55:24.270313
64	51111	63	f	2022-10-12 14:55:24.270313
65	51111	64	f	2022-10-12 14:55:24.270313
66	51111	65	f	2022-10-12 14:55:24.270313
67	51111	66	f	2022-10-12 14:55:24.270313
68	51111	67	f	2022-10-12 14:55:24.270313
69	51111	68	f	2022-10-12 14:55:24.270313
70	51111	69	f	2022-10-12 14:55:24.270313
71	51111	70	f	2022-10-12 14:55:24.270313
72	51111	71	f	2022-10-12 14:55:24.270313
73	51111	72	f	2022-10-12 14:55:24.270313
74	51111	73	f	2022-10-12 14:55:24.270313
75	51111	74	f	2022-10-12 14:55:24.270313
76	51111	75	f	2022-10-12 14:55:24.270313
77	51111	76	f	2022-10-12 14:55:24.270313
78	51111	77	f	2022-10-12 14:55:24.270313
79	51111	78	f	2022-10-12 14:55:24.270313
80	51111	79	f	2022-10-12 14:55:24.270313
81	51111	80	f	2022-10-12 14:55:24.270313
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
1	FRIEND_REQUEST	51111	1	1	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
2	FRIEND_REQUEST	51111	2	2	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
3	FRIEND_REQUEST	51111	3	3	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
4	FRIEND_REQUEST	51111	4	4	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
5	FRIEND_REQUEST	51111	5	5	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
6	FRIEND_REQUEST	51111	6	6	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
7	FRIEND_REQUEST	51111	7	7	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
8	FRIEND_REQUEST	51111	8	8	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
9	FRIEND_REQUEST	51111	9	9	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
10	FRIEND_REQUEST	51111	10	10	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
11	FRIEND_REQUEST	51111	11	11	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
12	FRIEND_REQUEST	51111	12	12	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
13	FRIEND_REQUEST	51111	13	13	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
14	FRIEND_REQUEST	51111	14	14	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
15	FRIEND_REQUEST	51111	15	15	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
16	FRIEND_REQUEST	51111	16	16	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
17	FRIEND_REQUEST	51111	17	17	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
18	FRIEND_REQUEST	51111	18	18	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
19	FRIEND_REQUEST	51111	19	19	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
20	FRIEND_REQUEST	51111	20	20	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
21	FRIEND_REQUEST	51111	21	21	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
22	FRIEND_REQUEST	51111	22	22	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
23	FRIEND_REQUEST	51111	23	23	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
24	FRIEND_REQUEST	51111	24	24	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
25	FRIEND_REQUEST	51111	25	25	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
26	FRIEND_REQUEST	51111	26	26	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
27	FRIEND_REQUEST	51111	27	27	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
28	FRIEND_REQUEST	51111	28	28	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
29	FRIEND_REQUEST	51111	29	29	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
30	FRIEND_REQUEST	51111	30	30	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
31	FRIEND_REQUEST	51111	31	31	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
32	FRIEND_REQUEST	51111	32	32	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
33	FRIEND_REQUEST	51111	33	33	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
34	FRIEND_REQUEST	51111	34	34	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
35	FRIEND_REQUEST	51111	35	35	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
36	FRIEND_REQUEST	51111	36	36	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
37	FRIEND_REQUEST	51111	37	37	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
38	FRIEND_REQUEST	51111	38	38	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
39	FRIEND_REQUEST	51111	39	39	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
40	FRIEND_REQUEST	51111	40	40	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
41	FRIEND_REQUEST	51111	41	41	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
42	FRIEND_REQUEST	51111	42	42	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
43	FRIEND_REQUEST	51111	43	43	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
44	FRIEND_REQUEST	51111	44	44	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
45	FRIEND_REQUEST	51111	45	45	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
46	FRIEND_REQUEST	51111	46	46	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
47	FRIEND_REQUEST	51111	47	47	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
48	FRIEND_REQUEST	51111	48	48	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
49	FRIEND_REQUEST	51111	49	49	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
50	FRIEND_REQUEST	51111	50	50	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
51	FRIEND_REQUEST	51111	51	51	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
52	FRIEND_REQUEST	51111	52	52	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
53	FRIEND_REQUEST	51111	53	53	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
54	FRIEND_REQUEST	51111	54	54	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
55	FRIEND_REQUEST	51111	55	55	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
56	FRIEND_REQUEST	51111	56	56	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
57	FRIEND_REQUEST	51111	57	57	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
58	FRIEND_REQUEST	51111	58	58	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
59	FRIEND_REQUEST	51111	59	59	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
60	FRIEND_REQUEST	51111	60	60	send you friend request	f	2022-10-12 14:55:24.271149	2022-10-12 14:55:24.271149
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.players (id, userid, gameid, score) FROM stdin;
1	1	1	0
2	2	2	1
3	3	3	1
4	4	4	3
5	5	5	1
6	6	6	2
7	7	7	0
8	8	8	2
9	9	9	1
10	10	10	0
11	11	11	2
12	12	12	0
13	13	13	3
14	14	14	3
15	15	15	2
16	16	16	1
17	17	17	0
18	18	18	1
19	19	19	2
20	20	20	2
21	21	21	3
22	22	22	2
23	23	23	3
24	24	24	1
25	25	25	0
26	26	26	3
27	27	27	1
28	28	28	1
29	29	29	1
30	30	30	1
31	31	31	0
32	32	32	2
33	33	33	1
34	34	34	0
35	35	35	3
36	36	36	3
37	37	37	1
38	38	38	0
39	39	39	1
40	40	40	3
41	41	41	0
42	42	42	3
43	43	43	3
44	44	44	0
45	45	45	2
46	46	46	2
47	47	47	3
48	48	48	0
49	49	49	0
50	50	50	3
51	51111	1	4
52	51111	2	3
53	51111	3	1
54	51111	4	2
55	51111	5	1
56	51111	6	4
57	51111	7	4
58	51111	8	2
59	51111	9	0
60	51111	10	3
61	51111	11	3
62	51111	12	3
63	51111	13	2
64	51111	14	4
65	51111	15	0
66	51111	16	0
67	51111	17	1
68	51111	18	1
69	51111	19	0
70	51111	20	0
71	51111	21	2
72	51111	22	1
73	51111	23	4
74	51111	24	4
75	51111	25	1
76	51111	26	2
77	51111	27	0
78	51111	28	1
79	51111	29	2
80	51111	30	3
81	51111	31	2
82	51111	32	4
83	51111	33	2
84	51111	34	0
85	51111	35	2
86	51111	36	0
87	51111	37	4
88	51111	38	3
89	51111	39	3
90	51111	40	0
91	51111	41	2
92	51111	42	4
93	51111	43	3
94	51111	44	3
95	51111	45	1
96	51111	46	2
97	51111	47	3
98	51111	48	1
99	51111	49	3
100	51111	50	4
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users (id, intra_id, username, email, first_name, last_name, status, xp, img_url, cover, created_at, updated_at) FROM stdin;
1	51111	alizaynou	alzaynou@student.1337.ma	Ali	Zaynoune	OFFLINE	742	https://cdn.intra.42.fr/users/alzaynou.jpg	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.202652	2022-10-12 14:55:24.202652
2	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	548	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
3	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	OFFLINE	116	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
4	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	OFFLINE	564	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
5	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	412	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
6	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	OFFLINE	597	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
7	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	OFFLINE	295	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
8	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	744	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
9	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	OFFLINE	521	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
10	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	OFFLINE	480	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
11	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	OFFLINE	633	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
12	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	OFFLINE	530	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
13	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	285	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
14	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	OFFLINE	244	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
15	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	OFFLINE	285	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
16	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	OFFLINE	285	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
17	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	OFFLINE	747	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
18	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	OFFLINE	52	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
19	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	OFFLINE	610	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
20	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	OFFLINE	207	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
21	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	OFFLINE	127	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
22	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	OFFLINE	327	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
23	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	650	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
24	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	OFFLINE	476	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
25	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	512	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
26	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	OFFLINE	473	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
27	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	OFFLINE	496	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
28	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	OFFLINE	313	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
29	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	OFFLINE	786	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
30	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	OFFLINE	323	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
31	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	OFFLINE	395	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
32	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	OFFLINE	255	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
33	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	631	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
34	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	OFFLINE	462	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
35	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	16	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
36	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	349	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
37	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	565	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
38	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	OFFLINE	25	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
39	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	OFFLINE	418	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
40	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	OFFLINE	757	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
41	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	OFFLINE	60	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
42	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	OFFLINE	460	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
43	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	19	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
44	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	OFFLINE	275	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
45	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	OFFLINE	168	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
46	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	OFFLINE	105	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
47	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	129	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
48	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	20	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
49	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	OFFLINE	78	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
50	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	OFFLINE	533	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
51	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	OFFLINE	375	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
52	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	OFFLINE	395	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
53	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	OFFLINE	239	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
54	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	OFFLINE	682	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
55	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	OFFLINE	331	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
56	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	450	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
57	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	12	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
58	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	733	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
59	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	686	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
60	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	OFFLINE	36	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
61	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	OFFLINE	596	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
62	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	284	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
63	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	739	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
64	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	OFFLINE	399	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
65	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	OFFLINE	135	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
66	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	571	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
67	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	OFFLINE	645	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
68	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	13	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
69	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	OFFLINE	251	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
70	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	OFFLINE	335	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
71	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	OFFLINE	759	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
72	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	OFFLINE	262	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
73	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	OFFLINE	535	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
74	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	OFFLINE	791	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
75	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	360	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
76	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	OFFLINE	546	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
77	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	OFFLINE	251	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
78	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	OFFLINE	600	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
79	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	OFFLINE	746	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
80	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	OFFLINE	758	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
81	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	OFFLINE	77	https://joeschmoe.io/api/v1/random	https://random.imagecdn.app/1800/800	2022-10-12 14:55:24.218547	2022-10-12 14:55:24.218547
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, createdat) FROM stdin;
1	51111	2	2022-10-12 14:55:24.223292
2	51111	4	2022-10-12 14:55:24.223292
3	51111	6	2022-10-12 14:55:24.223292
4	51111	8	2022-10-12 14:55:24.223292
5	51111	10	2022-10-12 14:55:24.223292
6	51111	12	2022-10-12 14:55:24.223292
7	51111	14	2022-10-12 14:55:24.223292
8	51111	16	2022-10-12 14:55:24.223292
9	51111	18	2022-10-12 14:55:24.223292
10	51111	20	2022-10-12 14:55:24.223292
11	1	1	2022-10-12 14:55:24.249303
12	2	2	2022-10-12 14:55:24.249303
13	3	3	2022-10-12 14:55:24.249303
14	4	4	2022-10-12 14:55:24.249303
15	5	5	2022-10-12 14:55:24.249303
16	6	6	2022-10-12 14:55:24.249303
17	7	7	2022-10-12 14:55:24.249303
18	8	8	2022-10-12 14:55:24.249303
19	9	9	2022-10-12 14:55:24.249303
20	10	10	2022-10-12 14:55:24.249303
21	11	11	2022-10-12 14:55:24.249303
22	12	12	2022-10-12 14:55:24.249303
23	13	13	2022-10-12 14:55:24.249303
24	14	14	2022-10-12 14:55:24.249303
25	15	15	2022-10-12 14:55:24.249303
26	16	16	2022-10-12 14:55:24.249303
27	17	17	2022-10-12 14:55:24.249303
28	18	18	2022-10-12 14:55:24.249303
29	19	19	2022-10-12 14:55:24.249303
30	20	20	2022-10-12 14:55:24.249303
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

SELECT pg_catalog.setval('public.game_id_seq', 50, true);


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

SELECT pg_catalog.setval('public.players_id_seq', 100, true);


--
-- Name: users_achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_achievements_id_seq', 30, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_id_seq', 81, true);


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

