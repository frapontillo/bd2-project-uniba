package net.frapontillo.uni.db2.project.entity;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public abstract class IEntityList<T> {
	protected double count;
	protected double page;
	protected double pages;
	protected List<T> list;
	public IEntityList() {}
	public IEntityList(double count, double page, double pages, List<T> list) {
		super();
		this.count = count;
		this.page = page;
		this.pages = pages;
		this.list = list;
	}
	public double getCount() {
		return count;
	}
	public void setCount(double count) {
		this.count = count;
	}
	public double getPage() {
		return page;
	}
	public void setPage(double page) {
		this.page = page;
	}
	public double getPages() {
		return pages;
	}
	public void setPages(double pages) {
		this.pages = pages;
	}
	public List<T> getList() {
		return list;
	}
	public void setList(List<T> list) {
		this.list = list;
	}
}
