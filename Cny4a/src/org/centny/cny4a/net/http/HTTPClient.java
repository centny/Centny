package org.centny.cny4a.net.http;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

public abstract class HTTPClient {
	protected String url;
	protected List<BasicNameValuePair> args = new ArrayList<BasicNameValuePair>();
	protected String encoding;
	protected HttpResponse response;
	protected String data;
	protected Throwable error;
	protected HTTPCallback callback;

	public HTTPClient() {
		super();
		this.encoding = "UTF-8";
	}

	public HTTPClient setUrl(String url) {
		this.url = url;
		return this;
	}

	public HTTPClient setCallback(HTTPCallback cback) {
		this.callback = cback;
		return this;
	}

	public List<BasicNameValuePair> getArgs() {
		return args;
	}

	public String getEncoding() {
		return encoding;
	}

	public HTTPClient setEncoding(String encoding) {
		this.encoding = encoding;
		return this;
	}

	public String getUrl() {
		return url;
	}

	public HTTPClient addArgs(String key, String val) {
		this.args.add(new BasicNameValuePair(key, val));
		return this;
	}

	public abstract void execute();

	public void onPostExecute() {
		if (this.callback != null) {
			if (this.error == null) {
				this.callback.onSuccess(this, this.data);
			} else {
				this.callback.onError(this, this.error);
			}
		}
	}

	public static class HTTPGetClient extends HTTPClient {
		//
		@Override
		public void execute() {
			HttpClient client = new DefaultHttpClient();
			String params = URLEncodedUtils.format(this.args, this.encoding);
			HttpGet get = new HttpGet(this.url + "?" + params);
			try {
				this.response = client.execute(get);
				if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
					HttpEntity entity = response.getEntity();
					InputStream is = entity.getContent();
					ByteArrayOutputStream baos = new ByteArrayOutputStream();
					byte[] buf = new byte[1024];
					int length = -1;
					while ((length = is.read(buf)) != -1) {
						baos.write(buf, 0, length);
					}
					this.data = new String(baos.toByteArray(), this.encoding);
					this.error = null;
				} else {
					this.error = new Exception("error response:"
							+ response.getStatusLine().getStatusCode());
				}
			} catch (Exception e) {
				this.error = e;
			}
		}
	}

	public static HTTPGetClient newGet() {
		return new HTTPGetClient();
	}
}
