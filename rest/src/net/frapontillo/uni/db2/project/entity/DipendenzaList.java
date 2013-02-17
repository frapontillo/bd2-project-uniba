package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

@XmlRootElement
@XmlSeeAlso({Dipendenza.class})
public class DipendenzaList extends IEntityList<Dipendenza> {
	public DipendenzaList() {}
	public DipendenzaList(double count, double page, double pages, List<Dipendenza> list) {
		super(count, page, pages, list);
	}
}
