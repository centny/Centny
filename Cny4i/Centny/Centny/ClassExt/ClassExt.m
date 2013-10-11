//
//  ClassExt.m
//  Centny
//
//  Created by Centny on 9/10/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "ClassExt.h"
#import "../GeneralDef.h"
#import "../Core/CoreMethod.h"
// //////////////////////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////NSString.///////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (Dictionary)
- (id)dictionaryBy:(NSString *)separator kvSeparator:(NSString *)kvs
{
	return [NSDictionary dictionaryBy:self arySeparator:separator kvSeparator:kvs];
}

- (id)dictionaryByURLQuery
{
	return [self dictionaryBy:@"&" kvSeparator:@"="];
}

- (float)heightByLineWidth:(float)width font:(UIFont *)font
{
	if ([@"" isEqualToString : self]) {
		NSDLog(@"the text can't be nil or empty");
		return -1;
	}

	if (width < 1) {
		NSDLog(@"the width can't less 1");
		return -1;
	}

	if (nil == font) {
		NSDLog(@"the font can't be nil");
		return -1;
	}

	//    GLfloat height;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
	label.text			= self;
	label.font			= font;
	label.numberOfLines = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
		label.lineBreakMode = UILineBreakModeWordWrap;
#else
		label.lineBreakMode = NSLineBreakByWordWrapping;
#endif
	[label sizeToFit];
	CGFloat height = label.frame.size.height;
	[label release];
	return height;
}

- (BOOL)isEmptyOrWhiteSpace
{
	return [self stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1;
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////NSDictionary/////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSDictionary (PatternStringToNSDictionary)
// dictionary by two speparator string,like @"a=1&b=2".
+ (id)dictionaryBy:(NSString *)data arySeparator:(NSString *)arys kvSeparator:(NSString *)kvs
{
	NSMutableDictionary *dict	= [[[NSMutableDictionary alloc] init] autorelease];
	NSArray				*fs		= [data componentsSeparatedByString:arys];

	if (nil == fs) {
		return dict;
	}

	for (NSString *one in fs) {
		NSArray *kv = [one componentsSeparatedByString:kvs];

		if ([kv count] < 2) {
			continue;
		}

		[dict setObject:kv[1] forKey:kv[0]];
	}

	return dict;
}

- (id)stringByURLQuery
{
	if (self.count) {
		NSMutableString *args = [NSMutableString string];

		for (NSString *key in [self allKeys]) {
			[args appendFormat:@"&%@=%@", key, [self objectForKey:key]];
		}

		NSRange rg = {0, 1};
		return [args stringByReplacingCharactersInRange:rg withString:@""];
	} else {
		return @"";
	}
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////NSURL.///////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSURL (Dictionary)
- (id)dictionaryByURLQuery
{
	return [[self.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dictionaryByURLQuery];
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// ///////////////////////////////////NSURLRequest.//////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSURLRequest (Dictionary)
- (id)dictionaryByURLQuery
{
	return [self.URL dictionaryByURLQuery];
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// ///////////////////////////////////UIColor.///////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIColor (Scorpion)
- (UIImage *)image
{
	return [UIImage imageWithColor:self];
}

+ (UIColor *)colorWithR:(int)r G:(int)g B:(int)b A:(float)a
{
	return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////UIImage extensions.//////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIImage (Color2Image)
+ (UIImage *)imageWithColor:(UIColor *)color
{
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);

	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (NSGImage *)gimage
{
	return [NSGImage gimageWith:self];
}

- (UIImage *)convertToGreyscale
{
	UIImage *i		= self;
	int		kRed	= 1;
	int		kGreen	= 2;
	int		kBlue	= 4;

	int colors		= kGreen;
	int m_width		= i.size.width;
	int m_height	= i.size.height;

	uint32_t		*rgbImage	= (uint32_t *)malloc(m_width * m_height * sizeof(uint32_t));
	CGColorSpaceRef colorSpace	= CGColorSpaceCreateDeviceRGB();
	CGContextRef	context		= CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);

	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGContextSetShouldAntialias(context, NO);
	CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	// now convert to grayscale
	uint8_t *m_imageData = (uint8_t *)malloc(m_width * m_height);

	for (int y = 0; y < m_height; y++) {
		for (int x = 0; x < m_width; x++) {
			uint32_t	rgbPixel	= rgbImage[y * m_width + x];
			uint32_t	sum			= 0, count = 0;

			if (colors & kRed) {
				sum += (rgbPixel >> 24) & 255; count++;
			}

			if (colors & kGreen) {
				sum += (rgbPixel >> 16) & 255; count++;
			}

			if (colors & kBlue) {
				sum += (rgbPixel >> 8) & 255; count++;
			}

			m_imageData[y * m_width + x] = sum / count;
		}
	}

	free(rgbImage);

	// convert from a gray scale image back into a UIImage
	uint8_t *result = (uint8_t *)calloc(m_width * m_height * sizeof(uint32_t), 1);

	// process the image back to rgb
	for (int i = 0; i < m_height * m_width; i++) {
		result[i * 4] = 0;
		int val = m_imageData[i];
		result[i * 4 + 1]	= val;
		result[i * 4 + 2]	= val;
		result[i * 4 + 3]	= val;
	}

	// create a UIImage
	colorSpace	= CGColorSpaceCreateDeviceRGB();
	context		= CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	CGImageRelease(image);

	free(m_imageData);

	// make sure the data will be released by giving it to an autoreleased NSData
	[NSData dataWithBytesNoCopy:result length:m_width * m_height];

	return resultUIImage;
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////UIView.///////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (ExtendView)
+ (void)pushRView:(UIView *)left rv:(UIView *)rv finished:(void (^)(BOOL))finished
{
	rv.frame = CGRectMake(FRAM_XW(left), rv.frame.origin.y, FRAM_W(rv), FRAM_H(rv));
	[UIView animateWithDuration:0.5 animations:^{
		left.frame = CGRectMake(left.frame.origin.x - FRAM_W(rv), left.frame.origin.y, FRAM_W(left), FRAM_H(left));
		rv.frame = CGRectMake(rv.frame.origin.x - FRAM_W(rv), rv.frame.origin.y, FRAM_W(rv), FRAM_H(rv));
	} completion:^(BOOL f) {
		if (finished) {
			finished(f);
		}
	}];
}

+ (void)popRView:(UIView *)left rv:(UIView *)rv finished:(void (^)(BOOL))finished
{
	[UIView animateWithDuration:0.5 animations:^{
		left.frame = CGRectMake(left.frame.origin.x + FRAM_W(rv), left.frame.origin.y, FRAM_W(left), FRAM_H(left));
		rv.frame = CGRectMake(rv.frame.origin.x + FRAM_W(rv), rv.frame.origin.y, FRAM_W(rv), FRAM_H(rv));
	} completion:^(BOOL f) {
		//			[rv removeFromSuperview];

		if (finished) {
			finished(f);
		}
	}];
}

+ (void)pushLView:(UIView *)right lv:(UIView *)lv finished:(void (^)(BOOL))finished
{
	lv.frame = CGRectMake(-FRAM_W(lv), lv.frame.origin.y, FRAM_W(lv), FRAM_H(lv));
	[UIView animateWithDuration:0.5 animations:^{
		right.frame = CGRectMake(right.frame.origin.x + FRAM_W(lv), right.frame.origin.y, FRAM_W(right), FRAM_H(right));
		lv.frame = CGRectMake(lv.frame.origin.x + FRAM_W(lv), lv.frame.origin.y, FRAM_W(lv), FRAM_H(lv));
	} completion:^(BOOL f) {
		if (finished) {
			finished(f);
		}
	}];
}

+ (void)popLView:(UIView *)right lv:(UIView *)lv finished:(void (^)(BOOL))finished
{
	[UIView animateWithDuration:0.5 animations:^{
		right.frame = CGRectMake(right.frame.origin.x - FRAM_W(lv), right.frame.origin.y, FRAM_W(right), FRAM_H(right));
		lv.frame = CGRectMake(lv.frame.origin.x - FRAM_W(lv), lv.frame.origin.y, FRAM_W(lv), FRAM_H(lv));
	} completion:^(BOOL f) {
		//			[lv removeFromSuperview];

		if (finished) {
			finished(f);
		}
	}];
}

+ (void)reviseTextDisplay:(UIView *)view
{
	int x, y, w, h;

	x			= [self checkIsInt:view.frame.origin.x];
	y			= [self checkIsInt:view.frame.origin.y];
	w			= [self checkIsEven:view.frame.size.width];
	h			= [self checkIsEven:view.frame.size.height];
	view.frame	= CGRectMake(x, y, w, h);
}

+ (CGRect)reviseViewFrame:(CGRect)rect
{
	int x, y, w, h;

	x	= [self checkIsInt:rect.origin.x];
	y	= [self checkIsInt:rect.origin.y];
	w	= [self checkIsEven:rect.size.width];
	h	= [self checkIsEven:rect.size.height];
	return CGRectMake(x, y, w, h);
}

+ (int)checkIsInt:(CGFloat)arg
{
	int temp = arg * 100;

	temp = temp % 100;

	if (temp > 50) {
		return ceilf(arg);
	} else {
		return floorf(arg);
	}
}

+ (int)checkIsEven:(CGFloat)arg
{
	int temp = arg * 100;

	temp = temp % 200;

	if (temp == 100) {
		return arg + 1;
	} else if (temp > 100) {
		return ceilf(arg);
	} else {
		return floorf(arg);
	}
}

+ (id)viewWithColor:(UIColor *)color frame:(CGRect)frame
{
	UIView *view = [[[UIView alloc] initWithFrame:frame] autorelease];

	view.backgroundColor = color;
	return view;
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// /////////////////////////////UIGestureRecognizer./////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIGestureRecognizer (ClickRecognizer)
+ (UITapGestureRecognizer *)recognizerByClick:(id)owner action:(SEL)action
{
	UITapGestureRecognizer *rec = [[[UITapGestureRecognizer alloc] init] autorelease];

	rec.numberOfTapsRequired	= 1;
	rec.numberOfTouchesRequired = 1;
	[rec addTarget:owner action:action];
	return rec;
}

+ (UITapGestureRecognizer *)recognizerByDoubleClick:(id)owner action:(SEL)action
{
	UITapGestureRecognizer *rec = [[[UITapGestureRecognizer alloc] init] autorelease];

	rec.numberOfTapsRequired	= 2;
	rec.numberOfTouchesRequired = 1;
	[rec addTarget:owner action:action];
	return rec;
}

@end
// //////////////////////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////UIScreen./////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIScreen (Vesion)
+ (BOOL)isIPhone5
{
	UIScreen	*ms		= [self mainScreen];
	float		height	= ms.bounds.size.height * ms.scale;

	return height >= 1136;
}

+ (float)contentHeight
{
	if ([self isIPhone5]) {
		return 548.0;
	} else {
		return 460.0;
	}
}

@end

@implementation UIColor (String)
+ (id)colorWithString:(NSString *)hex
{
	if (![@"#" isEqualToString :[hex substringToIndex:1]]) {
		return NULL;
	}

	float r, g, b, a = 255;
	switch (hex.length) {
		case 4:
			{
				char val;
				val = [hex characterAtIndex:1];
				r	= strtoul(&val, 0, 16);
				r	= (r / 15.0 * 255.0);
				val = [hex characterAtIndex:2];
				g	= strtoul(&val, 0, 16);
				g	= (g / 15.0 * 255.0);
				val = [hex characterAtIndex:3];
				b	= strtoul(&val, 0, 16);
				g	= (g / 15.0 * 255.0);
			}
			break;

		case 5:
			{
				char val;
				val = [hex characterAtIndex:1];
				r	= strtoul(&val, 0, 16);
				r	= (r / 15.0 * 255.0);
				val = [hex characterAtIndex:2];
				g	= strtoul(&val, 0, 16);
				g	= (g / 15.0 * 255.0);
				val = [hex characterAtIndex:3];
				b	= strtoul(&val, 0, 16);
				b	= (b / 15.0 * 255.0);
				val = [hex characterAtIndex:4];
				a	= strtoul(&val, 0, 16);
				a	= (a / 15.0);
			}
			break;

		case 7:
			{
				char val[2];
				val[0]	= [hex characterAtIndex:1];
				val[1]	= [hex characterAtIndex:2];
				r		= strtoul(val, 0, 16);
				val[0]	= [hex characterAtIndex:3];
				val[1]	= [hex characterAtIndex:4];
				g		= strtoul(val, 0, 16);
				val[0]	= [hex characterAtIndex:5];
				val[1]	= [hex characterAtIndex:6];
				b		= strtoul(val, 0, 16);
			}
			break;

		case 9:
			{
				char val[2];
				val[0]	= [hex characterAtIndex:1];
				val[1]	= [hex characterAtIndex:2];
				r		= strtoul(val, 0, 16);
				val[0]	= [hex characterAtIndex:3];
				val[1]	= [hex characterAtIndex:4];
				g		= strtoul(val, 0, 16);
				val[0]	= [hex characterAtIndex:5];
				val[1]	= [hex characterAtIndex:6];
				b		= strtoul(val, 0, 16);
				val[0]	= [hex characterAtIndex:7];
				val[1]	= [hex characterAtIndex:8];
				a		= strtoul(val, 0, 16);
				a		= (a / 255.0);
			}
			break;

		default:
			return nil;
	}
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
