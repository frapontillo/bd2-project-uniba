--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.2
-- Dumped by pg_dump version 9.2.2
-- Started on 2013-02-14 12:53:26 CET

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
-- TOC entry 2305 (class 0 OID 0)
-- Dependencies: 182
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

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
-- TOC entry 197 (class 1255 OID 34089)
-- Name: cerca_dipendente(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cerca_dipendente(nomecognome character varying) RETURNS SETOF dipendente
    LANGUAGE sql
    AS $$
SELECT * FROM dipendente
WHERE (LOWER(nome || ' ' || cognome) LIKE LOWER('%' || nomecognome || '%'))
OR (LOWER(cognome || ' ' || nome) LIKE LOWER('%' || nomecognome || '%'))
$$;


ALTER FUNCTION public.cerca_dipendente(nomecognome character varying) OWNER TO postgres;

--
-- TOC entry 195 (class 1255 OID 34058)
-- Name: del_dipendenza(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION del_dipendenza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Se il dipendente non era stato licenziato
IF (OLD.data_licenziamento IS NULL) THEN
	-- Decremento il numero dei dipendenti
	UPDATE attivita
	SET num_dip = num_dip - 1
	WHERE attivita.id_attivita = OLD.id_attivita;
END IF;
RETURN OLD;
END;
$$;


ALTER FUNCTION public.del_dipendenza() OWNER TO postgres;

--
-- TOC entry 198 (class 1255 OID 34099)
-- Name: esiste_sessione(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION esiste_sessione(auth character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE m_session RECORD;
BEGIN
	SELECT * INTO m_session
	FROM user_session
	WHERE authcode = auth;
	IF NOT found THEN RETURN FALSE;
	ELSE RETURN TRUE;
	END IF;
END;
$$;


ALTER FUNCTION public.esiste_sessione(auth character varying) OWNER TO postgres;

--
-- TOC entry 196 (class 1255 OID 34054)
-- Name: ins_dipendenza(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins_dipendenza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Se il dipendente non è già licenziato
IF (NEW.data_licenziamento IS NULL) THEN
	-- Incremento il numero dei dipendenti
	UPDATE attivita
	SET num_dip = num_dip + 1
	WHERE attivita.id_attivita = NEW.id_attivita;
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.ins_dipendenza() OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 34060)
-- Name: upd_dipendenza(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upd_dipendenza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Se l'attività o il dipendente sono cambiati
IF (NEW.id_attivita != OLD.id_attivita OR NEW.cf_dipendente != OLD.cf_dipendente) THEN
	RAISE INFO 'Attività o dipendente modificati.';
	-- Inserisco una nuova dipendenza
	INSERT INTO dipendenza (cf_dipendente, id_attivita, data_assunzione, data_licenziamento)
	VALUES (NEW.cf_dipendente, NEW.id_attivita, NEW.data_assunzione, NEW.data_licenziamento);
	-- Termino la dipendenza corrente impostando la data di licenziamento
	-- SOLO SE la data di licenziamento è nulla
	IF (OLD.data_licenziamento IS NULL) THEN
		UPDATE dipendenza
		SET data_licenziamento = NOW()
		WHERE cf_dipendente = OLD.cf_dipendente AND id_attivita = OLD.id_attivita;
	END IF;
	-- Restituisco la vecchia riga, che non deve essere modificata
	RETURN OLD;
END IF;
RAISE INFO 'Attività e dipendente non modificati.';
RETURN NEW;
END;
$$;


ALTER FUNCTION public.upd_dipendenza() OWNER TO postgres;

--
-- TOC entry 199 (class 1255 OID 34066)
-- Name: upd_dipendenza_licenziamento(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upd_dipendenza_licenziamento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Se è cambiata la data di licenziamento
IF (NEW.data_licenziamento IS DISTINCT FROM OLD.data_licenziamento) THEN
	-- Se la nuova data di licenziamento è impostata
	IF (NEW.data_licenziamento IS NOT NULL) THEN
		RAISE INFO 'Decremento il numero dei dipendenti.';
		-- Decremento il numero dei dipendenti dell'attività
		UPDATE attivita
		SET num_dip = num_dip - 1
		WHERE attivita.id_attivita = NEW.id_attivita;
	ELSE
		RAISE INFO 'Incremento il numero dei dipendenti.';
		-- Altrimenti incremento il numero dei dipendenti dell'attività
		UPDATE attivita
		SET num_dip = num_dip + 1
		WHERE attivita.id_attivita = NEW.id_attivita;
	END IF;
END IF;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.upd_dipendenza_licenziamento() OWNER TO postgres;

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
-- TOC entry 2306 (class 0 OID 0)
-- Dependencies: 179
-- Name: attivita_id_attivita_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attivita_id_attivita_seq OWNED BY attivita.id_attivita;


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
    id_tipo_struttura integer NOT NULL
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
-- TOC entry 2307 (class 0 OID 0)
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
-- TOC entry 2308 (class 0 OID 0)
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
    descrizione character varying NOT NULL,
    codice character(1) NOT NULL
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
-- TOC entry 2309 (class 0 OID 0)
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
-- TOC entry 2310 (class 0 OID 0)
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
-- TOC entry 2311 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_session_id_seq OWNED BY user_session.id;


--
-- TOC entry 2239 (class 2604 OID 33962)
-- Name: id_attivita; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita ALTER COLUMN id_attivita SET DEFAULT nextval('attivita_id_attivita_seq'::regclass);


--
-- TOC entry 2237 (class 2604 OID 33933)
-- Name: id_struttura; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura ALTER COLUMN id_struttura SET DEFAULT nextval('struttura_id_struttura_seq'::regclass);


--
-- TOC entry 2238 (class 2604 OID 33951)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_attivita ALTER COLUMN id SET DEFAULT nextval('tipo_attivita_id_seq'::regclass);


--
-- TOC entry 2236 (class 2604 OID 33922)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_struttura ALTER COLUMN id SET DEFAULT nextval('tipo_struttura_id_seq'::regclass);


--
-- TOC entry 2234 (class 2604 OID 33876)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 2235 (class 2604 OID 33890)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session ALTER COLUMN id SET DEFAULT nextval('user_session_id_seq'::regclass);


--
-- TOC entry 2296 (class 0 OID 33959)
-- Dependencies: 180
-- Data for Name: attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, cf_dipendente_manager) FROM stdin;
1	Comics for all	1	237647389204	COMICS4ALL	f	18	\N	12	\N
2	I-Max	0	546434564	IMAX	t	13	\N	7	\N
\.


--
-- TOC entry 2312 (class 0 OID 0)
-- Dependencies: 179
-- Name: attivita_id_attivita_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('attivita_id_attivita_seq', 2, true);


--
-- TOC entry 2288 (class 0 OID 33909)
-- Dependencies: 172
-- Data for Name: dipendente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dipendente (cf, nome, cognome, sesso, luogo_nascita, data_nascita) FROM stdin;
M	Mario	Speedwagon	1	New York	1970-01-03
A	Anna	Rossi	0	Roma	1985-07-07
P	Petey	Cruiser	1	Washington	1988-04-08
\.


--
-- TOC entry 2297 (class 0 OID 33983)
-- Dependencies: 181
-- Data for Name: dipendenza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dipendenza (cf_dipendente, id_attivita, data_assunzione, data_licenziamento) FROM stdin;
M	1	2012-01-01	2013-02-14
M	2	2012-01-01	2013-02-14
P	1	2012-01-01	\N
\.


--
-- TOC entry 2292 (class 0 OID 33930)
-- Dependencies: 176
-- Data for Name: struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY struttura (id_struttura, codice, id_tipo_struttura) FROM stdin;
1	Glass Building	3
2	Prima strada	5
3	Seconda strada	5
4	Terza strada	5
7	Quarta strada	5
8	Quinta strada	5
9	Sesta strada	5
10	Oro	8
11	Fashion	8
12	Fun	8
13	Nerd	8
14	Piccadilly	7
15	Tiananmen	7
16	Place de la Concorde	7
17	Washington Square Park	7
18	The Tower	3
19	East	3
20	West	3
22	North	3
21	South	3
\.


--
-- TOC entry 2313 (class 0 OID 0)
-- Dependencies: 175
-- Name: struttura_id_struttura_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('struttura_id_struttura_seq', 22, true);


--
-- TOC entry 2294 (class 0 OID 33948)
-- Dependencies: 178
-- Data for Name: tipo_attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_attivita (id, descrizione) FROM stdin;
1	negozio di abbigliamento
2	negozio di accessori
3	negozio di scarpe
4	ristorante lucano
5	distribuzione organizzata
6	cinema
7	cinema multisala
8	ristorante
9	negozio di informatica
10	drogheria
11	bar
12	pub
13	ristorante cinese
14	fast food
15	slow food
16	concessionaria d'auto
17	gioielleria
18	negozio di fumetti
\.


--
-- TOC entry 2314 (class 0 OID 0)
-- Dependencies: 177
-- Name: tipo_attivita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_attivita_id_seq', 18, true);


--
-- TOC entry 2290 (class 0 OID 33919)
-- Dependencies: 174
-- Data for Name: tipo_struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_struttura (id, descrizione, codice) FROM stdin;
3	edificio	E
5	via	V
7	piazza	P
8	galleria	G
\.


--
-- TOC entry 2315 (class 0 OID 0)
-- Dependencies: 173
-- Name: tipo_struttura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_struttura_id_seq', 8, true);


--
-- TOC entry 2285 (class 0 OID 33873)
-- Dependencies: 169
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, username, password) FROM stdin;
2	admin	1337
\.


--
-- TOC entry 2316 (class 0 OID 0)
-- Dependencies: 168
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- TOC entry 2287 (class 0 OID 33887)
-- Dependencies: 171
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_session (id, id_user, date_login, date_logout, authcode) FROM stdin;
\.


--
-- TOC entry 2317 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_session_id_seq', 1, false);


--
-- TOC entry 2261 (class 2606 OID 33940)
-- Name: cn_struttura_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT cn_struttura_unique UNIQUE (codice, id_tipo_struttura);


--
-- TOC entry 2256 (class 2606 OID 34031)
-- Name: cn_tipo_struttura_unique_codice; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT cn_tipo_struttura_unique_codice UNIQUE (codice);


--
-- TOC entry 2248 (class 2606 OID 33908)
-- Name: cn_user_session_authcode; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT cn_user_session_authcode UNIQUE (authcode);


--
-- TOC entry 2243 (class 2606 OID 33883)
-- Name: cn_user_username; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT cn_user_username UNIQUE (username);


--
-- TOC entry 2270 (class 2606 OID 33967)
-- Name: pk_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT pk_attivita PRIMARY KEY (id_attivita);


--
-- TOC entry 2254 (class 2606 OID 33916)
-- Name: pk_dipendente; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendente
    ADD CONSTRAINT pk_dipendente PRIMARY KEY (cf);


--
-- TOC entry 2272 (class 2606 OID 34080)
-- Name: pk_dipendenza; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT pk_dipendenza PRIMARY KEY (cf_dipendente, id_attivita, data_assunzione);


--
-- TOC entry 2264 (class 2606 OID 33938)
-- Name: pk_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT pk_struttura PRIMARY KEY (id_struttura);


--
-- TOC entry 2267 (class 2606 OID 33956)
-- Name: pk_tipo_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_attivita
    ADD CONSTRAINT pk_tipo_attivita PRIMARY KEY (id);


--
-- TOC entry 2259 (class 2606 OID 33927)
-- Name: pk_tipo_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT pk_tipo_struttura PRIMARY KEY (id);


--
-- TOC entry 2246 (class 2606 OID 33881)
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 2251 (class 2606 OID 33895)
-- Name: pk_user_session; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT pk_user_session PRIMARY KEY (id);


--
-- TOC entry 2268 (class 1259 OID 34024)
-- Name: ix_attivita_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_attivita_nome ON attivita USING btree (nome);


--
-- TOC entry 2252 (class 1259 OID 34025)
-- Name: ix_dipendente_cognome_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_dipendente_cognome_nome ON dipendente USING btree (cognome, nome);


--
-- TOC entry 2262 (class 1259 OID 34026)
-- Name: ix_struttura_codice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_struttura_codice ON struttura USING hash (codice);


--
-- TOC entry 2265 (class 1259 OID 34027)
-- Name: ix_tipo_attivita_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_attivita_descrizione ON tipo_attivita USING btree (descrizione);


--
-- TOC entry 2257 (class 1259 OID 34028)
-- Name: ix_tipo_struttura_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_struttura_descrizione ON tipo_struttura USING btree (descrizione);


--
-- TOC entry 2249 (class 1259 OID 33901)
-- Name: ix_user_session_authcode; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_session_authcode ON user_session USING hash (authcode);


--
-- TOC entry 2244 (class 1259 OID 34029)
-- Name: ix_user_username; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_username ON "user" USING hash (username);


--
-- TOC entry 2281 (class 2620 OID 34059)
-- Name: del_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_dipendenza AFTER DELETE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE del_dipendenza();


--
-- TOC entry 2280 (class 2620 OID 34055)
-- Name: ins_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ins_dipendenza AFTER INSERT ON dipendenza FOR EACH ROW EXECUTE PROCEDURE ins_dipendenza();


--
-- TOC entry 2282 (class 2620 OID 34062)
-- Name: upd_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_dipendenza BEFORE UPDATE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE upd_dipendenza();


--
-- TOC entry 2283 (class 2620 OID 34068)
-- Name: upd_dipendenza_licenziamento; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_dipendenza_licenziamento BEFORE UPDATE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE upd_dipendenza_licenziamento();


--
-- TOC entry 2275 (class 2606 OID 33994)
-- Name: fk_attivita_dipendente_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_dipendente_manager FOREIGN KEY (cf_dipendente_manager) REFERENCES dipendente(cf);


--
-- TOC entry 2276 (class 2606 OID 33999)
-- Name: fk_attivita_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_struttura FOREIGN KEY (id_struttura) REFERENCES struttura(id_struttura);


--
-- TOC entry 2277 (class 2606 OID 34004)
-- Name: fk_attivita_tipo_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_tipo_attivita FOREIGN KEY (id_tipo_attivita) REFERENCES tipo_attivita(id);


--
-- TOC entry 2278 (class 2606 OID 34069)
-- Name: fk_dipendenza_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_attivita FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2279 (class 2606 OID 34074)
-- Name: fk_dipendenza_dipendente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_dipendente FOREIGN KEY (cf_dipendente) REFERENCES dipendente(cf) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2274 (class 2606 OID 34032)
-- Name: fk_struttura_tipo_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT fk_struttura_tipo_struttura FOREIGN KEY (id_tipo_struttura) REFERENCES tipo_struttura(id);


--
-- TOC entry 2273 (class 2606 OID 33902)
-- Name: fk_user_session_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT fk_user_session_user FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- TOC entry 2304 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2013-02-14 12:53:26 CET

--
-- PostgreSQL database dump complete
--

