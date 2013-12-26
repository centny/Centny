package org.cny.cny4a.net.http.test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.concurrent.CountDownLatch;

import org.cny.cny4a.net.http.HTTP;
import org.cny.cny4a.net.http.HTTP.HTTPDownCallback;
import org.cny.cny4a.net.http.HTTP.HTTPNameDlCallback;
import org.cny.cny4a.net.http.HTTPClient;
import org.cny.cny4a.test.MainActivity;

import android.os.Environment;
import android.test.ActivityInstrumentationTestCase2;
import android.util.Log;

public class HTTPTaskTestCase extends
		ActivityInstrumentationTestCase2<MainActivity> {
	public HTTPTaskTestCase() {
		super(MainActivity.class);
	}

	File dl;

	@Override
	protected void setUp() throws Exception {
		super.setUp();
		File ext = Environment.getExternalStorageDirectory();
		this.dl = new File(ext, "dl");
		if (!this.dl.exists()) {
			this.dl.mkdirs();
		}
	}

	public void testDoGet() throws Throwable {
		final CountDownLatch cdl = new CountDownLatch(1);
		this.runTestOnUiThread(new Runnable() {

			@Override
			public void run() {
				HTTP.doGet("http://www.baidu.com", new HTTP.HTTPMCallback() {

					@Override
					public void onError(HTTPClient c, Throwable err) {
						cdl.countDown();
					}

					@Override
					public void onSuccess(HTTPClient c, String data) {
						cdl.countDown();
						assertTrue(data.length() > 0);
					}
				});
			}
		});
		cdl.await();
	}

	public void testDoGetDown() throws Throwable {
		final CountDownLatch cdl = new CountDownLatch(1);
		final File p = new File(this.dl, "www.txt");
		this.runTestOnUiThread(new Runnable() {

			@Override
			public void run() {
				HTTP.doGetDown("http://www.baidu.com",
						new HTTPDownCallback(p.getAbsolutePath()) {

							@Override
							public void onSuccess(HTTPClient c) {
								super.onSuccess(c);
								cdl.countDown();
							}

							@Override
							public void onError(HTTPClient c, Throwable err) {
								super.onError(c, err);
								cdl.countDown();
							}

						});
			}
		});
		cdl.await();
		assertTrue(p.exists());
		FileReader r = new FileReader(p);
		BufferedReader reader = new BufferedReader(r);
		String line = null;
		while ((line = reader.readLine()) != null) {
			Log.e("Line", line);
		}
		reader.close();
		assertTrue(new File(this.dl, "www.txt").delete());
	}

	public void testDoGetDown2() throws Throwable {
		final CountDownLatch cdl = new CountDownLatch(1);
		this.runTestOnUiThread(new Runnable() {

			@Override
			public void run() {
				HTTP.doGetDown("http://192.168.1.10/测试.dat",
						new HTTPNameDlCallback(dl.getAbsolutePath()) {

							@Override
							public void onSuccess(HTTPClient c) {
								super.onSuccess(c);
								cdl.countDown();
							}

							@Override
							public void onError(HTTPClient c, Throwable err) {
								super.onError(c, err);
								cdl.countDown();
							}

						});
			}
		});
		cdl.await();
		File p = new File(this.dl, "测试.dat");
		assertTrue(p.exists());
		assertTrue(new File(this.dl, "测试.dat").delete());
	}

	public void testDoGetDown3() throws Throwable {
		for (int i = 1; i < 5; i++) {
			testDl(i);
		}
	}

	private void testDl(final int sw) throws Throwable {
		final CountDownLatch cdl = new CountDownLatch(1);
		this.runTestOnUiThread(new Runnable() {

			@Override
			public void run() {
				HTTP.doGetDown("http://192.168.1.76:8000/dl?sw=" + sw,
						new HTTPNameDlCallback(dl.getAbsolutePath()) {

							@Override
							public void onSuccess(HTTPClient c) {
								super.onSuccess(c);
								cdl.countDown();
							}

							@Override
							public void onError(HTTPClient c, Throwable err) {
								super.onError(c, err);
								Log.d("Test Error", "error", err);
								assertTrue(false);
								cdl.countDown();
							}

						});
			}
		});
		cdl.await();
		File p = new File(this.dl, "测试.pdf");
		assertTrue(p.exists());
		assertTrue(new File(this.dl, "测试.pdf").delete());
	}

	public void testDoGetDown4() throws Throwable {
		final CountDownLatch cdl = new CountDownLatch(1);
		this.runTestOnUiThread(new Runnable() {

			@Override
			public void run() {
				HTTP.doGetDown("http://192.168.1.76:8000/dl?sw=5",
						new HTTPNameDlCallback(dl.getAbsolutePath()) {

							@Override
							public void onSuccess(HTTPClient c) {
								super.onSuccess(c);
								cdl.countDown();
							}

							@Override
							public void onError(HTTPClient c, Throwable err) {
								super.onError(c, err);
								Log.d("Test Error", "error", err);
								assertTrue(false);
								cdl.countDown();
							}

						});
			}
		});
		cdl.await();
		File p = new File(this.dl, "dl");
		assertTrue(p.exists());
		assertTrue(new File(this.dl, "dl").delete());
	}
}
