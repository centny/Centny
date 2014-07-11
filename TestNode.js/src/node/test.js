//var jsdom = require("jsdom");
//var window = jsdom.jsdom().parentWindow;
//require('jquery')(window);
"use strict";
var jsdom = require("jsdom");
global.window = jsdom.jsdom().parentWindow;
//XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
var $ = require("jquery")(window)
//console.log(window)
$.get("http://www.baidu.com",function(d){
  console.log(d);
},function(e){
  console.log(e);
});
var http = require("http");  
  
var url = require("url");  
function onRequest(request,response){  
      var pathname = url.parse(request.url).pathname;  
      console.log("Request for " + pathname + "  received.") ;  

      route(pathname);  

      response.writeHead(200,{"Content-Type":"text/plain"});  
      response.write("Hello World");  
      response.end();  
  }  

http.createServer(onRequest).listen(8080);  