/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq;

/**
 * This class is generated by jOOQ.
 *
 * Convenience access to all sequences in public
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public final class Sequences {

	/**
	 * The sequence public.attivita_id_attivita_seq
	 */
	public static final org.jooq.Sequence<java.lang.Long> ATTIVITA_ID_ATTIVITA_SEQ = new org.jooq.impl.SequenceImpl<java.lang.Long>("attivita_id_attivita_seq", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.impl.SQLDataType.BIGINT);

	/**
	 * The sequence public.struttura_id_struttura_seq
	 */
	public static final org.jooq.Sequence<java.lang.Long> STRUTTURA_ID_STRUTTURA_SEQ = new org.jooq.impl.SequenceImpl<java.lang.Long>("struttura_id_struttura_seq", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.impl.SQLDataType.BIGINT);

	/**
	 * The sequence public.tipo_attivita_id_seq
	 */
	public static final org.jooq.Sequence<java.lang.Long> TIPO_ATTIVITA_ID_SEQ = new org.jooq.impl.SequenceImpl<java.lang.Long>("tipo_attivita_id_seq", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.impl.SQLDataType.BIGINT);

	/**
	 * The sequence public.tipo_struttura_id_seq
	 */
	public static final org.jooq.Sequence<java.lang.Long> TIPO_STRUTTURA_ID_SEQ = new org.jooq.impl.SequenceImpl<java.lang.Long>("tipo_struttura_id_seq", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.impl.SQLDataType.BIGINT);

	/**
	 * The sequence public.user_id_seq
	 */
	public static final org.jooq.Sequence<java.lang.Long> USER_ID_SEQ = new org.jooq.impl.SequenceImpl<java.lang.Long>("user_id_seq", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.impl.SQLDataType.BIGINT);

	/**
	 * The sequence public.user_session_id_seq
	 */
	public static final org.jooq.Sequence<java.lang.Long> USER_SESSION_ID_SEQ = new org.jooq.impl.SequenceImpl<java.lang.Long>("user_session_id_seq", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.impl.SQLDataType.BIGINT);

	/**
	 * No instances
	 */
	private Sequences() {}
}
