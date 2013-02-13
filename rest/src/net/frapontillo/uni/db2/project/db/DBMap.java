package net.frapontillo.uni.db2.project.db;

import net.frapontillo.uni.db2.project.db.auto._DBMap;

public class DBMap extends _DBMap {

    private static DBMap instance;

    private DBMap() {}

    public static DBMap getInstance() {
        if(instance == null) {
            instance = new DBMap();
        }

        return instance;
    }
}
