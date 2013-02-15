package net.frapontillo.uni.db2.project.util;

import java.sql.Timestamp;
import java.util.Date;

public class ConvUtil {
	public static java.util.Date DateSqlToUtil(java.sql.Date sqlDate) {
		if (sqlDate == null) return null;
		java.util.Date utilDate = new java.util.Date();
		utilDate.setTime(sqlDate.getTime());
		return utilDate;
	}
	public static java.sql.Date DateUtilToSql(java.util.Date utilDate) {
		if (utilDate == null) return null;
		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
		return sqlDate;
	}
	public static Timestamp DateToTimestamp(Date date) {
		if (date == null) return null;
		Timestamp t = new Timestamp(date.getTime());
		return t;
	}
	public static Date TimestampToDate(Timestamp timestamp) {
		if (timestamp == null) return null;
		Date d = new Date(timestamp.getTime());
		return d;
	}
}
