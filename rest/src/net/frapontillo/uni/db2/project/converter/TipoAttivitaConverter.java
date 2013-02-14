package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.TipoAttivitaDB;
import net.frapontillo.uni.db2.project.entity.TipoAttivita;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class TipoAttivitaConverter extends AbstractConverter<TipoAttivitaDB, TipoAttivita> {

	@Override
	public TipoAttivita from(TipoAttivitaDB source, int lev) {
		if (source == null) return null;
		TipoAttivita obj = new TipoAttivita();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId((Integer) DBUtil.getID(source, TipoAttivitaDB.ID_PK_COLUMN));
			obj.setDescrizione(source.getDescrizione());
		}
		return obj;
	}

	@Override
	public TipoAttivitaDB to(TipoAttivita source, TipoAttivitaDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new TipoAttivitaDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(TipoAttivitaDB.ID_PK_COLUMN, source.getId());
			dbObj.setDescrizione(source.getDescrizione());
		}
		return dbObj;
	}

}
