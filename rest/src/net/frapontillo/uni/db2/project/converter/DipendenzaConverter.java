package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.Dipendenza;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.DipendenzaRecordDB;
import net.frapontillo.uni.db2.project.util.ConvUtil;

public class DipendenzaConverter extends AbstractConverter<DipendenzaRecordDB, Dipendenza> {

	@Override
	public Dipendenza from(DipendenzaRecordDB source, int lev) {
		if (source == null) return null;
		Dipendenza obj = new Dipendenza();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getId());
			obj.setIdDipendente(source.getIdDipendente());
			obj.setId_attivita(source.getIdAttivita());
			obj.setData_assunzione(source.getDataAssunzione());
			obj.setData_licenziamento(source.getDataLicenziamento());
			obj.setAttivita(new AttivitaConverter().from(source.fetchAttivitaDB(), CONV_TYPE.MINIMUM));
			obj.setDipendente(new DipendenteConverter().from(source.fetchDipendenteDB(), CONV_TYPE.MINIMUM));
		}
		return obj;
	}

	@Override
	public DipendenzaRecordDB to(Dipendenza source, DipendenzaRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new DipendenzaRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			if (source.getId() != null) dbObj.setId(source.getId());
			dbObj.setIdDipendente(source.getDipendente().getId());
			dbObj.setIdAttivita(source.getAttivita().getId());
			dbObj.setDataAssunzione(ConvUtil.DateUtilToSql(source.getData_assunzione()));
			dbObj.setDataLicenziamento(ConvUtil.DateUtilToSql(source.getData_licenziamento()));
		}
		return dbObj;
	}

}
