package net.frapontillo.uni.db2.project.util;

public class ConvUtil {
	public static java.util.Date DateSqlToUtil(java.sql.Date sqlDate) {
		java.util.Date utilDate = new java.util.Date();
		utilDate.setTime(sqlDate.getTime());
		return utilDate;
	}
	public static java.sql.Date DateUtilToSql(java.util.Date utilDate) {
		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
		return sqlDate;
	}
}
