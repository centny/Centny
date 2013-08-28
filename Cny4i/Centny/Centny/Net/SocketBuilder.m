//
//  SocketBuilder.m
//  ShortcutPrj
//
//  Created by Centny on 8/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "SocketBuilder.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <Foundation/Foundation.h>
#import "../Core/CoreMethod.h"

//
@interface SocketBuilder(){
    NSThread *thr;
    CFRunLoopRef cfRunLoop;
    CFRunLoopSourceRef source;
    NSMutableArray *_clients;
}
-(void)addClient:(SocketClient*)client;
@property(nonatomic,readonly)CFRunLoopRef builderLoop;
@end

// 读取数据
void readStream(CFReadStreamRef stream,CFStreamEventType eventType,void *info) {
    SocketClient *client=(SocketClient*)info;
    if(client.delegate){
        [client.delegate onReceiveData:stream type:eventType client:client];
    }
}
void writeStream (CFWriteStreamRef stream, CFStreamEventType eventType, void *info) {
    SocketClient *client=(SocketClient*)info;
    if(client.delegate){
        [client.delegate onResponseData:stream type:eventType client:client];
    }
}
// socket回调函数
void defaultTCPCallBack(CFSocketRef socket,CFSocketCallBackType type,CFDataRef address,const void *data,void* info) {
//    NSDLog(@"TCP call back,type:%d",(int)type);
    if (kCFSocketAcceptCallBack == type) {
        // 本地套接字句柄
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];      
        socklen_t nameLen = sizeof(name);
        if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name, &nameLen)) {
            NSDLog(@"error");
            exit(1);
        }
//        NSDLog(@"%@ connected.", inet_ntoa( ((struct sockaddr_in *)name)->sin_addr ));
        CFReadStreamRef iStream;
        CFWriteStreamRef oStream;
        // 创建一个可读写的socket连接
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &iStream, &oStream); 
        if (iStream && oStream) {
            SocketBuilder *builder=(SocketBuilder*)info;
            SocketClient *client=[[SocketClient alloc]initWith:socket istream:iStream ostream:oStream builder:builder];
            [builder addClient:client];
            if(builder.delegate){
                [builder.delegate onAcceptConnect:client builder:builder];
            }
            [client release];
            CFStreamClientContext streamContext = {0, NULL, NULL, NULL};
            streamContext.info=client;
            if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable,readStream,&streamContext)){
                exit(1);
            }
            
            if (!CFWriteStreamSetClient(oStream, kCFStreamEventCanAcceptBytes, writeStream,&streamContext)){
                exit(1);
            }
            //
            CFReadStreamSetProperty(iStream, kCFStreamPropertyShouldCloseNativeSocket,kCFBooleanTrue);
            CFReadStreamSetProperty(iStream, kCFStreamNetworkServiceType,kCFStreamNetworkServiceTypeVoIP);
            CFReadStreamScheduleWithRunLoop(iStream,builder.builderLoop, kCFRunLoopCommonModes);
            //
            CFWriteStreamSetProperty(oStream, kCFStreamPropertyShouldCloseNativeSocket,kCFBooleanTrue);
            CFWriteStreamSetProperty(oStream, kCFStreamNetworkServiceType,kCFStreamNetworkServiceTypeVoIP);
            CFWriteStreamScheduleWithRunLoop(oStream,builder.builderLoop, kCFRunLoopCommonModes);
            //
            CFWriteStreamOpen(oStream);
            CFReadStreamOpen(iStream);
        } else {
            close(nativeSocketHandle);
        }
    }
}
///
///
///
@implementation SocketClient
@synthesize socket=_socket,istream=_istream,ostream=_ostream,builder=_builder,delegate=_delegate;
-(id)initWith:(CFSocketRef)socket istream:(CFReadStreamRef)istream ostream:(CFWriteStreamRef)ostream builder:(SocketBuilder *)builder{
    self=[super init];
    if(self){
        _socket=socket;
        _istream=istream;
        _ostream=ostream;
        _builder=builder;
    }
    return self;
}
-(void)close{
    if(_builder){
        [_builder closeClient:self];
    }
}
-(void)write:(NSString *)data{
    const char* cdata=[data UTF8String];
    CFWriteStreamWrite(_ostream, (unsigned char*)cdata, strlen(cdata));
}
@end
///
///
///
@implementation SocketBuilder
@synthesize port=_port,isValid=_isValid,socket=_socket,delegate=_delegate,clients=_clients,builderLoop=cfRunLoop;
-(void)addToLoop{
//    NSDLog(@"ref:%p",CFRunLoopGetCurrent());
    cfRunLoop = CFRunLoopGetCurrent();
    source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
}
-(void)addClient:(SocketClient *)client{
    if(_clients){
        [_clients addObject:client];
    }
}
-(void)closeClient:(SocketClient*)client{
    if(client){
        CFReadStreamUnscheduleFromRunLoop(client.istream,self.builderLoop, kCFRunLoopCommonModes);
        CFReadStreamClose(client.istream);
        CFWriteStreamUnscheduleFromRunLoop(client.ostream,self.builderLoop, kCFRunLoopCommonModes);
        CFWriteStreamClose(client.ostream);
        [_clients removeObject:client];
    }
}
-(void)setup:(unsigned int)port callback:(CFSocketCallBack)callback{
    _port=port;
    CFSocketContext ctx={0,0,0,0,0};
    ctx.info=self;
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, callback, &ctx);
    if (NULL == _socket) {
        NSDLog(@"Cannot create socket!");
        _isValid=FALSE;
        return;
    }
    int optval = 1;
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, // 允许重用本地地址和端口
               (void *)&optval, sizeof(optval));
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(_port);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
    if (kCFSocketSuccess != CFSocketSetAddress(_socket, address)) {
        NSDLog(@"Bind to address failed!");
        if (_socket)
            CFRelease(_socket);
        if (address){
            CFRelease(address);
        }
        _socket = NULL;
        _isValid=FALSE;
        return;
    }
    _isValid=TRUE;
    CFRelease(address);
    NSDLog(@"initial listener completed");
}
//
-(id)initWithPort:(unsigned int)port{
    self=[super init];
    if(self){
        _clients=[[NSMutableArray alloc]init];
        [self setup:port callback:defaultTCPCallBack];
    }
    return self;
}
//
-(id)initWithPort:(unsigned int)port callback:(CFSocketCallBack)callback{
    self=[super init];
    if(self){
        _clients=[[NSMutableArray alloc]init];
        [self setup:port callback:callback];
    }
    return self;
}

-(void)runLoop{
    [self addToLoop];
    CFRunLoopRun();
}
-(void)runInNewThread{
    thr=[[NSThread alloc]initWithTarget:self selector:@selector(runLoop) object:nil];
    [thr start];
}
-(void)dealloc{
    if(cfRunLoop&&source){
        CFRunLoopRemoveSource(cfRunLoop,source,kCFRunLoopCommonModes);
        CFRelease(source);
        cfRunLoop=0;
        source=0;
    }
    if(_socket){
        CFSocketInvalidate(_socket);
        CFRelease(_socket);
        _socket=0;
    }
    if(_clients){
        [_clients release];
        _clients=nil;
    }
    [super dealloc];
}
@end
