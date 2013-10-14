package org.centny.cny4a.net.http;

public interface HTTPCallback {
	public void onSuccess(HTTPClient c, String data);

	public void onError(HTTPClient c, Throwable error);
}
