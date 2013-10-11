//
//  NSSLiteBuilder.m
//  BuyGo
//
//  Created by Cny on 8/23/13.
//  Copyright (c) 2013 Cny. All rights reserved.
//

#import "NSSLiteBuilder.h"
@interface NSSLiteBuilder () {
	sqlite3			*db_;
	sqlite3_stmt	*stm_;
}
@end
@implementation NSSLiteBuilder
@synthesize db = db_, stm = stm_;
- (id)init
{
	self = [super init];

	if (self) {
		db_		= NULL;
		stm_	= NULL;
	}

	return self;
}

+ (id)builderWithDb:(NSString *)spath
{
	NSSLiteBuilder *b = [[NSSLiteBuilder alloc]init];

	int res = [b initDb:[spath UTF8String]];

	if (res == SQLITE_OK) {
		return b;
	} else {
		return nil;
	}
}

- (int)initDb:(const char *)spath
{
	return sqlite3_open(spath, &db_);
}

- (int)exec:(const char *)sql
{
	char	*emsg	= NULL;
	int		res		= sqlite3_exec(db_, sql, NULL, NULL, &emsg);

	if (emsg) {
		self.emsg = [NSString stringWithUTF8String:emsg];
	} else {
		self.emsg = nil;
	}

	return res;
}

- (int)prepare:(const char *)sql
{
	char *emsg = NULL;

	int res = sqlite3_prepare_v2(db_, sql, -1, &stm_, nil);

	if (emsg) {
		self.emsg = [NSString stringWithUTF8String:emsg];
	} else {
		self.emsg = nil;
	}

	return res;
}

- (int)reset
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_reset(stm_);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)columnCount
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_column_count(stm_);
	} else {
		self.emsg = @"Statement not initialed";
		return 0;
	}
}

- (int)dataCount
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_data_count(stm_);
	} else {
		self.emsg = @"Statement not initialed";
		return 0;
	}
}

- (int)bind:(int)idx int32:(int)val
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_bind_int(stm_, idx, val);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)bind:(int)idx int64:(sqlite_int64)val
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_bind_int64(stm_, idx, val);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)bind:(int)idx double64:(double)val
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_bind_double(stm_, idx, val);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)bind:(int)idx text:(const char *)val
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_bind_text(stm_, idx, val, -1, NULL);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)bind:(int)idx string:(NSString *)val
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_bind_text(stm_, idx, [val UTF8String], -1, NULL);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)bindNull:(int)idx
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_bind_null(stm_, idx);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)columnInt32:(int)idx
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_column_int(stm_, idx);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (sqlite_int64)columnInt64:(int)idx
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_column_int64(stm_, idx);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (double)columnDouble:(int)idx
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_column_double(stm_, idx);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (const unsigned char *)columnText:(int)idx
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_column_text(stm_, idx);
	} else {
		self.emsg = @"Statement not initialed";
		return nil;
	}
}

- (NSString *)columnString:(int)idx
{
	if (stm_) {
		self.emsg = nil;
		const unsigned char *text = sqlite3_column_text(stm_, idx);

		if (text) {
			return [[NSString alloc]initWithCString:(char *)text encoding:NSUTF8StringEncoding];
		} else {
			return nil;
		}
	} else {
		self.emsg = @"Statement not initialed";
		return nil;
	}
}

- (const char *)columnName:(int)idx
{
	if (stm_) {
		return sqlite3_column_name(stm_, idx);
	} else {
		self.emsg = @"Statement not initialed";
		return 0;
	}
}

- (NSString *)columnNameString:(int)idx
{
	const char *text = [self columnName:idx];

	if (text) {
		return [NSString stringWithUTF8String:text];
	} else {
		return nil;
	}
}

- (int)columnType:(int)idx{
    return sqlite3_column_bytes(stm_, idx);
}

-(NSString*)errorMsg{
    const char* msg=sqlite3_errmsg(db_);
    if(msg){
        return [NSString stringWithUTF8String:msg];
    }else{
        return nil;
    }
}

- (int)freeStm
{
	if (stm_) {
		int res = sqlite3_finalize(stm_);
		stm_		= NULL;
		self.emsg	= nil;
		return res;
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (int)step
{
	if (stm_) {
		self.emsg = nil;
		return sqlite3_step(stm_);
	} else {
		self.emsg = @"Statement not initialed";
		return SQLITE_ERROR;
	}
}

- (NSArray *)queryAll:(SQLiteQueryCallback)back
{
	if (!stm_) {
		self.emsg = @"Statement not initialed";
		return nil;
	}

	NSMutableArray *ary = [NSMutableArray array];
    int res;
	while ((res=[self step]) != SQLITE_DONE) {
		NSMutableDictionary *row = [NSMutableDictionary dictionary];

        if(back){
            back(self,row);
        }else{
            for (int i = 0; i < [self columnCount]; i++) {
                NSString	*key	= [self columnNameString:i];
                NSString	*val	= [self columnString:i];
                if(key==nil||val==nil){
                    continue;
                }
                row[[NSString stringWithFormat:@"%@",key]] = [NSString stringWithFormat:@"%@",val];
            }
        }
		[ary addObject:row];
	}

	return ary;
}

- (void)dealloc
{
	if (stm_) {
		sqlite3_finalize(stm_);
		stm_ = NULL;
	}

	if (db_) {
		sqlite3_close(db_);
		db_ = NULL;
	}
    [super dealloc];
}

@end

