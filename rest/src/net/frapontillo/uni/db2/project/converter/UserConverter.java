package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.User;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserRecordDB;

public class UserConverter extends AbstractConverter<UserRecordDB, User> {

	@Override
	public User from(UserRecordDB source, int lev) {
		if (source == null) return null;
		User obj = new User();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setUsername(source.getUsername());
		}
		return obj;
	}

	@Override
	public UserRecordDB to(User source, UserRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new UserRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setUsername(source.getUsername());
		}
		return dbObj;
	}

}
