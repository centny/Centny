//
//  NSGImage.m
//  Centny
//
//  Created by Centny on 9/14/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSGImage.h"
@implementation NSGImage
@synthesize rawData = _rawData, width = _width, height = _height;
- (id)initWith:(UIImage *)image
{
	self = [super init];

	if (self) {
		CGImageRef cgimage = image.CGImage;
		_width	= CGImageGetWidth(cgimage);
		_height = CGImageGetHeight(cgimage);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		_rawData = (unsigned char *)calloc(_height * _width * 4, sizeof(unsigned char));
		NSUInteger		bytesPerPixel		= 4;
		NSUInteger		bytesPerRow			= bytesPerPixel * _width;
		NSUInteger		bitsPerComponent	= 8;
		CGContextRef	context				= CGBitmapContextCreate(_rawData, _width, _height,
				bitsPerComponent, bytesPerRow, colorSpace,
				kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
		CGContextDrawImage(context, CGRectMake(0, 0, _width, _height), cgimage);
		CGContextRelease(context);
	}

	return self;
}

- (UIColor *)colorAt:(size_t)x y:(size_t)y
{
	unsigned char *_v = _rawData + (y * _width + x) * 4;

	return [UIColor colorWithRed:((float)_v[0] / 255.0) green:((float)_v[1] / 255.0) blue:((float)_v[2] / 255.0) alpha:((float)_v[3] / 255.0)];
}

- (void)colorAt:(unsigned char *)buf x:(size_t)x y:(size_t)y
{
	unsigned char *_v = _rawData + (y * _width + x) * 4;

	memccpy(buf, _v, 4, sizeof(unsigned char));
}

- (unsigned char *)rawDataAt:(size_t)x y:(size_t)y
{
	return _rawData + (y * _width + x) * 4;
}

- (unsigned char)valueAt:(size_t)x y:(size_t)y a:(size_t)a
{
	unsigned char *_v = [self rawDataAt:x y:y];

	return _v[a];
}

+ (id)gimageWith:(UIImage *)image
{
	return [[[NSGImage alloc]initWith:image]autorelease];
}

+ (id)gimageNamed:(NSString *)name
{
	return [[[NSGImage alloc]initWith:[UIImage imageNamed:name]]autorelease];
}

- (void)dealloc
{
	free(_rawData);
	[super dealloc];
}

@end
