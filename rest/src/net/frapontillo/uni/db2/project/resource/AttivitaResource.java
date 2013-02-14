package net.frapontillo.uni.db2.project.resource;

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.apache.cayenne.exp.ExpressionFactory;
import org.apache.cayenne.query.SelectQuery;
import org.jooq.Record;

import static net.frapontillo.uni.db2.project.jooq.Tables.*;
import static org.jooq.impl.Factory.*;

import net.frapontillo.uni.db2.project.converter.AttivitaConverter;
import net.frapontillo.uni.db2.project.entity.Attivita;
import net.frapontillo.uni.db2.project.filter.AuthenticationResourceFilter;
import net.frapontillo.uni.db2.project.jooq.tables.records.AttivitaRecordDB;
import net.frapontillo.uni.db2.project.util.DBUtil;

import com.sun.jersey.spi.container.ResourceFilters;

@Path("attivita")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
//@ResourceFilters(AuthenticationResourceFilter.class)
public class AttivitaResource {
	@GET
	@Path("/{id}")
	public Attivita get(@PathParam("id") String id) {
		int mId = Integer.parseInt(id);
		AttivitaRecordDB r = (AttivitaRecordDB) DBUtil.getConn().select()
		.from(ATTIVITA)
		.where(ATTIVITA.ID_ATTIVITA.equal(mId))
		.fetchOne();
		Boolean c = r == null;
		return null;
	}
	
	@GET
	public Attivita search(@QueryParam("nome") String nome) {
//		SelectQuery query = new SelectQuery(AttivitaDB.class,
//				ExpressionFactory.likeIgnoreCaseDbExp(AttivitaDB.NOME_PROPERTY, "%"+nome+"%"));
//		List<AttivitaDB> dbObjs = (List<AttivitaDB>)DBUtil.getContext().performQuery(query);
//		AttivitaDB dbObj = dbObjs.size() > 0 ? (AttivitaDB)dbObjs.get(0) : null;
//		Attivita obj = new AttivitaConverter().from(dbObj);
//		return obj;
		return null;
	}
}
