package net.frapontillo.uni.db2.project.resource;

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.sun.jersey.spi.container.ResourceFilters;

import static net.frapontillo.uni.db2.project.jooq.Tables.*;

import net.frapontillo.uni.db2.project.converter.UserConverter;
import net.frapontillo.uni.db2.project.entity.User;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.tables.records.UserRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

@Path("user")
@ResourceFilters(AuthenticationResourceFilter.class)
public class UserResource {
	@GET
	@Path("/{id}")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public User get(@PathParam("id") String id) {
		int mId = Integer.parseInt(id);
		UserRecordDB r = (UserRecordDB) DBUtil.getConn().select().from(USER).where(USER.ID.equal(mId)).fetchOne();
		User obj = new UserConverter().from(r);
		return obj;
	}
}
