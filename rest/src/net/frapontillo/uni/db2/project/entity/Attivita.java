package net.frapontillo.uni.db2.project.entity;

import net.frapontillo.uni.db2.project.converter.IntegerConverter;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlRootElement
public class Attivita implements IEntity {
	protected Integer id;
	protected String codice;
	protected Boolean franchising;
	protected String nome;
	protected Integer num_dip;
	protected Integer piano;
	protected String piva;
	protected List<Dipendenza> dipendenze;
	protected Dipendente manager;
	protected Struttura struttura;
	protected TipoAttivita tipo_attivita;
	
	public Attivita(Integer id, String codice, Boolean franchising, String nome,
			Integer num_dip, Integer piano, String piva,
			List<Dipendenza> dipendenze, Dipendente manager,
			Struttura struttura, TipoAttivita tipo_attivita) {
		super();
		this.id = id;
		this.codice = codice;
		this.franchising = franchising;
		this.nome = nome;
		this.num_dip = num_dip;
		this.piano = piano;
		this.piva = piva;
		this.dipendenze = dipendenze;
		this.manager = manager;
		this.struttura = struttura;
		this.tipo_attivita = tipo_attivita;
	}
	
	public Attivita() {}
	
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
	public Boolean getFranchising() {
		return franchising;
	}
	public void setFranchising(Boolean franchising) {
		this.franchising = franchising;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public Integer getNum_dip() {
		return num_dip;
	}
	public void setNum_dip(Integer num_dip) {
		this.num_dip = num_dip;
	}
	public Integer getPiano() {
		return piano;
	}
	@XmlJavaTypeAdapter(IntegerConverter.class)
	public void setPiano(Integer piano) {
		this.piano = piano;
	}
	public String getPiva() {
		return piva;
	}
	public void setPiva(String piva) {
		this.piva = piva;
	}
	public List<Dipendenza> getDipendenze() {
		return dipendenze;
	}
	public void setDipendenze(List<Dipendenza> dipendenze) {
		this.dipendenze = dipendenze;
	}
	public Dipendente getManager() {
		return manager;
	}
	public void setManager(Dipendente manager) {
		this.manager = manager;
	}
	public Struttura getStruttura() {
		return struttura;
	}
	public void setStruttura(Struttura struttura) {
		this.struttura = struttura;
	}
	public TipoAttivita getTipo_attivita() {
		return tipo_attivita;
	}
	public void setTipo_attivita(TipoAttivita tipo_attivita) {
		this.tipo_attivita = tipo_attivita;
	}
}
