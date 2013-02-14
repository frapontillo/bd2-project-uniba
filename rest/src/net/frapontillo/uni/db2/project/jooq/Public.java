/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq;

/**
 * This class is generated by jOOQ.
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public class Public extends org.jooq.impl.SchemaImpl {

	private static final long serialVersionUID = -1488597792;

	/**
	 * The singleton instance of public
	 */
	public static final Public PUBLIC = new Public();

	/**
	 * No further instances allowed
	 */
	private Public() {
		super("public");
	}

	@Override
	public final java.util.List<org.jooq.Sequence<?>> getSequences() {
		return java.util.Arrays.<org.jooq.Sequence<?>>asList(
			net.frapontillo.uni.db2.project.jooq.Sequences.ATTIVITA_ID_ATTIVITA_SEQ,
			net.frapontillo.uni.db2.project.jooq.Sequences.STRUTTURA_ID_STRUTTURA_SEQ,
			net.frapontillo.uni.db2.project.jooq.Sequences.TIPO_ATTIVITA_ID_SEQ,
			net.frapontillo.uni.db2.project.jooq.Sequences.TIPO_STRUTTURA_ID_SEQ,
			net.frapontillo.uni.db2.project.jooq.Sequences.USER_ID_SEQ,
			net.frapontillo.uni.db2.project.jooq.Sequences.USER_SESSION_ID_SEQ);
	}

	@Override
	public final java.util.List<org.jooq.Table<?>> getTables() {
		return java.util.Arrays.<org.jooq.Table<?>>asList(
			net.frapontillo.uni.db2.project.jooq.tables.Attivita.ATTIVITA,
			net.frapontillo.uni.db2.project.jooq.tables.Dipendente.DIPENDENTE,
			net.frapontillo.uni.db2.project.jooq.tables.Dipendenza.DIPENDENZA,
			net.frapontillo.uni.db2.project.jooq.tables.Struttura.STRUTTURA,
			net.frapontillo.uni.db2.project.jooq.tables.TipoAttivita.TIPO_ATTIVITA,
			net.frapontillo.uni.db2.project.jooq.tables.TipoStruttura.TIPO_STRUTTURA,
			net.frapontillo.uni.db2.project.jooq.tables.User.USER,
			net.frapontillo.uni.db2.project.jooq.tables.UserSession.USER_SESSION);
	}
}
