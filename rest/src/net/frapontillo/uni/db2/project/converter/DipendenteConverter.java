package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.DipendenteDB;
import net.frapontillo.uni.db2.project.entity.Dipendente;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class DipendenteConverter extends AbstractConverter<DipendenteDB, Dipendente> {

	@Override
	public Dipendente from(DipendenteDB source, int lev) {
		if (source == null) return null;
		Dipendente obj = new Dipendente();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setCf((String) DBUtil.getID(source, DipendenteDB.CF_PK_COLUMN));
			obj.setCognome(source.getCognome());
			obj.setNome(source.getNome());
		}
		if (lev >= CONV_TYPE.NORMAL) {
			obj.setData_nascita(source.getDataNascita());
			obj.setLuogo_nascita(source.getLuogoNascita());
			obj.setSesso(source.getSesso() ? "M" : "F");
		}
		if (lev >= CONV_TYPE.CASCADE) {
			obj.setAttivita_gestite(new AttivitaConverter().fromList(source.getAttivitas()));
			obj.setImpieghi(new DipendenzaConverter().fromList(source.getDipendenzas()));
		}
		return obj;
	}

	@Override
	public DipendenteDB to(Dipendente source, DipendenteDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new DipendenteDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(DipendenteDB.CF_PK_COLUMN, source.getCf());
			dbObj.setCognome(source.getCognome());
			dbObj.setNome(source.getNome());
		}
		if (lev >= CONV_TYPE.NORMAL) {
			dbObj.setDataNascita(source.getData_nascita());
			dbObj.setLuogoNascita(source.getLuogo_nascita());
			dbObj.setSesso(source.getSesso() == "M");
		}
		if (lev >= CONV_TYPE.CASCADE) {
			// TODO: impossibile gestire attività gestite e dipendenze da qui
		}
		return dbObj;
	}

}
