package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.db.AttivitaDB;
import net.frapontillo.uni.db2.project.entity.Attivita;
import net.frapontillo.uni.db2.project.util.DBUtil;

public class AttivitaConverter extends AbstractConverter<AttivitaDB, Attivita> {

	@Override
	public Attivita from(AttivitaDB source, int lev) {
		if (source == null) return null;
		Attivita obj = new Attivita();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId((Integer) DBUtil.getID(source, AttivitaDB.ID_ATTIVITA_PK_COLUMN));
			obj.setCodice(source.getCodice());
			obj.setNome(source.getNome());
			obj.setTipo_attivita(new TipoAttivitaConverter().from(source.getToTipoAttivita(), lev));
		}
		if (lev >= CONV_TYPE.NORMAL) {
			obj.setFranchising(source.getFranchising());
			obj.setManager(new DipendenteConverter().from(source.getToDipendente()));
			obj.setNum_dip(source.getNumDip());
			obj.setPiva(source.getPiva());
			obj.setStruttura(new StrutturaConverter().from(source.getToStruttura(), lev-1));
		}
		if (lev >= CONV_TYPE.CASCADE) {
			obj.setDipendenze(new DipendenzaConverter().fromList(source.getDipendenzas(), lev-2));
		}
		return obj;
	}

	@Override
	public AttivitaDB to(Attivita source, AttivitaDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new AttivitaDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			dbObj.writeProperty(AttivitaDB.ID_ATTIVITA_PK_COLUMN, source.getId());
			dbObj.setCodice(source.getCodice());
			dbObj.setNome(source.getNome());
			Integer idAttivita = source.getTipo_attivita() != null ? source.getTipo_attivita().getId() : null;
			dbObj.writeProperty(AttivitaDB.TO_TIPO_ATTIVITA_PROPERTY, idAttivita);
		}
		if (lev >= CONV_TYPE.NORMAL) {
			dbObj.setFranchising(source.getFranchising());
			String cfManager = source.getManager() != null ? source.getManager().getCf() : null;
			dbObj.writeProperty(AttivitaDB.TO_DIPENDENTE_PROPERTY, cfManager);
			Integer numDip = source.getNum_dip();
			numDip = numDip == null ? 0 : numDip;
			dbObj.setNumDip(numDip);
			dbObj.setPiva(source.getPiva());
			dbObj.setPiano(source.getPiano());
		}
		if (lev >= CONV_TYPE.CASCADE) {
		}
		return dbObj;
	}

}
