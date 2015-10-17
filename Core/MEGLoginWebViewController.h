//  MEGLoginWebViewController.h
//
//  Copyright © 2015年 bs. All rights reserved.

#import <UIKit/UIKit.h>

@interface MEGLoginWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, copy) void (^completionHandler)(BOOL success);

-(id)initWithAuthorizationRequest:(NSURLRequest *)request;

@end
