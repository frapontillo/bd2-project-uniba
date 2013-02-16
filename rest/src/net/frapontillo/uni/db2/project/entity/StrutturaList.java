package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

@XmlRootElement
@XmlSeeAlso({Struttura.class})
public class StrutturaList extends IEntityList<Struttura> {
	public StrutturaList() {}
	public StrutturaList(double count, double page, double pages, List<Struttura> list) {
		super(count, page, pages, list);
	}
}
