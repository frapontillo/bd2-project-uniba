/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq.routines;

/**
 * This class is generated by jOOQ.
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public class InsDipendenza extends org.jooq.impl.AbstractRoutine<java.lang.Object> {

	private static final long serialVersionUID = -1095095336;


	/**
	 * The procedure parameter <code>public.ins_dipendenza.RETURN_VALUE</code>
	 * <p>
	 * The SQL type of this item (trigger) could not be mapped.<br/>
	 * Deserialising this field might not work!
	 */
	public static final org.jooq.Parameter<java.lang.Object> RETURN_VALUE = createParameter("RETURN_VALUE", org.jooq.util.postgres.PostgresDataType.getDefaultDataType("trigger"));

	/**
	 * Create a new routine call instance
	 */
	public InsDipendenza() {
		super("ins_dipendenza", net.frapontillo.uni.db2.project.jooq.Public.PUBLIC, org.jooq.util.postgres.PostgresDataType.getDefaultDataType("trigger"));

		setReturnParameter(RETURN_VALUE);
	}
}
