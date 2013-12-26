package org.cny.cny4a.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.widget.ListView;

public class ScrollableListView extends ListView {

	public ScrollableListView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.init();
	}

	private GestureDetector detector;

	private void init() {
		detector = new GestureDetector(getContext(), new ScrollDetector());
		setFadingEdgeLength(0);
	}

	@Override
	public boolean onInterceptTouchEvent(MotionEvent ev) {
		return super.onInterceptTouchEvent(ev) && detector.onTouchEvent(ev);
	}

	class ScrollDetector extends SimpleOnGestureListener {
		@Override
		public boolean onScroll(MotionEvent e1, MotionEvent e2,
				float distanceX, float distanceY) {
			if (Math.abs(distanceY) >= Math.abs(distanceX)) {
				return true;
			}
			return false;
		}
	}

}
