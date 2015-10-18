//
//  MEGQiitaManager.m
//  MEGOAuth2Client
//
//  Created by Koichiro Oishi on 2015/10/10.
//  Copyright © 2015年 bs. All rights reserved.
//

#import "MEGQiitaManager.h"
#import "MEGOAuth2Client.h"

@implementation MEGQiitaManager
{
  NSString *_consumerKey;
  NSString *_consumerSecret;
  id _applicationLaunchNotificationObserver;
}

+ (MEGQiitaManager *)sharedInstance
{
  static MEGQiitaManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MEGQiitaManager alloc] init];
  });
  return sharedInstance;
}

- (void)setConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
  _consumerKey = consumerKey;
  _consumerSecret = consumerSecret;
  [[MEGOAuth2Client sharedInstance] setConsumerKey:_consumerKey consumerSecret:_consumerSecret];

//  self.apiClient = [[HTBHatenaBookmarkAPIClient alloc] initWithKey:consumerKey secret:consumerSecret];
//  _authorized = NO;
//  
//  // Resume token
//  if (self.userManager.token) {
//    _authorized = YES;
//    self.apiClient.accessToken = self.userManager.token;
//  }
}

- (void)authorizeWithSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure
{
  _applicationLaunchNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMEGAOauthLoginFinishNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
    NSURLRequest *request = [[notification userInfo] valueForKey:kMEGApplicationLaunchOptionsURLKey];

    [[MEGOAuth2Client sharedInstance] getAccessToken:request completionHandler:^(NSString *token) {
      [[NSNotificationCenter defaultCenter] removeObserver:_applicationLaunchNotificationObserver];
      _applicationLaunchNotificationObserver = nil;
      self.token = token;
      success();
    } failure:^(NSError *error) {
      failure(error);
    }];
  }];

  NSURL *url =  [[MEGOAuth2Client sharedInstance] requestUrl];
  NSNotification *notification = [NSNotification notificationWithName:kMEGAOauthLoginStartNotification
                                                               object:[NSURLRequest requestWithURL:url]];
  [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - token

- (void)setToken:(NSString *)token
{
  [MEGOAuth2Client sharedInstance].token = token;
}

- (NSString *)token
{
  return [MEGOAuth2Client sharedInstance].token;
}

- (void)logout
{
  self.token = nil;
}

@end
