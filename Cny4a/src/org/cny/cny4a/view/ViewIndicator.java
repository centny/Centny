package org.cny.cny4a.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;

public class ViewIndicator extends CustomIndicator {

	public ViewIndicator(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public ViewIndicator(Context context) {
		super(context);
	}

	@Override
	protected void onPosUnselected(int currentPos) {
		View view = this.views.get(currentPos);
		view.setBackgroundResource(this.indicatorNormal);
	}

	@Override
	protected void onPosSelected(int currentPos) {
		View view = this.views.get(currentPos);
		view.setBackgroundResource(this.indicatorSelected);
	}

	@Override
	protected View createView(Context ctx) {
		View view = new View(ctx);
		view.setBackgroundResource(this.indicatorNormal);
		return view;
	}

}
