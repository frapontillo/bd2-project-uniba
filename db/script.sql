--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.2
-- Dumped by pg_dump version 9.2.2
-- Started on 2013-02-18 16:37:26 CET

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
-- TOC entry 183 (class 1259 OID 34258)
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
-- TOC entry 172 (class 1259 OID 33909)
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
-- TOC entry 203 (class 1255 OID 34185)
-- Name: cerca_dipendente(character varying, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cerca_dipendente(nomecognome character varying, lim bigint, offs bigint) RETURNS SETOF dipendente
    LANGUAGE sql
    AS $$
SELECT * FROM dipendente
WHERE (LOWER(nome || ' ' || cognome) LIKE LOWER('%' || nomecognome || '%'))
OR (LOWER(cognome || ' ' || nome) LIKE LOWER('%' || nomecognome || '%'))
ORDER BY cognome, nome
LIMIT lim OFFSET offs;
$$;


ALTER FUNCTION public.cerca_dipendente(nomecognome character varying, lim bigint, offs bigint) OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 34164)
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
-- TOC entry 197 (class 1255 OID 34058)
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
-- TOC entry 199 (class 1255 OID 34099)
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
-- TOC entry 198 (class 1255 OID 34054)
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
-- TOC entry 202 (class 1255 OID 34060)
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
-- TOC entry 201 (class 1255 OID 34066)
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
    id_dipendente_manager integer
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
-- TOC entry 2317 (class 0 OID 0)
-- Dependencies: 179
-- Name: attivita_id_attivita_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attivita_id_attivita_seq OWNED BY attivita.id_attivita;


--
-- TOC entry 181 (class 1259 OID 33983)
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
-- TOC entry 182 (class 1259 OID 34132)
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
-- Dependencies: 182
-- Name: dipendenza_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dipendenza_id_seq OWNED BY dipendenza.id;


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
-- TOC entry 2319 (class 0 OID 0)
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
-- TOC entry 2320 (class 0 OID 0)
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
-- TOC entry 2321 (class 0 OID 0)
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
-- TOC entry 2322 (class 0 OID 0)
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
    date_login timestamp with time zone NOT NULL,
    date_logout timestamp with time zone,
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
-- TOC entry 2323 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_session_id_seq OWNED BY user_session.id;


--
-- TOC entry 2245 (class 2604 OID 33962)
-- Name: id_attivita; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita ALTER COLUMN id_attivita SET DEFAULT nextval('attivita_id_attivita_seq'::regclass);


--
-- TOC entry 2248 (class 2604 OID 34134)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza ALTER COLUMN id SET DEFAULT nextval('dipendenza_id_seq'::regclass);


--
-- TOC entry 2243 (class 2604 OID 33933)
-- Name: id_struttura; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura ALTER COLUMN id_struttura SET DEFAULT nextval('struttura_id_struttura_seq'::regclass);


--
-- TOC entry 2244 (class 2604 OID 33951)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_attivita ALTER COLUMN id SET DEFAULT nextval('tipo_attivita_id_seq'::regclass);


--
-- TOC entry 2242 (class 2604 OID 33922)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_struttura ALTER COLUMN id SET DEFAULT nextval('tipo_struttura_id_seq'::regclass);


--
-- TOC entry 2239 (class 2604 OID 33876)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 2240 (class 2604 OID 33890)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session ALTER COLUMN id SET DEFAULT nextval('user_session_id_seq'::regclass);


--
-- TOC entry 2305 (class 0 OID 33959)
-- Dependencies: 180
-- Data for Name: attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (1, 'Comics 4 All', 0, '34567432', 'COMICS4ALL', true, 13, NULL, 18, 6);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (19, 'Fun Fun Fun!!!', 1, '1234567', 'FUN2', false, 12, NULL, 18, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (23, 'Apple Store', 1, '4290293', 'AAPL', true, 14, NULL, 9, 1);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (24, 'Art Y', 0, '768796', 'RTY', true, 1, 11, 2, NULL);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (20, 'Revenge of the Nerds', 0, '1337', 'NERDZ', false, 13, NULL, 9, 6);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (2, 'I-Maxx', 2, '546434564eee', 'IMAX2', true, 13, NULL, 7, 7);
INSERT INTO attivita (id_attivita, nome, num_dip, piva, codice, franchising, id_struttura, piano, id_tipo_attivita, id_dipendente_manager) VALUES (10, 'Ipercoop', 1, '456789', 'IPRCP', true, 2, NULL, 5, 5);


--
-- TOC entry 2324 (class 0 OID 0)
-- Dependencies: 179
-- Name: attivita_id_attivita_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('attivita_id_attivita_seq', 24, true);


--
-- TOC entry 2297 (class 0 OID 33909)
-- Dependencies: 172
-- Data for Name: dipendente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('RDFGBHN', 'Mario', 'Rossino', 'Matera', '1990-01-30', true, 1);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('PNTVTI', 'Vito', 'Pontillo', 'Altamura (BA)', '1990-03-23', true, 5);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('tryu', 'Giovanni', 'Verdi', 'Roma', '2013-02-17', true, 3);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('yuiop', 'Giovanna', 'Bianchi', 'Bari', '2013-02-05', false, 7);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('rtyj', 'Francesco', 'Pontillo', 'Altamura (BA)', '1988-10-10', true, 6);
INSERT INTO dipendente (cf, nome, cognome, luogo_nascita, data_nascita, sesso, id) VALUES ('4567890', 'Caia', 'Tizia', 'Altamura', NULL, false, 9);


--
-- TOC entry 2325 (class 0 OID 0)
-- Dependencies: 183
-- Name: dipendente_id_dipendente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('dipendente_id_dipendente_seq', 10, true);


--
-- TOC entry 2306 (class 0 OID 33983)
-- Dependencies: 181
-- Data for Name: dipendenza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (10, '2013-02-06', '2013-03-05', 16, 7);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (10, '2013-02-07', NULL, 18, 7);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2013-01-01', '2013-01-30', 20, 6);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2013-02-02', NULL, 22, 9);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (19, '2013-02-15', NULL, 23, 3);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (23, '2013-02-18', NULL, 25, 9);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (20, '2013-02-05', '2013-01-31', 14, 6);
INSERT INTO dipendenza (id_attivita, data_assunzione, data_licenziamento, id, id_dipendente) VALUES (2, '2013-02-07', NULL, 21, 7);


--
-- TOC entry 2326 (class 0 OID 0)
-- Dependencies: 182
-- Name: dipendenza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('dipendenza_id_seq', 25, true);


--
-- TOC entry 2301 (class 0 OID 33930)
-- Dependencies: 176
-- Data for Name: struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (1, 'Glass Building', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (2, 'Prima strada', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (3, 'Seconda strada', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (4, 'Terza strada', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (7, 'Quarta strada', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (8, 'Quinta strada', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (10, 'Oro', 8);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (14, 'Piccadilly', 7);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (15, 'Tiananmen', 7);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (16, 'Place de la Concorde', 7);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (17, 'Washington Square Park', 7);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (18, 'The Tower', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (20, 'West', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (21, 'South', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (9, 'Sesta strada!', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (11, 'East Side', 8);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (23, 'Whop whop!', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (22, 'North', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (24, 'Gangnam Style', 5);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (26, 'Twisted B', 3);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (13, 'Nerdz', 8);
INSERT INTO struttura (id_struttura, codice, id_tipo_struttura) VALUES (12, 'Fun', 7);


--
-- TOC entry 2327 (class 0 OID 0)
-- Dependencies: 175
-- Name: struttura_id_struttura_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('struttura_id_struttura_seq', 26, true);


--
-- TOC entry 2303 (class 0 OID 33948)
-- Dependencies: 178
-- Data for Name: tipo_attivita; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipo_attivita (id, descrizione) VALUES (1, 'negozio di abbigliamento');
INSERT INTO tipo_attivita (id, descrizione) VALUES (2, 'negozio di accessori');
INSERT INTO tipo_attivita (id, descrizione) VALUES (3, 'negozio di scarpe');
INSERT INTO tipo_attivita (id, descrizione) VALUES (4, 'ristorante lucano');
INSERT INTO tipo_attivita (id, descrizione) VALUES (5, 'distribuzione organizzata');
INSERT INTO tipo_attivita (id, descrizione) VALUES (6, 'cinema');
INSERT INTO tipo_attivita (id, descrizione) VALUES (7, 'cinema multisala');
INSERT INTO tipo_attivita (id, descrizione) VALUES (8, 'ristorante');
INSERT INTO tipo_attivita (id, descrizione) VALUES (9, 'negozio di informatica');
INSERT INTO tipo_attivita (id, descrizione) VALUES (10, 'drogheria');
INSERT INTO tipo_attivita (id, descrizione) VALUES (11, 'bar');
INSERT INTO tipo_attivita (id, descrizione) VALUES (12, 'pub');
INSERT INTO tipo_attivita (id, descrizione) VALUES (13, 'ristorante cinese');
INSERT INTO tipo_attivita (id, descrizione) VALUES (14, 'fast food');
INSERT INTO tipo_attivita (id, descrizione) VALUES (15, 'slow food');
INSERT INTO tipo_attivita (id, descrizione) VALUES (16, 'concessionaria d''auto');
INSERT INTO tipo_attivita (id, descrizione) VALUES (17, 'gioielleria');
INSERT INTO tipo_attivita (id, descrizione) VALUES (18, 'negozio di fumetti');


--
-- TOC entry 2328 (class 0 OID 0)
-- Dependencies: 177
-- Name: tipo_attivita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_attivita_id_seq', 18, true);


--
-- TOC entry 2299 (class 0 OID 33919)
-- Dependencies: 174
-- Data for Name: tipo_struttura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (3, 'edificio', 'E');
INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (5, 'via', 'V');
INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (7, 'piazza', 'P');
INSERT INTO tipo_struttura (id, descrizione, codice) VALUES (8, 'galleria', 'G');


--
-- TOC entry 2329 (class 0 OID 0)
-- Dependencies: 173
-- Name: tipo_struttura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_struttura_id_seq', 8, true);


--
-- TOC entry 2294 (class 0 OID 33873)
-- Dependencies: 169
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "user" (id, username, password) VALUES (2, 'admin', 'b1487b31aa21e263a6d454d7d8e0100b12fa41811d5bf6e3a31d2dbf197ead30');


--
-- TOC entry 2330 (class 0 OID 0)
-- Dependencies: 168
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- TOC entry 2296 (class 0 OID 33887)
-- Dependencies: 171
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (2, 2, '2013-02-15 00:00:00+01', NULL, '9aa54d07e4ca6148438ca89946cd5289b3713204fd0ec0ef2cd046e87b456c26');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (3, 2, '2013-02-15 00:00:00+01', NULL, 'c3cc786653eded26bceb2d6c85f38c4cd49380f100b122b6c256b9073dbae20b');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (5, 2, '2013-02-15 19:12:35.794+01', NULL, 'd0d53fe611bf51e99b35ba70837651fd36879c286ab7b0fa127973bfeb2adcce');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (6, 2, '2013-02-15 19:13:40.987+01', NULL, 'f4a65106cb5ddb30bb38082d9a13b24d278f38ba82e7c6df0e57bafeb265313c');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (7, 2, '2013-02-15 19:23:27.399+01', NULL, '67123668583b6a4f70ce3b279979cc48bbfbb7f0468811ffc21f1d513d6711f3');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (8, 2, '2013-02-15 19:23:46.625+01', NULL, '154816946c48ee483bb23c7dfc40cf77665e5943eebe333ccadeec6d47618383');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (9, 2, '2013-02-15 20:26:01.148+01', NULL, 'b7879246b0b95fb07c4aea4be29c5048564aa7ddc0633dfaff61919a71561e08');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (10, 2, '2013-02-15 20:26:26.737+01', NULL, 'c533ebdb06c4e09092bc4f742dfdbe60b432e4971dc5c8389bff28579231360d');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (11, 2, '2013-02-15 20:26:48.927+01', NULL, '2cf676a10d0b61467a6f5bac820261d2e92e9706cee3ffa79fcb850edb2497fd');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (12, 2, '2013-02-15 20:34:48.737+01', NULL, 'd80eb795a7aabe6ce13af0c03d074eed536984befd0ab570ff2bc6e21de5e959');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (13, 2, '2013-02-15 20:35:14.625+01', NULL, '60b81f53a4a2def8a5013054cfe5e69325d73b668dc8aaeb4233b3aa8c7750f6');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (14, 2, '2013-02-15 20:35:59.516+01', NULL, '214d77a19f0995c4477fa97d575948f31f0396d2753356540d91cede207385b6');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (15, 2, '2013-02-15 20:37:37.012+01', NULL, '3343160fb6d02b2385ce07515e73b9493a2368168c11bb23544f29acce8ef21b');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (18, 2, '2013-02-15 20:44:24.766+01', NULL, 'a4c137a6812d4501057e90044fff93b91c3407a4ca339f9a815979b59118288a');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (21, 2, '2013-02-15 20:45:47.949+01', NULL, 'bd5c0203ac39530afb1c6b9f16f2996972ef446ada5e4522fdc2240859e021da');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (1, 2, '2013-02-15 00:00:00+01', NULL, '1337');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (22, 2, '2013-02-16 10:41:29.657+01', NULL, '32a9258cffdda638443e5a7c01c827f182323cb0b46c0fc1c5c35f00e912c6ec');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (23, 2, '2013-02-16 17:25:43.604+01', NULL, '0e888f3bbee7fb36aa3d32b021acbfbac538cc93c2540a3b65f10c8b3ad33dff');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (24, 2, '2013-02-16 17:59:30.769+01', NULL, 'f289b02372ae4016a7c167da06f1ca9b52bf4f1e47ac16080dcca7905caaf2e2');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (25, 2, '2013-02-16 18:26:27.146+01', NULL, '78dee5535a2f594c191423f47f706604cf459086d36e4ac3b540d1a9dfce645b');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (26, 2, '2013-02-16 18:26:43.824+01', NULL, '3b7e7b437b7bf47ea9f483e5c152ba6f6220b2edcd4315f5d3fba9083e7373fa');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (29, 2, '2013-02-17 02:36:58.41+01', NULL, '667d83bfadf9f9f44d77db8349781f2afa511e5d7c747768ed1bb0bc194ea65b');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (33, 2, '2013-02-17 12:03:16.655+01', NULL, '72bd67d9101a9267c9634be47958006c362fba494c711553f4f2a2b32b2c0a9d');
INSERT INTO user_session (id, id_user, date_login, date_logout, authcode) VALUES (35, 2, '2013-02-17 23:56:44.546+01', NULL, 'acd2e4f01b73b2d7a543adc8baa69b0bbb5901a9bbe63d3f7233853f64053cb2');


--
-- TOC entry 2331 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_session_id_seq', 35, true);


--
-- TOC entry 2268 (class 2606 OID 33940)
-- Name: cn_struttura_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT cn_struttura_unique UNIQUE (codice, id_tipo_struttura);


--
-- TOC entry 2263 (class 2606 OID 34031)
-- Name: cn_tipo_struttura_unique_codice; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT cn_tipo_struttura_unique_codice UNIQUE (codice);


--
-- TOC entry 2255 (class 2606 OID 33908)
-- Name: cn_user_session_authcode; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT cn_user_session_authcode UNIQUE (authcode);


--
-- TOC entry 2250 (class 2606 OID 33883)
-- Name: cn_user_username; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT cn_user_username UNIQUE (username);


--
-- TOC entry 2277 (class 2606 OID 33967)
-- Name: pk_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT pk_attivita PRIMARY KEY (id_attivita);


--
-- TOC entry 2261 (class 2606 OID 34225)
-- Name: pk_dipendente; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendente
    ADD CONSTRAINT pk_dipendente PRIMARY KEY (id);


--
-- TOC entry 2279 (class 2606 OID 34153)
-- Name: pk_dipendenza; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT pk_dipendenza PRIMARY KEY (id);


--
-- TOC entry 2271 (class 2606 OID 33938)
-- Name: pk_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT pk_struttura PRIMARY KEY (id_struttura);


--
-- TOC entry 2274 (class 2606 OID 33956)
-- Name: pk_tipo_attivita; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_attivita
    ADD CONSTRAINT pk_tipo_attivita PRIMARY KEY (id);


--
-- TOC entry 2266 (class 2606 OID 33927)
-- Name: pk_tipo_struttura; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipo_struttura
    ADD CONSTRAINT pk_tipo_struttura PRIMARY KEY (id);


--
-- TOC entry 2253 (class 2606 OID 33881)
-- Name: pk_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- TOC entry 2258 (class 2606 OID 33895)
-- Name: pk_user_session; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT pk_user_session PRIMARY KEY (id);


--
-- TOC entry 2281 (class 2606 OID 34242)
-- Name: un_dipendenza_dipendente_attivita_assunzione; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT un_dipendenza_dipendente_attivita_assunzione UNIQUE (id_attivita, data_assunzione, id_dipendente);


--
-- TOC entry 2275 (class 1259 OID 34024)
-- Name: ix_attivita_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_attivita_nome ON attivita USING btree (nome);


--
-- TOC entry 2259 (class 1259 OID 34025)
-- Name: ix_dipendente_cognome_nome; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_dipendente_cognome_nome ON dipendente USING btree (cognome, nome);


--
-- TOC entry 2269 (class 1259 OID 34026)
-- Name: ix_struttura_codice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_struttura_codice ON struttura USING hash (codice);


--
-- TOC entry 2272 (class 1259 OID 34027)
-- Name: ix_tipo_attivita_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_attivita_descrizione ON tipo_attivita USING btree (descrizione);


--
-- TOC entry 2264 (class 1259 OID 34028)
-- Name: ix_tipo_struttura_descrizione; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_tipo_struttura_descrizione ON tipo_struttura USING btree (descrizione);


--
-- TOC entry 2256 (class 1259 OID 33901)
-- Name: ix_user_session_authcode; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_session_authcode ON user_session USING hash (authcode);


--
-- TOC entry 2251 (class 1259 OID 34029)
-- Name: ix_user_username; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ix_user_username ON "user" USING hash (username);


--
-- TOC entry 2290 (class 2620 OID 34059)
-- Name: del_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER del_dipendenza AFTER DELETE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE del_dipendenza();


--
-- TOC entry 2289 (class 2620 OID 34055)
-- Name: ins_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ins_dipendenza AFTER INSERT ON dipendenza FOR EACH ROW EXECUTE PROCEDURE ins_dipendenza();


--
-- TOC entry 2291 (class 2620 OID 34062)
-- Name: upd_dipendenza; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_dipendenza BEFORE UPDATE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE upd_dipendenza();


--
-- TOC entry 2292 (class 2620 OID 34068)
-- Name: upd_dipendenza_licenziamento; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upd_dipendenza_licenziamento BEFORE UPDATE ON dipendenza FOR EACH ROW EXECUTE PROCEDURE upd_dipendenza_licenziamento();


--
-- TOC entry 2286 (class 2606 OID 34253)
-- Name: fk_attivita_dipendente_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_dipendente_manager FOREIGN KEY (id_dipendente_manager) REFERENCES dipendente(id);


--
-- TOC entry 2284 (class 2606 OID 34243)
-- Name: fk_attivita_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_struttura FOREIGN KEY (id_struttura) REFERENCES struttura(id_struttura);


--
-- TOC entry 2285 (class 2606 OID 34248)
-- Name: fk_attivita_tipo_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attivita
    ADD CONSTRAINT fk_attivita_tipo_attivita FOREIGN KEY (id_tipo_attivita) REFERENCES tipo_attivita(id);


--
-- TOC entry 2287 (class 2606 OID 34231)
-- Name: fk_dipendenza_attivita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_attivita FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2288 (class 2606 OID 34236)
-- Name: fk_dipendenza_dipendente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dipendenza
    ADD CONSTRAINT fk_dipendenza_dipendente FOREIGN KEY (id_dipendente) REFERENCES dipendente(id);


--
-- TOC entry 2283 (class 2606 OID 34032)
-- Name: fk_struttura_tipo_struttura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY struttura
    ADD CONSTRAINT fk_struttura_tipo_struttura FOREIGN KEY (id_tipo_struttura) REFERENCES tipo_struttura(id);


--
-- TOC entry 2282 (class 2606 OID 34118)
-- Name: fk_user_session_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_session
    ADD CONSTRAINT fk_user_session_user FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- TOC entry 2315 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2013-02-18 16:37:27 CET

--
-- PostgreSQL database dump complete
--

