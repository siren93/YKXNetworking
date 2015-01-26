//
//  YKXViewController.h
//  ImageDownloader
//
//  Created by 杨绚 on 15-1-9.
//  Copyright (c) 2015年 net.siren93. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoader.h"

@interface YKXViewController : UIViewController<FileDownloadDelegate>

@property (strong) NSArray *imageURLArray;
@property (strong) ImageLoader *imageLoader;
@property NSString *cachePath;

@end
