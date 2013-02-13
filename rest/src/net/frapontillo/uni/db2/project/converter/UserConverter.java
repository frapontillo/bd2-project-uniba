package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.UserDB;
import net.frapontillo.uni.db2.project.entity.User;

public class UserConverter extends AbstractConverter<UserDB, User> {

	@Override
	public User from(UserDB source, int lev) {
		if (source == null) return null;
		User obj = new User();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setUsername(source.getUsername());
		}
		return obj;
	}

	@Override
	public UserDB to(User source, int lev) {
		if (source == null) return null;
		UserDB dbObj = new UserDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setUsername(source.getUsername());
		}
		return dbObj;
	}

}
