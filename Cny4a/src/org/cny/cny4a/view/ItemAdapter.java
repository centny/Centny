package org.cny.cny4a.view;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.BaseAdapter;

public abstract class ItemAdapter extends BaseAdapter {
	protected int itemRId;
	protected Context ctx;
	protected Class<?> iclass;
	protected Set<Object> selected = new HashSet<Object>();
	protected boolean singleSelect;

	/**
	 * default constructor for ItemAdapter
	 * 
	 * @param itemRId
	 *            the layout id for create the view.
	 * @param ctx
	 *            the Context.
	 * @param iclass
	 *            the SubClass for ListItem,it must be a static class.
	 */
	public ItemAdapter(int itemRId, Context ctx, Class<?> iclass) {
		super();
		this.itemRId = itemRId;
		this.ctx = ctx;
		this.iclass = iclass;
	}

	public Context getCtx() {
		return ctx;
	}

	public Class<?> getIclass() {
		return iclass;
	}

	public int getItemRId() {
		return itemRId;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Object dobj = this.getItem(position);
		ListItem item = null;
		if (convertView == null) {
			convertView = LayoutInflater.from(this.ctx).inflate(this.itemRId,
					null);
			try {
				item = (ListItem) this.iclass.getConstructor(ItemAdapter.class,
						View.class).newInstance(this, convertView);
				convertView.setTag(item);
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		} else {
			item = (ListItem) convertView.getTag();
		}
		item.update(dobj);
		return convertView;
	}

	public ItemAdapter addSelected(Object obj) {
		if (this.singleSelect) {
			this.selected.clear();
		}
		this.selected.add(obj);
		return this;
	}

	public ItemAdapter removeSelected(Object obj) {
		this.selected.remove(obj);
		return this;
	}

	public boolean isSingleSelect() {
		return singleSelect;
	}

	public ItemAdapter setSingleSelect(boolean singleSelect) {
		this.singleSelect = singleSelect;
		return this;
	}

	public Set<Object> getSelected() {
		return selected;
	}

	public void clearSelected() {
		if (this.selected != null) {
			this.selected.clear();
		}
	}

	public boolean isSelected(Object data) {
		return this.selected.contains(data);
	}

	@Override
	public abstract Object getItem(int position);

	@Override
	public abstract int getCount();

	public static abstract class ListItem {
		protected ItemAdapter adapter;
		protected View tview;

		public ListItem(ItemAdapter adapter, View tview) {
			super();
			this.adapter = adapter;
			this.tview = tview;
		}

		public Context getCtx() {
			return this.adapter.getCtx();
		}

		public ItemAdapter getAdapter() {
			return adapter;
		}

		public View getTview() {
			return tview;
		}

		public abstract void update(Object data);
	}

	public static interface DataAdapter {
		int getCount();

		Object getData(int position);

		List<Object> toArray();
	}

	public static abstract class AbstractDataAdapter implements DataAdapter {
		@Override
		public List<Object> toArray() {
			List<Object> ls = new ArrayList<Object>();
			int count = this.getCount();
			for (int i = 0; i < count; i++) {
				ls.add(this.getData(i));
			}
			return ls;
		}
	}

	public static class JsonDataAdapter extends AbstractDataAdapter {
		private JSONArray datas;

		public JsonDataAdapter(JSONArray datas) {
			this.datas = datas;
		}

		@Override
		public int getCount() {
			if (this.datas == null) {
				return 0;
			} else {
				return this.datas.length();
			}
		}

		@Override
		public Object getData(int position) {
			try {
				return this.datas.get(position);
			} catch (JSONException e) {
				throw new RuntimeException(e);
			}
		}

		public JSONArray getDatas() {
			return datas;
		}

	}

	public static class ListDataAdapter implements DataAdapter {
		private List<?> datas;

		public ListDataAdapter(List<?> datas) {
			this.datas = datas;
		}

		@Override
		public int getCount() {
			if (this.datas == null) {
				return 0;
			} else {
				return this.datas.size();
			}
		}

		@Override
		public Object getData(int position) {
			return this.datas.get(position);
		}

		public List<?> getDatas() {
			return datas;
		}

		@SuppressWarnings("unchecked")
		@Override
		public List<Object> toArray() {
			return (List<Object>) this.datas;
		}

	}

	public static class DataItemAdapter extends ItemAdapter {
		private DataAdapter dadapter;

		public DataItemAdapter(DataAdapter dadapter, int itemRId, Context ctx,
				Class<?> iclass) {
			super(itemRId, ctx, iclass);
			this.dadapter = dadapter;
		}

		@Override
		public Object getItem(int position) {
			return this.dadapter.getData(position);
		}

		@Override
		public int getCount() {
			return this.dadapter.getCount();
		}

		public DataAdapter getDadapter() {
			return dadapter;
		}

	}

	public static abstract class PageDataAdapter extends ItemAdapter implements
			OnScrollListener {

		private List<Object> datas = new ArrayList<Object>();
		private int pageNo, pageSize, begNo;
		private int lastVItem;

		public PageDataAdapter(int itemRId, Context ctx, Class<?> iclass,
				int begNo, int pageSize) {
			super(itemRId, ctx, iclass);
			this.begNo = begNo;
			this.pageNo = begNo;
			this.pageSize = pageSize;
		}

		public void reset() {
			this.datas.clear();
			this.pageNo = this.begNo;
			this.notifyDataSetChanged();
		}

		public void onNextPageCallBack(DataAdapter da) {
			int count = da.getCount();
			for (int i = 0; i < count; i++) {
				this.datas.add(da.getData(i));
			}
			this.notifyDataSetChanged();
			this.pageNo++;
		}

		public void start() {
			this.onNextPage(this.pageNo, this.pageSize);
		}

		public abstract void onNextPage(int pageNo, int pageSize);

		@Override
		public void onScroll(AbsListView arg0, int arg1, int arg2, int arg3) {
			this.lastVItem = arg1 + arg2 - 1;
		}

		@Override
		public void onScrollStateChanged(AbsListView arg0, int arg1) {
			if (arg1 == OnScrollListener.SCROLL_STATE_IDLE
					&& this.lastVItem == this.getCount() - 1) {
				this.onNextPage(this.pageNo, pageSize);
			}
		}

		@Override
		public Object getItem(int position) {
			return this.datas.get(position);
		}

		@Override
		public int getCount() {
			return this.datas.size();
		}
	}

	public static class ListItemAdapter extends DataItemAdapter {

		public ListItemAdapter(final List<?> datas, int itemRId, Context ctx,
				Class<?> iclass) {
			super(new ListDataAdapter(datas), itemRId, ctx, iclass);
		}
	}

	public static class JArrayItemAdapter extends DataItemAdapter {

		public JArrayItemAdapter(JSONArray datas, int itemRId, Context ctx,
				Class<?> iclass) {
			super(new JsonDataAdapter(datas), itemRId, ctx, iclass);
		}

	}
}
