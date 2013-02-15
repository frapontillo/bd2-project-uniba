/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq.tables.daos;

/**
 * This class is generated by jOOQ.
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public class TipoStrutturaDaoDB extends org.jooq.impl.DAOImpl<net.frapontillo.uni.db2.project.jooq.tables.records.TipoStrutturaRecordDB, net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB, java.lang.Integer> {

	/**
	 * Create a new TipoStrutturaDaoDB without any factory
	 */
	public TipoStrutturaDaoDB() {
		super(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA, net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB.class);
	}

	/**
	 * Create a new TipoStrutturaDaoDB with an attached factory
	 */
	public TipoStrutturaDaoDB(org.jooq.impl.Factory factory) {
		super(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA, net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB.class, factory);
	}

	@Override
	protected java.lang.Integer getId(net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB object) {
		return object.getId();
	}

	/**
	 * Fetch records that have <code>id IN (values)</code>
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB> fetchByIdDB(java.lang.Integer... values) {
		return fetch(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA.ID, values);
	}

	/**
	 * Fetch a unique that has <code>id = value</code>
	 */
	public net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB fetchOneByIdDB(java.lang.Integer value) {
		return fetchOne(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA.ID, value);
	}

	/**
	 * Fetch records that have <code>descrizione IN (values)</code>
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB> fetchByDescrizioneDB(java.lang.String... values) {
		return fetch(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA.DESCRIZIONE, values);
	}

	/**
	 * Fetch records that have <code>codice IN (values)</code>
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB> fetchByCodiceDB(java.lang.String... values) {
		return fetch(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA.CODICE, values);
	}

	/**
	 * Fetch a unique that has <code>codice = value</code>
	 */
	public net.frapontillo.uni.db2.project.jooq.tables.pojos.TipoStrutturaDB fetchOneByCodiceDB(java.lang.String value) {
		return fetchOne(net.frapontillo.uni.db2.project.jooq.tables.TipoStrutturaDB.TIPO_STRUTTURA.CODICE, value);
	}
}
