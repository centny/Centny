/*
 * the log4javascript appender for network log cliet.
 * @author Cny
 */
C4js.Uer = (function() {
	//
	function Uer(url, args, auto) {
		if (this.url) {
			this.url = urll;
		}
		if (args) {
			this.args = args;
		}
		if (auto) {
			this.Auto = auto;
		}
	}
	//
	Uer.prototype.files = new Array();
	Uer.prototype.Auto = true;
	Uer.prototype.Maxsize = 0;
	Uer.prototype.Minsize = 0;
	Uer.prototype.Uploading = false;
	Uer.prototype.Url = "";
	Uer.prototype.Fname = "file";
	Uer.prototype.Args = {};
	//
	Uer.prototype.AddF = function(f) {
		f.Status = "W";
		this.files.push(f);
	};
	Uer.prototype.Add = function(fl) {
		added = new Array();
		err = new Array();
		for (i = 0; i < fl.length; i++) {
			if (this.Maxsize && fl[i].size > this.Maxsize) {
				err.push(fl[i]);
				continue;
			}
			if (this.Minsize && fl[i].size < this.Minsize) {
				err.push(fl[i]);
				continue;
			}
			added.push(fl[i]);
			this.AddF(fl[i]);
		}
		this.OnAdd(added, err);
		this.Auto && this.uloop();
	};
	Uer.prototype.AddI = function(id) {
		t = document.getElementById(id);
		if (!t) {
			return;
		}
		t.uer = this;
		t.addEventListener("change", this.onc);
	};
	Uer.prototype.DelI = function(id) {
		t = document.getElementById(id);
		if (!t) {
			return;
		}
		t.uer = undefined;
		t.removeEventListener("change", this.onc);
	};
	Uer.prototype.onc = function(e) {
		e.preventDefault();
		t = e.srcElement;
		if (t.uer && t.files) {
			t.uer.Add(t.files);
		}
		return true;
	};
	Uer.prototype.uloop = function() {
		if (this.files.length < 1) {
			return;
		}
		f = this.files[0];
		var xhr = new XMLHttpRequest();
		var upload = xhr.upload;
		uer = this;
		upload.addEventListener("loadstart", function(e) {
			f.Status = "S";
			uer.OnStart(f, e);
		}, false);
		upload.addEventListener("progress", function(e) {
			f.Status = "P";
			rate = 0;
			if (e.lengthComputable) {
				rate = event.loaded / event.total;
			}
			uer.OnProcess(f, rate);
		}, false);
		upload.addEventListener("load", function(e) {
			f.Status = "L";
			uer.OnSuccess(f, xhr.responseText, e);
			uer.files.shift();
			uer.uloop();
		}, false);
		upload.addEventListener("error", function(e) {
			f.Status = "E";
			uer.OnErr(f, e);
		}, false);
		upload.addEventListener("abort", function(e) {
			f.Status = "A";
			uer.OnAbort(f, e);
		}, false);
		f.Status = "P";
		form = new FormData();
		uargs = new Array();
		for (k in this.Args) {
			uargs.push(k + "=" + this.Args[k]);
		}
		eargs = this.OnPrepare(f, xhr, form);
		if (eargs) {
			for (k in eargs) {
				uargs.push(k + "=" + eargs[k]);
			}
		}
		if (this.Fname.length) {
			form.append(this.Fname, f);
		}
		xhr.open("POST", this.Url + "?" + uargs.join("&"));
		xhr.overrideMimeType("application/octet-stream");
		xhr.send(form);
	};
	Uer.prototype.OnAdd = function(added, err) {

	};
	Uer.prototype.OnPrepare = function(f, xhr, form) {
		return {};
	};
	Uer.prototype.OnStart = function(f, e) {

	};
	Uer.prototype.OnProcess = function(f, rate, e) {

	};
	Uer.prototype.OnSuccess = function(f, text, e) {

	};
	Uer.prototype.OnErr = function(f, e) {

	};
	Uer.prototype.OnAbort = function(f, e) {

	};
	return Uer;
})();