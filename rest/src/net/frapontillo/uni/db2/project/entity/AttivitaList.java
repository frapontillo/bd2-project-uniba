package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class AttivitaList extends IEntityList<Attivita> {
	public AttivitaList() {}
	public AttivitaList(double page, double pages, List<Attivita> list) {
		super(page, pages, list);
	}
}
