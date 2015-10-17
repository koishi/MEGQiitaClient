//  MEGLoginWebViewController.m
//
//  Copyright © 2015年 bs. All rights reserved.

#import "MEGLoginWebViewController.h"
#import "MEGQiitaManager.h"
#import "MEGOAuth2Client.h"

@implementation MEGLoginWebViewController
{
  UIWebView *_webView;
  NSURLRequest *_authorizationRequest;
}

-(id)initWithAuthorizationRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _authorizationRequest = request;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadOAuthLoginView:)
                                                     name:kMEGAOauthLoginStartNotification object:nil];
        [[MEGQiitaManager sharedInstance] authorizeWithSuccess:^{
            [self hideModalView:YES];
        } failure:^(NSError *error) {
            [self hideModalView:NO];
        }];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _webView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ログイン認証";

    if (self.navigationController.viewControllers.count == 1) {
      UIBarButtonItem *buton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeButtonPushed:)];
      self.navigationItem.leftBarButtonItem = buton;
    }
    [_webView loadRequest:_authorizationRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if ([[MEGOAuth2Client sharedInstance] checkRedirectURI:request]) {

    NSNotification *notification = [NSNotification notificationWithName:kMEGAOauthLoginFinishNotification
                                                                 object:nil
                                                               userInfo:@{kMEGApplicationLaunchOptionsURLKey:request}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self hideModalView:YES];
    
    return NO;
  }
  return YES;
}

- (void)closeButtonPushed:(id)sender
{
  [self hideModalView:NO];
}

- (void)hideModalView:(BOOL)success
{
    if (self.completionHandler) {
        self.completionHandler(success);
    } else {
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }
}

#pragma mark - 

-(void)loadOAuthLoginView:(NSNotification *)notification
{
    NSURLRequest *req = (NSURLRequest *)notification.object;
    _authorizationRequest = req;
    [_webView loadRequest:_authorizationRequest];
}


@end
