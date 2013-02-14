package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.UserDB;
import net.frapontillo.uni.db2.project.entity.User;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class UserConverter extends AbstractConverter<UserDB, User> {

	@Override
	public User from(UserDB source, int lev) {
		if (source == null) return null;
		User obj = new User();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId((Integer) DBUtil.getID(source, UserDB.ID_PK_COLUMN));
			obj.setUsername(source.getUsername());
		}
		return obj;
	}

	@Override
	public UserDB to(User source, UserDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new UserDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(UserDB.ID_PK_COLUMN, source.getId());
			dbObj.setUsername(source.getUsername());
		}
		return dbObj;
	}

}
