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
public class UserSessionRecordDB extends org.jooq.impl.UpdatableRecordImpl<net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserSessionRecordDB> {

	private static final long serialVersionUID = 624336460;

	/**
	 * The table column <code>public.user_session.id</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public void setId(java.lang.Long value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID, value);
	}

	/**
	 * The table column <code>public.user_session.id</code>
	 * <p>
	 * This column is part of the table's PRIMARY KEY
	 */
	public java.lang.Long getId() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID);
	}

	/**
	 * The table column <code>public.user_session.id_user</code>
	 * <p>
	 * This column is part of a FOREIGN KEY: <code><pre>
	 * CONSTRAINT user_session__fk_user_session_user
	 * FOREIGN KEY (id_user)
	 * REFERENCES public.user (id)
	 * </pre></code>
	 */
	public void setIdUser(java.lang.Integer value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID_USER, value);
	}

	/**
	 * The table column <code>public.user_session.id_user</code>
	 * <p>
	 * This column is part of a FOREIGN KEY: <code><pre>
	 * CONSTRAINT user_session__fk_user_session_user
	 * FOREIGN KEY (id_user)
	 * REFERENCES public.user (id)
	 * </pre></code>
	 */
	public java.lang.Integer getIdUser() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID_USER);
	}

	/**
	 * Link this record to a given {@link net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserRecordDB 
	 * UserRecordDB}
	 */
	public void setIdUser(net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserRecordDB value) {
		if (value == null) {
			setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID_USER, null);
		}
		else {
			setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID_USER, value.getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.ID));
		}
	}

	/**
	 * The table column <code>public.user_session.id_user</code>
	 * <p>
	 * This column is part of a FOREIGN KEY: <code><pre>
	 * CONSTRAINT user_session__fk_user_session_user
	 * FOREIGN KEY (id_user)
	 * REFERENCES public.user (id)
	 * </pre></code>
	 */
	public net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserRecordDB fetchUserDB() {
		return create()
			.selectFrom(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER)
			.where(net.frapontillo.uni.db2.project.jooq.gen.tables.UserDB.USER.ID.equal(getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.ID_USER)))
			.fetchOne();
	}

	/**
	 * The table column <code>public.user_session.date_login</code>
	 */
	public void setDateLogin(java.sql.Timestamp value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.DATE_LOGIN, value);
	}

	/**
	 * The table column <code>public.user_session.date_login</code>
	 */
	public java.sql.Timestamp getDateLogin() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.DATE_LOGIN);
	}

	/**
	 * The table column <code>public.user_session.date_logout</code>
	 */
	public void setDateLogout(java.sql.Timestamp value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.DATE_LOGOUT, value);
	}

	/**
	 * The table column <code>public.user_session.date_logout</code>
	 */
	public java.sql.Timestamp getDateLogout() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.DATE_LOGOUT);
	}

	/**
	 * The table column <code>public.user_session.authcode</code>
	 */
	public void setAuthcode(java.lang.String value) {
		setValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.AUTHCODE, value);
	}

	/**
	 * The table column <code>public.user_session.authcode</code>
	 */
	public java.lang.String getAuthcode() {
		return getValue(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION.AUTHCODE);
	}

	/**
	 * Create a detached UserSessionRecordDB
	 */
	public UserSessionRecordDB() {
		super(net.frapontillo.uni.db2.project.jooq.gen.tables.UserSessionDB.USER_SESSION);
	}
}