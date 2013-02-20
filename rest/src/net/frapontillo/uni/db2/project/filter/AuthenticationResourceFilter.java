package net.frapontillo.uni.db2.project.filter;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.USER_SESSION;

import javax.ws.rs.ext.Provider;

import org.jooq.impl.Factory;

import net.frapontillo.uni.db2.project.exception.UnauthorizedException;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserSessionRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerRequestFilter;
import com.sun.jersey.spi.container.ContainerResponseFilter;
import com.sun.jersey.spi.container.ResourceFilter;

@Provider
public class AuthenticationResourceFilter implements ResourceFilter, ContainerRequestFilter {

	@Override
	public ContainerRequest filter(ContainerRequest req) {
		String authcode = req.getQueryParameters().getFirst("authcode");
		// Cerco la sessione con l'authcode in input
		Factory f = DBUtil.getConn();
		UserSessionRecordDB r = null;
		try {
			r = (UserSessionRecordDB) f
					.select()
					.from(USER_SESSION)
					.where(USER_SESSION.AUTHCODE.equal(authcode))
					.fetchOne();
		} finally {
			DBUtil.closeConn(f);
		}
		
		// Se l'authcode non esiste rigetto 401
		if (r == null) {
			throw new UnauthorizedException();
		}
		
		return req;
	}

	@Override
	public ContainerRequestFilter getRequestFilter() {
		return this;
	}

	@Override
	public ContainerResponseFilter getResponseFilter() {
		return null;
	}

}
