package org.centny.cny4a.util;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

import android.app.Activity;
import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.util.Log;

/**
 * the external util for android.
 * 
 * @author Centny.
 * 
 */
public class Util {

	/**
	 * get the local IP address.<br/>
	 * check the order:WIFI,Mobile,or null.
	 * 
	 * @param aty
	 *            the activity for android.
	 * @return IP.
	 */
	public static String localIpAddress(Activity aty) {
		return localIpAddress(aty, false);
	}

	/**
	 * @param aty
	 *            the activity for android.
	 * @param onlyWifi
	 *            only check wifi.
	 * @return IP.
	 */
	public static String localIpAddress(Activity aty, boolean onlyWifi) {
		try {
			WifiManager wifi;
			wifi = (WifiManager) aty.getSystemService(Context.WIFI_SERVICE);
			if (wifi.isWifiEnabled()) {
				WifiInfo winfo = wifi.getConnectionInfo();
				return intToIp(winfo.getIpAddress());
			}
			if (onlyWifi) {
				return null;
			}
			for (Enumeration<NetworkInterface> en = NetworkInterface
					.getNetworkInterfaces(); en.hasMoreElements();) {
				NetworkInterface intf = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = intf
						.getInetAddresses(); enumIpAddr.hasMoreElements();) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					if (!inetAddress.isLoopbackAddress()) {
						return inetAddress.getHostAddress().toString();
					}
				}
			}
		} catch (SocketException ex) {
			Log.e(Util.class.getName(), ex + "");
		}
		return null;
	}

	/**
	 * convert int IP Address format to normal format.
	 * 
	 * @param i
	 *            the int IP address.
	 * @return the normal IP address.
	 */
	public static String intToIp(int i) {
		return (i & 0xFF) + "." + ((i >> 8) & 0xFF) + "." + ((i >> 16) & 0xFF)
				+ "." + ((i >> 24) & 0xFF);
	}

}
