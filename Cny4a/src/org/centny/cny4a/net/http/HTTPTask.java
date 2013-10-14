package org.centny.cny4a.net.http;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.message.BasicNameValuePair;

import android.os.AsyncTask;

public class HTTPTask extends AsyncTask<HTTPClient, Float, HTTPClient> {

	@Override
	protected HTTPClient doInBackground(HTTPClient... params) {
		params[0].execute();
		return params[0];
	}

	@Override
	protected void onPostExecute(HTTPClient result) {
		result.onPostExecute();
	}

	public static void doGet(String url, List<BasicNameValuePair> args,
			HTTPCallback cback) {
		HTTPClient hc = HTTPClient.newGet();
		hc.setUrl(url);
		if (args != null) {
			hc.getArgs().addAll(args);
		}
		hc.setCallback(cback);
		new HTTPTask().execute(hc);
	}

	public static HTTPArgs kvArgs(String name, String value) {
		return new HTTPArgs().add(name, value);
	}

	public static class HTTPArgs extends ArrayList<BasicNameValuePair> {

		private static final long serialVersionUID = -7928429895807549348L;

		public HTTPArgs add(String name, String value) {
			this.add(new BasicNameValuePair(name, value));
			return this;
		}

		public HTTPArgs put(String name, String value) {
			this.add(new BasicNameValuePair(name, value));
			return this;
		}
	}
}
