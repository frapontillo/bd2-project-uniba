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

import org.jooq.Field;
import org.jooq.Record;
import org.jooq.Result;
import org.jooq.SelectConditionStep;
import org.jooq.impl.Factory;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import net.frapontillo.uni.db2.project.converter.AttivitaConverter;
import net.frapontillo.uni.db2.project.entity.Attivita;
import net.frapontillo.uni.db2.project.entity.AttivitaList;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.AttivitaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.core.spi.factory.ResponseBuilderImpl;
import com.sun.jersey.spi.container.ResourceFilters;

@Path("attivita")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
@ResourceFilters(AuthenticationResourceFilter.class)
public class AttivitaResource {
	@GET
	@Path("/{id}")
	public Attivita get(@PathParam("id") Integer id) {
		AttivitaRecordDB r = (AttivitaRecordDB) DBUtil.getConn()
				.select()
				.from(ATTIVITA)
				.where(ATTIVITA.ID_ATTIVITA.equal(id))
				.fetchOne();
		Attivita entity = new AttivitaConverter().from(r);
		return entity;
	}
	
	@GET
	public AttivitaList search(
			@QueryParam("nome") String nome,
			@QueryParam("struttura") Integer struttura,
			@QueryParam("page") @DefaultValue("1") Double page) {
		double pageSize = 10;
		int offset = (int) (pageSize*(page-1));
		double pages = 0;
		Factory f = DBUtil.getConn();
		SelectConditionStep where = f
				.select()
				.from(ATTIVITA)
				.where(ATTIVITA.NOME.likeIgnoreCase("%"+nome+"%"));
		if (struttura != null && struttura > 0)
			where = where.and(ATTIVITA.ID_STRUTTURA.equal(struttura));
		Result<Record> r = where
				.orderBy(ATTIVITA.NOME)
				.limit((int)pageSize)
				.offset(offset)
				.fetch();
		Field<Integer> countField = ATTIVITA.CODICE.count();

		SelectConditionStep whereC = f
				.select(countField)
				.from(ATTIVITA)
				.where(ATTIVITA.NOME.likeIgnoreCase("%"+nome+"%"));
		if (struttura != null && struttura > 0)
			whereC = whereC.and(ATTIVITA.ID_STRUTTURA.equal(struttura));
		Record c = whereC.fetchOne();
		Double count = Double.valueOf(c.getValue(countField));
		pages = Math.ceil(count/pageSize);
		
		AttivitaList entity = new AttivitaList(count, page, pages, new AttivitaConverter().fromResult(r));
		return entity;
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
	public Attivita put(@PathParam("id") Integer id, Attivita a) {
		Factory f = DBUtil.getConn();
		AttivitaRecordDB r = (AttivitaRecordDB) f.select()
				.from(ATTIVITA)
				.where(ATTIVITA.ID_ATTIVITA.equal(id))
				.fetchOne();
		new AttivitaConverter().to(a, r);
		r.store();
		Attivita entity = new AttivitaConverter().from(r);
		return entity;
	}

	@DELETE
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Response delete(@PathParam("id") Integer id) {
		Factory f = DBUtil.getConn();
		int d = f.delete(ATTIVITA)
				.where(ATTIVITA.ID_ATTIVITA.equal(id))
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
