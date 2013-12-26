package org.cny.cny4a.view;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.util.Log;
import android.util.SparseArray;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

public class FocusImages extends ViewPager {
	private static final int FI_MAX_SIZE = 1000;
	private LinearLayout markLayout;
	private FocusImagesAdapter focusAdapter;

	public FocusImagesAdapter getFocusAdapter() {
		return focusAdapter;
	}

	public FocusImages setFocusAdapter(FocusImagesAdapter adapter) {
		this.focusAdapter = adapter;
		this.setAdapter(adapter);
		this.setOnPageChangeListener(adapter);
		int icount = adapter.getItemCount();
		this.setCurrentItem(FI_MAX_SIZE / 2 - FI_MAX_SIZE / 2 % icount);
		return this;
	}

	public LinearLayout getMarkLayout() {
		return markLayout;
	}

	public FocusImages setMarkLayout(LinearLayout markLayout) {
		this.markLayout = markLayout;
		return this;
	}

	public FocusImages(Context context) {
		super(context);
	}

	public FocusImages(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public FocusImages next() {
		this.setCurrentItem(this.getCurrentItem() + 1);
		return this;
	}

	public FocusImages next(boolean smoothScroll) {
		this.setCurrentItem(this.getCurrentItem() + 1, smoothScroll);
		return this;
	}

	public FocusImages prev() {
		this.setCurrentItem(this.getCurrentItem() - 1);
		return this;
	}

	public FocusImages prev(boolean smoothScroll) {
		this.setCurrentItem(this.getCurrentItem() - 1, smoothScroll);
		return this;
	}

	public static abstract class FocusImagesAdapter extends PagerAdapter
			implements OnPageChangeListener {
		private SparseArray<View> views = new SparseArray<View>();

		@Override
		public int getCount() {
			return FI_MAX_SIZE;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			int pos = position % this.getCount();
			Log.i("FocusImagesAdapter", "remove view," + "position:" + pos
					+ ",container  child count:" + container.getChildCount());
			View view = this.views.get(position);
			this.removeView(view, position);
			container.removeView(view);
			this.views.delete(position);
		}

		@Override
		public Object instantiateItem(ViewGroup container, int position) {
			int pos = position % this.getItemCount();
			Log.i("FocusImagesAdapter", "create view,position:" + pos
					+ ",container  child count:" + container.getChildCount());
			View v = this.createView(pos);
			container.addView(v);
			this.views.put(position, v);
			return position;
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == this.views.get((Integer) arg1);
		}

		@Override
		public void onPageScrollStateChanged(int arg0) {

		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {

		}

		@Override
		public void onPageSelected(int arg0) {

		}

		public void removeView(View view, int position) {
		}

		public int realPosition(int position) {
			return position % this.getItemCount();
		}

		public abstract View createView(int position);

		public abstract int getItemCount();
	}
}
