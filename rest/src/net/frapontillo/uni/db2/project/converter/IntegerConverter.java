package net.frapontillo.uni.db2.project.converter;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class IntegerConverter extends XmlAdapter<String,Integer> {

	@Override
	public String marshal(Integer mInt) throws Exception {
		if (mInt == null) return "";
		else return mInt.toString();
	}

	@Override
	public Integer unmarshal(String mStr) throws Exception {
		if (mStr.equalsIgnoreCase("")) return null;
		else return Integer.valueOf(mStr);
	}

}
