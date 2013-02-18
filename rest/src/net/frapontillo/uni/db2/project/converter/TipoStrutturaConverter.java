package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.TipoStruttura;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoStrutturaRecordDB;

public class TipoStrutturaConverter extends AbstractConverter<TipoStrutturaRecordDB, TipoStruttura> {

	@Override
	public TipoStruttura from(TipoStrutturaRecordDB source, int lev) {
		if (source == null) return null;
		TipoStruttura obj = new TipoStruttura();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setCodice(source.getCodice());
			obj.setDescrizione(source.getDescrizione());
		}
		return obj;
	}

	@Override
	public TipoStrutturaRecordDB to(TipoStruttura source, TipoStrutturaRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new TipoStrutturaRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setCodice(source.getCodice());
			dbObj.setDescrizione(source.getDescrizione());
		}
		return dbObj;
	}

}
