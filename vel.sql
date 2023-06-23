--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-06-23 11:54:17

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
-- TOC entry 7 (class 2615 OID 33000)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 3 (class 3079 OID 33001)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 282 (class 1255 OID 33384)
-- Name: delete_low_priced_bicycle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_low_priced_bicycle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.price < 600 THEN
        DELETE FROM bicycles
        WHERE id = NEW.id;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.delete_low_priced_bicycle() OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 33376)
-- Name: fill_empty_description(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fill_empty_description() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.description IS NULL OR NEW.description = '' THEN
        NEW.description := '...';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fill_empty_description() OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 33366)
-- Name: max_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.max_price() RETURNS numeric
    LANGUAGE sql
    AS $$
    SELECT MAX(price)
    FROM products;
$$;


ALTER FUNCTION public.max_price() OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 33261)
-- Name: new_product(); Type: PROCEDURE; Schema: public; Owner: main
--

CREATE PROCEDURE public.new_product()
    LANGUAGE sql
    AS $$
    INSERT INTO products (id,name,description, price, quantity) VALUES (8,'Звонок электрический','xyz', 1000, 10);
    UPDATE clients SET address = 'ул.Ленина,д.26,кв.13' WHERE id = 1;
    SELECT * FROM products;
$$;


ALTER PROCEDURE public.new_product() OWNER TO main;

--
-- TOC entry 269 (class 1255 OID 33368)
-- Name: orders_range(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.orders_range() RETURNS TABLE(order_id integer, client_id integer, order_date timestamp without time zone, status character varying, total numeric)
    LANGUAGE sql
    AS $$
    SELECT o.id AS order_id, o.client_id, o.date AS order_date, o.status, o.total
    FROM orders o
    WHERE o.total >= 1500 AND o.total <= 2000;
$$;


ALTER FUNCTION public.orders_range() OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 33262)
-- Name: pr_orders(timestamp without time zone, integer, numeric); Type: PROCEDURE; Schema: public; Owner: main
--

CREATE PROCEDURE public.pr_orders(IN p_date timestamp without time zone, IN p_id integer, IN p_value numeric)
    LANGUAGE sql
    AS $$
    UPDATE orders
    SET total = p_value, date = p_date
    WHERE id = p_id;
$$;


ALTER PROCEDURE public.pr_orders(IN p_date timestamp without time zone, IN p_id integer, IN p_value numeric) OWNER TO main;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 240 (class 1259 OID 33263)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 33268)
-- Name: avg_price; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.avg_price AS
 SELECT products.id,
    products.name
   FROM public.products
  WHERE (products.price > ( SELECT avg(products_1.price) AS avg
           FROM public.products products_1));


ALTER TABLE public.avg_price OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 33272)
-- Name: bicycles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bicycles (
    id integer NOT NULL,
    model character varying(60) NOT NULL,
    price numeric(10,2) NOT NULL,
    frame_material character varying(50) NOT NULL,
    frame_size integer NOT NULL,
    wheel_size integer NOT NULL,
    color character varying(50) NOT NULL,
    type_id integer NOT NULL,
    brand_id integer NOT NULL
);


ALTER TABLE public.bicycles OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 33275)
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id integer NOT NULL,
    name_brands character varying(60) NOT NULL
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 33278)
-- Name: bicycle_brands; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bicycle_brands AS
 SELECT b.id,
    b.model,
    br.name_brands AS brand,
    b.price,
    b.frame_material,
    b.frame_size,
    b.wheel_size,
    b.color
   FROM (public.bicycles b
     JOIN public.brands br ON ((b.brand_id = br.id)));


ALTER TABLE public.bicycle_brands OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 33282)
-- Name: types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types (
    id integer NOT NULL,
    name_types character varying(60) NOT NULL
);


ALTER TABLE public.types OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 33285)
-- Name: bicycle_types; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bicycle_types AS
 SELECT t.name_types AS type_name,
    count(*) AS total_count
   FROM (public.bicycles b
     JOIN public.types t ON ((b.type_id = t.id)))
  GROUP BY t.name_types;


ALTER TABLE public.bicycle_types OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 33289)
-- Name: bicycles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bicycles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bicycles_id_seq OWNER TO postgres;

--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 247
-- Name: bicycles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bicycles_id_seq OWNED BY public.bicycles.id;


--
-- TOC entry 248 (class 1259 OID 33290)
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brands_id_seq OWNER TO postgres;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 248
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;


--
-- TOC entry 249 (class 1259 OID 33291)
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    address character varying(60) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(60)
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 33294)
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO postgres;

--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 250
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- TOC entry 251 (class 1259 OID 33295)
-- Name: expensive_products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.expensive_products AS
 SELECT products.id,
    products.name,
    products.price,
    products.quantity
   FROM public.products
  WHERE (products.price >= (2000)::numeric)
  WITH CASCADED CHECK OPTION;


ALTER TABLE public.expensive_products OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 33299)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 33302)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_items_id_seq OWNER TO postgres;

--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 253
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 254 (class 1259 OID 33303)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    client_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    status character varying(20) NOT NULL,
    total numeric(10,2) NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 33306)
-- Name: orders_clients; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.orders_clients AS
 SELECT orders.id,
    orders.date,
    orders.status,
    clients.name
   FROM (public.orders
     JOIN public.clients ON ((orders.client_id = clients.id)));


ALTER TABLE public.orders_clients OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 33310)
-- Name: orders_clients1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.orders_clients1 AS
 SELECT o.id,
    o.date,
    o.status,
    c.name
   FROM (public.orders o
     JOIN public.clients c ON ((o.client_id = c.id)));


ALTER TABLE public.orders_clients1 OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 33314)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 257
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 258 (class 1259 OID 33315)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 258
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 259 (class 1259 OID 33316)
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.types_id_seq OWNER TO postgres;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 259
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- TOC entry 3328 (class 2604 OID 33317)
-- Name: bicycles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bicycles ALTER COLUMN id SET DEFAULT nextval('public.bicycles_id_seq'::regclass);


--
-- TOC entry 3329 (class 2604 OID 33318)
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- TOC entry 3331 (class 2604 OID 33319)
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- TOC entry 3332 (class 2604 OID 33320)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 3333 (class 2604 OID 33321)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 33322)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 33323)
-- Name: types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- TOC entry 3289 (class 0 OID 33002)
-- Dependencies: 225
-- Data for Name: pga_jobagent; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
6292	2023-06-23 03:24:09.608264+03	DESKTOP-4D9JRGN
\.


--
-- TOC entry 3290 (class 0 OID 33011)
-- Dependencies: 227
-- Data for Name: pga_jobclass; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
\.


--
-- TOC entry 3291 (class 0 OID 33021)
-- Dependencies: 229
-- Data for Name: pga_job; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
2	1	pr_order			t	2023-05-27 02:14:43.174088+03	2023-05-27 02:14:43.174088+03	\N	2023-06-24 00:37:00+03	2023-06-18 09:41:45.212455+03
\.


--
-- TOC entry 3293 (class 0 OID 33069)
-- Dependencies: 233
-- Data for Name: pga_schedule; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
2	2	pr_new_order		t	2023-05-27 03:36:26+03	\N	{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,t,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}	{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}	{f,f,f,f,f,f,t}	{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}	{f,f,f,f,f,f,f,f,f,f,f,f}
\.


--
-- TOC entry 3294 (class 0 OID 33097)
-- Dependencies: 235
-- Data for Name: pga_exception; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
\.


--
-- TOC entry 3295 (class 0 OID 33111)
-- Dependencies: 237
-- Data for Name: pga_joblog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
46	2	f	2023-05-27 03:13:00.780809+03	00:00:00.025524
47	2	f	2023-05-27 03:14:01.214643+03	00:00:00.026392
48	2	f	2023-05-27 03:15:01.653803+03	00:00:00.025434
49	2	f	2023-05-27 03:15:52.023148+03	00:00:00.025859
50	2	f	2023-05-27 03:16:02.097307+03	00:00:00.026923
51	2	f	2023-05-27 03:17:02.545887+03	00:00:00.028958
52	2	f	2023-05-27 03:24:47.812082+03	00:00:00.027333
53	2	f	2023-05-27 03:25:02.922782+03	00:00:00.026397
9	2	f	2023-05-27 02:16:03.778958+03	00:00:00.025312
10	2	f	2023-05-27 02:19:00.077917+03	00:00:00.026207
11	2	f	2023-05-27 02:21:00.957822+03	00:00:00.138298
12	2	f	2023-05-27 02:21:46.289917+03	00:00:00.027014
13	2	f	2023-05-27 02:22:01.404662+03	00:00:00.028589
14	2	f	2023-05-27 02:26:58.580026+03	00:00:00.036965
15	2	f	2023-05-27 02:45:23.707575+03	00:00:00.040144
16	2	f	2023-05-27 02:45:28.702146+03	00:00:00.001304
17	2	f	2023-05-27 02:45:53.928141+03	00:00:00.025943
18	2	f	2023-05-27 02:46:44.291301+03	00:00:00.025008
19	2	f	2023-05-27 02:47:04.437389+03	00:00:00.025412
20	2	f	2023-05-27 02:48:04.870558+03	00:00:00.026074
21	2	f	2023-05-27 02:49:00.276755+03	00:00:00.026056
22	2	f	2023-05-27 02:50:00.713465+03	00:00:00.025562
23	2	f	2023-05-27 02:51:01.162753+03	00:00:00.025232
24	2	f	2023-05-27 02:52:01.61231+03	00:00:00.025731
25	2	f	2023-05-27 02:53:02.052608+03	00:00:00.026266
26	2	f	2023-05-27 02:54:02.596482+03	00:00:00.02552
27	2	f	2023-05-27 02:54:47.830472+03	00:00:00.026367
28	2	f	2023-05-27 02:55:02.92697+03	00:00:00.026484
29	2	f	2023-05-27 02:56:03.351555+03	00:00:00.025239
30	2	f	2023-05-27 02:57:03.801714+03	00:00:00.025472
31	2	f	2023-05-27 02:58:04.255775+03	00:00:00.025626
32	2	f	2023-05-27 02:59:04.691741+03	00:00:00.025063
33	2	f	2023-05-27 03:00:00.092112+03	00:00:00.025429
34	2	f	2023-05-27 03:01:00.535319+03	00:00:00.130854
35	2	f	2023-05-27 03:02:00.969417+03	00:00:00.026492
36	2	f	2023-05-27 03:03:01.413433+03	00:00:00.026223
37	2	f	2023-05-27 03:04:01.858986+03	00:00:00.026316
38	2	f	2023-05-27 03:05:02.303646+03	00:00:00.028018
39	2	f	2023-05-27 03:06:02.741183+03	00:00:00.135827
40	2	f	2023-05-27 03:07:03.193162+03	00:00:00.025341
41	2	f	2023-05-27 03:08:03.631759+03	00:00:00.025286
42	2	f	2023-05-27 03:09:04.068014+03	00:00:00.024982
43	2	f	2023-05-27 03:10:04.50928+03	00:00:00.027862
44	2	f	2023-05-27 03:11:04.956884+03	00:00:00.025612
45	2	f	2023-05-27 03:12:00.457065+03	00:00:00.026567
54	2	f	2023-05-27 03:26:03.360928+03	00:00:00.025848
55	2	f	2023-05-27 03:27:03.820476+03	00:00:00.025326
56	2	f	2023-05-27 03:28:04.274424+03	00:00:00.025956
57	2	f	2023-05-27 03:29:04.837813+03	00:00:00.025815
58	2	f	2023-05-27 03:30:00.150407+03	00:00:00.141334
59	2	f	2023-05-27 03:31:00.580121+03	00:00:00.025143
60	2	f	2023-05-27 03:32:01.014747+03	00:00:00.148103
61	2	s	2023-05-27 03:37:03.215794+03	00:00:00.051975
62	2	f	2023-05-27 04:37:04.183538+03	00:00:00.041056
63	2	f	2023-05-27 05:37:00.421282+03	00:00:00.038949
64	2	f	2023-05-27 06:37:02.406158+03	00:00:00.037307
65	2	f	2023-05-27 11:35:35.669371+03	00:00:00.102127
66	2	f	2023-05-27 11:37:01.491199+03	00:00:00.041525
67	2	f	2023-05-27 12:37:04.523238+03	00:00:00.199801
68	2	f	2023-05-27 13:37:01.1096+03	00:00:00.041201
69	2	f	2023-05-27 14:37:02.975556+03	00:00:00.062863
70	2	f	2023-05-27 15:37:04.515505+03	00:00:00.039936
71	2	f	2023-05-27 16:37:01.180695+03	00:00:00.044885
72	2	f	2023-05-27 17:37:03.925343+03	00:00:00.042937
73	2	f	2023-05-27 18:37:01.519747+03	00:00:00.063743
74	2	f	2023-05-27 19:37:02.542629+03	00:00:00.084079
75	2	f	2023-05-27 20:37:03.492727+03	00:00:00.041517
76	2	f	2023-05-27 21:37:02.327172+03	00:00:00.069822
77	2	f	2023-05-28 10:20:24.507917+03	00:00:00.128319
78	2	f	2023-06-03 08:23:21.487512+03	00:00:00.196827
79	2	f	2023-06-03 08:37:04.284871+03	00:00:00.041135
80	2	f	2023-06-03 09:37:00.128297+03	00:00:00.055669
81	2	f	2023-06-03 10:37:04.318247+03	00:00:00.038357
82	2	f	2023-06-03 11:37:03.4379+03	00:00:00.045278
83	2	f	2023-06-03 12:37:03.251685+03	00:00:00.147877
84	2	f	2023-06-03 13:37:02.614017+03	00:00:00.17786
85	2	f	2023-06-03 14:37:02.796158+03	00:00:00.040303
86	2	f	2023-06-03 15:37:01.266295+03	00:00:00.038839
87	2	f	2023-06-03 16:37:02.786204+03	00:00:00.039395
88	2	f	2023-06-03 17:37:00.166576+03	00:00:00.046083
89	2	f	2023-06-03 18:37:02.376036+03	00:00:00.18774
90	2	f	2023-06-03 19:37:04.297355+03	00:00:00.055733
91	2	f	2023-06-03 20:37:01.437251+03	00:00:00.040706
92	2	f	2023-06-03 21:37:03.025626+03	00:00:00.049324
93	2	f	2023-06-03 22:37:03.700737+03	00:00:00.06324
94	2	f	2023-06-03 23:37:00.734226+03	00:00:00.039924
95	2	f	2023-06-10 09:41:15.61813+03	00:00:00.052061
96	2	f	2023-06-10 10:37:04.361252+03	00:00:00.062569
97	2	f	2023-06-10 11:37:00.840999+03	00:00:00.039858
98	2	f	2023-06-10 12:37:04.024127+03	00:00:00.087009
99	2	f	2023-06-10 13:37:04.789325+03	00:00:00.043404
100	2	f	2023-06-10 14:37:02.173336+03	00:00:00.047147
101	2	f	2023-06-10 15:37:02.825842+03	00:00:00.043956
102	2	f	2023-06-10 16:37:02.046368+03	00:00:00.042839
103	2	f	2023-06-10 17:37:01.151371+03	00:00:00.038394
104	2	f	2023-06-10 18:37:01.433441+03	00:00:00.048301
105	2	f	2023-06-10 19:37:04.122083+03	00:00:00.062021
106	2	f	2023-06-10 20:37:02.477184+03	00:00:00.057956
107	2	f	2023-06-10 21:37:01.934938+03	00:00:00.044354
108	2	f	2023-06-10 22:37:01.292577+03	00:00:00.039325
110	2	i	2023-06-11 08:35:47.31453+03	\N
109	2	f	2023-06-11 08:35:47.188231+03	00:00:00.281199
111	2	f	2023-06-17 00:37:03.945387+03	00:00:00.09142
112	2	f	2023-06-17 01:37:00.627799+03	00:00:00.070176
113	2	f	2023-06-17 09:04:53.037546+03	00:00:00.045877
114	2	f	2023-06-17 09:37:02.293482+03	00:00:00.049922
115	2	f	2023-06-17 10:37:03.165412+03	00:00:00.041342
116	2	f	2023-06-17 11:37:01.476636+03	00:00:00.045976
117	2	f	2023-06-17 12:37:04.928611+03	00:00:00.05625
118	2	f	2023-06-17 13:37:00.385267+03	00:00:00.039638
119	2	f	2023-06-17 14:37:00.798521+03	00:00:00.097968
120	2	f	2023-06-17 15:37:01.428619+03	00:00:00.041054
121	2	f	2023-06-17 16:37:01.367225+03	00:00:00.039733
122	2	f	2023-06-17 17:37:01.258342+03	00:00:00.03985
123	2	f	2023-06-17 18:37:00.426185+03	00:00:00.045947
124	2	f	2023-06-17 19:37:04.300691+03	00:00:00.149206
126	2	i	2023-06-17 21:06:00.092725+03	\N
125	2	f	2023-06-17 21:05:59.964292+03	00:00:00.80669
127	2	f	2023-06-17 21:37:00.395412+03	00:00:00.040928
129	2	i	2023-06-18 09:41:45.251218+03	\N
128	2	f	2023-06-18 09:41:45.231872+03	00:00:00.163725
\.


--
-- TOC entry 3292 (class 0 OID 33045)
-- Dependencies: 231
-- Data for Name: pga_jobstep; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
2	2	new_order		t	s	CALL new_product();		postgres	f	\N
\.


--
-- TOC entry 3296 (class 0 OID 33127)
-- Dependencies: 239
-- Data for Name: pga_jobsteplog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
38	38	2	f	1	2023-05-27 03:05:02.30488+03	00:00:00.026334	Couldn't get a connection to the database!
39	39	2	f	1	2023-05-27 03:06:02.742223+03	00:00:00.13432	Couldn't get a connection to the database!
40	40	2	f	1	2023-05-27 03:07:03.194235+03	00:00:00.023883	Couldn't get a connection to the database!
41	41	2	f	1	2023-05-27 03:08:03.632903+03	00:00:00.023752	Couldn't get a connection to the database!
9	9	2	f	1	2023-05-27 02:16:03.780143+03	00:00:00.023729	Couldn't get a connection to the database!
10	10	2	f	1	2023-05-27 02:19:00.079017+03	00:00:00.024668	Couldn't get a connection to the database!
11	11	2	f	1	2023-05-27 02:21:00.958899+03	00:00:00.136062	Couldn't get a connection to the database!
12	12	2	f	1	2023-05-27 02:21:46.291048+03	00:00:00.025441	Couldn't get a connection to the database!
13	13	2	f	1	2023-05-27 02:22:01.405827+03	00:00:00.024945	Couldn't get a connection to the database!
14	14	2	f	-1	2023-05-27 02:26:58.581279+03	00:00:00.035323	ОШИБКА:  процедура new_product() не существует\nLINE 1: CALL new_product();\n             ^\nHINT:  Процедура с данными именем и типами аргументов не найдена. Возможно, вам следует добавить явные приведения типов.
15	15	2	f	-1	2023-05-27 02:45:23.709103+03	00:00:00.038159	ОШИБКА:  процедура new_product() не существует\nLINE 1: CALL new_product();\n             ^\nHINT:  Процедура с данными именем и типами аргументов не найдена. Возможно, вам следует добавить явные приведения типов.
16	16	2	f	-1	2023-05-27 02:45:28.702635+03	00:00:00.000611	ОШИБКА:  процедура new_product() не существует\nLINE 1: CALL new_product();\n             ^\nHINT:  Процедура с данными именем и типами аргументов не найдена. Возможно, вам следует добавить явные приведения типов.
17	17	2	f	1	2023-05-27 02:45:53.929322+03	00:00:00.024324	Couldn't get a connection to the database!
18	18	2	f	1	2023-05-27 02:46:44.292314+03	00:00:00.023559	Couldn't get a connection to the database!
19	19	2	f	1	2023-05-27 02:47:04.438483+03	00:00:00.023943	Couldn't get a connection to the database!
20	20	2	f	1	2023-05-27 02:48:04.871705+03	00:00:00.024509	Couldn't get a connection to the database!
21	21	2	f	1	2023-05-27 02:49:00.27781+03	00:00:00.024567	Couldn't get a connection to the database!
22	22	2	f	1	2023-05-27 02:50:00.714508+03	00:00:00.024084	Couldn't get a connection to the database!
23	23	2	f	1	2023-05-27 02:51:01.163941+03	00:00:00.0237	Couldn't get a connection to the database!
24	24	2	f	1	2023-05-27 02:52:01.613438+03	00:00:00.024189	Couldn't get a connection to the database!
25	25	2	f	1	2023-05-27 02:53:02.053905+03	00:00:00.024513	Couldn't get a connection to the database!
26	26	2	f	1	2023-05-27 02:54:02.597659+03	00:00:00.023992	Couldn't get a connection to the database!
27	27	2	f	1	2023-05-27 02:54:47.831562+03	00:00:00.02485	Couldn't get a connection to the database!
28	28	2	f	1	2023-05-27 02:55:02.928192+03	00:00:00.024843	Couldn't get a connection to the database!
29	29	2	f	1	2023-05-27 02:56:03.352594+03	00:00:00.023772	Couldn't get a connection to the database!
30	30	2	f	1	2023-05-27 02:57:03.802842+03	00:00:00.023907	Couldn't get a connection to the database!
31	31	2	f	1	2023-05-27 02:58:04.257014+03	00:00:00.023991	Couldn't get a connection to the database!
32	32	2	f	1	2023-05-27 02:59:04.692844+03	00:00:00.023571	Couldn't get a connection to the database!
33	33	2	f	1	2023-05-27 03:00:00.093207+03	00:00:00.023918	Couldn't get a connection to the database!
34	34	2	f	1	2023-05-27 03:01:00.536517+03	00:00:00.129194	Couldn't get a connection to the database!
35	35	2	f	1	2023-05-27 03:02:00.970469+03	00:00:00.025	Couldn't get a connection to the database!
36	36	2	f	1	2023-05-27 03:03:01.414614+03	00:00:00.024526	Couldn't get a connection to the database!
37	37	2	f	1	2023-05-27 03:04:01.860092+03	00:00:00.024788	Couldn't get a connection to the database!
42	42	2	f	1	2023-05-27 03:09:04.069142+03	00:00:00.02348	Couldn't get a connection to the database!
43	43	2	f	1	2023-05-27 03:10:04.510316+03	00:00:00.026338	Couldn't get a connection to the database!
44	44	2	f	1	2023-05-27 03:11:04.958031+03	00:00:00.02402	Couldn't get a connection to the database!
45	45	2	f	1	2023-05-27 03:12:00.458166+03	00:00:00.025065	Couldn't get a connection to the database!
46	46	2	f	1	2023-05-27 03:13:00.782071+03	00:00:00.023823	Couldn't get a connection to the database!
47	47	2	f	1	2023-05-27 03:14:01.215779+03	00:00:00.024824	Couldn't get a connection to the database!
48	48	2	f	1	2023-05-27 03:15:01.655002+03	00:00:00.023832	Couldn't get a connection to the database!
49	49	2	f	1	2023-05-27 03:15:52.024202+03	00:00:00.024327	Couldn't get a connection to the database!
50	50	2	f	1	2023-05-27 03:16:02.098372+03	00:00:00.025332	Couldn't get a connection to the database!
51	51	2	f	1	2023-05-27 03:17:02.547074+03	00:00:00.027308	Couldn't get a connection to the database!
52	52	2	f	1	2023-05-27 03:24:47.814916+03	00:00:00.024079	Couldn't get a connection to the database!
53	53	2	f	1	2023-05-27 03:25:02.92387+03	00:00:00.024857	Couldn't get a connection to the database!
54	54	2	f	1	2023-05-27 03:26:03.362037+03	00:00:00.024353	Couldn't get a connection to the database!
55	55	2	f	1	2023-05-27 03:27:03.821594+03	00:00:00.023764	Couldn't get a connection to the database!
56	56	2	f	1	2023-05-27 03:28:04.275587+03	00:00:00.024283	Couldn't get a connection to the database!
57	57	2	f	1	2023-05-27 03:29:04.839+03	00:00:00.024235	Couldn't get a connection to the database!
58	58	2	f	1	2023-05-27 03:30:00.151392+03	00:00:00.139922	Couldn't get a connection to the database!
59	59	2	f	1	2023-05-27 03:31:00.58113+03	00:00:00.023801	Couldn't get a connection to the database!
60	60	2	f	1	2023-05-27 03:32:01.017511+03	00:00:00.141818	Couldn't get a connection to the database!
61	61	2	s	0	2023-05-27 03:37:03.22186+03	00:00:00.045528	
62	62	2	f	-1	2023-05-27 04:37:04.184847+03	00:00:00.039343	ОШИБКА:  повторяющееся значение ключа нарушает ограничение уникальности "products_pkey"\nDETAIL:  Ключ "(id)=(8)" уже существует.\nCONTEXT:  SQL-функция "new_product", оператор 1
\.


--
-- TOC entry 3540 (class 0 OID 33272)
-- Dependencies: 242
-- Data for Name: bicycles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bicycles (id, model, price, frame_material, frame_size, wheel_size, color, type_id, brand_id) FROM stdin;
1	Defy Advanced 2	1000.00	Карбон	16	24	красный	1	2
2	Spark	2000.00	Сталь	18	26	черный	1	1
3	Huper	3000.00	Алюминий	20	28	зеленый	2	3
4	Spark II	2500.00	Карбон	18	26	черный	1	1
\.


--
-- TOC entry 3541 (class 0 OID 33275)
-- Dependencies: 243
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brands (id, name_brands) FROM stdin;
1	Trek
2	Cannondale
3	Cube
\.


--
-- TOC entry 3545 (class 0 OID 33291)
-- Dependencies: 249
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, name, address, phone, email) FROM stdin;
3	Алексеев Алексей	ул. Гагарина, д.36, кв.25	+7 (999) 555-55-55	alekseev@gmail.com
4	Антонов Иван	ул. Пушкина, д.25, кв.4	+7 (999) 321-54-45	ivanov_a@gmail.com
2	Петров Петр	ул. Пушкина, д.54, кв.443	+7 (999) 987-65-43	petrov@gmail.com
1	Иванов Иван	ул.Ленина,д.26,кв.13	+7 (999) 123-45-67	ivanov@gmail.com
\.


--
-- TOC entry 3547 (class 0 OID 33299)
-- Dependencies: 252
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity) FROM stdin;
\.


--
-- TOC entry 3549 (class 0 OID 33303)
-- Dependencies: 254
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, client_id, date, status, total) FROM stdin;
2	1	2023-05-12 12:35:13	Доставляется	2500.00
3	1	2023-05-12 12:40:12	Завершен	1800.00
4	2	2023-05-12 11:30:25	В обработке	1200.00
5	2	2023-05-12 11:32:23	Доставляется	2200.00
6	2	2023-05-12 11:38:26	Завершен	1600.00
7	3	2023-05-12 19:32:10	В обработке	900.00
8	3	2023-05-12 19:36:23	Доставляется	1900.00
9	3	2023-05-12 19:37:00	Завершен	1300.00
22	1	2023-05-19 22:28:53.388171	В ожидании	1000.00
1	1	2023-05-27 00:00:00	В обработке	2000.00
\.


--
-- TOC entry 3539 (class 0 OID 33263)
-- Dependencies: 240
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, description, price, quantity) FROM stdin;
1	Фляга Elite Jet 	550 мл, цвет зеленый	1000.00	10
4	Велозамок Abus Bordo	Окружность складного замка в раскрытом виде составляет 90 см	4000.00	40
8	Звонок электрический	xyz	1000.00	10
3	Велозамок M-Wave	с ключом, 10 х 1100 мм.	350.00	30
5	Насос для велосипеда	Насос универсальный, ручной для велосипеда.	620.00	25
6	Набор фонарей Nova и Moon	qwerty	2800.00	15
7	Рама для велосипеда X	Рама для велосипеда X	1500.00	5
2	Продукт 2	Описание	2000.00	20
33	Товар 1	...	600.00	15
\.


--
-- TOC entry 3542 (class 0 OID 33282)
-- Dependencies: 245
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types (id, name_types) FROM stdin;
2	Горный
3	Городской
1	Спортивный
4	Дорожный 
5	Дорожный 
\.


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 247
-- Name: bicycles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bicycles_id_seq', 16, true);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 248
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brands_id_seq', 6, true);


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 250
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 10, true);


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 253
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 32, true);


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 257
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 23, true);


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 258
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 33, true);


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 259
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_id_seq', 5, true);


--
-- TOC entry 3371 (class 2606 OID 33325)
-- Name: bicycles bicycles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bicycles
    ADD CONSTRAINT bicycles_pkey PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 33327)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 33329)
-- Name: clients clients_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_key UNIQUE (email);


--
-- TOC entry 3379 (class 2606 OID 33331)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 3381 (class 2606 OID 33333)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3383 (class 2606 OID 33335)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3369 (class 2606 OID 33337)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3375 (class 2606 OID 33339)
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- TOC entry 3389 (class 2620 OID 33377)
-- Name: products check_empty_description; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_empty_description BEFORE INSERT ON public.products FOR EACH ROW EXECUTE FUNCTION public.fill_empty_description();


--
-- TOC entry 3390 (class 2620 OID 33385)
-- Name: bicycles check_low_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_low_price BEFORE INSERT OR UPDATE ON public.bicycles FOR EACH ROW EXECUTE FUNCTION public.delete_low_priced_bicycle();


--
-- TOC entry 3384 (class 2606 OID 33340)
-- Name: bicycles bicycles_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bicycles
    ADD CONSTRAINT bicycles_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- TOC entry 3385 (class 2606 OID 33345)
-- Name: bicycles bicycles_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bicycles
    ADD CONSTRAINT bicycles_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- TOC entry 3386 (class 2606 OID 33350)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- TOC entry 3387 (class 2606 OID 33355)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3388 (class 2606 OID 33360)
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 16
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO read_role;
GRANT USAGE ON SCHEMA public TO insert_role;
GRANT USAGE ON SCHEMA public TO update_role;
GRANT USAGE ON SCHEMA public TO delete_role;
GRANT USAGE ON SCHEMA public TO user_2;
GRANT USAGE ON SCHEMA public TO managers;


--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE products; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.products TO read_role;
GRANT INSERT ON TABLE public.products TO insert_role;
GRANT UPDATE ON TABLE public.products TO update_role;
GRANT DELETE ON TABLE public.products TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.products TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.products TO example_user;


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE avg_price; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.avg_price TO read_role;
GRANT INSERT ON TABLE public.avg_price TO insert_role;
GRANT UPDATE ON TABLE public.avg_price TO update_role;
GRANT DELETE ON TABLE public.avg_price TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.avg_price TO managers;


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE bicycles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.bicycles TO read_role;
GRANT INSERT ON TABLE public.bicycles TO insert_role;
GRANT UPDATE ON TABLE public.bicycles TO update_role;
GRANT DELETE ON TABLE public.bicycles TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.bicycles TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.bicycles TO example_user;


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE brands; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.brands TO read_role;
GRANT INSERT ON TABLE public.brands TO insert_role;
GRANT UPDATE ON TABLE public.brands TO update_role;
GRANT DELETE ON TABLE public.brands TO delete_role;
GRANT SELECT ON TABLE public.brands TO user_2;
GRANT SELECT,INSERT,UPDATE ON TABLE public.brands TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.brands TO example_user;


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE bicycle_brands; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.bicycle_brands TO read_role;
GRANT INSERT ON TABLE public.bicycle_brands TO insert_role;
GRANT UPDATE ON TABLE public.bicycle_brands TO update_role;
GRANT DELETE ON TABLE public.bicycle_brands TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.bicycle_brands TO managers;


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE types; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.types TO read_role;
GRANT INSERT ON TABLE public.types TO insert_role;
GRANT UPDATE ON TABLE public.types TO update_role;
GRANT DELETE ON TABLE public.types TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.types TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.types TO example_user;


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE bicycle_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.bicycle_types TO read_role;
GRANT INSERT ON TABLE public.bicycle_types TO insert_role;
GRANT UPDATE ON TABLE public.bicycle_types TO update_role;
GRANT DELETE ON TABLE public.bicycle_types TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.bicycle_types TO managers;


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE clients; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.clients TO read_role;
GRANT INSERT ON TABLE public.clients TO insert_role;
GRANT UPDATE ON TABLE public.clients TO update_role;
GRANT DELETE ON TABLE public.clients TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.clients TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clients TO example_user;


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 249 3571
-- Name: COLUMN clients.id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public.clients TO user_2;


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 249 3571
-- Name: COLUMN clients.name; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(name) ON TABLE public.clients TO user_2;


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE expensive_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.expensive_products TO read_role;
GRANT INSERT ON TABLE public.expensive_products TO insert_role;
GRANT UPDATE ON TABLE public.expensive_products TO update_role;
GRANT DELETE ON TABLE public.expensive_products TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.expensive_products TO managers;


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE order_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.order_items TO read_role;
GRANT INSERT ON TABLE public.order_items TO insert_role;
GRANT UPDATE ON TABLE public.order_items TO update_role;
GRANT DELETE ON TABLE public.order_items TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.order_items TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.order_items TO example_user;


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.orders TO read_role;
GRANT INSERT ON TABLE public.orders TO insert_role;
GRANT UPDATE ON TABLE public.orders TO update_role;
GRANT DELETE ON TABLE public.orders TO delete_role;
GRANT SELECT ON TABLE public.orders TO user_2;
GRANT SELECT,INSERT,UPDATE ON TABLE public.orders TO managers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.orders TO example_user;


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE orders_clients; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.orders_clients TO read_role;
GRANT INSERT ON TABLE public.orders_clients TO insert_role;
GRANT UPDATE ON TABLE public.orders_clients TO update_role;
GRANT DELETE ON TABLE public.orders_clients TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.orders_clients TO managers;


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE orders_clients1; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.orders_clients1 TO read_role;
GRANT INSERT ON TABLE public.orders_clients1 TO insert_role;
GRANT UPDATE ON TABLE public.orders_clients1 TO update_role;
GRANT DELETE ON TABLE public.orders_clients1 TO delete_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.orders_clients1 TO managers;


-- Completed on 2023-06-23 11:54:17

--
-- PostgreSQL database dump complete
--

