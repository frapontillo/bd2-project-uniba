package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.Struttura;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.StrutturaRecordDB;

public class StrutturaConverter extends AbstractConverter<StrutturaRecordDB, Struttura> {

	@Override
	public Struttura from(StrutturaRecordDB source, int lev) {
		if (source == null) return null;
		Struttura obj = new Struttura();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getIdStruttura());
			obj.setCodice(source.getCodice());
			obj.setTipo(new TipoStrutturaConverter().from(source.fetchTipoStrutturaDB()));
		}
		if (lev >= CONV_TYPE.CASCADE) {
			obj.setAttivita(new AttivitaConverter().fromList(source.fetchAttivitaDBList()));
		}
		return obj;
	}

	@Override
	public StrutturaRecordDB to(Struttura source, StrutturaRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new StrutturaRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setIdStruttura(source.getId());
			dbObj.setCodice(source.getCodice());
			dbObj.setIdTipoStruttura(source.getTipo().getId());
		}
		return dbObj;
	}

}
