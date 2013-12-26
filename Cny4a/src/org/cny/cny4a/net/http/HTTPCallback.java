package org.cny.cny4a.net.http;

import java.io.OutputStream;

import org.apache.http.client.methods.HttpUriRequest;

public interface HTTPCallback {
	public void onRequest(HTTPClient c, HttpUriRequest r);

	public OutputStream onBebin(HTTPClient c, HTTPResponse r, boolean append)
			throws Exception;

	public void onEnd(HTTPClient c, OutputStream out) throws Exception;

	//
	public void onProcess(HTTPClient c, float rate);

	public void onSuccess(HTTPClient c);

	public void onError(HTTPClient c, Throwable err);
}
