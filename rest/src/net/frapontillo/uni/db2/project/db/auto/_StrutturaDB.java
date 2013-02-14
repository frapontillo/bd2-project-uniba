package net.frapontillo.uni.db2.project.db.auto;

import java.util.List;

import org.apache.cayenne.CayenneDataObject;

import net.frapontillo.uni.db2.project.db.AttivitaDB;
import net.frapontillo.uni.db2.project.db.TipoStrutturaDB;

/**
 * Class _StrutturaDB was generated by Cayenne.
 * It is probably a good idea to avoid changing this class manually,
 * since it may be overwritten next time code is regenerated.
 * If you need to make any customizations, please use subclass.
 */
public abstract class _StrutturaDB extends CayenneDataObject {

    public static final String CODICE_PROPERTY = "codice";
    public static final String ATTIVITAS_PROPERTY = "attivitas";
    public static final String TO_TIPO_STRUTTURA_PROPERTY = "toTipoStruttura";

    public static final String ID_STRUTTURA_PK_COLUMN = "id_struttura";

    public void setCodice(String codice) {
        writeProperty("codice", codice);
    }
    public String getCodice() {
        return (String)readProperty("codice");
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


    public void setToTipoStruttura(TipoStrutturaDB toTipoStruttura) {
        setToOneTarget("toTipoStruttura", toTipoStruttura, true);
    }

    public TipoStrutturaDB getToTipoStruttura() {
        return (TipoStrutturaDB)readProperty("toTipoStruttura");
    }


}
