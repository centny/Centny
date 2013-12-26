package org.cny.cny4a.net.http;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.message.BasicNameValuePair;
import org.cny.cny4a.net.http.HTTPClient.HTTPMClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class HTTP {
	public static void doPost(String url, List<BasicNameValuePair> args,
			HTTPCallback cb) {
		HTTPMClient hc = new HTTPMClient(url, cb);
		if (args != null) {
			hc.getArgs().addAll(args);
		}
		hc.setMethod("POST");
		hc.execute(hc);
	}

	public static void doGet(String url, List<BasicNameValuePair> args,
			HTTPCallback cb) {
		HTTPMClient hc = new HTTPMClient(url, cb);
		if (args != null) {
			hc.getArgs().addAll(args);
		}
		hc.setMethod("GET");
		hc.execute(hc);
	}

	public static void doGet(String url, HTTPCallback cb) {
		doGet(url, null, cb);
	}

	public static void doGetDown(String url, List<BasicNameValuePair> args,
			HTTPDownCallback cb) {
		HTTPMClient dc = new HTTPMClient(url, cb);
		if (args != null) {
			dc.getArgs().addAll(args);
		}
		dc.setMethod("GET");
		dc.execute(dc);
	}

	public static void doGetDown(String url, HTTPDownCallback cb) {
		doGetDown(url, null, cb);
	}

	public static void doPostDown(String url, List<BasicNameValuePair> args,
			HTTPDownCallback cb) {
		HTTPMClient dc = new HTTPMClient(url, cb);
		if (args != null) {
			dc.getArgs().addAll(args);
		}
		dc.setMethod("POST");
		dc.execute(dc);
	}

	public abstract static class HTTPMCallback implements HTTPCallback {
		private ByteArrayOutputStream out = new ByteArrayOutputStream();
		private HTTPClient c;
		protected String bencoding = "UTF-8";

		@Override
		public OutputStream onBebin(HTTPClient c, HTTPResponse r, boolean append) {
			this.c = c;
			return out;
		}

		@Override
		public void onEnd(HTTPClient c, OutputStream out) {
		}

		@Override
		public void onProcess(HTTPClient c, float rate) {
		}

		@Override
		public void onRequest(HTTPClient c, HttpUriRequest r) {

		}

		@Override
		public void onSuccess(HTTPClient c) {
			try {
				this.onSuccess(c, this.data());
			} catch (Exception e) {
				this.onError(c, e);
			}
		}

		public String data() throws Exception {
			String bcode = this.c.response.getEncoding();
			if (bcode != null) {
				this.bencoding = bcode;
			}
			return new String(this.out.toByteArray(), this.bencoding);
		}

		public OutputStream getOut() {
			return this.out;
		}

		public abstract void onSuccess(HTTPClient c, String data);
	}

	public abstract static class HTTPJsonCallback extends HTTPMCallback {

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

	public static class HTTPDownCallback implements HTTPCallback {
		private String filepath;
		private FileOutputStream fos;

		public HTTPDownCallback() {

		}

		public HTTPDownCallback(String filepath) {
			this.filepath = filepath;
		}

		@Override
		public OutputStream onBebin(HTTPClient c, HTTPResponse r, boolean append)
				throws Exception {
			this.fos = new FileOutputStream(this.filepath, false);
			return new BufferedOutputStream(this.fos);
		}

		@Override
		public void onEnd(HTTPClient c, OutputStream out) throws Exception {
			out.close();
		}

		@Override
		public void onProcess(HTTPClient c, float rate) {

		}

		@Override
		public void onSuccess(HTTPClient c) {

		}

		@Override
		public void onError(HTTPClient c, Throwable err) {
			try {
				if (this.fos != null) {
					this.fos.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		@Override
		public void onRequest(HTTPClient c, HttpUriRequest r) {

		}

		public String getFilepath() {
			return filepath;
		}

		public void setFilepath(String filepath) {
			this.filepath = filepath;
		}

	}

	public static class HTTPNameDlCallback extends HTTPDownCallback {
		private String defaultName;
		private String sdir;
		private String fname;

		public HTTPNameDlCallback(String sdir) {
			this.sdir = sdir;
		}

		@Override
		public OutputStream onBebin(HTTPClient c, HTTPResponse r, boolean append)
				throws Exception {
			this.fname = r.getFilename();
			if (this.fname == null && this.defaultName != null) {
				this.fname = this.defaultName;
			}
			if (this.fname == null) {
				this.fname = this.getUrlName(c);
			}
			File f = new File(this.sdir, this.fname);
			this.setFilepath(f.getAbsolutePath());
			return super.onBebin(c, r, append);
		}

		private String getUrlName(HTTPClient c) {
			String url = c.getUrl();
			url = url.split("\\?")[0];
			String[] urls = url.split("/");
			return urls[urls.length - 1];
		}

		public String getDefaultName() {
			return defaultName;
		}

		public void setDefaultName(String defaultName) {
			this.defaultName = defaultName;
		}

		public String getSdir() {
			return sdir;
		}

		public void setSdir(String sdir) {
			this.sdir = sdir;
		}

		public String getFname() {
			return fname;
		}

		public void setFname(String fname) {
			this.fname = fname;
		}

	}
}
