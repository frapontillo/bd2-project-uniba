package net.frapontillo.uni.db2.project.db.auto;

import java.util.Date;
import java.util.List;

import org.apache.cayenne.CayenneDataObject;

import net.frapontillo.uni.db2.project.db.AttivitaDB;
import net.frapontillo.uni.db2.project.db.DipendenzaDB;

/**
 * Class _DipendenteDB was generated by Cayenne.
 * It is probably a good idea to avoid changing this class manually,
 * since it may be overwritten next time code is regenerated.
 * If you need to make any customizations, please use subclass.
 */
public abstract class _DipendenteDB extends CayenneDataObject {

    public static final String COGNOME_PROPERTY = "cognome";
    public static final String DATA_NASCITA_PROPERTY = "dataNascita";
    public static final String LUOGO_NASCITA_PROPERTY = "luogoNascita";
    public static final String NOME_PROPERTY = "nome";
    public static final String SESSO_PROPERTY = "sesso";
    public static final String ATTIVITAS_PROPERTY = "attivitas";
    public static final String DIPENDENZAS_PROPERTY = "dipendenzas";

    public static final String CF_PK_COLUMN = "cf";

    public void setCognome(String cognome) {
        writeProperty("cognome", cognome);
    }
    public String getCognome() {
        return (String)readProperty("cognome");
    }

    public void setDataNascita(Date dataNascita) {
        writeProperty("dataNascita", dataNascita);
    }
    public Date getDataNascita() {
        return (Date)readProperty("dataNascita");
    }

    public void setLuogoNascita(String luogoNascita) {
        writeProperty("luogoNascita", luogoNascita);
    }
    public String getLuogoNascita() {
        return (String)readProperty("luogoNascita");
    }

    public void setNome(String nome) {
        writeProperty("nome", nome);
    }
    public String getNome() {
        return (String)readProperty("nome");
    }

    public void setSesso(Boolean sesso) {
        writeProperty("sesso", sesso);
    }
    public Boolean getSesso() {
        return (Boolean)readProperty("sesso");
    }

    public void addToAttivitas(AttivitaDB obj) {
        addToManyTarget("attivitas", obj, true);
    }
    public void removeFromAttivitas(AttivitaDB obj) {
        removeToManyTarget("attivitas", obj, true);
    }
    @SuppressWarnings("unchecked")
    public List<AttivitaDB> getAttivitas() {
        return (List<AttivitaDB>)readProperty("attivitas");
    }


    public void addToDipendenzas(DipendenzaDB obj) {
        addToManyTarget("dipendenzas", obj, true);
    }
    public void removeFromDipendenzas(DipendenzaDB obj) {
        removeToManyTarget("dipendenzas", obj, true);
    }
    @SuppressWarnings("unchecked")
    public List<DipendenzaDB> getDipendenzas() {
        return (List<DipendenzaDB>)readProperty("dipendenzas");
    }


}
