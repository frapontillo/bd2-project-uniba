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
import org.jooq.SelectJoinStep;
import org.jooq.impl.Factory;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import net.frapontillo.uni.db2.project.converter.DipendenzaConverter;
import net.frapontillo.uni.db2.project.entity.Dipendenza;
import net.frapontillo.uni.db2.project.entity.DipendenzaList;
import net.frapontillo.uni.db2.project.exception.BadRequestException;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenzaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.core.spi.factory.ResponseBuilderImpl;
import com.sun.jersey.spi.container.ResourceFilters;

@Path("dipendenza")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
@ResourceFilters(AuthenticationResourceFilter.class)
public class DipendenzaResource {
	@GET
	@Path("/{id}")
	public Dipendenza get(@PathParam("id") Long id) {
		if (id == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		DipendenzaRecordDB dbObj = (DipendenzaRecordDB) f
				.select()
				.from(DIPENDENZA)
				.where(DIPENDENZA.ID.equal(id))
				.fetchOne();
		Dipendenza d = new DipendenzaConverter().from(dbObj);
		DBUtil.closeConn(f);
		return d;
	}
	
	@GET
	public DipendenzaList search(
			@QueryParam("dipendente") Integer dipendente,
			@QueryParam("attivita") Integer attivita,
			@QueryParam("page") @DefaultValue("1") Integer page) {
		double pageSize = 10;
		int offset = (int) (pageSize*(page-1));
		double pages = 0;
		Factory f = DBUtil.getConn();
		
		// PARTE 1: ottengo i record
		SelectJoinStep join = f.select().from(DIPENDENZA);
		SelectConditionStep where;
		// Condizione sul dipendente
		if (dipendente != null) where = join.where(DIPENDENZA.ID_DIPENDENTE.equal(dipendente));
		else where = join.where();
		// Condizione sull'attività
		if (attivita != null) where = where.and(DIPENDENZA.ID_ATTIVITA.equal(attivita));
		// A questo punto, where ha un valore e si può proseguire
		Result<Record> r = where
				.orderBy(DIPENDENZA.DATA_ASSUNZIONE.desc())
				.limit((int)pageSize)
				.offset(offset)
				.fetch();
		
		// PARTE 2: ottengo il conteggio dei record totali
		Field<Integer> countField = DIPENDENZA.ID.count();
		SelectJoinStep joinC = f.select(countField).from(DIPENDENZA);
		SelectConditionStep whereC;
		// Condizione sul dipendente
		if (dipendente != null) whereC = joinC.where(DIPENDENZA.ID_DIPENDENTE.equal(dipendente));
		else whereC = joinC.where();
		// Condizione sull'attività
		if (attivita != null) whereC = whereC.and(DIPENDENZA.ID_ATTIVITA.equal(attivita));
		// A questo punto, whereC ha un valore e si può proseguire
		Record c = whereC.fetchOne();
		
		Double count = Double.valueOf(c.getValue(countField));
		pages = Math.ceil(count/pageSize);
		DipendenzaList entity = new DipendenzaList(
				count, page, pages, new DipendenzaConverter().fromResult(r));
		
		DBUtil.closeConn(f);
		return entity;
	}
	
	@POST
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Dipendenza post(Dipendenza a) {
		Factory f = DBUtil.getConn();
		DipendenzaRecordDB r = f.newRecord(DIPENDENZA);
		new DipendenzaConverter().to(a, r);
		r.store();
		Dipendenza entity = new DipendenzaConverter().from(r);
		DBUtil.closeConn(f);
		return entity;
	}
	
	@PUT
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Dipendenza put(@PathParam("id") Long id, Dipendenza dip) {
		if (dip == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		DipendenzaRecordDB d = (DipendenzaRecordDB) f.
				select()
				.from(DIPENDENZA)
				.where(DIPENDENZA.ID.equal(dip.getId()))
				.fetchOne();
		d = new DipendenzaConverter().to(dip, d);
		int r = d.store();
		if (r != 1) {
			DBUtil.closeConn(f);
			throw new RuntimeException();
		}
		dip = new DipendenzaConverter().from(d);
		DBUtil.closeConn(f);
		return dip;
	}

	@DELETE
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Response delete(@PathParam("id") Long id) {
		Factory f = DBUtil.getConn();
		int d = f.delete(DIPENDENZA)
				.where(DIPENDENZA.ID.equal(id))
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
