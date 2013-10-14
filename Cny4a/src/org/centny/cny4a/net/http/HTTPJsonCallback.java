package org.centny.cny4a.net.http;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public abstract class HTTPJsonCallback implements HTTPCallback {

	@Override
	public void onSuccess(HTTPClient c, String data) {
		Throwable err;
		try {
			this.onSuccess(c, new JSONObject(data));
			return;
		} catch (JSONException e) {
			err = e;
		}
		try {
			this.onSuccess(c, new JSONArray(data));
			return;
		} catch (JSONException e) {
			err = e;
		}
		this.onFailure(c, err);
	}

	@Override
	public void onError(HTTPClient c, Throwable error) {
		this.onFailure(c, error);
	}

	public abstract void onSuccess(HTTPClient c, JSONArray arg0);

	public abstract void onSuccess(HTTPClient c, JSONObject arg0);

	public abstract void onFailure(HTTPClient c, Throwable arg0);
}
