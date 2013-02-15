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

import net.frapontillo.uni.db2.project.converter.TipoStrutturaConverter;
import net.frapontillo.uni.db2.project.entity.TipoStruttura;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoStrutturaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.spi.container.ResourceFilters;

@Path("tipostruttura")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
@ResourceFilters(AuthenticationResourceFilter.class)
public class TipoStrutturaResource {
	@GET
	@Path("/{id}")
	public TipoStruttura get(@PathParam("id") Integer id) {
		TipoStrutturaRecordDB r = (TipoStrutturaRecordDB) DBUtil.getConn()
				.select()
				.from(TIPO_STRUTTURA)
				.where(TIPO_STRUTTURA.ID.equal(id))
				.fetchOne();
		TipoStruttura entity = new TipoStrutturaConverter().from(r);
		return entity;
	}
	
	@GET
	public GenericEntity<List<TipoStruttura>> search(
			@QueryParam("descrizione") @DefaultValue("") String descrizione,
			@QueryParam("skip") @DefaultValue("0") Integer skip,
			@QueryParam("top") @DefaultValue("20") Integer top) {
		Result<Record> r = DBUtil.getConn()
				.select()
				.from(TIPO_STRUTTURA)
				.where(TIPO_STRUTTURA.DESCRIZIONE.likeIgnoreCase("%"+descrizione+"%"))
				.limit(top)
				.offset(skip)
				.fetch();
		List<TipoStruttura> entity = new TipoStrutturaConverter().fromResult(r);
		return new GenericEntity<List<TipoStruttura>>(entity) {};
	}
}
