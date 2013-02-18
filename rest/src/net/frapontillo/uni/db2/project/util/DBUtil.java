package net.frapontillo.uni.db2.project.util;

import java.sql.Connection;
import java.sql.DriverManager;

import org.jooq.SQLDialect;
import org.jooq.impl.Factory;

public final class DBUtil {	
	public static Factory getConn() {
		Factory factory = null;
		String userName = "postgres";
        String password = "30lode";
        String url = "jdbc:postgresql://localhost:5432/db2";

        try {
            Class.forName("org.postgresql.Driver").newInstance();
            Connection conn = DriverManager.getConnection(url, userName, password);
            factory = new Factory(conn, SQLDialect.POSTGRES);
        } catch (Exception e) {
            e.printStackTrace();
        }
		return factory;
	}
}

