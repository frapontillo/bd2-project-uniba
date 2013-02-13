--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.2
-- Dumped by pg_dump version 9.2.2
-- Started on 2013-02-13 23:06:36 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2290 (class 1262 OID 33870)
-- Name: db2; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE db2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


ALTER DATABASE db2 OWNER TO postgres;

\connect db2

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 182 (class 3079 OID 11995)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2293 (class 0 OID 0)
-- Dependencies: 182
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 180 (class 1259 OID 33959)
-- Name: attivita; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attivita (
    id_attivita integer NOT NULL,
    nome character varying(20) NOT NULL,
    num_dip integer DEFAULT 0 NOT NULL,
    piva character varying(50) NOT NULL,
    codice character varying NOT NULL,
    franchising boolean DEFAULT false NOT NULL,
    id_struttura integer,
    piano integer,
    id_tipo_attivita integer,
    cf_dipendente_manager character varying
);


ALTER TABLE public.attivita OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 33957)
-- Name: attivita_id_attivita_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attivita_id_attivita_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attivita_id_attivita_seq OWNER TO postgres;

--
-- TOC entry 2294 (class 0 OID 0)
-- Dependencies: 179
-- Name: attivita_id_attivita_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attivita_id_attivita_seq OWNED BY attivita.id_attivita;


--
-- TOC entry 172 (class 1259 OID 33909)
-- Name: dipendente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dipendente (
    cf character varying NOT NULL,
    nome character varying NOT NULL,
    cognome character varying NOT NULL,
    sesso bit(1) NOT NULL,
    luogo_nascita character varying,
    data_nascita date
);


ALTER TABLE public.dipendente OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 33983)
-- Name: dipendenza; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dipendenza (
    cf_dipendente character varying NOT NULL,
    id_attivita integer NOT NULL,
    data_assunzione date NOT NULL,
    data_licenziamento date
);


ALTER TABLE public.dipendenza OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 33930)
-- Name: struttura; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE struttura (
    id_struttura integer NOT NULL,
    codice character varying NOT NULL,
    id_tipo_struttura integer
);


ALTER TABLE public.struttura OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 33928)
-- Name: struttura_id_struttura_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE struttura_id_struttura_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.struttura_id_struttura_seq OWNER TO postgres;

--
-- TOC entry 2295 (class 0 OID 0)
-- Dependencies: 175
-- Name: struttura_id_struttura_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE struttura_id_struttura_seq OWNED BY struttura.id_struttura;


--
-- TOC entry 178 (class 1259 OID 33948)
-- Name: tipo_attivita; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipo_attivita (
    id integer NOT NULL,
    descrizione character varying NOT NULL
);


ALTER TABLE public.tipo_attivita OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 33946)
-- Name: tipo_attivita_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tipo_attivita_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_attivita_id_seq OWNER TO postgres;

--
-- TOC entry 2296 (class 0 OID 0)
-- Dependencies: 177
-- Name: tipo_attivita_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_attivita_id_seq OWNED BY tipo_attivita.id;


--
-- TOC entry 174 (class 1259 OID 33919)
-- Name: tipo_struttura; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipo_struttura (
    id integer NOT NULL,
    descrizione character varying NOT NULL
);


ALTER TABLE public.tipo_struttura OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 33917)
-- Name: tipo_struttura_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tipo_struttura_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_struttura_id_seq OWNER TO postgres;

--
-- TOC entry 2297 (class 0 OID 0)
-- Dependencies: 173
-- Name: tipo_struttura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_struttura_id_seq OWNED BY tipo_struttura.id;


--
-- TOC entry 169 (class 1259 OID 33873)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 168 (class 1259 OID 33871)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 2298 (class 0 OID 0)
-- Dependencies: 168
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 171 (class 1259 OID 33887)
-- Name: user_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_session (
    id bigint NOT NULL,
    id_user integer NOT NULL,
    date_login date NOT NULL,
    date_logout date,
    authcode character varying NOT NULL
);


ALTER TABLE public.user_session OWNER TO postgres;

--
-- TOC entry 170 (class 1259 OID 33885)
-- Name: user_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_session_id_seq OWNER TO postgres;

--
-- TOC entry 2299 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_session_id_seq OWNED BY user_session.id;


--
-- TOC entry 2233 (class 2604 OID 33962)
-- Name: id_attivita; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita ALTER COLUMN id_attivita SET DEFAULT nextval('attivita_id_attivita_seq'::regclass);


--
-- TOC entry 2231 (class 2604 OID 33933)
-- Name: id_struttura; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura ALTER COLUMN id_struttura SET DEFAULT nextval('struttura_id_struttura_seq'::regclass);


--
-- TOC entry 2232 (class 2604 OID 33951)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_attivita ALTER COLUMN id SET DEFAULT nextval('tipo_attivita_id_seq'::regclass);


--
-- TOC entry 2230 (class 2604 OID 33922)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_struttura ALTER COLUMN id SET DEFAULT nextval('tipo_struttura_id_seq'::regclass);


--
-- TOC entry 2228 (class 2604 OID 33876)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 2229 (class 2604 OID 33890)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session ALTER COLUMN id SET DEFAULT nextval('user_session_id_seq'::regclass);


--
-- TOC entry 2284 (class 0 OID 33959)
-- Dependencies: 180
-- Data for Name: attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, cf_dipendente_manager) FROM stdin;
\.


--
-- TOC entry 2300 (class 0 OID 0)
-- Dependencies: 179
-- Name: attivita_id_attivita_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('attivita_id_attivita_seq', 1, false);


--
-- TOC entry 2276 (class 0 OID 33909)
-- Dependencies: 172
-- Data for Name: dipendente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dipendente (cf, nome, cognome, sesso, luogo_nascita, data_nascita) FROM stdin;
\.


--
-- TOC entry 2285 (class 0 OID 33983)
-- Dependencies: 181
-- Data for Name: dipendenza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dipendenza (cf_dipendente, id_attivita, data_assunzione, data_licenziamento) FROM stdin;
\.


--
-- TOC entry 2280 (class 0 OID 33930)
-- Dependencies: 176
-- Data for Name: struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY struttura (id_struttura, codice, id_tipo_struttura) FROM stdin;
\.


--
-- TOC entry 2301 (class 0 OID 0)
-- Dependencies: 175
-- Name: struttura_id_struttura_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('struttura_id_struttura_seq', 1, false);


--
-- TOC entry 2282 (class 0 OID 33948)
-- Dependencies: 178
-- Data for Name: tipo_attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_attivita (id, descrizione) FROM stdin;
\.


--
-- TOC entry 2302 (class 0 OID 0)
-- Dependencies: 177
-- Name: tipo_attivita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_attivita_id_seq', 1, false);


--
-- TOC entry 2278 (class 0 OID 33919)
-- Dependencies: 174
-- Data for Name: tipo_struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_struttura (id, descrizione) FROM stdin;
\.


--
-- TOC entry 2303 (class 0 OID 0)
-- Dependencies: 173
-- Name: tipo_struttura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_struttura_id_seq', 1, false);


--
-- TOC entry 2273 (class 0 OID 33873)
-- Dependencies: 169
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, username, password) FROM stdin;
\.


--
-- TOC entry 2304 (class 0 OID 0)
-- Dependencies: 168
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 1, false);


--
-- TOC entry 2275 (class 0 OID 33887)
-- Dependencies: 171
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_session (id, id_user, date_login, date_logout, authcode) FROM stdin;
\.


--
-- TOC entry 2305 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_session_id_seq', 1, false);


--
-- TOC entry 2253 (class 2606 OID 33940)
-- Name: cn_struttura_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT cn_struttura_unique UNIQUE (codice, id_tipo_struttura);


--
-- TOC entry 2242 (class 2606 OID 33908)
-- Name: cn_user_session_authcode; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT cn_user_session_authcode UNIQUE (authcode);


--
-- TOC entry 2237 (class 2606 OID 33883)
-- Name: cn_user_username; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT cn_user_username UNIQUE (username);


--
-- TOC entry 2262 (class 2606 OID 33967)
-- Name: pk_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT pk_attivita PRIMARY KEY (id_attivita);


--
-- TOC entry 2248 (class 2606 OID 33916)
-- Name: pk_dipendente; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendente
    ADD CONSTRAINT pk_dipendente PRIMARY KEY (cf);


--
-- TOC entry 2264 (class 2606 OID 33990)
-- Name: pk_dipendenza; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT pk_dipendenza PRIMARY KEY (cf_dipendente, id_attivita);


--
-- TOC entry 2256 (class 2606 OID 33938)
-- Name: pk_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT pk_struttura PRIMARY KEY (id_struttura);


--
-- TOC entry 2259 (class 2606 OID 33956)
-- Name: pk_tipo_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_attivita
    ADD CONSTRAINT pk_tipo_attivita PRIMARY KEY (id);


--
-- TOC entry 2251 (class 2606 OID 33927)
-- Name: pk_tipo_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT pk_tipo_struttura PRIMARY KEY (id);


--
-- TOC entry 2240 (class 2606 OID 33881)
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 2245 (class 2606 OID 33895)
-- Name: pk_user_session; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT pk_user_session PRIMARY KEY (id);


--
-- TOC entry 2260 (class 1259 OID 34024)
-- Name: ix_attivita_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_attivita_nome ON attivita USING btree (nome);


--
-- TOC entry 2246 (class 1259 OID 34025)
-- Name: ix_dipendente_cognome_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_dipendente_cognome_nome ON dipendente USING btree (cognome, nome);


--
-- TOC entry 2254 (class 1259 OID 34026)
-- Name: ix_struttura_codice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_struttura_codice ON struttura USING hash (codice);


--
-- TOC entry 2257 (class 1259 OID 34027)
-- Name: ix_tipo_attivita_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_attivita_descrizione ON tipo_attivita USING btree (descrizione);


--
-- TOC entry 2249 (class 1259 OID 34028)
-- Name: ix_tipo_struttura_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_struttura_descrizione ON tipo_struttura USING btree (descrizione);


--
-- TOC entry 2243 (class 1259 OID 33901)
-- Name: ix_user_session_authcode; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_session_authcode ON user_session USING hash (authcode);


--
-- TOC entry 2238 (class 1259 OID 34029)
-- Name: ix_user_username; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_username ON "user" USING hash (username);


--
-- TOC entry 2267 (class 2606 OID 33994)
-- Name: fk_attivita_dipendente_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_dipendente_manager FOREIGN KEY (cf_dipendente_manager) REFERENCES dipendente(cf);


--
-- TOC entry 2268 (class 2606 OID 33999)
-- Name: fk_attivita_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_struttura FOREIGN KEY (id_struttura) REFERENCES struttura(id_struttura);


--
-- TOC entry 2269 (class 2606 OID 34004)
-- Name: fk_attivita_tipo_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_tipo_attivita FOREIGN KEY (id_tipo_attivita) REFERENCES tipo_attivita(id);


--
-- TOC entry 2271 (class 2606 OID 34014)
-- Name: fk_dipendenza_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_attivita FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita);


--
-- TOC entry 2270 (class 2606 OID 34009)
-- Name: fk_dipendenza_dipendente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_dipendente FOREIGN KEY (cf_dipendente) REFERENCES dipendente(cf);


--
-- TOC entry 2266 (class 2606 OID 34019)
-- Name: fk_struttura_tipo_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT fk_struttura_tipo_struttura FOREIGN KEY (id_tipo_struttura) REFERENCES tipo_struttura(id);


--
-- TOC entry 2265 (class 2606 OID 33902)
-- Name: fk_user_session_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT fk_user_session_user FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- TOC entry 2292 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2013-02-13 23:06:37 CET

--
-- PostgreSQL database dump complete
--

