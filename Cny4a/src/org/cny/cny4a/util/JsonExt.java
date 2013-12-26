package org.cny.cny4a.util;

import org.json.JSONObject;

public class JsonExt {

	private JSONObject json;

	public JsonExt(JSONObject json) {
		super();
		this.json = json;
	}

	public String getString(String name) {
		return this.getString(name, "");
	}

	public String getString(String name, String df) {
		try {
			return this.json.getString(name);
		} catch (Exception e) {
			return df;
		}
	}

	public int getInt(String name, int df) {
		try {
			return this.json.getInt(name);
		} catch (Exception e) {
			return df;
		}
	}

	public JsonExt getJSONObject(String name) {
		try {

			return new JsonExt(this.json.getJSONObject(name));
		} catch (Exception e) {
			return null;
		}
	}

	public JsonAryExt getJSONArray(String name) {
		try {
			return new JsonAryExt(this.json.getJSONArray(name));
		} catch (Exception e) {
			return null;
		}
	}

	public boolean getBoolean(String name, boolean df) {
		try {

			return this.json.getBoolean(name);
		} catch (Exception e) {
			return df;
		}
	}

	public double getDouble(String name, double df) {
		try {

			return this.json.getDouble(name);
		} catch (Exception e) {
			return df;
		}
	}

	public long getLong(String name, long df) {
		try {

			return this.json.getLong(name);
		} catch (Exception e) {
			return df;
		}
	}

	public JSONObject getJson() {
		return this.json;
	}
}
