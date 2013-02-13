package net.frapontillo.uni.db2.project.converter;

import java.util.ArrayList;
import java.util.List;

import net.frapontillo.uni.db2.project.entity.IEntity;

import org.apache.cayenne.CayenneDataObject;

public abstract class AbstractConverter<S extends CayenneDataObject, D extends IEntity> {
	
	public abstract D from(S source, int lev);
	public abstract S to(D source, int lev);

	public final D from(S source) {
		return from(source, CONV_TYPE.CASCADE);
	}
	
	public final S to(D source) {
		return to(source, CONV_TYPE.NORMAL);
	}

	public List<D> fromList(List<S> source, int lev) {
		List<D> list = new ArrayList<D>();
		for (S s : source) {
			D d = from(s);
			list.add(d);
		}
		return list;
	}
	
	public List<S> toList(List<D> source, int lev) {
		List<S> list = new ArrayList<S>();
		for (D d : source) {
			S s = to(d);
			list.add(s);
		}
		return list;
	}
	
	public final List<D> fromList(List<S> source) {
		return fromList(source, CONV_TYPE.NORMAL);
	}
	
	public final List<S> toList(List<D> source) {
		return toList(source, CONV_TYPE.NORMAL);
	}
}
