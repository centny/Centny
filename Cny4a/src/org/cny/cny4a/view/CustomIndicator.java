package org.cny.cny4a.view;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;

public abstract class CustomIndicator extends LinearLayout {

	protected Context ctx;
	protected int indicatorWidth = 20;
	protected int indicatorHeight = 20;
	protected int indicatorMargin = 0;
	protected int indicatorLMargin = 0;
	protected int indicatorRMargin = 0;
	protected int indicatorNormal = 0, indicatorSelected = 0;
	protected int indicatorCount = 0;
	protected int currentPos = 0;
	protected List<View> views = new ArrayList<View>();

	public CustomIndicator(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.ctx = context;
	}

	public CustomIndicator(Context context) {
		super(context);
		this.ctx = context;
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

	public int getIndicatorLMargin() {
		return indicatorLMargin;
	}

	public CustomIndicator setIndicatorLMargin(int indicatorLMargin) {
		this.indicatorLMargin = indicatorLMargin;
		return this;
	}

	public int getIndicatorRMargin() {
		return indicatorRMargin;
	}

	public CustomIndicator setIndicatorRMargin(int indicatorRMargin) {
		this.indicatorRMargin = indicatorRMargin;
		return this;
	}

	public int getCurrentPos() {
		return currentPos;
	}

	public CustomIndicator setCurrentPos(int currentPos) {
		this.onPosUnselected(this.currentPos);
		this.currentPos = currentPos;
		if (this.currentPos < 0) {
			this.currentPos = 0;
		}
		if (this.currentPos >= this.indicatorCount) {
			this.currentPos = this.indicatorCount - 1;
		}
		this.onPosSelected(this.currentPos);

		return this;
	}

	public void initViews() {
		this.views.clear();
		this.removeAllViewsInLayout();
		for (int i = 0; i < this.indicatorCount; i++) {
			View view = this.createView(this.ctx);
			LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
					this.indicatorWidth == 0 ? android.view.ViewGroup.LayoutParams.WRAP_CONTENT
							: indicatorWidth,
					this.indicatorHeight == 0 ? android.view.ViewGroup.LayoutParams.WRAP_CONTENT
							: indicatorHeight);
			params.rightMargin = (i == this.indicatorCount - 1) ? this.indicatorRMargin
					: this.indicatorMargin;
			params.leftMargin = i == 0 ? this.indicatorLMargin
					: this.indicatorMargin;
//			params.topMargin = this.indicatorMargin;
//			params.bottomMargin = this.indicatorMargin;
			view.setLayoutParams(params);
			this.addView(view);
			this.views.add(view);
		}
		this.setCurrentPos(0);
	}

	protected abstract void onPosUnselected(int currentPos);

	protected abstract void onPosSelected(int currentPos);

	protected abstract View createView(Context ctx);
}
