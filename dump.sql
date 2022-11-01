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

--
-- Name: update_changetimestamp(); Type: FUNCTION; Schema: public; Owner: nabouzah
--

CREATE FUNCTION public.update_changetimestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN NEW.updated_at = now();
RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_changetimestamp() OWNER TO nabouzah;

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
    created_at timestamp without time zone NOT NULL,
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
    id integer NOT NULL,
    userid integer NOT NULL,
    achievementid integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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

COPY public.game (id, status, level, started, created_at, updated_at) FROM stdin;
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
1	51111	2	f	2022-11-01 08:36:34.071298
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.message (id, sender_id, content, conversation_id, created_at, updated_at, read_by, delivered_to) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.notification (id, type, userid, fromid, targetid, content, read, created_at, updated_at) FROM stdin;
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
1	1	alizaynoune1	zaynoune1@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
3	3	alizaynoune3	zaynoune3@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
4	4	alizaynoune4	zaynoune4@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
5	5	alizaynoune5	zaynoune5@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
6	6	alizaynoune6	zaynoune6@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
7	7	alizaynoune7	zaynoune7@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
8	8	alizaynoune8	zaynoune8@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
9	9	alizaynoune9	zaynoune9@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
10	10	alizaynoune10	zaynoune10@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
11	11	alizaynoune11	zaynoune11@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
12	12	alizaynoune12	zaynoune12@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
13	13	alizaynoune13	zaynoune13@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
14	14	alizaynoune14	zaynoune14@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
15	15	alizaynoune15	zaynoune15@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
16	16	alizaynoune16	zaynoune16@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
17	17	alizaynoune17	zaynoune17@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
18	18	alizaynoune18	zaynoune18@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
19	19	alizaynoune19	zaynoune19@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
20	20	alizaynoune20	zaynoune20@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
21	21	alizaynoune21	zaynoune21@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
22	22	alizaynoune22	zaynoune22@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
23	23	alizaynoune23	zaynoune23@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
24	24	alizaynoune24	zaynoune24@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
25	25	alizaynoune25	zaynoune25@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
26	26	alizaynoune26	zaynoune26@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
27	27	alizaynoune27	zaynoune27@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
28	28	alizaynoune28	zaynoune28@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
29	29	alizaynoune29	zaynoune29@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
30	30	alizaynoune30	zaynoune30@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
31	31	alizaynoune31	zaynoune31@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
32	32	alizaynoune32	zaynoune32@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
33	33	alizaynoune33	zaynoune33@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
34	34	alizaynoune34	zaynoune34@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
35	35	alizaynoune35	zaynoune35@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
36	36	alizaynoune36	zaynoune36@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
37	37	alizaynoune37	zaynoune37@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
38	38	alizaynoune38	zaynoune38@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
39	39	alizaynoune39	zaynoune39@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
40	40	alizaynoune40	zaynoune40@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
41	41	alizaynoune41	zaynoune41@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
42	42	alizaynoune42	zaynoune42@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
43	43	alizaynoune43	zaynoune43@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
44	44	alizaynoune44	zaynoune44@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
45	45	alizaynoune45	zaynoune45@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
46	46	alizaynoune46	zaynoune46@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
47	47	alizaynoune47	zaynoune47@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
48	48	alizaynoune48	zaynoune48@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
49	49	alizaynoune49	zaynoune49@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
50	50	alizaynoune50	zaynoune50@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
51	51	alizaynoune51	zaynoune51@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
52	52	alizaynoune52	zaynoune52@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
53	53	alizaynoune53	zaynoune53@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
54	54	alizaynoune54	zaynoune54@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
55	55	alizaynoune55	zaynoune55@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
56	56	alizaynoune56	zaynoune56@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
57	57	alizaynoune57	zaynoune57@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
58	58	alizaynoune58	zaynoune58@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
59	59	alizaynoune59	zaynoune59@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
60	60	alizaynoune60	zaynoune60@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
61	61	alizaynoune61	zaynoune61@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
62	62	alizaynoune62	zaynoune62@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
63	63	alizaynoune63	zaynoune63@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
64	64	alizaynoune64	zaynoune64@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
65	65	alizaynoune65	zaynoune65@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
66	66	alizaynoune66	zaynoune66@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
67	67	alizaynoune67	zaynoune67@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
68	68	alizaynoune68	zaynoune68@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
69	69	alizaynoune69	zaynoune69@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
70	70	alizaynoune70	zaynoune70@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
71	71	alizaynoune71	zaynoune71@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
72	72	alizaynoune72	zaynoune72@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
73	73	alizaynoune73	zaynoune73@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
74	74	alizaynoune74	zaynoune74@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
75	75	alizaynoune75	zaynoune75@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
76	76	alizaynoune76	zaynoune76@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
77	77	alizaynoune77	zaynoune77@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
78	78	alizaynoune78	zaynoune78@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
79	79	alizaynoune79	zaynoune79@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
80	80	alizaynoune80	zaynoune80@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
81	81	alizaynoune81	zaynoune81@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
82	82	alizaynoune82	zaynoune82@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
83	83	alizaynoune83	zaynoune83@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
84	84	alizaynoune84	zaynoune84@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
85	85	alizaynoune85	zaynoune85@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
86	86	alizaynoune86	zaynoune86@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
87	87	alizaynoune87	zaynoune87@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
88	88	alizaynoune88	zaynoune88@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
89	89	alizaynoune89	zaynoune89@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
90	90	alizaynoune90	zaynoune90@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
91	91	alizaynoune91	zaynoune91@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
92	92	alizaynoune92	zaynoune92@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
93	93	alizaynoune93	zaynoune93@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
94	94	alizaynoune94	zaynoune94@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
95	95	alizaynoune95	zaynoune95@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
96	96	alizaynoune96	zaynoune96@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
97	97	alizaynoune97	zaynoune97@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
98	98	alizaynoune98	zaynoune98@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
99	99	alizaynoune99	zaynoune99@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
100	100	alizaynoune100	zaynoune100@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
101	101	alizaynoune101	zaynoune101@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
102	102	alizaynoune102	zaynoune102@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
103	103	alizaynoune103	zaynoune103@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
104	104	alizaynoune104	zaynoune104@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
105	105	alizaynoune105	zaynoune105@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
106	106	alizaynoune106	zaynoune106@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
107	107	alizaynoune107	zaynoune107@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
108	108	alizaynoune108	zaynoune108@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
109	109	alizaynoune109	zaynoune109@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
110	110	alizaynoune110	zaynoune110@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
111	111	alizaynoune111	zaynoune111@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
112	112	alizaynoune112	zaynoune112@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
113	113	alizaynoune113	zaynoune113@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
114	114	alizaynoune114	zaynoune114@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
115	115	alizaynoune115	zaynoune115@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
116	116	alizaynoune116	zaynoune116@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
117	117	alizaynoune117	zaynoune117@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
118	118	alizaynoune118	zaynoune118@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
119	119	alizaynoune119	zaynoune119@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
120	120	alizaynoune120	zaynoune120@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
121	121	alizaynoune121	zaynoune121@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
122	122	alizaynoune122	zaynoune122@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
123	123	alizaynoune123	zaynoune123@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
124	124	alizaynoune124	zaynoune124@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
125	125	alizaynoune125	zaynoune125@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
126	126	alizaynoune126	zaynoune126@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
127	127	alizaynoune127	zaynoune127@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
128	128	alizaynoune128	zaynoune128@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
129	129	alizaynoune129	zaynoune129@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
130	130	alizaynoune130	zaynoune130@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
131	131	alizaynoune131	zaynoune131@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
132	132	alizaynoune132	zaynoune132@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
133	133	alizaynoune133	zaynoune133@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
134	134	alizaynoune134	zaynoune134@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
135	135	alizaynoune135	zaynoune135@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
136	136	alizaynoune136	zaynoune136@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
137	137	alizaynoune137	zaynoune137@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
138	138	alizaynoune138	zaynoune138@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
139	139	alizaynoune139	zaynoune139@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
140	140	alizaynoune140	zaynoune140@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
141	141	alizaynoune141	zaynoune141@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
142	142	alizaynoune142	zaynoune142@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
143	143	alizaynoune143	zaynoune143@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
144	144	alizaynoune144	zaynoune144@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
145	145	alizaynoune145	zaynoune145@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
146	146	alizaynoune146	zaynoune146@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
147	147	alizaynoune147	zaynoune147@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
148	148	alizaynoune148	zaynoune148@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
149	149	alizaynoune149	zaynoune149@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
150	150	alizaynoune150	zaynoune150@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
151	151	alizaynoune151	zaynoune151@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
152	152	alizaynoune152	zaynoune152@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
153	153	alizaynoune153	zaynoune153@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
154	154	alizaynoune154	zaynoune154@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
155	155	alizaynoune155	zaynoune155@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
156	156	alizaynoune156	zaynoune156@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
157	157	alizaynoune157	zaynoune157@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
158	158	alizaynoune158	zaynoune158@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
159	159	alizaynoune159	zaynoune159@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
160	160	alizaynoune160	zaynoune160@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
161	161	alizaynoune161	zaynoune161@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
162	162	alizaynoune162	zaynoune162@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
163	163	alizaynoune163	zaynoune163@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
164	164	alizaynoune164	zaynoune164@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
165	165	alizaynoune165	zaynoune165@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
166	166	alizaynoune166	zaynoune166@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
167	167	alizaynoune167	zaynoune167@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
168	168	alizaynoune168	zaynoune168@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
169	169	alizaynoune169	zaynoune169@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
170	170	alizaynoune170	zaynoune170@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
171	171	alizaynoune171	zaynoune171@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
172	172	alizaynoune172	zaynoune172@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
173	173	alizaynoune173	zaynoune173@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
174	174	alizaynoune174	zaynoune174@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
175	175	alizaynoune175	zaynoune175@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
176	176	alizaynoune176	zaynoune176@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
177	177	alizaynoune177	zaynoune177@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
178	178	alizaynoune178	zaynoune178@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
179	179	alizaynoune179	zaynoune179@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
180	180	alizaynoune180	zaynoune180@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
181	181	alizaynoune181	zaynoune181@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
182	182	alizaynoune182	zaynoune182@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
183	183	alizaynoune183	zaynoune183@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
184	184	alizaynoune184	zaynoune184@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
185	185	alizaynoune185	zaynoune185@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
186	186	alizaynoune186	zaynoune186@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
187	187	alizaynoune187	zaynoune187@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
188	188	alizaynoune188	zaynoune188@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
189	189	alizaynoune189	zaynoune189@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
190	190	alizaynoune190	zaynoune190@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
191	191	alizaynoune191	zaynoune191@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
192	192	alizaynoune192	zaynoune192@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
193	193	alizaynoune193	zaynoune193@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
194	194	alizaynoune194	zaynoune194@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
195	195	alizaynoune195	zaynoune195@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
196	196	alizaynoune196	zaynoune196@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
197	197	alizaynoune197	zaynoune197@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
198	198	alizaynoune198	zaynoune198@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
199	199	alizaynoune199	zaynoune199@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
200	200	alizaynoune200	zaynoune200@ali.ali	ali	zaynoune	OFFLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:34:50.314824
232	51111	alzaynou	alzaynou@student.1337.ma	Ali	Zaynoune	ONLINE	0	https://cdn.intra.42.fr/users/7930a8e34ad5d6c7629b269e9db89ded/alzaynou.jpg	\N	2022-11-01 08:36:14.465561	2022-11-01 08:39:21.646935
2	2	alizaynoune2	zaynoune2@ali.ali	ali	zaynoune	ONLINE	0	https://joeschmoe.io/api/v1/random	\N	2022-11-01 08:34:50.314824	2022-11-01 08:39:21.195985
\.


--
-- Data for Name: users_achievements; Type: TABLE DATA; Schema: public; Owner: nabouzah
--

COPY public.users_achievements (id, userid, achievementid, created_at) FROM stdin;
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.achievements_id_seq', 33, true);


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
-- Name: group_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.group_member_id_seq', 1, false);


--
-- Name: invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.invites_id_seq', 1, true);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.message_id_seq', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.notification_id_seq', 1, false);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.players_id_seq', 1, false);


--
-- Name: users_achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_achievements_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nabouzah
--

SELECT pg_catalog.setval('public.users_id_seq', 232, true);


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
-- Name: users update_users_changetimestamp; Type: TRIGGER; Schema: public; Owner: nabouzah
--

CREATE TRIGGER update_users_changetimestamp BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_changetimestamp();


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

