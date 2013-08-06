package org.centny.cny4a.view;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class CustomIndicator extends LinearLayout {

	private Context ctx;
	private int indicatorWidth = 20;
	private int indicatorHeight = 20;
	private int indicatorMargin = 0;
	private int indicatorNormal = 0, indicatorSelected = 0;
	private int indicatorCount = 0;
	private int currentPos = 0;
	private List<ImageView> views = new ArrayList<ImageView>();

	public CustomIndicator(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.ctx = context;
	}

	public CustomIndicator(Context context) {
		super(context);
		this.ctx = context;
	}

	public void initViews() {
		this.views.clear();
		this.removeAllViewsInLayout();
		for (int i = 0; i < this.indicatorCount; i++) {
			ImageView view = new ImageView(this.ctx);

			LayoutParams params = new LayoutParams(
					this.indicatorWidth == 0 ? LayoutParams.WRAP_CONTENT
							: indicatorWidth,
					this.indicatorHeight == 0 ? LayoutParams.WRAP_CONTENT
							: indicatorHeight);
			params.rightMargin = this.indicatorMargin;
			params.leftMargin = this.indicatorMargin;
			params.topMargin = this.indicatorMargin;
			params.bottomMargin = this.indicatorMargin;
			view.setLayoutParams(params);
			view.setBackgroundResource(this.indicatorNormal);
			this.addView(view);
			this.views.add(view);
		}
		this.setCurrentPos(0);
	}

	public int getIndicatorWidth() {
		return indicatorWidth;
	}

	public CustomIndicator setIndicatorWidth(int indicatorWidth) {
		this.indicatorWidth = indicatorWidth;
		return this;
	}

	public int getIndicatorHeight() {
		return indicatorHeight;
	}

	public CustomIndicator setIndicatorHeight(int indicatorHeight) {
		this.indicatorHeight = indicatorHeight;
		return this;
	}

	public int getIndicatorMargin() {
		return indicatorMargin;
	}

	public CustomIndicator setIndicatorMargin(int indicatorMargin) {
		this.indicatorMargin = indicatorMargin;
		return this;
	}

	public int getIndicatorNormal() {
		return indicatorNormal;
	}

	public CustomIndicator setIndicatorNormal(int indicatorNormal) {
		this.indicatorNormal = indicatorNormal;
		return this;
	}

	public int getIndicatorSelected() {
		return indicatorSelected;
	}

	public CustomIndicator setIndicatorSelected(int indicatorSelected) {
		this.indicatorSelected = indicatorSelected;
		return this;
	}

	public int getIndicatorCount() {
		return indicatorCount;
	}

	public void setIndicatorCount(int indicatorCount) {
		this.indicatorCount = indicatorCount;
	}

	public int getCurrentPos() {
		return currentPos;
	}

	public CustomIndicator setCurrentPos(int currentPos) {
		this.currentPos = currentPos;
		if (this.currentPos < 0) {
			this.currentPos = 0;
		}
		if (this.currentPos >= this.indicatorCount) {
			this.currentPos = this.indicatorCount - 1;
		}
		ImageView iv;
		for (int i = 0; i < this.indicatorCount; i++) {
			iv = this.views.get(i);
			iv.setBackgroundResource(this.indicatorNormal);
		}
		iv = this.views.get(this.currentPos);
		iv.setBackgroundResource(this.indicatorSelected);
		return this;
	}
}
