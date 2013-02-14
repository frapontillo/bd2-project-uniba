package net.frapontillo.uni.db2.project.entity;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class TipoStruttura implements IEntity {
	protected Integer id;
	protected char codice;
	protected String descrizione;
	public TipoStruttura(Integer id, char codice, String descrizione) {
		super();
		this.id = id;
		this.codice = codice;
		this.descrizione = descrizione;
	}
	public TipoStruttura() {}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public char getCodice() {
		return codice;
	}
	public void setCodice(char codice) {
		this.codice = codice;
	}
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}
}
