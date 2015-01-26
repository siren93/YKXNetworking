//
//  FileDownloadDelegate.h
//  HTTPTest
//
//  Created by 杨绚 on 15-1-9.
//  Copyright (c) 2015年 net.siren93. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSURLResponse;
@class NSMutableData;
@class NSError;

@protocol HTTPUtilsDelegate <NSObject>

- (void) didReceiveResponse:(NSURLResponse *) response;

- (void) onLoading:(NSMutableData *) data;

- (void) didFinished:(NSMutableData *) data;

- (void) didFailed:(NSError *) error;

@end
