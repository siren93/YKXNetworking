//
//  ImageLoader.h
//  HTTPTest
//
//  Created by 杨绚 on 15-1-9.
//  Copyright (c) 2015年 net.siren93. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPUtilsDelegate.h"
#import "FileDownloadDelegate.h"

@interface ImageLoader : NSObject<HTTPUtilsDelegate>

@property id<FileDownloadDelegate> delegate;

- (void) loadImageFromURL: (NSString *) URL WithCachePath: (NSString *) path;

@end
