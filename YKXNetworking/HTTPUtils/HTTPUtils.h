//
//  HTTPUtils.h
//  HTTPTest
//
//  Created by 杨绚 on 14-12-31.
//  Copyright (c) 2014年 net.siren93. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPUtilsDelegate.h"

@interface HTTPUtils : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (atomic, retain) id<HTTPUtilsDelegate> delegate;

- (void) get: (NSString *) URL isSyn: (BOOL) isSyn;
- (void) post: (NSString *) URL params: (NSDictionary *) params isSyn: (BOOL) isSyn;

@end
