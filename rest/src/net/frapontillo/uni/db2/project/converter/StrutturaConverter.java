package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.StrutturaDB;
import net.frapontillo.uni.db2.project.entity.Struttura;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class StrutturaConverter extends AbstractConverter<StrutturaDB, Struttura> {

	@Override
	public Struttura from(StrutturaDB source, int lev) {
		if (source == null) return null;
		Struttura obj = new Struttura();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId((Integer) DBUtil.getID(source, StrutturaDB.ID_STRUTTURA_PK_COLUMN));
			obj.setCodice(source.getCodice());
			obj.setTipo(new TipoStrutturaConverter().from(source.getToTipoStruttura()));
		}
		if (lev >= CONV_TYPE.CASCADE) {
			obj.setAttivita(new AttivitaConverter().fromList(source.getAttivitas()));
		}
		return obj;
	}

	@Override
	public StrutturaDB to(Struttura source, StrutturaDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new StrutturaDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(StrutturaDB.ID_STRUTTURA_PK_COLUMN, source.getId());
			dbObj.setCodice(source.getCodice());
			dbObj.setToTipoStruttura(new TipoStrutturaConverter().to(source.getTipo()));
		}
		if (lev >= CONV_TYPE.CASCADE) {
			// TODO: impossibile gestire le attività da qui
		}
		return dbObj;
	}

}
