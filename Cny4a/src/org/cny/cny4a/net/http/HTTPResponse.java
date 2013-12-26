package org.cny.cny4a.net.http;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

public class HTTPResponse {
	private HttpResponse reponse;
	private long contentLength;
	private String contentType;
	private String encoding;
	private int statusCode;
	private String filename;
	private Map<String, String> headers = new HashMap<String, String>();

	public HTTPResponse(HttpResponse reponse) {
		if (reponse == null) {
			throw new RuntimeException("response is null");
		}
		this.reponse = reponse;
		this.statusCode = this.reponse.getStatusLine().getStatusCode();
		Header h;
		h = this.reponse.getFirstHeader("Content-Length");
		if (h == null) {
			this.contentLength = 0;
		} else {
			this.contentLength = Long.parseLong(h.getValue());
		}
		h = this.reponse.getFirstHeader("Content-Type");
		if (h == null) {
			this.contentType = null;
		} else {
			HeaderElement he = h.getElements()[0];
			this.contentType = he.getName();
			NameValuePair cnv = he.getParameterByName("charset");
			if (cnv != null) {
				this.encoding = cnv.getValue();
			}

		}
		h = this.reponse.getFirstHeader("Content-Disposition");
		if (h == null) {
			this.filename = null;
		} else {
			HeaderElement he = h.getElements()[0];
			NameValuePair cnv = he.getParameterByName("filename");
			if (cnv != null) {
				this.filename = cnv.getValue();
				try {
					this.filename = new String(
							this.filename.getBytes("ISO-8859-1"), "UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
			}
		}
		for (Header hd : this.reponse.getAllHeaders()) {
			try {
				byte[] bys = hd.getValue().getBytes("ISO-8859-1");
				this.headers.put(hd.getName(), new String(bys, "UTF-8"));
			} catch (RuntimeException e) {
			} catch (UnsupportedEncodingException e) {
			}
		}

	}

	public HttpResponse getReponse() {
		return reponse;
	}

	public long getContentLength() {
		return contentLength;
	}

	public String getContentType() {
		return contentType;
	}

	public String getEncoding() {
		return encoding;
	}

	public int getStatusCode() {
		return statusCode;
	}

	public String getFilename() {
		return filename;
	}

	public String getValue(String key) {
		return this.headers.get(key);
	}
}
