package net.frapontillo.uni.db2.project.resource;

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.cayenne.exp.ExpressionFactory;
import org.apache.cayenne.query.SelectQuery;

import com.sun.jersey.spi.container.ResourceFilters;

import net.frapontillo.uni.db2.project.converter.UserConverter;
import net.frapontillo.uni.db2.project.db.UserDB;
import net.frapontillo.uni.db2.project.entity.User;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.util.DBUtil;

@Path("user")
@ResourceFilters(AuthenticationResourceFilter.class)
public class UserResource {
	@GET
	@Path("/{id}")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public User get(@PathParam("id") String id) {
		int mId = Integer.parseInt(id);
		SelectQuery query = new SelectQuery(UserDB.class,
				ExpressionFactory.matchDbExp(UserDB.ID_PK_COLUMN, mId));
		List<UserDB> dbObjs = (List<UserDB>)DBUtil.getContext().performQuery(query);
		UserDB dbObj = dbObjs.size() > 0 ? (UserDB)dbObjs.get(0) : null;
		User obj = new UserConverter().from(dbObj);
		return obj;
	}
}
