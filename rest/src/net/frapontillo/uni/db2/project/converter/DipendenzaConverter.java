package net.frapontillo.uni.db2.project.converter;

import java.util.Date;

import net.frapontillo.uni.db2.project.db.DipendenzaDB;
import net.frapontillo.uni.db2.project.entity.Dipendenza;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class DipendenzaConverter extends AbstractConverter<DipendenzaDB, Dipendenza> {

	@Override
	public Dipendenza from(DipendenzaDB source, int lev) {
		if (source == null) return null;
		Dipendenza obj = new Dipendenza();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setCf((String) DBUtil.getID(source, DipendenzaDB.CF_DIPENDENTE_PK_COLUMN));
			obj.setId_attivita((Integer) DBUtil.getID(source, DipendenzaDB.ID_ATTIVITA_PK_COLUMN));
			obj.setData_assunzione((Date) DBUtil.getID(source, DipendenzaDB.DATA_ASSUNZIONE_PK_COLUMN));
			obj.setData_licenziamento(source.getDataLicenziamento());
		}
		obj.setAttivita(new AttivitaConverter().from(source.getToAttivita(), CONV_TYPE.MINIMUM));
		return obj;
	}

	@Override
	public DipendenzaDB to(Dipendenza source, DipendenzaDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new DipendenzaDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(DipendenzaDB.CF_DIPENDENTE_PK_COLUMN, source.getCf());
			dbObj.writeProperty(DipendenzaDB.ID_ATTIVITA_PK_COLUMN, source.getId_attivita());
			dbObj.writeProperty(DipendenzaDB.DATA_ASSUNZIONE_PK_COLUMN, source.getData_assunzione());
			dbObj.setDataLicenziamento(source.getData_licenziamento());
		}
		return dbObj;
	}

}
