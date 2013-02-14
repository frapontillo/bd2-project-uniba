package net.frapontillo.uni.db2.project.entity;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class TipoAttivita implements IEntity {
	protected Integer id;
	protected String descrizione;
	public TipoAttivita(Integer id, String descrizione) {
		super();
		this.id = id;
		this.descrizione = descrizione;
	}
	public TipoAttivita() {}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}
}
