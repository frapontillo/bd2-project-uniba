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
public class UserDaoDB extends org.jooq.impl.DAOImpl<net.frapontillo.uni.db2.project.jooq.tables.records.UserRecordDB, net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB, java.lang.Integer> {

	/**
	 * Create a new UserDaoDB without any factory
	 */
	public UserDaoDB() {
		super(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER, net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB.class);
	}

	/**
	 * Create a new UserDaoDB with an attached factory
	 */
	public UserDaoDB(org.jooq.impl.Factory factory) {
		super(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER, net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB.class, factory);
	}

	@Override
	protected java.lang.Integer getId(net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB object) {
		return object.getId();
	}

	/**
	 * Fetch records that have <code>id IN (values)</code>
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB> fetchByIdDB(java.lang.Integer... values) {
		return fetch(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER.ID, values);
	}

	/**
	 * Fetch a unique that has <code>id = value</code>
	 */
	public net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB fetchOneByIdDB(java.lang.Integer value) {
		return fetchOne(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER.ID, value);
	}

	/**
	 * Fetch records that have <code>username IN (values)</code>
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB> fetchByUsernameDB(java.lang.String... values) {
		return fetch(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER.USERNAME, values);
	}

	/**
	 * Fetch a unique that has <code>username = value</code>
	 */
	public net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB fetchOneByUsernameDB(java.lang.String value) {
		return fetchOne(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER.USERNAME, value);
	}

	/**
	 * Fetch records that have <code>password IN (values)</code>
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.tables.pojos.UserDB> fetchByPasswordDB(java.lang.String... values) {
		return fetch(net.frapontillo.uni.db2.project.jooq.tables.UserDB.USER.PASSWORD, values);
	}
}
