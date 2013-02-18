package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

@XmlRootElement
@XmlSeeAlso({Attivita.class})
public class AttivitaList extends IEntityList<Attivita> {
	public AttivitaList() {}
	public AttivitaList(double count, double page, double pages, List<Attivita> list) {
		super(count, page, pages, list);
	}
}
