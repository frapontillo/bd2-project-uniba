package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.TipoAttivita;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.TipoAttivitaRecordDB;

public class TipoAttivitaConverter extends AbstractConverter<TipoAttivitaRecordDB, TipoAttivita> {

	@Override
	public TipoAttivita from(TipoAttivitaRecordDB source, int lev) {
		if (source == null) return null;
		TipoAttivita obj = new TipoAttivita();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setDescrizione(source.getDescrizione());
		}
		return obj;
	}

	@Override
	public TipoAttivitaRecordDB to(TipoAttivita source, TipoAttivitaRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new TipoAttivitaRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setDescrizione(source.getDescrizione());
		}
		return dbObj;
	}

}
