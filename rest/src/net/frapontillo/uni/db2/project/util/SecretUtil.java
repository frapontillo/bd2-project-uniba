package net.frapontillo.uni.db2.project.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.Random;

public final class SecretUtil {
	public static String computeHash(String username, String password) {
		String hash = null;
        StringBuffer sb = new StringBuffer();
		byte[] salt = new byte[13];
		new Random().nextBytes(salt);
		String hashThis = username + "\\" + password + "//" + new Date().getTime();
		
		MessageDigest digest;
		try {
			digest = MessageDigest.getInstance("SHA-256");
			digest.reset();
			digest.update(salt);
			byte byteData[] = digest.digest(hashThis.getBytes());
			for (int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
			}
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		hash = sb.toString();
		return hash;
	}
	
	public static String hashPassword(String password) {
		String hash = null;
        StringBuffer sb = new StringBuffer();
		
		MessageDigest digest;
		try {
			digest = MessageDigest.getInstance("SHA-256");
			digest.reset();
			byte byteData[] = digest.digest(password.getBytes());
			for (int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
			}
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		hash = sb.toString();
		return hash;
	}
}
