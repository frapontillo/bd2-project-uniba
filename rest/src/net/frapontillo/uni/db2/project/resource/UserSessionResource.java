package net.frapontillo.uni.db2.project.resource;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import java.util.Date;

import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.jooq.impl.Factory;

import net.frapontillo.uni.db2.project.converter.UserSessionConverter;
import net.frapontillo.uni.db2.project.entity.UserSession;
import net.frapontillo.uni.db2.project.exception.BadRequestException;
import net.frapontillo.uni.db2.project.exception.UnauthorizedException;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserRecordDB;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.UserSessionRecordDB;
import net.frapontillo.uni.db2.project.util.ConvUtil;
import net.frapontillo.uni.db2.project.util.DBUtil;
import net.frapontillo.uni.db2.project.util.SecretUtil;

import com.sun.jersey.core.spi.factory.ResponseBuilderImpl;
import com.sun.jersey.spi.container.ResourceFilters;

@Path("usersession")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
public class UserSessionResource {
	@GET
	@ResourceFilters(AuthenticationResourceFilter.class)
	public UserSession get(@QueryParam("authcode") String authcode) {
		UserSessionRecordDB r = (UserSessionRecordDB) DBUtil.getConn().
				select().
				from(USER_SESSION).
				where(USER_SESSION.AUTHCODE.equal(authcode)).fetchOne();
		UserSession obj = new UserSessionConverter().from(r);
		return obj;
	}
	
	@POST
	public UserSession post(
			@QueryParam("username") String username,
			@QueryParam("password") String password) {
		// Se non sono presenti dati validi, rigetto una Bad Request
		if (username == null || password == null
				|| username.equals("") || password.equals("")) {
			throw new BadRequestException();
		}
		// Ottengo l'hash della password
		String hashed = SecretUtil.hashPassword(password);
		// Cerco l'utente
		Factory f = DBUtil.getConn();
		UserRecordDB u = (UserRecordDB) f
				.select()
				.from(USER)
				.where(USER.USERNAME.equal(username))
				.and(USER.PASSWORD.equal(hashed))
				.fetchOne();
		// Se la combinazione è errata, rigetto 401
		if (u == null) {
			throw new UnauthorizedException();
		}
		// Altrimenti 
		UserSessionRecordDB r = f.newRecord(USER_SESSION);
		String authcode = SecretUtil.computeHash(username, hashed);
		r.setAuthcode(authcode);
		r.setDateLogin(ConvUtil.DateToTimestamp(new Date()));
		r.setDateLogin(ConvUtil.DateToTimestamp(new Date()));
		r.setIdUser(u.getId());
		r.store();
		UserSession entity = new UserSessionConverter().from(r);
		return entity;
	}
	
	@DELETE
	public Response delete(@QueryParam("authcode") String authcode) {
		// Se sono arrivato fin qui vuol dire che l'authcode esiste
		// Cancello la sessione con l'authcode in input
		Factory f = DBUtil.getConn();
		int r = f
				.delete(USER_SESSION)
				.where(USER_SESSION.AUTHCODE.equal(authcode))
				.execute();
		
		// Se l'authcode non esiste rigetto 401
		if (r != 1) {
			throw new UnauthorizedException();
		}
		
		// Altrimenti restituisco un 204.
		return new ResponseBuilderImpl()
			.status(Status.NO_CONTENT)
			.build();
	}
}
