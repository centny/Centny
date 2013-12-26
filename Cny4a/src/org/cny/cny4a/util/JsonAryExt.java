package org.cny.cny4a.util;

import org.json.JSONArray;

public class JsonAryExt {
	private JSONArray json;

	public JsonAryExt(JSONArray json) {
		super();
		this.json = json;
	}

	public String getString(int idx) {
		try {
			return this.json.getString(idx);
		} catch (Exception e) {
			return "";
		}
	}

	public int getInt(int idx) {
		try {
			return this.json.getInt(idx);
		} catch (Exception e) {
			return 0;
		}
	}

	public JsonExt getJSONObject(int idx) {
		try {
			return new JsonExt(this.json.getJSONObject(idx));
		} catch (Exception e) {
			return null;
		}
	}

	public JSONArray getJSONArray(int idx) {
		try {
			return this.json.getJSONArray(idx);
		} catch (Exception e) {
			return null;
		}
	}

	public boolean getBoolean(int idx) {
		try {

			return this.json.getBoolean(idx);
		} catch (Exception e) {
			return false;
		}
	}

	public double getDouble(int idx) {
		try {

			return this.json.getDouble(idx);
		} catch (Exception e) {
			return 0;
		}
	}

	public long getLong(int idx) {
		try {

			return this.json.getLong(idx);
		} catch (Exception e) {
			return 0;
		}
	}

	public int length() {
		return this.json.length();
	}

	public JSONArray getJson() {
		return this.json;
	}
}
