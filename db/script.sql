--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.2
-- Dumped by pg_dump version 9.2.2
-- Started on 2013-02-20 14:37:04 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 184 (class 3079 OID 11995)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2316 (class 0 OID 0)
-- Dependencies: 184
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 168 (class 1259 OID 34504)
-- Name: dipendente_id_dipendente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dipendente_id_dipendente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dipendente_id_dipendente_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 169 (class 1259 OID 34506)
-- Name: dipendente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dipendente (
    cf character varying NOT NULL,
    nome character varying NOT NULL,
    cognome character varying NOT NULL,
    luogo_nascita character varying,
    data_nascita date,
    sesso boolean NOT NULL,
    id integer DEFAULT nextval('dipendente_id_dipendente_seq'::regclass) NOT NULL
);


ALTER TABLE public.dipendente OWNER TO postgres;

--
-- TOC entry 203 (class 1255 OID 34656)
-- Name: cerca_dipendente(character varying, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cerca_dipendente(nomecognome character varying, lim bigint, offs bigint) RETURNS SETOF dipendente
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT * FROM dipendente
WHERE (LOWER(nome || ' ' || cognome) LIKE LOWER('%' || nomecognome || '%'))
OR (LOWER(cognome || ' ' || nome) LIKE LOWER('%' || nomecognome || '%'))
ORDER BY cognome, nome
LIMIT lim OFFSET offs;
RETURN;
END;
$$;


ALTER FUNCTION public.cerca_dipendente(nomecognome character varying, lim bigint, offs bigint) OWNER TO postgres;

--
-- TOC entry 197 (class 1255 OID 34514)
-- Name: conta_cerca_dipendenti(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION conta_cerca_dipendenti(nomecognome character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE c int;
BEGIN
SELECT COUNT(*) into c FROM dipendente
WHERE (LOWER(nome || ' ' || cognome) LIKE LOWER('%' || nomecognome || '%'))
OR (LOWER(cognome || ' ' || nome) LIKE LOWER('%' || nomecognome || '%'));
RETURN c;
END;
$$;


ALTER FUNCTION public.conta_cerca_dipendenti(nomecognome character varying) OWNER TO postgres;

--
-- TOC entry 198 (class 1255 OID 34515)
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
-- TOC entry 199 (class 1255 OID 34516)
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
-- TOC entry 200 (class 1255 OID 34517)
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
-- TOC entry 201 (class 1255 OID 34518)
-- Name: upd_dipendenza(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upd_dipendenza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Se l'attività o il dipendente sono cambiati
IF (NEW.id_attivita != OLD.id_attivita OR NEW.id_dipendente != OLD.id_dipendente) THEN
	RAISE INFO 'Attività o dipendente modificati.';
	-- Inserisco una nuova dipendenza
	INSERT INTO dipendenza (id_dipendente, id_attivita, data_assunzione, data_licenziamento)
	VALUES (NEW.id_dipendente, NEW.id_attivita, NEW.data_assunzione, NEW.data_licenziamento);
	-- Termino la dipendenza corrente impostando la data di licenziamento
	-- SOLO SE la data di licenziamento è nulla
	IF (OLD.data_licenziamento IS NULL) THEN
		UPDATE dipendenza
		SET data_licenziamento = NOW()
		WHERE id_dipendente = OLD.id_dipendente AND id_attivita = OLD.id_attivita;
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
-- TOC entry 202 (class 1255 OID 34519)
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
-- TOC entry 170 (class 1259 OID 34520)
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
    id_dipendente_manager integer
);


ALTER TABLE public.attivita OWNER TO postgres;

--
-- TOC entry 171 (class 1259 OID 34528)
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
-- TOC entry 2317 (class 0 OID 0)
-- Dependencies: 171
-- Name: attivita_id_attivita_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attivita_id_attivita_seq OWNED BY attivita.id_attivita;


--
-- TOC entry 172 (class 1259 OID 34530)
-- Name: dipendenza; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dipendenza (
    id_attivita integer NOT NULL,
    data_assunzione date NOT NULL,
    data_licenziamento date,
    id bigint NOT NULL,
    id_dipendente integer NOT NULL
);


ALTER TABLE public.dipendenza OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 34533)
-- Name: dipendenza_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dipendenza_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dipendenza_id_seq OWNER TO postgres;

--
-- TOC entry 2318 (class 0 OID 0)
-- Dependencies: 173
-- Name: dipendenza_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dipendenza_id_seq OWNED BY dipendenza.id;


--
-- TOC entry 174 (class 1259 OID 34535)
-- Name: struttura; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE struttura (
    id_struttura integer NOT NULL,
    codice character varying NOT NULL,
    id_tipo_struttura integer NOT NULL
);


ALTER TABLE public.struttura OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 34541)
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
-- TOC entry 2319 (class 0 OID 0)
-- Dependencies: 175
-- Name: struttura_id_struttura_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE struttura_id_struttura_seq OWNED BY struttura.id_struttura;


--
-- TOC entry 176 (class 1259 OID 34543)
-- Name: tipo_attivita; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipo_attivita (
    id integer NOT NULL,
    descrizione character varying NOT NULL
);


ALTER TABLE public.tipo_attivita OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 34549)
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
-- TOC entry 2320 (class 0 OID 0)
-- Dependencies: 177
-- Name: tipo_attivita_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_attivita_id_seq OWNED BY tipo_attivita.id;


--
-- TOC entry 178 (class 1259 OID 34551)
-- Name: tipo_struttura; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipo_struttura (
    id integer NOT NULL,
    descrizione character varying NOT NULL,
    codice character(1) NOT NULL
);


ALTER TABLE public.tipo_struttura OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 34557)
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
-- TOC entry 2321 (class 0 OID 0)
-- Dependencies: 179
-- Name: tipo_struttura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_struttura_id_seq OWNED BY tipo_struttura.id;


--
-- TOC entry 180 (class 1259 OID 34559)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 34565)
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
-- TOC entry 2322 (class 0 OID 0)
-- Dependencies: 181
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 182 (class 1259 OID 34567)
-- Name: user_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_session (
    id bigint NOT NULL,
    id_user integer NOT NULL,
    date_login timestamp with time zone NOT NULL,
    date_logout timestamp with time zone,
    authcode character varying NOT NULL
);


ALTER TABLE public.user_session OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 34573)
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
-- TOC entry 2323 (class 0 OID 0)
-- Dependencies: 183
-- Name: user_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_session_id_seq OWNED BY user_session.id;


--
-- TOC entry 2242 (class 2604 OID 34575)
-- Name: id_attivita; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita ALTER COLUMN id_attivita SET DEFAULT nextval('attivita_id_attivita_seq'::regclass);


--
-- TOC entry 2243 (class 2604 OID 34576)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza ALTER COLUMN id SET DEFAULT nextval('dipendenza_id_seq'::regclass);


--
-- TOC entry 2244 (class 2604 OID 34577)
-- Name: id_struttura; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura ALTER COLUMN id_struttura SET DEFAULT nextval('struttura_id_struttura_seq'::regclass);


--
-- TOC entry 2245 (class 2604 OID 34578)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_attivita ALTER COLUMN id SET DEFAULT nextval('tipo_attivita_id_seq'::regclass);


--
-- TOC entry 2246 (class 2604 OID 34579)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_struttura ALTER COLUMN id SET DEFAULT nextval('tipo_struttura_id_seq'::regclass);


--
-- TOC entry 2247 (class 2604 OID 34580)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 2248 (class 2604 OID 34581)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session ALTER COLUMN id SET DEFAULT nextval('user_session_id_seq'::regclass);


--
-- TOC entry 2295 (class 0 OID 34520)
-- Dependencies: 170
-- Data for Name: attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (4, 'Champions', 3, '9509504178', 'WQLSW31', true, 6, 2, 1, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (7, 'Idea Bellezza', 6, '0947858856', 'UBLOI19', true, 1, NULL, 10, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (6, 'Gelido', 1, '8726363205', 'UIQOW24', false, 9, 1, 6, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (22, 'Sapori abruzzesi', 0, '6591548509', 'IRQDW91', false, 6, 0, 12, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (10, 'Limoni', 1, '9181581361', 'SJVRR37', true, 4, NULL, 10, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (24, 'The Bangkok', 2, '8141813704', 'GAGSP43', false, 8, NULL, 14, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (15, 'PCWorld', 2, '6274194810', 'IGXUU46', true, 9, 2, 4, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (5, 'Clear Mouse Company', 2, '0756890611', 'QWBEZ07', false, 10, 1, 7, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (16, 'Paragon Logistics', 3, '4808308924', 'EDCLW55', false, 8, NULL, 2, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (8, 'Infopan', 2, '2000365299', 'CIBCV79', false, 4, NULL, 7, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (14, 'Oviesse', 2, '8455804791', 'KOZAQ15', true, 2, NULL, 1, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (18, 'Renault', 6, '0682796642', 'JJSHH54', true, 2, NULL, 3, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (12, 'Ottica Giacoia', 3, '3280667204', 'RLNYX86', false, 7, NULL, 8, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (17, 'Pizza Hut', 5, '4998185032', 'WGRRJ50', true, 5, NULL, 9, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (9, 'Ipercoop', 5, '7925070380', 'IKHJM27', true, 2, NULL, 4, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (20, 'Mangiare', 6, '9819115108', 'NANSZ50', false, 8, NULL, 11, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (11, 'Mediaworld', 3, '0243677104', 'JWMOR50', true, 6, 1, 4, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (19, 'Senso Unico', 5, '4433700061', 'MAECW38', false, 8, NULL, 1, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (13, 'Otto', 3, '8602457118', 'TWEZT26', false, 5, NULL, 8, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (23, 'Cantina della Bruna', 3, '7452514869', 'HROVQ63', false, 2, NULL, 13, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (2, 'British Supplies', 5, '2777716853', 'BAYLO73', false, 8, NULL, 5, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (1, 'Banco Popolare', 4, '5458910213', 'HOLBM52', true, 7, NULL, 2, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (21, 'Trattoria del centro', 4, '7823060595', 'LCOHG44', false, 5, NULL, 11, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (3, 'Cardinale', 4, '6829469922', 'PBLJV10', false, 10, 0, 6, NULL);


--
-- TOC entry 2324 (class 0 OID 0)
-- Dependencies: 171
-- Name: attivita_id_attivita_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('attivita_id_attivita_seq', 24, true);


--
-- TOC entry 2294 (class 0 OID 34506)
-- Dependencies: 169
-- Data for Name: dipendente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('RIFJZA48D98K273M', 'James', 'Jenkins', 'Frederick', '1966-06-20', true, 1);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('WTRHHF45F43K666U', 'Jonas', 'Guerra', 'Saginaw', '1985-10-17', true, 2);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('VXRMJH84R12T094H', 'Dalton', 'Mitchell', 'Roanoke', '1967-11-12', true, 3);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('TVFBGW69R22L011N', 'Jin', 'Hartman', 'Hollywood', '1991-10-26', true, 4);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('ZBOFVP22X48Q268H', 'Valentine', 'Patrick', 'Waycross', '1993-12-31', true, 5);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('VJDCUF28S82C836A', 'Castor', 'Duncan', 'Del Rio', '1958-08-05', true, 6);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('LDRHUX96E93D762W', 'Ishmael', 'Johns', 'Catskill', '1954-04-02', true, 7);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('JFYRIT09U22A636Y', 'Caleb', 'Mayer', 'Vallejo', '1954-06-25', true, 8);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('UTWDWP81M36P685J', 'Bradley', 'Frederick', 'Healdsburg', '1959-08-20', true, 9);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('CCPICF77D83B609U', 'Wang', 'Langley', 'New London', '1991-01-21', true, 10);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('CZYSPQ51Z64J759B', 'Macaulay', 'Castro', 'San Bernardino', '1960-08-23', true, 11);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('LHRUJI82D88T976P', 'Gary', 'Fowler', 'Calabasas', '1956-08-01', true, 12);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('OHTAQM55O27I600L', 'Gil', 'Gonzales', 'Farrell', '1968-02-03', true, 13);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('SOBLXS49D82L575A', 'Zachery', 'Mays', 'Franklin', '1989-04-07', true, 15);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('XFZDZF64L74H403X', 'Wesley', 'Berg', 'Healdsburg', '1972-10-26', true, 16);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('WFGDRU82V87D701Y', 'Yoshio', 'Francis', 'Moraga', '1962-10-12', true, 17);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('MTJZAW03U94E864Z', 'Edan', 'Conley', 'Sunbury', '1953-03-30', true, 18);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('NATIDN32L35A824U', 'Elmo', 'Farley', 'Santa Monica', '1950-02-08', true, 19);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('SBUDGR76R18O682Z', 'Zachery', 'Rosales', 'Fullerton', '1960-02-08', true, 20);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('FGQTGL06F39A008F', 'Daquan', 'Kirk', 'Ada', '1959-03-28', true, 21);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('XECTST69S67A806P', 'Dieter', 'Burnett', 'Orangeburg', '1953-05-11', true, 22);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('ZIBXJD91J16J184W', 'Kenyon', 'Cortez', 'Little Rock', '1960-03-12', true, 23);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('PYCJZY36O67F612O', 'Hop', 'Harvey', 'Las Cruces', '1965-01-05', true, 24);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('RTRJCU25R87E362T', 'Lucius', 'Davidson', 'Centennial', '1971-11-03', true, 25);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('HUVBZM12A66M231Q', 'Isaac', 'Wiggins', 'Stevens Point', '1966-05-08', true, 26);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('AQRUUC40V13Z408L', 'Ashton', 'Erickson', 'Natchez', '1977-01-31', true, 27);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('IHFZUN39D89A856R', 'Fritz', 'Rice', 'Carolina', '1970-12-31', true, 28);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('LPGTPQ83C96S299F', 'Octavius', 'Hopkins', 'Minneapolis', '1951-08-14', true, 29);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('RPKQPH12Y50C063T', 'Clinton', 'Yates', 'New Brunswick', '1976-02-04', true, 30);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('IYDCJW09F32Z985K', 'Velma', 'Ballard', 'Del Rio', '1952-02-09', false, 31);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('BXGJGE38W55P947A', 'Shaeleigh', 'Mcdowell', 'Annapolis', '1992-03-08', false, 32);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('VVICUH93R83X821G', 'Kelsey', 'Francis', 'Northampton', '1950-04-19', false, 33);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('JEFWTD34E10E985B', 'Naomi', 'Russo', 'Williamsport', '1989-04-21', false, 34);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('AMVJJR64Y17P498I', 'Nomlanga', 'Wise', 'Oneida', '1969-05-03', false, 35);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('EDVGIU18W86V816E', 'Kaye', 'Gay', 'San Fernando', '1971-02-19', false, 36);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('ZHXTXJ77S46J581V', 'Chava', 'Wong', 'Watervliet', '1990-11-01', false, 37);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('BVTSRO83S36N394C', 'Sasha', 'Ryan', 'San Clemente', '1955-08-01', false, 38);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('ONFGXU00P20O393A', 'Madison', 'Solomon', 'Tucson', '1964-06-09', false, 39);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('XPGOCP55R33M886D', 'Quyn', 'Hopkins', 'Coral Springs', '1971-11-21', false, 40);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('WBLYPT89U47S339Y', 'Joelle', 'Madden', 'La Verne', '1964-09-21', false, 41);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('ZGVISR13V97A884T', 'Jenna', 'Daugherty', 'Muncie', '1953-01-19', false, 42);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('IABCSK46J92V846F', 'Cassandra', 'Gilbert', 'Irving', '1957-08-10', false, 43);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('NDJHEE16Y58N985A', 'Lillith', 'Wise', 'Laramie', '1958-10-11', false, 44);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('GJJMEH98M11X632Y', 'Kai', 'Jacobson', 'Bethany', '1992-11-26', false, 45);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('CKRYXP74Q34D685C', 'Zena', 'Roberson', 'Battle Creek', '1955-10-04', false, 46);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('VHEZEU34T79V834U', 'Donna', 'Branch', 'Morrison', '1957-06-16', false, 47);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('STYEWO93R91T749T', 'Madison', 'Petersen', 'Bell', '1987-02-10', false, 48);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('BLVAHS37N68C350M', 'Jocelyn', 'Miles', 'Laguna Woods', '1972-04-12', false, 49);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('VILYBF39Z96B019B', 'Jamalia', 'Melton', 'Iowa City', '1957-05-04', false, 50);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('EDABFJ62V19I927W', 'Emi', 'Wilkinson', 'Deadwood', '1973-04-05', false, 51);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('GYEYAF09H55S767T', 'Sybill', 'Bentley', 'Idaho Falls', '1974-07-13', false, 52);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('EXNBFL29H59N796S', 'Vielka', 'Vance', 'Savannah', '1964-06-29', false, 53);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('WFIKXA06U96F057E', 'Rowan', 'Campbell', 'Kemmerer', '1993-04-20', false, 54);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('ULZTYU66N65I476W', 'Maya', 'Oneill', 'Toledo', '1974-08-14', false, 55);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('GMVXRY43C35N095W', 'Tallulah', 'Frost', 'Macon', '1986-10-15', false, 56);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('NVDBDP88L44I791Q', 'Meredith', 'Bond', 'Burlington', '1960-09-06', false, 57);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('BELPSN52J45X930A', 'Kylan', 'Medina', 'Springfield', '1969-07-23', false, 58);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('IBIVJA85Q46U572C', 'Katell', 'Poole', 'Nome', '1986-05-11', false, 59);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('SCBGAA60B16X462I', 'Ashely', 'Douglas', 'Carrollton', '1982-04-17', false, 60);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('RMCMGA29Q62T255G', 'Brock', 'Aguirre', 'Shelton', '1979-11-12', true, 14);


--
-- TOC entry 2325 (class 0 OID 0)
-- Dependencies: 168
-- Name: dipendente_id_dipendente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('dipendente_id_dipendente_seq', 60, true);


--
-- TOC entry 2297 (class 0 OID 34530)
-- Dependencies: 172
-- Data for Name: dipendenza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (7, '2011-12-25', NULL, 2, 27);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (9, '2011-06-20', NULL, 3, 5);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2011-08-08', NULL, 4, 58);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2012-11-05', NULL, 5, 41);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (9, '2012-04-02', NULL, 7, 53);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (17, '2011-08-18', NULL, 9, 19);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (8, '2012-12-11', NULL, 10, 30);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (17, '2012-12-31', NULL, 11, 37);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (15, '2011-10-13', NULL, 16, 20);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (10, '2011-09-15', NULL, 17, 55);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2012-10-10', NULL, 18, 46);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (18, '2011-02-19', NULL, 20, 45);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (24, '2011-06-21', NULL, 22, 37);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (15, '2011-12-22', NULL, 23, 46);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2012-10-14', NULL, 25, 58);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (14, '2012-03-27', NULL, 27, 17);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (7, '2011-04-04', NULL, 28, 44);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (7, '2011-07-10', NULL, 30, 37);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (23, '2012-03-25', NULL, 32, 36);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2011-01-07', NULL, 33, 41);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (9, '2011-03-24', NULL, 34, 48);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (13, '2011-01-04', NULL, 36, 32);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2011-02-23', NULL, 37, 31);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (18, '2011-04-04', NULL, 41, 23);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (3, '2012-07-17', NULL, 42, 20);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2012-10-22', NULL, 44, 6);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (17, '2011-10-16', NULL, 46, 33);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (8, '2012-11-13', NULL, 49, 30);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (14, '2011-07-29', NULL, 51, 21);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (18, '2012-07-03', NULL, 54, 7);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (12, '2012-07-04', NULL, 56, 45);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (17, '2012-10-19', NULL, 64, 7);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (17, '2011-04-22', NULL, 66, 2);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (21, '2012-06-03', NULL, 67, 47);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (9, '2011-05-28', NULL, 68, 43);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2012-02-05', NULL, 72, 9);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (23, '2012-12-16', NULL, 75, 58);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2011-10-07', NULL, 76, 23);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (3, '2012-08-03', NULL, 77, 55);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2011-01-21', NULL, 78, 55);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (21, '2011-09-10', NULL, 79, 45);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2012-02-05', NULL, 8, 3);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (18, '2012-05-01', NULL, 14, 34);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (7, '2012-08-19', NULL, 21, 43);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (18, '2012-10-12', NULL, 26, 46);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (11, '2012-08-22', NULL, 29, 59);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (7, '2012-05-23', NULL, 35, 5);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (4, '2012-01-19', NULL, 38, 23);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (16, '2012-10-31', NULL, 40, 21);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (16, '2012-08-01', NULL, 43, 22);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (6, '2012-10-27', NULL, 47, 38);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (4, '2012-03-10', NULL, 48, 2);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2012-02-07', NULL, 50, 35);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (3, '2012-05-25', NULL, 52, 21);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (1, '2012-10-04', NULL, 55, 21);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (23, '2012-07-19', NULL, 59, 7);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (12, '2012-04-28', NULL, 60, 17);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2012-06-02', NULL, 62, 41);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2012-04-27', NULL, 63, 58);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (12, '2012-10-18', NULL, 65, 31);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (1, '2012-01-07', NULL, 69, 6);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2012-03-29', NULL, 70, 1);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (11, '2012-11-02', NULL, 71, 18);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (21, '2012-04-12', NULL, 73, 50);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (13, '2012-03-04', NULL, 74, 49);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (1, '2012-01-06', NULL, 80, 20);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (5, '2012-02-15', NULL, 1, 10);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (13, '2012-01-13', NULL, 12, 30);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (4, '2012-03-21', NULL, 15, 14);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (24, '2012-06-13', NULL, 19, 36);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (16, '2012-03-22', NULL, 24, 16);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (5, '2012-03-17', NULL, 31, 54);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (7, '2012-01-13', NULL, 39, 47);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (9, '2012-06-06', NULL, 45, 20);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (18, '2012-05-25', NULL, 57, 35);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2012-04-01', NULL, 58, 22);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (11, '2012-03-12', NULL, 61, 10);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (4, '2011-05-07', '2011-12-07', 13, 12);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (1, '2012-12-29', NULL, 6, 14);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (21, '2012-01-23', NULL, 53, 14);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (3, '2013-02-19', NULL, 81, 14);


--
-- TOC entry 2326 (class 0 OID 0)
-- Dependencies: 173
-- Name: dipendenza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('dipendenza_id_seq', 81, true);


--
-- TOC entry 2299 (class 0 OID 34535)
-- Dependencies: 174
-- Data for Name: struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (1, 'Dolan Plaza', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (2, 'Sequola Square', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (3, 'Keshan Road', 4);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (4, 'East Poppy Avenue', 4);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (5, 'Barbarian''s Tunnel', 2);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (6, 'Gnomes'' Tower', 1);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (7, 'Passage of Skeletons', 2);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (8, 'Plaza of Confusion', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (9, 'Crimson Turret', 1);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (10, 'Tower of Sigils', 1);


--
-- TOC entry 2327 (class 0 OID 0)
-- Dependencies: 175
-- Name: struttura_id_struttura_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('struttura_id_struttura_seq', 10, true);


--
-- TOC entry 2301 (class 0 OID 34543)
-- Dependencies: 176
-- Data for Name: tipo_attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipo_attivita (id, descrizione) VALUES (1, 'Abbigliamento');
INSERT INTO tipo_attivita (id, descrizione) VALUES (2, 'Banca');
INSERT INTO tipo_attivita (id, descrizione) VALUES (3, 'Concessionaria');
INSERT INTO tipo_attivita (id, descrizione) VALUES (4, 'Distr. Org.');
INSERT INTO tipo_attivita (id, descrizione) VALUES (5, 'Ferramenta');
INSERT INTO tipo_attivita (id, descrizione) VALUES (6, 'Gelateria');
INSERT INTO tipo_attivita (id, descrizione) VALUES (7, 'Informatica');
INSERT INTO tipo_attivita (id, descrizione) VALUES (8, 'Ottica');
INSERT INTO tipo_attivita (id, descrizione) VALUES (9, 'Pizzeria');
INSERT INTO tipo_attivita (id, descrizione) VALUES (10, 'Profumeria');
INSERT INTO tipo_attivita (id, descrizione) VALUES (11, 'Ristorante');
INSERT INTO tipo_attivita (id, descrizione) VALUES (12, 'Ristorante abruzzese');
INSERT INTO tipo_attivita (id, descrizione) VALUES (13, 'Ristorante lucano');
INSERT INTO tipo_attivita (id, descrizione) VALUES (14, 'Ristorante thailandese');


--
-- TOC entry 2328 (class 0 OID 0)
-- Dependencies: 177
-- Name: tipo_attivita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_attivita_id_seq', 14, true);


--
-- TOC entry 2303 (class 0 OID 34551)
-- Dependencies: 178
-- Data for Name: tipo_struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (1, 'Edificio', 'E');
INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (2, 'Galleria', 'G');
INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (3, 'Piazza', 'P');
INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (4, 'Via', 'V');


--
-- TOC entry 2329 (class 0 OID 0)
-- Dependencies: 179
-- Name: tipo_struttura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_struttura_id_seq', 4, true);


--
-- TOC entry 2305 (class 0 OID 34559)
-- Dependencies: 180
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "user" (id, username, password) VALUES (1, 'admin', 'b1487b31aa21e263a6d454d7d8e0100b12fa41811d5bf6e3a31d2dbf197ead30');


--
-- TOC entry 2330 (class 0 OID 0)
-- Dependencies: 181
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- TOC entry 2307 (class 0 OID 34567)
-- Dependencies: 182
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (1, 1, '2013-02-19 12:07:13.475+01', NULL, 'a6da1ee97fb05a635644055ad0b0a1c463fe3f3481224245c22c8f0391374188');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (2, 1, '2013-02-19 12:14:43.883+01', NULL, 'f6d7ecbdd980b81933a899255f4feeef1df1a8911a9dcb1cdd087832b37ffb2e');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (3, 1, '2013-02-19 12:15:42.562+01', NULL, '5779e0f57d4839498ed246b293d27d1681287f52b1f96cd69bb88b05baeb28ed');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (4, 1, '2013-02-19 12:15:49.286+01', NULL, 'c3302327d03300fa33e779be82338baba482c1e845841e9ffc2f7fac67bde40d');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (6, 1, '2013-02-19 12:16:56.601+01', NULL, 'a75974446adc67c1769f1db251e5a84d6e8dfcb0e093271a9542d93aaa5dc4b8');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (8, 1, '2013-02-19 20:17:14.945+01', NULL, '8172d92064287f7df4d1e243d76990708618ebd7cee519dacee3c2377832dcd9');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (9, 1, '2013-02-19 20:17:23.286+01', NULL, '8953b2747fa6fd9f217fa0b836e606d7f1f37f65ff36fe89f8df1ca64b99bd32');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (10, 1, '2013-02-19 20:17:48.078+01', NULL, '2691ba3fe1ad683db80c6a6b5e2aa8f28b3450d6dfa5683cea72bddbdf3f67ad');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (11, 1, '2013-02-19 20:20:14.388+01', NULL, 'c4f77f45bf9f6b831c9ae40fea7c5c050a376e46fa813411ede251177035ac74');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (13, 1, '2013-02-19 20:30:28.243+01', NULL, 'd506a1d7229356e006b345835adf2c50d9fa9fcd070a000b3597f1db6cdfd9c3');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (14, 1, '2013-02-19 20:30:33.891+01', NULL, 'e948d3fd6d10e1a3e7f0a6a7dc8280cdc3f3581bd2fa37b5523e43cedd911538');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (15, 1, '2013-02-19 20:34:15.686+01', NULL, 'f73f064d317cc5497b9122ca1a318641b4cb778fbd24779c649c6f374b815801');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (16, 1, '2013-02-19 20:34:24.429+01', NULL, 'd55a6814674d246ea15b75a893681ec3e2fa8fa0fed27c5d1d938385db832161');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (17, 1, '2013-02-20 14:33:47.521+01', NULL, '0be89d821904a82d3be2e9a6fb227f94b08e24126cd7d5af3bf2227d1addb2df');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (18, 1, '2013-02-20 14:34:29.054+01', NULL, '953a8dbc90f4b23030913934fcb89af2286b6da0c521772c35965245d89c19ec');


--
-- TOC entry 2331 (class 0 OID 0)
-- Dependencies: 183
-- Name: user_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_session_id_seq', 18, true);


--
-- TOC entry 2260 (class 2606 OID 34583)
-- Name: cn_struttura_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT cn_struttura_unique UNIQUE (codice, id_tipo_struttura);


--
-- TOC entry 2268 (class 2606 OID 34585)
-- Name: cn_tipo_struttura_unique_codice; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT cn_tipo_struttura_unique_codice UNIQUE (codice);


--
-- TOC entry 2278 (class 2606 OID 34587)
-- Name: cn_user_session_authcode; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT cn_user_session_authcode UNIQUE (authcode);


--
-- TOC entry 2273 (class 2606 OID 34589)
-- Name: cn_user_username; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT cn_user_username UNIQUE (username);


--
-- TOC entry 2254 (class 2606 OID 34591)
-- Name: pk_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT pk_attivita PRIMARY KEY (id_attivita);


--
-- TOC entry 2251 (class 2606 OID 34593)
-- Name: pk_dipendente; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendente
    ADD CONSTRAINT pk_dipendente PRIMARY KEY (id);


--
-- TOC entry 2256 (class 2606 OID 34595)
-- Name: pk_dipendenza; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT pk_dipendenza PRIMARY KEY (id);


--
-- TOC entry 2263 (class 2606 OID 34597)
-- Name: pk_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT pk_struttura PRIMARY KEY (id_struttura);


--
-- TOC entry 2266 (class 2606 OID 34599)
-- Name: pk_tipo_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_attivita
    ADD CONSTRAINT pk_tipo_attivita PRIMARY KEY (id);


--
-- TOC entry 2271 (class 2606 OID 34601)
-- Name: pk_tipo_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT pk_tipo_struttura PRIMARY KEY (id);


--
-- TOC entry 2276 (class 2606 OID 34603)
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 2281 (class 2606 OID 34605)
-- Name: pk_user_session; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT pk_user_session PRIMARY KEY (id);


--
-- TOC entry 2258 (class 2606 OID 34607)
-- Name: un_dipendenza_dipendente_attivita_assunzione; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT un_dipendenza_dipendente_attivita_assunzione UNIQUE (id_attivita, data_assunzione, id_dipendente);


--
-- TOC entry 2252 (class 1259 OID 34608)
-- Name: ix_attivita_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_attivita_nome ON attivita USING btree (nome);


--
-- TOC entry 2249 (class 1259 OID 34609)
-- Name: ix_dipendente_cognome_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_dipendente_cognome_nome ON dipendente USING btree (cognome, nome);


--
-- TOC entry 2261 (class 1259 OID 34655)
-- Name: ix_struttura_codice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_struttura_codice ON struttura USING btree (codice);


--
-- TOC entry 2264 (class 1259 OID 34611)
-- Name: ix_tipo_attivita_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_attivita_descrizione ON tipo_attivita USING btree (descrizione);


--
-- TOC entry 2269 (class 1259 OID 34612)
-- Name: ix_tipo_struttura_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_struttura_descrizione ON tipo_struttura USING btree (descrizione);


--
-- TOC entry 2279 (class 1259 OID 34613)
-- Name: ix_user_session_authcode; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_session_authcode ON user_session USING hash (authcode);


--
-- TOC entry 2274 (class 1259 OID 34614)
-- Name: ix_user_username; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_username ON "user" USING hash (username);


--
-- TOC entry 2289 (class 2620 OID 34615)
-- Name: del_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_dipendenza AFTER DELETE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE del_dipendenza();


--
-- TOC entry 2290 (class 2620 OID 34616)
-- Name: ins_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ins_dipendenza AFTER INSERT ON dipendenza FOR EACH ROW EXECUTE PROCEDURE ins_dipendenza();


--
-- TOC entry 2291 (class 2620 OID 34617)
-- Name: upd_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_dipendenza BEFORE UPDATE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE upd_dipendenza();


--
-- TOC entry 2292 (class 2620 OID 34618)
-- Name: upd_dipendenza_licenziamento; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_dipendenza_licenziamento BEFORE UPDATE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE upd_dipendenza_licenziamento();


--
-- TOC entry 2282 (class 2606 OID 34619)
-- Name: fk_attivita_dipendente_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_dipendente_manager FOREIGN KEY (id_dipendente_manager) REFERENCES dipendente(id);


--
-- TOC entry 2283 (class 2606 OID 34624)
-- Name: fk_attivita_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_struttura FOREIGN KEY (id_struttura) REFERENCES struttura(id_struttura);


--
-- TOC entry 2284 (class 2606 OID 34629)
-- Name: fk_attivita_tipo_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_tipo_attivita FOREIGN KEY (id_tipo_attivita) REFERENCES tipo_attivita(id);


--
-- TOC entry 2285 (class 2606 OID 34634)
-- Name: fk_dipendenza_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_attivita FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2286 (class 2606 OID 34639)
-- Name: fk_dipendenza_dipendente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_dipendente FOREIGN KEY (id_dipendente) REFERENCES dipendente(id);


--
-- TOC entry 2287 (class 2606 OID 34644)
-- Name: fk_struttura_tipo_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT fk_struttura_tipo_struttura FOREIGN KEY (id_tipo_struttura) REFERENCES tipo_struttura(id);


--
-- TOC entry 2288 (class 2606 OID 34649)
-- Name: fk_user_session_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT fk_user_session_user FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- TOC entry 2315 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2013-02-20 14:37:05 CET

--
-- PostgreSQL database dump complete
--

