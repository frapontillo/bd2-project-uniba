/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq.gen.tables.records;

/**
 * This class is generated by jOOQ.
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public class StrutturaRecordDB extends org.jooq.impl.UpdatableRecordImpl<net.frapontillo.uni.db2.project.jooq.gen.tables.records.StrutturaRecordDB> {

	private static final long serialVersionUID = 370142138;

	/**
	 * The table column <code>public.struttura.id_struttura</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public void setIdStruttura(java.lang.Integer value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_STRUTTURA, value);
	}

	/**
	 * The table column <code>public.struttura.id_struttura</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public java.lang.Integer getIdStruttura() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_STRUTTURA);
	}

	/**
	 * The table column <code>public.struttura.id_struttura</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.gen.tables.records.AttivitaRecordDB> fetchAttivitaDBList() {
		return create()
			.selectFrom(net.frapontillo.uni.db2.project.jooq.gen.tables.AttivitaDB.ATTIVITA)
			.where(net.frapontillo.uni.db2.project.jooq.gen.tables.AttivitaDB.ATTIVITA.ID_STRUTTURA.equal(getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_STRUTTURA)))
			.fetch();
	}

	/**
	 * The table column <code>public.struttura.codice</code>
	 */
	public void setCodice(java.lang.String value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.CODICE, value);
	}

	/**
	 * The table column <code>public.struttura.codice</code>
	 */
	public java.lang.String getCodice() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.CODICE);
	}

	/**
	 * The table column <code>public.struttura.id_tipo_struttura</code>
	 * <p>
	 * This column is part of a FOREIGN KEY: <code><pre>
	 * CONSTRAINT struttura__fk_struttura_tipo_struttura
	 * FOREIGN KEY (id_tipo_struttura)
	 * REFERENCES public.tipo_struttura (id)
	 * </pre></code>
	 */
	public void setIdTipoStruttura(java.lang.Integer value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_TIPO_STRUTTURA, value);
	}

	/**
	 * The table column <code>public.struttura.id_tipo_struttura</code>
	 * <p>
	 * This column is part of a FOREIGN KEY: <code><pre>
	 * CONSTRAINT struttura__fk_struttura_tipo_struttura
	 * FOREIGN KEY (id_tipo_struttura)
	 * REFERENCES public.tipo_struttura (id)
	 * </pre></code>
	 */
	public java.lang.Integer getIdTipoStruttura() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_TIPO_STRUTTURA);
	}

	/**
	 * Link this record to a given {@link net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoStrutturaRecordDB 
	 * TipoStrutturaRecordDB}
	 */
	public void setIdTipoStruttura(net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoStrutturaRecordDB value) {
		if (value == null) {
			setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_TIPO_STRUTTURA, null);
		}
		else {
			setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_TIPO_STRUTTURA, value.getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.TipoStrutturaDB.TIPO_STRUTTURA.ID));
		}
	}

	/**
	 * The table column <code>public.struttura.id_tipo_struttura</code>
	 * <p>
	 * This column is part of a FOREIGN KEY: <code><pre>
	 * CONSTRAINT struttura__fk_struttura_tipo_struttura
	 * FOREIGN KEY (id_tipo_struttura)
	 * REFERENCES public.tipo_struttura (id)
	 * </pre></code>
	 */
	public net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoStrutturaRecordDB fetchTipoStrutturaDB() {
		return create()
			.selectFrom(net.frapontillo.uni.db2.project.jooq.gen.tables.TipoStrutturaDB.TIPO_STRUTTURA)
			.where(net.frapontillo.uni.db2.project.jooq.gen.tables.TipoStrutturaDB.TIPO_STRUTTURA.ID.equal(getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA.ID_TIPO_STRUTTURA)))
			.fetchOne();
	}

	/**
	 * Create a detached StrutturaRecordDB
	 */
	public StrutturaRecordDB() {
		super(net.frapontillo.uni.db2.project.jooq.gen.tables.StrutturaDB.STRUTTURA);
	}
}
