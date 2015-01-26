//
//  YKXViewController.m
//  ImageDownloader
//
//  Created by 杨绚 on 15-1-9.
//  Copyright (c) 2015年 net.siren93. All rights reserved.
//

#import "YKXViewController.h"

@interface YKXViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *myProgressView;
@end

@implementation YKXViewController

@synthesize myImageView = _myImageView;
@synthesize myProgressView = _myProgressView;
@synthesize imageURLArray = _imageURLArray;
@synthesize imageLoader = _imageLoader;

static int currentImageIndex = 0;

- (void) viewDidLoad
{
    self.myProgressView.progress = 0;
    self.imageURLArray = [NSArray arrayWithObjects:@"http://g.hiphotos.baidu.com/image/pic/item/bd315c6034a85edf3b332f3f4a540923dd54756b.jpg", @"http://c.hiphotos.baidu.com/image/pic/item/314e251f95cad1c875042d3b7c3e6709c93d516b.jpg", @"http://a.hiphotos.baidu.com/image/pic/item/18d8bc3eb13533fa4a254232abd3fd1f41345b1f.jpg", @"http://b.hiphotos.baidu.com/image/pic/item/91529822720e0cf38e719fe70946f21fbe09aa2c.jpg", @"http://g.hiphotos.baidu.com/image/pic/item/03087bf40ad162d93c2f031012dfa9ec8b13cdfd.jpg", nil];
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    self.cachePath = [cachePaths objectAtIndex:0];
    self.imageLoader = [[ImageLoader alloc] init];
    self.imageLoader.delegate = self;
    [self.imageLoader loadImageFromURL:self.imageURLArray[currentImageIndex] WithCachePath:self.cachePath];
}

- (IBAction)getImage:(UIButton *)sender {
    if ([[sender currentTitle] isEqualToString:@"上一张"]) {
        if (currentImageIndex == 0) {
            currentImageIndex = self.imageURLArray.count - 1;
        }else{
            currentImageIndex = (currentImageIndex - 1) % 5;
        }
    }
    else
    {
        currentImageIndex = (currentImageIndex + 1) % 5;
    }
    [self.imageLoader loadImageFromURL:self.imageURLArray[currentImageIndex] WithCachePath:self.cachePath];
}

- (void) onStart
{
    [self.myProgressView setProgress:0];
}

- (void) onLoading:(float)percentage
{
    [self.myProgressView setProgress:percentage];
}

- (void) onFinished:(NSMutableData *)data
{
    UIImage *image = [UIImage imageWithData: data];
    self.myImageView.image = image;
}

- (void) onFailed:(NSString *)errMsg
{
    NSLog(@"%@", errMsg);
}

@end
