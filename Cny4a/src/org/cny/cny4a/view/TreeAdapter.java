package org.cny.cny4a.view;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.View;

public class TreeAdapter extends ItemAdapter {
	private List<Object> objs = new ArrayList<Object>();
	private Map<Object, List<Object>> mdatas = new HashMap<Object, List<Object>>();

	public TreeAdapter(int itemRId, Context ctx, Class<?> iclass) {
		super(itemRId, ctx, iclass);
	}

	@Override
	public Object getItem(int position) {
		return this.objs.get(position);
	}

	@Override
	public int getCount() {
		return this.objs.size();
	}

	public void showSub(DataAdapter data) {
		int idx = 0;
		if (data != null) {
			idx = this.objs.indexOf(data);
		}
		if (idx < 0) {
			return;
		}
		this.showSub(data, idx);
	}

	public void showSub(DataAdapter data, int idx) {
		if (idx < 0) {
			idx = -1;
		}
		List<Object> objs = data.toArray();
		if (data != null) {
			this.mdatas.put(data, objs);
		}
		this.objs.addAll(idx + 1, objs);
	}

	public void hideSub(DataAdapter data) {
		List<Object> objs = this.mdatas.get(data);
		if (objs == null) {
			return;
		}
		for (Object tobj : objs) {
			this.hideSub((DataAdapter) tobj);
		}
		this.objs.removeAll(objs);
		this.mdatas.remove(data);
	}

	public static abstract class TreeNode extends AbstractDataAdapter {
		protected TreeNode parent;
		protected TreeAdapter tadapter;
		protected boolean expanded;
		protected int rindent;
		protected boolean selected;

		//

		public TreeNode(TreeAdapter tadapter, TreeNode parent) {
			this.tadapter = tadapter;
			this.parent = parent;
			if (this.parent == null) {
				this.rindent = this.getIndent();
			} else {
				this.rindent = this.parent.rindent + this.getIndent();
			}
		}

		public void showSub() {
			this.tadapter.showSub(this);
			this.tadapter.notifyDataSetChanged();
			this.expanded = true;
		}

		public void hideSub() {
			this.tadapter.hideSub(this);
			this.tadapter.notifyDataSetChanged();
			this.expanded = false;
		}

		public boolean isExpanded() {
			return this.expanded;
		}

		public void setExpanded(boolean expanded) {
			this.expanded = expanded;
		}

		public boolean isSelected() {
			return this.tadapter.isSelected(this);
		}

		public TreeNode getParent() {
			return parent;
		}

		public TreeAdapter getTadapter() {
			return tadapter;
		}

		public int getRindent() {
			return rindent;
		}

		public abstract boolean loadSub();

		public abstract boolean isLeaf();

		public abstract int getIndent();
	}

	public static abstract class TreeItem extends ListItem implements
			View.OnClickListener {
		protected TreeNode tnode;

		public TreeItem(ItemAdapter adapter, View tview) {
			super(adapter, tview);
			tview.setOnClickListener(this);
		}

		@Override
		public final void update(Object data) {
			this.tnode = (TreeNode) data;
			this.onUpdate(this.tnode, this.tnode.getRindent());
		}

		@Override
		public final void onClick(View arg0) {
			if (!tnode.isLeaf()) {
				if (this.tnode.isExpanded()) {
					this.tnode.hideSub();
				} else {
					if (this.tnode.loadSub()) {
						this.tnode.showSub();
					}
				}
			}
			this.onClickNode(arg0);
		}

		public void setSelected(boolean selected) {
			if (selected) {
				this.tnode.getTadapter().addSelected(this.tnode);
			} else {
				this.tnode.getTadapter().removeSelected(this.tnode);
			}
		}

		public boolean isSelected() {
			return this.tnode.isSelected();
		}

		public abstract void onUpdate(Object data, int indent);

		public abstract void onClickNode(View v);
	}
}
