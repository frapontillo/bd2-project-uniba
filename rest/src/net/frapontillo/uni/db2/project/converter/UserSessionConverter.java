package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.UserSessionDB;
import net.frapontillo.uni.db2.project.entity.UserSession;

public class UserSessionConverter extends
		AbstractConverter<UserSessionDB, UserSession> {

	@Override
	public UserSession from(UserSessionDB source, int lev) {
		if (source == null) return null;
		UserSession obj = new UserSession();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setAuthcode(source.getAuthcode());
			obj.setUser(new UserConverter().from(source.getToUser(), lev - 1));
		}
		if (lev >= CONV_TYPE.NORMAL) {
			obj.setDate_login(source.getDateLogin());
			obj.setDate_logout(source.getDateLogout());
		}
		return obj;
	}

	@Override
	public UserSessionDB to(UserSession source, int lev) {
		if (source == null) return null;
		UserSessionDB dbObj = new UserSessionDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setAuthcode(source.getAuthcode());
			dbObj.setToUser(new UserConverter().to(source.getUser()));
		}
		if (lev >= CONV_TYPE.NORMAL) {
			dbObj.setDateLogin(source.getDate_login());
			dbObj.setDateLogout(source.getDate_logout());
		}
		return dbObj;
	}

}
