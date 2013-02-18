package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.Dipendente;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenteRecordDB;
import net.frapontillo.uni.db2.project.util.ConvUtil;

public class DipendenteConverter extends AbstractConverter<DipendenteRecordDB, Dipendente> {

	@Override
	public Dipendente from(DipendenteRecordDB source, int lev) {
		if (source == null) return null;
		Dipendente obj = new Dipendente();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setCf(source.getCf());
			obj.setCognome(source.getCognome());
			obj.setNome(source.getNome());
			obj.setData_nascita(source.getDataNascita());
			obj.setLuogo_nascita(source.getLuogoNascita());
		}
		if (lev >= CONV_TYPE.NORMAL) {
			obj.setSesso(source.getSesso() ? "M" :"F");
		}
		if (lev >= CONV_TYPE.CASCADE) {
			obj.setAttivita_gestite(new AttivitaConverter().fromList(source.fetchAttivitaDBList()));
			obj.setImpieghi(new DipendenzaConverter().fromList(source.fetchDipendenzaDBList()));
		}
		return obj;
	}

	@Override
	public DipendenteRecordDB to(Dipendente source, DipendenteRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new DipendenteRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.setId(source.getId());
			dbObj.setCf(source.getCf());
			dbObj.setCognome(source.getCognome());
			dbObj.setNome(source.getNome());
			dbObj.setDataNascita(ConvUtil.DateUtilToSql(source.getData_nascita()));
			dbObj.setLuogoNascita(source.getLuogo_nascita());
		}
		if (lev >= CONV_TYPE.NORMAL) {
			String sesso = source.getSesso();
			if (sesso != null) {
				dbObj.setSesso(sesso.equals("M"));
			} else dbObj.setSesso(null);
			
		}
		if (lev >= CONV_TYPE.CASCADE) {
		}
		return dbObj;
	}

}
