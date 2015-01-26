//
//  FileDownloadDelegate.h
//  ImageDownloader
//
//  Created by 杨绚 on 15-1-9.
//  Copyright (c) 2015年 net.siren93. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileDownloadDelegate <NSObject>

- (void) onStart;

- (void) onLoading: (float) percentage;

- (void) onFinished: (NSMutableData *) data;

- (void) onFailed: (NSString *) errorMsg;

@end
