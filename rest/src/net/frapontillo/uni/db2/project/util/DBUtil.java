package net.frapontillo.uni.db2.project.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.jooq.SQLDialect;
import org.jooq.impl.Factory;

public final class DBUtil {	
	public static Factory getConn() {
		Factory factory = null;
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            DataSource ds = (DataSource) envCtx.lookup("jdbc/MallDB");
            Connection conn = ds.getConnection();
            // factory = new Factory(ds, SQLDialect.POSTGRES);
            factory = new Factory(conn, SQLDialect.POSTGRES);
        } catch (Exception e) {
            e.printStackTrace();
        }
		return factory;
	}
	
	public static void closeConn(Factory factory) {
		if (factory == null) return;
		try {
			Connection c = factory.getConnection();
			if (c != null && !c.isClosed())
				factory.getConnection().close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}

