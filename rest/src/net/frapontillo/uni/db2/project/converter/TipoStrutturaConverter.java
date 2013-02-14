package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.TipoStrutturaDB;
import net.frapontillo.uni.db2.project.entity.TipoStruttura;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class TipoStrutturaConverter extends AbstractConverter<TipoStrutturaDB, TipoStruttura> {

	@Override
	public TipoStruttura from(TipoStrutturaDB source, int lev) {
		if (source == null) return null;
		TipoStruttura obj = new TipoStruttura();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId((Integer) DBUtil.getID(source, TipoStrutturaDB.ID_PK_COLUMN));
			obj.setCodice(source.getCodice().charAt(0));
			obj.setDescrizione(source.getDescrizione());
		}
		return obj;
	}

	@Override
	public TipoStrutturaDB to(TipoStruttura source, TipoStrutturaDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new TipoStrutturaDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(TipoStrutturaDB.ID_PK_COLUMN, source.getId());
			dbObj.setCodice(String.valueOf(source.getCodice()));
			dbObj.setDescrizione(source.getDescrizione());
		}
		return dbObj;
	}

}
