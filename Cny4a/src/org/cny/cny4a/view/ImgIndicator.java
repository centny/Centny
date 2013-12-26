package org.cny.cny4a.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;

public class ImgIndicator extends CustomIndicator {

	public ImgIndicator(Context context) {
		super(context);
	}

	public ImgIndicator(Context context, AttributeSet attrs) {
		super(context, attrs);
	}
	
	@Override
	protected View createView(Context ctx) {
		ImageView view = new ImageView(this.ctx);
		view.setBackgroundResource(this.indicatorNormal);
		return view;
	}

	@Override
	protected void onPosUnselected(int currentPos) {
		ImageView iv;
		iv = (ImageView) this.views.get(this.currentPos);
		iv.setBackgroundResource(this.indicatorNormal);		
	}

	@Override
	protected void onPosSelected(int currentPos) {
		ImageView iv;
		iv = (ImageView) this.views.get(this.currentPos);
		iv.setBackgroundResource(this.indicatorSelected);	
	}
}
