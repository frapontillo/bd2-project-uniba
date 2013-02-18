package net.frapontillo.uni.db2.project.resource;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import net.frapontillo.uni.db2.project.converter.StrutturaConverter;
import net.frapontillo.uni.db2.project.entity.Struttura;
import net.frapontillo.uni.db2.project.entity.StrutturaList;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.StrutturaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import org.jooq.Field;
import org.jooq.Record;
import org.jooq.Result;
import org.jooq.impl.Factory;

import com.sun.jersey.core.spi.factory.ResponseBuilderImpl;
import com.sun.jersey.spi.container.ResourceFilters;

@Path("struttura")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
@ResourceFilters(AuthenticationResourceFilter.class)
public class StrutturaResource {
	@GET
	@Path("/{id}")
	public Struttura get(@PathParam("id") Integer id) {
		Factory f = DBUtil.getConn();
		StrutturaRecordDB r = (StrutturaRecordDB) f
				.select()
				.from(STRUTTURA)
				.where(STRUTTURA.ID_STRUTTURA.equal(id))
				.fetchOne();
		Struttura entity = new StrutturaConverter().from(r);
		DBUtil.closeConn(f);
		return entity;
	}
	
	@GET
	public StrutturaList search(
			@QueryParam("codice") @DefaultValue("") String codice,
			@QueryParam("page") @DefaultValue("1") Double page) {
		double pageSize = 10;
		int offset = (int) (pageSize*(page-1));
		double pages = 0;
		Factory f = DBUtil.getConn();
		Result<Record> r = f
				.select()
				.from(STRUTTURA)
				.where(STRUTTURA.CODICE.likeIgnoreCase("%"+codice+"%"))
				.orderBy(STRUTTURA.CODICE)
				.limit((int)pageSize)
				.offset(offset)
				.fetch();
		Field<Integer> countField = STRUTTURA.CODICE.count();
		Record c = f
				.select(countField)
				.from(STRUTTURA)
				.where(STRUTTURA.CODICE.likeIgnoreCase("%"+codice+"%"))
				.fetchOne();
		Double count = Double.valueOf(c.getValue(countField));
		pages = Math.ceil(count/pageSize);
		StrutturaList entity = new StrutturaList(
				count, page, pages, new StrutturaConverter().fromResult(r));
		
		DBUtil.closeConn(f);
		return entity;
	}
	
	@POST
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Struttura post(Struttura a) {
		Factory f = DBUtil.getConn();
		StrutturaRecordDB r = f.newRecord(STRUTTURA);
		new StrutturaConverter().to(a, r);
		r.store();
		Struttura entity = new StrutturaConverter().from(r);
		DBUtil.closeConn(f);
		return entity;
	}

	@PUT
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Struttura put(@PathParam("id") Integer id, Struttura a) {
		Factory f = DBUtil.getConn();
		StrutturaRecordDB r = (StrutturaRecordDB) f
				.select()
				.from(STRUTTURA)
				.where(STRUTTURA.ID_STRUTTURA.equal(id))
				.fetchOne();
		new StrutturaConverter().to(a, r);
		r.store();
		Struttura entity = new StrutturaConverter().from(r);
		DBUtil.closeConn(f);
		return entity;
	}

	@DELETE
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Response delete(@PathParam("id") Integer id) {
		Factory f = DBUtil.getConn();
		int d = f.delete(STRUTTURA)
				.where(STRUTTURA.ID_STRUTTURA.equal(id))
				.execute();

		DBUtil.closeConn(f);
		
		if (d == 1) {
			return new ResponseBuilderImpl()
				.status(Status.NO_CONTENT)
				.build();
		}
			
		return new ResponseBuilderImpl()
			.status(Status.NOT_FOUND)
			.build();
	}
}
