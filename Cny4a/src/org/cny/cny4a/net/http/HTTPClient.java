package org.cny.cny4a.net.http;

import java.io.InputStream;
import java.io.OutputStream;
import java.security.InvalidParameterException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import android.os.AsyncTask;

public abstract class HTTPClient extends
		AsyncTask<HTTPClient, Float, HTTPClient> {

	@Override
	protected HTTPClient doInBackground(HTTPClient... params) {
		params[0].exec();
		return params[0];
	}

	@Override
	protected void onPostExecute(HTTPClient result) {
		result.onPostExecute();
	}

	@Override
	protected void onProgressUpdate(Float... values) {
		this.cback.onProcess(this, values[0]);
	}

	//
	protected String url;
	protected List<BasicNameValuePair> headers = new ArrayList<BasicNameValuePair>();
	protected List<BasicNameValuePair> args = new ArrayList<BasicNameValuePair>();
	protected String rencoding = "UTF-8";
	protected HttpClient client = new DefaultHttpClient();
	protected Throwable error;
	protected HTTPResponse response;
	protected HttpUriRequest request;
	protected HTTPCallback cback;

	public HTTPClient(String url, HTTPCallback cback) {
		if (url == null || url.trim().length() < 1) {
			throw new InvalidParameterException("url is null or empty");
		}
		if (cback == null) {
			throw new InvalidParameterException("the callback is null");
		}
		this.setUrl(url);
		this.cback = cback;
	}

	public HTTPClient setUrl(String url) {
		this.url = url;
		return this;
	}

	public List<BasicNameValuePair> getArgs() {
		return args;
	}

	public List<BasicNameValuePair> getHeaders() {
		return headers;
	}

	public String getUrl() {
		return url;
	}

	public HTTPClient addArgs(String key, String val) {
		this.args.add(new BasicNameValuePair(key, val));
		return this;
	}

	public HTTPClient addHeader(String key, String val) {
		this.headers.add(new BasicNameValuePair(key, val));
		return this;
	}

	private void exec() {
		try {
			this.request = this.createRequest();
			this.cback.onRequest(this, this.request);
			this.response = new HTTPResponse(this.client.execute(request));
			OutputStream out = null;
			switch (this.response.getStatusCode()) {
			case HttpStatus.SC_OK:
				out = this.cback.onBebin(this, this.response, false);
				break;
			case HttpStatus.SC_PARTIAL_CONTENT:
				out = this.cback.onBebin(this, this.response, true);
				break;
			default:
				this.error = new Exception("error response:"
						+ this.response.getStatusCode());
				break;
			}
			if (out == null) {
				return;
			}
			HttpEntity entity = response.getReponse().getEntity();
			InputStream is;
			long rsize = 0;
			long clen = this.response.getContentLength();
			is = entity.getContent();
			byte[] buf = new byte[4096];
			int length = -1;
			while ((length = is.read(buf)) != -1) {
				out.write(buf, 0, length);
				rsize += length;
				this.onProcess(rsize, clen);
			}
			this.error = null;
			this.cback.onEnd(this, out);
		} catch (Exception e) {
			this.error = e;
		}
	}

	protected void onProcess(long rsize, long clen) {
		if (clen > 0) {
			this.publishProgress((float) (((double) rsize) / ((double) clen)));
		} else {
			this.publishProgress((float) 0);
		}
	}

	public void onPostExecute() {
		if (this.error == null) {
			this.cback.onSuccess(this);
		} else {
			this.cback.onError(this, this.error);
		}
	}

	public abstract HttpUriRequest createRequest();

	public static class HTTPMClient extends HTTPClient {
		private String method = "GET";

		public HTTPMClient(String url, HTTPCallback cback) {
			super(url, cback);
		}

		public HTTPMClient setMethod(String method) {
			this.method = method;
			return this;
		}

		public HttpUriRequest createRequest() {
			if ("GET".equals(method)) {
				String params = URLEncodedUtils.format(this.args,
						this.rencoding);
				HttpGet get;
				if (params.length() > 0) {
					if (this.url.indexOf("?") > 0) {
						get = new HttpGet(this.url + "&" + params);
					} else {
						get = new HttpGet(this.url + "?" + params);
					}
				} else {
					get = new HttpGet(this.url);
				}
				for (BasicNameValuePair nv : this.headers) {
					get.addHeader(nv.getName(), nv.getValue());
				}
				return get;
			} else if ("POST".equals(method)) {
				HttpPost post = new HttpPost(this.url);
				for (NameValuePair nvp : this.args) {
					post.addHeader(nvp.getName(), nvp.getValue());
				}
				for (BasicNameValuePair nv : this.headers) {
					post.addHeader(nv.getName(), nv.getValue());
				}
				return post;
			} else {
				return null;
			}
		}
	}
}
