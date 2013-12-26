package org.cny.cny4a.test;

import org.cny.cny4a.R;
import org.cny.cny4a.view.CustomIndicator;
import org.cny.cny4a.view.FocusImages;
import org.cny.cny4a.view.FocusIndicatorBuilder;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;

public class TestFocus extends FragmentActivity {
	private FocusImages fimg;
	private CustomIndicator indicator;
	private Context ctx;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.test_focus);
		this.ctx = this;
		this.indicator = (CustomIndicator) this.findViewById(R.id.indicator);
		this.indicator.setIndicatorMargin(5);
		this.fimg = (FocusImages) this.findViewById(R.id.fimg);
		this.fbuilder.init(this.fimg, this.indicator);
	}

	private int[] imgIds = { R.drawable.ic_launcher1, R.drawable.ic_launcher2,
			R.drawable.ic_launcher3, R.drawable.ic_launcher4,
			R.drawable.ic_launcher5 };
	private FocusIndicatorBuilder fbuilder = new FocusIndicatorBuilder() {

		@Override
		public int getItemCount() {
			return imgIds.length;
		}

		@Override
		public View createView(int position) {
			ImageView iv = new ImageView(ctx);
			LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT,
					LayoutParams.MATCH_PARENT);
			iv.setLayoutParams(params);
			iv.setBackgroundResource(imgIds[position]);
			return iv;
		}

		@Override
		public int getIndicatorNormal() {
			return R.drawable.p1;
		}

		@Override
		public int getIndicatorSelected() {
			return R.drawable.p2;
		}

	};
}
