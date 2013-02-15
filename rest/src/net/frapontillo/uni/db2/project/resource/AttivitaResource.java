package net.frapontillo.uni.db2.project.resource;

import java.util.List;
import java.util.Map;

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

import org.jooq.Record;
import org.jooq.Result;
import org.jooq.impl.Factory;

import static net.frapontillo.uni.db2.project.jooq.Tables.*;

import net.frapontillo.uni.db2.project.converter.AttivitaConverter;
import net.frapontillo.uni.db2.project.entity.Attivita;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.tables.records.AttivitaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.core.spi.factory.ResponseBuilderImpl;
import com.sun.jersey.spi.container.ResourceFilters;

@Path("attivita")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
// TODO: riabilitare dopo implementazione del login
// @ResourceFilters(AuthenticationResourceFilter.class)
public class AttivitaResource {
	@GET
	@Path("/{id}")
	public Attivita get(@PathParam("id") String id) {
		int mId = Integer.parseInt(id);
		AttivitaRecordDB r = (AttivitaRecordDB) DBUtil.getConn()
				.select()
				.from(ATTIVITA)
				.where(ATTIVITA.ID_ATTIVITA.equal(mId))
				.fetchOne();
		Attivita entity = new AttivitaConverter().from(r);
		return entity;
	}
	
	@GET
	public GenericEntity<List<Attivita>> search(@QueryParam("nome") String nome) {
		Result<Record> r = DBUtil.getConn().select()
				.from(ATTIVITA)
				.where(ATTIVITA.NOME.likeIgnoreCase("%"+nome+"%"))
				.fetch();
		List<Attivita> entity = new AttivitaConverter().fromResult(r);
		return new GenericEntity<List<Attivita>>(entity) {};
	}
	
	@POST
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Attivita post(Attivita a) {
		Factory f = DBUtil.getConn();
		AttivitaRecordDB r = f.newRecord(ATTIVITA);
		new AttivitaConverter().to(a, r);
		r.store();
		Attivita entity = new AttivitaConverter().from(r);
		return entity;
	}

	@PUT
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Attivita put(@PathParam("id") String id, Attivita a) {
		int mId = Integer.parseInt(id);
		Factory f = DBUtil.getConn();
		AttivitaRecordDB r = (AttivitaRecordDB) f.select()
				.from(ATTIVITA)
				.where(ATTIVITA.ID_ATTIVITA.equal(mId))
				.fetchOne();
		new AttivitaConverter().to(a, r);
		r.store();
		Attivita entity = new AttivitaConverter().from(r);
		return entity;
	}

	@DELETE
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Response delete(@PathParam("id") String id) {
		int mId = Integer.parseInt(id);
		Factory f = DBUtil.getConn();
		int d = f.delete(ATTIVITA)
				.where(ATTIVITA.ID_ATTIVITA.equal(mId))
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
