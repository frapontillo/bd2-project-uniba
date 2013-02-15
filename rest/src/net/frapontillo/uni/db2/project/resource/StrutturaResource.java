package net.frapontillo.uni.db2.project.resource;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import net.frapontillo.uni.db2.project.converter.StrutturaConverter;
import net.frapontillo.uni.db2.project.entity.Struttura;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.StrutturaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

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
		StrutturaRecordDB r = (StrutturaRecordDB) DBUtil.getConn()
				.select()
				.from(STRUTTURA)
				.where(STRUTTURA.ID_STRUTTURA.equal(id))
				.fetchOne();
		Struttura entity = new StrutturaConverter().from(r);
		return entity;
	}
	
	@GET
	public GenericEntity<List<Struttura>> search(
			@QueryParam("codice") String codice) {
		Result<Record> r = DBUtil.getConn()
				.select()
				.from(STRUTTURA)
				.where(STRUTTURA.CODICE.likeIgnoreCase("%"+codice+"%"))
				.fetch();
		List<Struttura> entity = new StrutturaConverter().fromResult(r);
		return new GenericEntity<List<Struttura>>(entity) {};
	}
	
	@POST
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Struttura post(Struttura a) {
		Factory f = DBUtil.getConn();
		StrutturaRecordDB r = f.newRecord(STRUTTURA);
		new StrutturaConverter().to(a, r);
		r.store();
		Struttura entity = new StrutturaConverter().from(r);
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
