/**
 * This class is generated by jOOQ
 */
package net.frapontillo.uni.db2.project.jooq.gen;

/**
 * This class is generated by jOOQ.
 *
 * Convenience access to all stored procedures and functions in public
 */
@javax.annotation.Generated(value    = {"http://www.jooq.org", "2.6.2"},
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings("all")
public final class Routines {

	/**
	 * Call public.cerca_dipendente
	 *
	 * @param nomecognome
	 * @param lim
	 * @param offs
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Object cercaDipendente(org.jooq.Configuration configuration, java.lang.String nomecognome, java.lang.Long lim, java.lang.Long offs) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendenteDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendenteDB();
		f.setNomecognome(nomecognome);
		f.setLim(lim);
		f.setOffs(offs);

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.cerca_dipendente as a field
	 *
	 * @param nomecognome
	 * @param lim
	 * @param offs
	 */
	public static org.jooq.Field<java.lang.Object> cercaDipendente(java.lang.String nomecognome, java.lang.Long lim, java.lang.Long offs) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendenteDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendenteDB();
		f.setNomecognome(nomecognome);
		f.setLim(lim);
		f.setOffs(offs);

		return f.asField();
	}

	/**
	 * Get public.cerca_dipendente as a field
	 *
	 * @param nomecognome
	 * @param lim
	 * @param offs
	 */
	public static org.jooq.Field<java.lang.Object> cercaDipendente(org.jooq.Field<java.lang.String> nomecognome, org.jooq.Field<java.lang.Long> lim, org.jooq.Field<java.lang.Long> offs) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendenteDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendenteDB();
		f.setNomecognome(nomecognome);
		f.setLim(lim);
		f.setOffs(offs);

		return f.asField();
	}

	/**
	 * Call public.cerca_dipendenti
	 *
	 * @param nomecognome IN parameter
	 * @param lim IN parameter
	 * @param offs IN parameter
	 * @param cf OUT parameter
	 * @param nome OUT parameter
	 * @param cognome OUT parameter
	 * @param luogoNascita OUT parameter
	 * @param datNascita OUT parameter
	 * @param sesso OUT parameter
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendentiDB cercaDipendenti(org.jooq.Configuration configuration, java.lang.String nomecognome, java.lang.Long lim, java.lang.Long offs) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendentiDB p = new net.frapontillo.uni.db2.project.jooq.gen.routines.CercaDipendentiDB();
		p.setNomecognome(nomecognome);
		p.setLim(lim);
		p.setOffs(offs);

		p.execute(configuration);
		return p;
	}

	/**
	 * Call public.conta_cerca_dipendenti
	 *
	 * @param nomecognome
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Integer contaCercaDipendenti(org.jooq.Configuration configuration, java.lang.String nomecognome) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.ContaCercaDipendentiDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.ContaCercaDipendentiDB();
		f.setNomecognome(nomecognome);

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.conta_cerca_dipendenti as a field
	 *
	 * @param nomecognome
	 */
	public static org.jooq.Field<java.lang.Integer> contaCercaDipendenti(java.lang.String nomecognome) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.ContaCercaDipendentiDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.ContaCercaDipendentiDB();
		f.setNomecognome(nomecognome);

		return f.asField();
	}

	/**
	 * Get public.conta_cerca_dipendenti as a field
	 *
	 * @param nomecognome
	 */
	public static org.jooq.Field<java.lang.Integer> contaCercaDipendenti(org.jooq.Field<java.lang.String> nomecognome) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.ContaCercaDipendentiDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.ContaCercaDipendentiDB();
		f.setNomecognome(nomecognome);

		return f.asField();
	}

	/**
	 * Call public.del_dipendenza
	 *
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Object delDipendenza(org.jooq.Configuration configuration) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.DelDipendenzaDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.DelDipendenzaDB();

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.del_dipendenza as a field
	 *
	 */
	public static org.jooq.Field<java.lang.Object> delDipendenza() {
		net.frapontillo.uni.db2.project.jooq.gen.routines.DelDipendenzaDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.DelDipendenzaDB();

		return f.asField();
	}

	/**
	 * Call public.esiste_sessione
	 *
	 * @param auth
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Boolean esisteSessione(org.jooq.Configuration configuration, java.lang.String auth) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.EsisteSessioneDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.EsisteSessioneDB();
		f.setAuth(auth);

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.esiste_sessione as a field
	 *
	 * @param auth
	 */
	public static org.jooq.Field<java.lang.Boolean> esisteSessione(java.lang.String auth) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.EsisteSessioneDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.EsisteSessioneDB();
		f.setAuth(auth);

		return f.asField();
	}

	/**
	 * Get public.esiste_sessione as a field
	 *
	 * @param auth
	 */
	public static org.jooq.Field<java.lang.Boolean> esisteSessione(org.jooq.Field<java.lang.String> auth) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.EsisteSessioneDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.EsisteSessioneDB();
		f.setAuth(auth);

		return f.asField();
	}

	/**
	 * Call public.ins_dipendenza
	 *
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Object insDipendenza(org.jooq.Configuration configuration) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.InsDipendenzaDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.InsDipendenzaDB();

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.ins_dipendenza as a field
	 *
	 */
	public static org.jooq.Field<java.lang.Object> insDipendenza() {
		net.frapontillo.uni.db2.project.jooq.gen.routines.InsDipendenzaDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.InsDipendenzaDB();

		return f.asField();
	}

	/**
	 * Call public.upd_dipendenza
	 *
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Object updDipendenza(org.jooq.Configuration configuration) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaDB();

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.upd_dipendenza as a field
	 *
	 */
	public static org.jooq.Field<java.lang.Object> updDipendenza() {
		net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaDB();

		return f.asField();
	}

	/**
	 * Call public.upd_dipendenza_licenziamento
	 *
	 * @throws org.jooq.exception.DataAccessException if something went wrong executing the query
	 */
	public static java.lang.Object updDipendenzaLicenziamento(org.jooq.Configuration configuration) {
		net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaLicenziamentoDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaLicenziamentoDB();

		f.execute(configuration);
		return f.getReturnValue();
	}

	/**
	 * Get public.upd_dipendenza_licenziamento as a field
	 *
	 */
	public static org.jooq.Field<java.lang.Object> updDipendenzaLicenziamento() {
		net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaLicenziamentoDB f = new net.frapontillo.uni.db2.project.jooq.gen.routines.UpdDipendenzaLicenziamentoDB();

		return f.asField();
	}

	/**
	 * No instances
	 */
	private Routines() {}
}
