//
//  HTTPUtils.m
//  HTTPTest
//
//  Created by 杨绚 on 14-12-31.
//  Copyright (c) 2014年 net.siren93. All rights reserved.
//

#import "HTTPUtils.h"

@interface HTTPUtils ()

@property (atomic, retain) NSURLConnection *connection;
@property (atomic, retain) NSMutableData *receivedData;
@property (atomic) NSInteger statusCode;
@property (atomic, copy) NSString *errorDesc;
@property (atomic) bool didTaskFinished;

@end

@implementation HTTPUtils
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize statusCode = _statusCode;
@synthesize errorDesc = _errorDesc;
@synthesize delegate = _delegate;
@synthesize didTaskFinished = _didTaskFinished;

/*!
 * GET
 */
- (void) get : (NSString *) URL isSyn:(BOOL)isSyn
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString: URL]
                                     cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval: 10];
    [request setHTTPMethod:@"GET"];
    if (isSyn)
    {
        NSURLResponse *response;
        NSError *error;
        self.receivedData = [[NSMutableData alloc] init];
        [self.receivedData appendData: [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error]];
        NSString *html = [[NSString alloc] initWithData:self.receivedData encoding: NSUTF8StringEncoding];
        NSLog(@"html: %@", html);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        self.statusCode = [httpResponse statusCode];
        self.errorDesc = [error localizedDescription];
        if(self.errorDesc != nil)
        {
            NSLog(@"statusCode: %d", (int)self.statusCode);
            NSLog(@"errorDesc: %@", self.errorDesc);
        }
        //获取cookie
        //NSDictionary *responseHeaders = [httpResponse allHeaderFields];
        //NSString *cookie = [responseHeaders valueForKey:@"Set-Cookie"];
        //NSLog(@"cookie: %@", cookie);
    } else
    {
        self.didTaskFinished = false;
        self.connection = [NSURLConnection connectionWithRequest:request delegate: self];
        //在command line tool项目中运行时加以下代码避免main函数终结
        //while (!self.didTaskFinished) {
        //    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        //}
    }
    
}

/*!
 * POST
 */
- (void) post : (NSString *) URL params:(NSDictionary *)params isSyn:(BOOL)isSyn
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval: 10];
    [request setHTTPMethod: @"POST"];
    NSMutableString *content;
    NSEnumerator *keyEnumerator = [params keyEnumerator];
    NSEnumerator *valueEnumeratir = [params objectEnumerator];
    for (NSObject *key  in keyEnumerator) {
        [content appendString:[NSString stringWithFormat:@"%@", key]];
        [content appendString:@"="];
        [content appendString:[NSString stringWithFormat:@"%@", [valueEnumeratir nextObject]]];
        [content appendString:@"&"];
    }
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    if (isSyn) {
        NSURLResponse *response;
        NSError *error;
        self.receivedData = [[NSMutableData alloc] init];
        [self.receivedData appendData: [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error]];
        NSString *html = [[NSString alloc] initWithData:self.receivedData encoding: NSUTF8StringEncoding];
        NSLog(@"html: %@", html);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        self.statusCode = [httpResponse statusCode];
        self.errorDesc = [error localizedDescription];
        if(self.errorDesc != nil)
        {
            NSLog(@"statusCode: %d", (int)self.statusCode);
            NSLog(@"errorDesc: %@", self.errorDesc);
        }
    }else
    {
        self.didTaskFinished = false;
        self.connection = [NSURLConnection connectionWithRequest:request delegate: self];
        //在command line tool项目中运行时加以下代码避免main函数终结
        //while (!self.didTaskFinished) {
        //    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        //}
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    self.statusCode = [httpResponse statusCode];
    self.receivedData = [[NSMutableData alloc] init];
    [self.delegate didReceiveResponse:response];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData: data];
    [self.delegate onLoading:self.receivedData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.didTaskFinished = true;
    [self.delegate didFinished:self.receivedData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.didTaskFinished = true;
    NSLog(@"%d",(int)self.statusCode);
    [self.delegate didFailed:error];
}


@end
