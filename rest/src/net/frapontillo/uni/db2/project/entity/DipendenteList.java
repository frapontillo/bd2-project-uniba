package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class DipendenteList extends IEntityList<Dipendente> {
	public DipendenteList() {}
	public DipendenteList(double page, double pages, List<Dipendente> list) {
		super(page, pages, list);
	}
}
