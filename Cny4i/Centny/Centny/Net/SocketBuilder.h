//
//  SocketBuilder.h
//  ShortcutPrj
//
//  Created by Centny on 8/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
//
@class	SocketBuilder;
@class	SocketClient;
//
@protocol SocketClientDelegate <NSObject>
@required
- (void)onReceiveData:(CFReadStreamRef)stream type:(CFStreamEventType)type client:(SocketClient *)client;
- (void)onResponseData:(CFWriteStreamRef)stream type:(CFStreamEventType)type client:(SocketClient *)client;
@end
//
@protocol SocketBuilderDelegate <NSObject>
@required
- (void)onAcceptConnect:(SocketClient *)client builder:(SocketBuilder *)builder;
@end
//
@interface SocketClient : NSObject {
	CFSocketRef					_socket;
	CFReadStreamRef				_istream;
	CFWriteStreamRef			_ostream;
	SocketBuilder				*_builder;
	id <SocketClientDelegate>	_delegate;
}
@property(nonatomic, readonly) CFSocketRef				socket;
@property(nonatomic, readonly) CFReadStreamRef			istream;
@property(nonatomic, readonly) CFWriteStreamRef			ostream;
@property(nonatomic, readonly) SocketBuilder			*builder;
@property(nonatomic, assign) id <SocketClientDelegate>	delegate;
- (id)initWith:(CFSocketRef)socket istream:(CFReadStreamRef)istream ostream:(CFWriteStreamRef)ostream builder:(SocketBuilder *)builder;
- (void)close;
- (void)write:(NSString *)data;
@end

@interface SocketBuilder : NSObject {
	CFSocketRef					_socket;	// the socket object.
	unsigned int				_port;		// the socket port to listen.
	BOOL						_isValid;	// the Socket state.
	id <SocketBuilderDelegate>	_delegate;	// the socket builder deletagte.
}
@property(nonatomic, readonly) CFSocketRef							socket;
@property(nonatomic, readonly) unsigned int							port;
@property(nonatomic, readonly) BOOL									isValid;
@property(nonatomic, readwrite, assign) id <SocketBuilderDelegate>	delegate;
@property(nonatomic, readonly) NSArray								*clients;
// add the socket loop to currrent loop.
- (void)addToLoop;
// close one client,it will release the SocketClient object.
- (void)closeClient:(SocketClient *)client;
// initial the socket server by port and default callback method.
- (id)initWithPort:(unsigned int)port;
// initial the socket server by port and specified callback method.
- (id)initWithPort:(unsigned int)port callback:(CFSocketCallBack)callback;
// run the socket loop in new thread.
- (void)runInNewThread;
@end

void defaultTCPCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);
