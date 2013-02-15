/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq.gen.tables;

/**
 * This class is generated by jOOQ.
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public class DipendenteDB extends org.jooq.impl.UpdatableTableImpl<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB> {

	private static final long serialVersionUID = -997970323;

	/**
	 * The singleton instance of public.dipendente
	 */
	public static final net.frapontillo.uni.db2.project.jooq.gen.tables.DipendenteDB DIPENDENTE = new net.frapontillo.uni.db2.project.jooq.gen.tables.DipendenteDB();

	/**
	 * The class holding records for this type
	 */
	@Override
	public java.lang.Class<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB> getRecordType() {
		return net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB.class;
	}

	/**
	 * The table column <code>public.dipendente.cf</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public final org.jooq.TableField<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB, java.lang.String> CF = createField("cf", org.jooq.impl.SQLDataType.VARCHAR, this);

	/**
	 * The table column <code>public.dipendente.nome</code>
	 */
	public final org.jooq.TableField<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB, java.lang.String> NOME = createField("nome", org.jooq.impl.SQLDataType.VARCHAR, this);

	/**
	 * The table column <code>public.dipendente.cognome</code>
	 */
	public final org.jooq.TableField<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB, java.lang.String> COGNOME = createField("cognome", org.jooq.impl.SQLDataType.VARCHAR, this);

	/**
	 * The table column <code>public.dipendente.luogo_nascita</code>
	 */
	public final org.jooq.TableField<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB, java.lang.String> LUOGO_NASCITA = createField("luogo_nascita", org.jooq.impl.SQLDataType.VARCHAR, this);

	/**
	 * The table column <code>public.dipendente.data_nascita</code>
	 */
	public final org.jooq.TableField<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB, java.sql.Date> DATA_NASCITA = createField("data_nascita", org.jooq.impl.SQLDataType.DATE, this);

	/**
	 * The table column <code>public.dipendente.sesso</code>
	 */
	public final org.jooq.TableField<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB, java.lang.Boolean> SESSO = createField("sesso", org.jooq.impl.SQLDataType.BOOLEAN, this);

	public DipendenteDB() {
		super("dipendente", net.frapontillo.uni.db2.project.jooq.gen.PublicDB.PUBLIC);
	}

	public DipendenteDB(java.lang.String alias) {
		super(alias, net.frapontillo.uni.db2.project.jooq.gen.PublicDB.PUBLIC, net.frapontillo.uni.db2.project.jooq.gen.tables.DipendenteDB.DIPENDENTE);
	}

	@Override
	public org.jooq.UniqueKey<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB> getMainKey() {
		return net.frapontillo.uni.db2.project.jooq.gen.Keys.PK_DIPENDENTE;
	}

	@Override
	@SuppressWarnings("unchecked")
	public java.util.List<org.jooq.UniqueKey<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB>> getKeys() {
		return java.util.Arrays.<org.jooq.UniqueKey<net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB>>asList(net.frapontillo.uni.db2.project.jooq.gen.Keys.PK_DIPENDENTE);
	}

	@Override
	public net.frapontillo.uni.db2.project.jooq.gen.tables.DipendenteDB as(java.lang.String alias) {
		return new net.frapontillo.uni.db2.project.jooq.gen.tables.DipendenteDB(alias);
	}
}
