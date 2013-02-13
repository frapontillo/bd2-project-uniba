package net.frapontillo.uni.db2.project.util;

import org.apache.cayenne.CayenneDataObject;
import org.apache.cayenne.access.DataContext;

public final class DBUtil {
	public static Object getID(CayenneDataObject dbEntity, String ID) {
		return (dbEntity.getObjectId() != null && !dbEntity.getObjectId().isTemporary()) 
	            ? dbEntity.getObjectId().getIdSnapshot().get(ID) 
	            : null;
	}
	
	public static DataContext getContext() {
		DataContext context = DataContext.createDataContext();
		return context;
	}
}

