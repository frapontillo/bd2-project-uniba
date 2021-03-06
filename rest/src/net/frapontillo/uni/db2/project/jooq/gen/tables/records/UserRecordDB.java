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
public class UserRecordDB extends org.jooq.impl.UpdatableRecordImpl<net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserRecordDB> {

	private static final long serialVersionUID = -1730573902;

	/**
	 * The table column <code>public.user.id</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public void setId(java.lang.Integer value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.ID, value);
	}

	/**
	 * The table column <code>public.user.id</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public java.lang.Integer getId() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.ID);
	}

	/**
	 * The table column <code>public.user.id</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public java.util.List<net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserSessionRecordDB> fetchUserSessionDBList() {
		return create()
			.selectFrom(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION)
			.where(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID_USER.equal(getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.ID)))
			.fetch();
	}

	/**
	 * The table column <code>public.user.username</code>
	 */
	public void setUsername(java.lang.String value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.USERNAME, value);
	}

	/**
	 * The table column <code>public.user.username</code>
	 */
	public java.lang.String getUsername() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.USERNAME);
	}

	/**
	 * The table column <code>public.user.password</code>
	 */
	public void setPassword(java.lang.String value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.PASSWORD, value);
	}

	/**
	 * The table column <code>public.user.password</code>
	 */
	public java.lang.String getPassword() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.PASSWORD);
	}

	/**
	 * Create a detached UserRecordDB
	 */
	public UserRecordDB() {
		super(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER);
	}
}
