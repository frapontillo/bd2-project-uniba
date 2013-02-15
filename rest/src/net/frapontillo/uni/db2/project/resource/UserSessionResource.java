package net.frapontillo.uni.db2.project.resource;

import static net.frapontillo.uni.db2.project.jooq.Tables.*;

import java.util.List;

import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import net.frapontillo.uni.db2.project.converter.UserSessionConverter;
import net.frapontillo.uni.db2.project.entity.UserSession;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.tables.records.UserSessionRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.spi.container.ResourceFilters;

@Path("usersession")
public class UserSessionResource {
	@GET
	@Path("/{authcode}")
	@ResourceFilters(AuthenticationResourceFilter.class)
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public UserSession get(@PathParam("authcode") String authcode) {
		UserSessionRecordDB r = (UserSessionRecordDB) DBUtil.getConn().
				select().
				from(USER_SESSION).
				where(USER_SESSION.AUTHCODE.equal(authcode)).fetchOne();
		UserSession obj = new UserSessionConverter().from(r);
		return obj;
	}
	
	@POST
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public UserSession post(@QueryParam("username") String username,
			@QueryParam("password") String password) {
		// TODO: creare sessione di login
		return null;
	}
	
	@DELETE
	@Path("/{authcode}")
	@ResourceFilters(AuthenticationResourceFilter.class)
	public void delete(@QueryParam("authcode") String authcode) {
		// TODO: eliminare sessione di login
		return;
	}
}
