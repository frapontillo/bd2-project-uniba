package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Struttura implements IEntity {
	protected Integer id;
	protected String codice;
	protected TipoStruttura tipo;
	protected List<Attivita> attivita;
	public Struttura(Integer id, String codice, TipoStruttura tipo,
			List<Attivita> attivita) {
		super();
		this.id = id;
		this.codice = codice;
		this.tipo = tipo;
		this.attivita = attivita;
	}
	
	public Struttura() {}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCodice() {
		return codice;
	}

	public void setCodice(String codice) {
		this.codice = codice;
	}

	public TipoStruttura getTipo() {
		return tipo;
	}

	public void setTipo(TipoStruttura tipo) {
		this.tipo = tipo;
	}

	public List<Attivita> getAttivita() {
		return attivita;
	}

	public void setAttivita(List<Attivita> attivita) {
		this.attivita = attivita;
	}
	
}
