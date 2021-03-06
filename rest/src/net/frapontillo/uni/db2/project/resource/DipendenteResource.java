package net.frapontillo.uni.db2.project.resource;

import java.util.List;

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

import org.jooq.impl.Factory;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;
import static net.frapontillo.uni.db2.project.jooq.gen.Routines.*;

import net.frapontillo.uni.db2.project.converter.CONV_TYPE;
import net.frapontillo.uni.db2.project.converter.DipendenteConverter;
import net.frapontillo.uni.db2.project.entity.Dipendente;
import net.frapontillo.uni.db2.project.entity.DipendenteList;
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
	@Path("/{id}")
	public Dipendente get(@PathParam("id") Integer id) {
		if (id == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		try {
			DipendenteRecordDB dbObj = (DipendenteRecordDB) f.select()
					.from(DIPENDENTE)
					.where(DIPENDENTE.ID.equal(id))
					.fetchOne();
			Dipendente d = new DipendenteConverter().from(dbObj);
			return d;
		} finally {
			DBUtil.closeConn(f);
		}
	}
	
	@GET
	public DipendenteList search(
			@QueryParam("nomecognome") String nomecognome,
			@QueryParam("page") @DefaultValue("1") Double page) {
		Factory f = DBUtil.getConn();
		try {
			Long pageSize = (long) 10;
			Long offset = (long) (pageSize*(page-1));
			double pages = 0;
			String sql = cercaDipendente(nomecognome, pageSize, offset).toString();
			List<DipendenteRecordDB> r = f.select().from(sql).fetch().into(DipendenteRecordDB.class);
			Double count = f.select(contaCercaDipendenti(nomecognome)).fetchOne(0, Double.class);
			pages = Math.ceil(count/pageSize);
			DipendenteList entity = new DipendenteList(
					count, page, pages, new DipendenteConverter().fromList(r, CONV_TYPE.MINIMUM));
			return entity;
		} finally {
			DBUtil.closeConn(f);
		}
	}
	
	@POST
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Dipendente post(Dipendente dip) {
		if (dip == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		try {
			DipendenteRecordDB d = f.newRecord(DIPENDENTE);
			d = new DipendenteConverter().to(dip, d);
			int r = d.store();
			if (r != 1) {
				DBUtil.closeConn(f);
				throw new RuntimeException();
			}
			dip = new DipendenteConverter().from(d);
			return dip;
		} finally {
			DBUtil.closeConn(f);
		}
	}
	
	@PUT
	@Path("/{id}")
	@Consumes({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public Dipendente put(@PathParam("id") Integer id, Dipendente dip) {
		if (dip == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		try {
			DipendenteRecordDB d = (DipendenteRecordDB) f.
					select()
					.from(DIPENDENTE)
					.where(DIPENDENTE.ID.equal(id))
					.fetchOne();
			d = new DipendenteConverter().to(dip, d);
			int r = d.store();
			if (r != 1) {
				DBUtil.closeConn(f);
				throw new RuntimeException();
			}
			dip = new DipendenteConverter().from(d);
			return dip;
		} finally {
			DBUtil.closeConn(f);
		}
	}
	
	@DELETE
	@Path("/{id}")
	public void delete(@PathParam("id") Integer id) {
		if (id == null) throw new BadRequestException();
		Factory f = DBUtil.getConn();
		try {
			int r = f.delete(DIPENDENTE)
					.where(DIPENDENTE.ID.equal(id))
					.execute();
			if (r != 1) {
				DBUtil.closeConn(f);
				throw new RuntimeException();
			}
			return;
		} finally {
			DBUtil.closeConn(f);
		}
	}
}
