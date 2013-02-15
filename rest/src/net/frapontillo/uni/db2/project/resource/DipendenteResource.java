package net.frapontillo.uni.db2.project.resource;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.jooq.impl.Factory;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import net.frapontillo.uni.db2.project.converter.DipendenteConverter;
import net.frapontillo.uni.db2.project.entity.Dipendente;
import net.frapontillo.uni.db2.project.exception.BadRequestException;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.spi.container.ResourceFilters;

@Path("dipendente")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
@ResourceFilters(AuthenticationResourceFilter.class)
public class DipendenteResource {
	@GET
	@Path("/{cf}")
	public Dipendente get(@PathParam("cf") String cf) {
		if (cf == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		DipendenteRecordDB dbObj = (DipendenteRecordDB) f.select()
				.from(DIPENDENTE)
				.where(DIPENDENTE.CF.equal(cf))
				.fetchOne();
		Dipendente d = new DipendenteConverter().from(dbObj);
		return d;
	}
	
	@POST
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Dipendente post(Dipendente dip) {
		if (dip == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		DipendenteRecordDB d = f.newRecord(DIPENDENTE);
		d = new DipendenteConverter().to(dip, d);
		int r = d.store();
		if (r != 1) throw new RuntimeException();
		dip = new DipendenteConverter().from(d);
		return dip;
	}
	
	@PUT
	@Path("/{cf}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Dipendente put(@PathParam("cf") String cf, Dipendente dip) {
		if (dip == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		DipendenteRecordDB d = (DipendenteRecordDB) f.
				select()
				.from(DIPENDENTE)
				.where(DIPENDENTE.CF.equal(dip.getCf()))
				.fetchOne();
		d = new DipendenteConverter().to(dip, d);
		int r = d.store();
		if (r != 1) throw new RuntimeException();
		dip = new DipendenteConverter().from(d);
		return dip;
	}
	
	@DELETE
	@Path("/{cf}")
	public void delete(@PathParam("cf") String cf) {
		if (cf == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		int r = f.delete(DIPENDENTE)
				.where(DIPENDENTE.CF.equal(cf))
				.execute();
		if (r != 1) throw new RuntimeException();
		return;
	}
}
