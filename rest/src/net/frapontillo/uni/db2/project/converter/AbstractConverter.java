package net.frapontillo.uni.db2.project.converter;

import java.util.ArrayList;
import java.util.List;

import net.frapontillo.uni.db2.project.entity.IEntity;

import org.jooq.Record;
import org.jooq.Result;

public abstract class AbstractConverter<S extends Record, D extends IEntity> {
	
	public abstract D from(S source, int lev);
	public final D from(S source) {
		return from(source, CONV_TYPE.CASCADE);
	}
	
	public abstract S to(D source, S dest, int lev);
	public final S to(D source) {
		return to(source, null, CONV_TYPE.NORMAL);
	}
	public final S to(D source, int lev) {
		return to(source, null, CONV_TYPE.NORMAL);
	}
	public final S to(D source, S dest) {
		return to(source, dest, CONV_TYPE.NORMAL);
	}

	public final List<D> fromList(List<S> source) {
		return fromList(source, CONV_TYPE.NORMAL);
	}
	public List<D> fromList(List<S> source, int lev) {
		List<D> list = new ArrayList<D>();
		for (S s : source) {
			D d = from(s);
			list.add(d);
		}
		return list;
	}
	

	public final List<D> fromResult(Result<Record> source) {
		return fromResult(source, CONV_TYPE.NORMAL);
	}
	@SuppressWarnings("unchecked")
	public List<D> fromResult(Result<Record> source, int lev) {
		List<D> list = new ArrayList<D>();
		for (Record s : source) {
			D d = from((S) s);
			list.add(d);
		}
		return list;
	}

	public final List<S> toList(List<D> source) {
		return toList(source, CONV_TYPE.NORMAL);
	}
	public List<S> toList(List<D> source, int lev) {
		List<S> list = new ArrayList<S>();
		for (D d : source) {
			S s = to(d);
			list.add(s);
		}
		return list;
	}
}
