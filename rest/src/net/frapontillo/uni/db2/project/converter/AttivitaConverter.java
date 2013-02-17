package net.frapontillo.uni.db2.project.converter;

import net.frapontillo.uni.db2.project.entity.Attivita;
import net.frapontillo.uni.db2.project.jooq.gen.tables.records.AttivitaRecordDB;

public class AttivitaConverter extends AbstractConverter<AttivitaRecordDB, Attivita> {

	@Override
	public Attivita from(AttivitaRecordDB source, int lev) {
		if (source == null) return null;
		Attivita obj = new Attivita();
		if (lev >= CONV_TYPE.MINIMUM) {
			obj.setId(source.getIdAttivita());
			obj.setCodice(source.getCodice());
			obj.setNome(source.getNome());
			obj.setTipo_attivita(new TipoAttivitaConverter().from(source.fetchTipoAttivitaDB(), lev));
		}
		if (lev >= CONV_TYPE.NORMAL) {
			obj.setFranchising(source.getFranchising());
			obj.setManager(new DipendenteConverter().from(source.fetchDipendenteDB()));
			obj.setNum_dip(source.getNumDip());
			obj.setPiva(source.getPiva());
			obj.setStruttura(new StrutturaConverter().from(source.fetchStrutturaDB(), lev-1));
		}
		if (lev >= CONV_TYPE.CASCADE) {
			obj.setDipendenze(new DipendenzaConverter().fromList(source.fetchDipendenzaDBList(), lev-2));
		}
		return obj;
	}

	@Override
	public AttivitaRecordDB to(Attivita source, AttivitaRecordDB dbObj, int lev) {
		if (source == null) return null;
		if (dbObj == null) dbObj = new AttivitaRecordDB();
		if (lev >= CONV_TYPE.MINIMUM) {
			if (source.getId() != null)
				dbObj.setIdAttivita(source.getId());
			dbObj.setCodice(source.getCodice());
			dbObj.setNome(source.getNome());
			Integer idTipoAttivita = source.getTipo_attivita() != null ? source.getTipo_attivita().getId() : null;
			dbObj.setIdTipoAttivita(idTipoAttivita);
		}
		if (lev >= CONV_TYPE.NORMAL) {
			dbObj.setFranchising(source.getFranchising());
			Integer idManager = source.getManager() != null ? source.getManager().getId() : null;
			dbObj.setIdDipendenteManager(idManager);
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
