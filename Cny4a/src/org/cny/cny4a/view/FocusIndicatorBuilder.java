package org.cny.cny4a.view;

import org.cny.cny4a.view.FocusImages.FocusImagesAdapter;

public abstract class FocusIndicatorBuilder extends FocusImagesAdapter {
	private FocusImages fimg;
	private CustomIndicator indicator;

	public FocusIndicatorBuilder() {
		super();
	}

	public FocusIndicatorBuilder(FocusImages fimg, CustomIndicator indicator) {
		super();
		this.init(fimg, indicator);
	}

	public FocusIndicatorBuilder init(FocusImages fimg,
			CustomIndicator indicator) {
		this.fimg = fimg;
		this.fimg.setFocusAdapter(this);
		this.indicator = indicator;
		this.indicator.setIndicatorCount(this.getItemCount());
		this.indicator.setIndicatorNormal(this.getIndicatorNormal());
		this.indicator.setIndicatorSelected(this.getIndicatorSelected());
		this.indicator.initViews();
		return this;
	}

	@Override
	public void onPageSelected(int arg0) {
		if (this.indicator != null) {
			this.indicator.setCurrentPos(this.realPosition(arg0));
		}
	}

	public abstract int getIndicatorNormal();

	public abstract int getIndicatorSelected();
}
