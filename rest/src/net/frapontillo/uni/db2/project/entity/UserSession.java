package net.frapontillo.uni.db2.project.entity;

import java.sql.Date;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class UserSession implements IEntity {
	protected Long id;
	protected String authcode;
	protected User user;
	protected Date date_login;
	protected Date date_logout;
	
	public UserSession() {
	}
	
	public UserSession(Long id, String authcode, User user, Date date_login,
			Date date_logout) {
		super();
		this.id = id;
		this.authcode = authcode;
		this.user = user;
		this.date_login = date_login;
		this.date_logout = date_logout;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAuthcode() {
		return authcode;
	}

	public void setAuthcode(String authcode) {
		this.authcode = authcode;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Date getDate_login() {
		return date_login;
	}

	public void setDate_login(Date date_login) {
		this.date_login = date_login;
	}

	public Date getDate_logout() {
		return date_logout;
	}

	public void setDate_logout(Date date_logout) {
		this.date_logout = date_logout;
	}
}
