package net.frapontillo.uni.db2.project.jooq.gen;

import org.jooq.util.DefaultGeneratorStrategy;
import org.jooq.util.Definition;


public class DBGeneratorStrategy extends DefaultGeneratorStrategy {
	@Override
	public String getJavaClassName(Definition definition, Mode mode) {
		String name = super.getJavaClassName(definition, mode);
		name += "DB";
		return name;
	}
}
