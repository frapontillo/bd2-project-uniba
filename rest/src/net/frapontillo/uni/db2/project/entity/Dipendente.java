package net.frapontillo.uni.db2.project.entity;

import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Dipendente implements IEntity {  
	protected Integer id;
    protected String cf;
    protected String cognome;
    protected String nome;
    protected Date data_nascita;
    protected String luogo_nascita;
    protected String sesso;
    protected List<Attivita> attivita_gestite;
    protected List<Dipendenza> impieghi;
    
	public Dipendente(Integer id, String cf, String cognome, String nome,
			Date data_nascita, String luogo_nascita, String sesso,
			List<Attivita> attivita_gestite, List<Dipendenza> impieghi) {
		super();
		this.id = id;
		this.cf = cf;
		this.cognome = cognome;
		this.nome = nome;
		this.data_nascita = data_nascita;
		this.luogo_nascita = luogo_nascita;
		this.sesso = sesso;
		this.attivita_gestite = attivita_gestite;
		this.impieghi = impieghi;
	}
    
	public Dipendente() {}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCf() {
		return cf;
	}

	public void setCf(String cf) {
		this.cf = cf;
	}

	public String getCognome() {
		return cognome;
	}

	public void setCognome(String cognome) {
		this.cognome = cognome;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public Date getData_nascita() {
		return data_nascita;
	}

	public void setData_nascita(Date data_nascita) {
		this.data_nascita = data_nascita;
	}

	public String getLuogo_nascita() {
		return luogo_nascita;
	}

	public void setLuogo_nascita(String luogo_nascita) {
		this.luogo_nascita = luogo_nascita;
	}

	public String getSesso() {
		return sesso;
	}

	public void setSesso(String sesso) {
		this.sesso = sesso;
	}

	public List<Attivita> getAttivita_gestite() {
		return attivita_gestite;
	}

	public void setAttivita_gestite(List<Attivita> attivita_gestite) {
		this.attivita_gestite = attivita_gestite;
	}

	public List<Dipendenza> getImpieghi() {
		return impieghi;
	}

	public void setImpieghi(List<Dipendenza> impieghi) {
		this.impieghi = impieghi;
	}
}
