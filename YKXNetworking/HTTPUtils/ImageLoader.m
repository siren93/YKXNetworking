//
//  ImageLoader.m
//  HTTPTest
//
//  Created by 杨绚 on 15-1-9.
//  Copyright (c) 2015年 net.siren93. All rights reserved.
//

#import "ImageLoader.h"
#import "HTTPUtils.h"

@interface ImageLoader()
@property BOOL withCache;
@property (atomic, copy) NSString *path;
@property (atomic, copy) NSString *fileName;
@property (atomic) NSNumber *fileSize;
@property (atomic, copy) NSString *URL;
@end

@implementation ImageLoader

@synthesize path = _path;
@synthesize fileName = _fileName;
@synthesize fileSize = _fileSize;
@synthesize URL = _URL;
@synthesize withCache = _withCache;
@synthesize delegate = _delegate;

- (void) loadImageFromURL:(NSString *)URL WithCachePath:(NSString *)path
{
    self.fileName = [NSString stringWithFormat:@"%d.jpg",(int)[URL hash]];
    self.URL = URL;
    self.path = path;
    HTTPUtils *task = [[HTTPUtils alloc] init];
    task.delegate = self;
    if (path == nil)
    {   //不带缓存
        self.withCache = NO;
        [task get:URL isSyn:NO];
    } else
    {   //带缓存
        self.withCache = YES;
        NSString *filePath = [self.path stringByAppendingPathComponent:self.fileName];
        NSMutableData *imageData = [NSMutableData dataWithContentsOfFile:filePath];
        if(imageData.length == 0)
        {
            [task get:URL isSyn:NO];
        }
        else
        {
            [self.delegate onLoading:1];
            [self.delegate onFinished:imageData];
        }
    }
}

- (void) didReceiveResponse:(NSURLResponse *)response
{
    self.fileSize = [NSNumber numberWithLongLong: [response expectedContentLength]];
    if ([self.delegate respondsToSelector:@selector(onStart)])
    {
        [self.delegate onStart];
    }
}

- (void) onLoading:(NSMutableData *)data
{
    NSNumber *partialSize = [NSNumber numberWithInteger:[data length]];
    NSNumber *percentage = [NSNumber numberWithFloat: [partialSize floatValue] / [self.fileSize floatValue]];
    if([self.delegate respondsToSelector:@selector(onLoading:)])
    {
        [self.delegate onLoading:[percentage floatValue]];
    }
}

- (void) didFinished:(NSMutableData *)data
{
    if (self.withCache)
    {
        NSString *filePath = [self.path stringByAppendingPathComponent:self.fileName];
        if([data writeToFile:filePath atomically:YES])
        {
            NSLog(@"写入缓存成功");
        } else
        {
            NSLog(@"写入缓存失败");
            NSLog(@"缓存目录：%@", self.path);
        }
    }
    if([self.delegate respondsToSelector:@selector(onFinished:)])
    {
        [self.delegate onFinished:data];
    }
}

- (void) didFailed:(NSError *)error
{
    NSString *errMsg = [NSString stringWithFormat:@"Failed！\nURL：%@\nError：%@ ", self.URL, error];
    if ([self.delegate respondsToSelector:@selector(onFailed:)])
    {
        [self.delegate onFailed:errMsg];
    }
}

@end
