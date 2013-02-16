package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

@XmlRootElement
@XmlSeeAlso({Dipendente.class})
public class DipendenteList extends IEntityList<Dipendente> {
	public DipendenteList() {}
	public DipendenteList(double count, double page, double pages, List<Dipendente> list) {
		super(count, page, pages, list);
	}
}
