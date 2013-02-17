package net.frapontillo.uni.db2.project.resource;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;

import org.jooq.Record;
import org.jooq.Result;
import org.jooq.impl.Factory;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import net.frapontillo.uni.db2.project.converter.DipendenzaConverter;
import net.frapontillo.uni.db2.project.entity.Dipendenza;
import net.frapontillo.uni.db2.project.exception.BadRequestException;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenzaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

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
		return d;
	}
	
	@GET
	public GenericEntity<List<Dipendenza>> search(@QueryParam("dipendente") Integer dipendente) {
		if (dipendente == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		Result<Record> dbObj = f
				.select()
				.from(DIPENDENZA)
				.where(DIPENDENZA.ID_DIPENDENTE.equal(dipendente))
				.fetch();
		List<Dipendenza> entity = new DipendenzaConverter().fromResult(dbObj);
		return new GenericEntity<List<Dipendenza>>(entity) {};
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
		if (r != 1) throw new RuntimeException();
		dip = new DipendenzaConverter().from(d);
		return dip;
	}
	
}
