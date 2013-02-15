package net.frapontillo.uni.db2.project.entity;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Dipendenza implements IEntity {
	protected Long id;
	protected String cf;
	protected Integer id_attivita;
	protected Date data_assunzione;
	protected Date data_licenziamento;
	protected Dipendente dipendente;
	protected Attivita attivita;
	public Dipendenza(Long id, String cf, Integer id_attivita, Date data_assunzione,
			Date data_licenziamento, Dipendente dipendente, Attivita attivita) {
		super();
		this.id = id;
		this.cf = cf;
		this.id_attivita = id_attivita;
		this.data_assunzione = data_assunzione;
		this.data_licenziamento = data_licenziamento;
		this.dipendente = dipendente;
		this.attivita = attivita;
	}
	public Dipendenza() {}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCf() {
		return cf;
	}
	public void setCf(String cf) {
		this.cf = cf;
	}
	public Integer getId_attivita() {
		return id_attivita;
	}
	public void setId_attivita(Integer id_attivita) {
		this.id_attivita = id_attivita;
	}
	public Date getData_assunzione() {
		return data_assunzione;
	}
	public void setData_assunzione(Date data_assunzione) {
		this.data_assunzione = data_assunzione;
	}
	public Date getData_licenziamento() {
		return data_licenziamento;
	}
	public void setData_licenziamento(Date data_licenziamento) {
		this.data_licenziamento = data_licenziamento;
	}
	public Dipendente getDipendente() {
		return dipendente;
	}
	public void setDipendente(Dipendente dipendente) {
		this.dipendente = dipendente;
	}
	public Attivita getAttivita() {
		return attivita;
	}
	public void setAttivita(Attivita attivita) {
		this.attivita = attivita;
	}
}
