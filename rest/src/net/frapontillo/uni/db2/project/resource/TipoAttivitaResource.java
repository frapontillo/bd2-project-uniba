package net.frapontillo.uni.db2.project.resource;

import static net.frapontillo.uni.db2.project.jooq.gen.Tables.*;

import java.util.List;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;

import org.jooq.Record;
import org.jooq.Result;
import org.jooq.SelectLimitStep;
import org.jooq.impl.Factory;

import net.frapontillo.uni.db2.project.converter.TipoAttivitaConverter;
import net.frapontillo.uni.db2.project.entity.TipoAttivita;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoAttivitaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.spi.container.ResourceFilters;

@Path("tipoattivita")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
@ResourceFilters(AuthenticationResourceFilter.class)
public class TipoAttivitaResource {
	@GET
	@Path("/{id}")
	public TipoAttivita get(@PathParam("id") Integer id) {
		Factory f = DBUtil.getConn();
		TipoAttivitaRecordDB r = (TipoAttivitaRecordDB) f
				.select()
				.from(TIPO_ATTIVITA)
				.where(TIPO_ATTIVITA.ID.equal(id))
				.fetchOne();
		TipoAttivita entity = new TipoAttivitaConverter().from(r);
		DBUtil.closeConn(f);
		return entity;
	}
	
	@GET
	public GenericEntity<List<TipoAttivita>> search(
			@QueryParam("descrizione") @DefaultValue("") String descrizione,
			@QueryParam("skip") @DefaultValue("0") Integer skip,
			@QueryParam("top") @DefaultValue("0") Integer top) {
		Factory f = DBUtil.getConn();
		SelectLimitStep s = f
				.select()
				.from(TIPO_ATTIVITA)
				.where(TIPO_ATTIVITA.DESCRIZIONE.likeIgnoreCase("%"+descrizione+"%"))
				.orderBy(TIPO_ATTIVITA.DESCRIZIONE);
		Result<Record> r = null;
		if (top > 0) {
			skip = skip >= 0 ? skip : 0;
			r = s.limit(top).offset(skip).fetch();
		} else {
			r = s.fetch();
		}
		List<TipoAttivita> entity = new TipoAttivitaConverter().fromResult(r);
		DBUtil.closeConn(f);
		return new GenericEntity<List<TipoAttivita>>(entity) {};
	}
}
