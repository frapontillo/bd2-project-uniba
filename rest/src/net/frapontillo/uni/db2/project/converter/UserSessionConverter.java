package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.UserSession;
import net.frapontillo.uni.db2.project.jooq.tables.records.UserSessionRecordDB;

public class UserSessionConverter extends
		AbstractConverter<UserSessionRecordDB, UserSession> {

	@Override
	public UserSession from(UserSessionRecordDB source, int lev) {
		if (source == null) return null;
		UserSession obj = new UserSession();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setAuthcode(source.getAuthcode());
			obj.setUser(new UserConverter().from(source.fetchUserDB(), lev - 1));
		}
		if (lev >= CONV_TYPE.NORMAL) {
			obj.setDate_login(source.getDateLogin());
			obj.setDate_logout(source.getDateLogout());
		}
		return obj;
	}

	@Override
	public UserSessionRecordDB to(UserSession source, UserSessionRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new UserSessionRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setAuthcode(source.getAuthcode());
			dbObj.setIdUser(source.getUser().getId());
		}
		if (lev >= CONV_TYPE.NORMAL) {
			dbObj.setDateLogin(source.getDate_login());
			dbObj.setDateLogout(source.getDate_logout());
		}
		return dbObj;
	}

}
