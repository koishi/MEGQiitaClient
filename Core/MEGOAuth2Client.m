//
//  MEGOAuth2Client.m
//  MEGOAuth2Client
//
//  Created by Koichiro Oishi on 2015/09/27.
//  Copyright © 2015年 bs. All rights reserved.
//

#import "MEGOAuth2Client.h"

#import "UICKeyChainStore.h"

#import "AFNetworking.h"

#import "MEGQiitaManager.h"

NSString *const kServiceName = @"Qiita-token";

@implementation MEGOAuth2Client
{
  NSString *_consumerKey;
  NSString *_consumerSecret;
}

NSString *const kMEGAOauthLoginStartNotification = @"kMEGAOauthLoginStartNotification";
NSString *const kMEGAOauthLoginFinishNotification = @"kMEGAOauthLoginFinishNotification";
NSString *const kMEGApplicationLaunchOptionsURLKey = @"UIApplicationLaunchOptionsURLKey";

// シングルトンのインスタンス取得
+ (MEGOAuth2Client *)sharedInstance
{
  static MEGOAuth2Client* sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MEGOAuth2Client alloc] init];
  });
  return sharedInstance;
}

// OAuth2.0認証に必要なリクエストを生成する処理
- (void)requestAccessToAccount:(void (^)(NSURL *preparedURL))withPreparedAuthorizationURLHandler
{
  NSString *url = [NSString stringWithFormat:@"%@%@?response_type=code&client_id=%@&scope=%@",
                   kOauth2ClientBaseUrl,kOauth2ClientAuthUrl, _consumerKey, kOauth2ClientScope];
  withPreparedAuthorizationURLHandler([NSURL URLWithString:url]);
}

- (NSURL*)requestUrl
{
  NSString *url = [NSString stringWithFormat:@"%@%@?response_type=code&client_id=%@&scope=%@",
                   kOauth2ClientBaseUrl,kOauth2ClientAuthUrl, _consumerKey, kOauth2ClientScope];
  return [NSURL URLWithString:url];
}

// OAuth2.0認証のリダイレクトURIの一致の有無を確認する処理
- (BOOL)checkRedirectURI:(NSURLRequest *)request
{
  // HOSTの取得
//  NSString *host = [[request URL] host];
  if ( [[[[request URL] absoluteString] lowercaseString] hasPrefix:[kOauth2ClientRedirectUrl lowercaseString]]) {
//  if ([host isEqualToString:kOauth2ClientRedirectUrl]) {
    return YES;
  } else {
    return NO;
  }
}


// アクセストークンを取得する処理
- (void)getAccessToken:(NSURLRequest *)request
     completionHandler:(void (^)(NSString *accessToken))completionHandler
               failure:(void (^)(NSError *error))failure
{

  NSString *code;
  NSArray *urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
  for (NSString *param in urlParams) {
    NSArray *keyValue = [param componentsSeparatedByString:@"="];
    NSString *key = [keyValue objectAtIndex:0];
    if ([key isEqualToString:@"code"]) {
      code = [keyValue objectAtIndex:1];
      break;
    }
  }

  if (!code) {
    return;
  }

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  // サーバエラー時のContent-Typeにtext/plainを許可(成功時にapplication/jsonが必要なので共に追加)
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",nil];

  // RequestSerializer
  AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
  [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  manager.requestSerializer = requestSerializer;
  
  // パラメータの設定
  NSString *tokenURL = [kOauth2ClientBaseUrl stringByAppendingString:kOauth2ClientTokenUrl];
  NSDictionary *parammeters = @{@"client_id": _consumerKey, @"client_secret": _consumerSecret, @"code": code};
  
  [manager POST:tokenURL parameters:parammeters success:^(NSURLSessionDataTask *task, id responseObject) {

    // 成功した場合
    if(responseObject && [responseObject count] > 0) {
      NSString *token = responseObject[@"token"];
//      UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:kServiceName];
//      keychain[kServiceName] = token;
      self.token = token;
      
      // 処理が終了したときに実行(アクセストークンを返す)
      completionHandler(token);
    }

  } failure:^(NSURLSessionDataTask *task, NSError *error) {

    // 失敗した場合
    NSError *err;
    NSData *data = [[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    if(data) {
      // エラーの中身がある場合
      NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err]);
    }
    //      // 失敗を返す
    failure(err);

  }];


}

// リフレッシュトークンから新しいアクセストークンを取得する処理
- (void)getRefreshAccessToken:(void (^)(NSString *accessToken))success failure:(void (^)(NSError *error))failure {

  NSString *clientId;
  NSString *tokenURL;
  NSString *refreshToken;
 
  if (clientId && tokenURL && refreshToken) {
    // 必須パラメータがある場合
    // AFHTTPSessionManagerをインスタンス化
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // サーバエラー時のContent-Typeにtext/plainを許可(成功時にapplication/jsonが必要なので共に追加)
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", nil];
    
    // パラメータの設定
    NSDictionary *data = @{@"client_id": clientId, @"refresh_token": refreshToken, @"grant_type": @"refresh_token"};
    
    [manager POST:tokenURL parameters:data success:^(NSURLSessionDataTask *task, id responseObject) {
      
      // 成功した場合
      if (responseObject && [responseObject count] > 0) {
        NSString *accessToken = responseObject[@"access_token"];
        NSString *refreshToken = responseObject[@"refresh_token"];
//        [[LUKeychainAccess standardKeychainAccess] setObject:accessToken forKey:@"accessToken"];
//        [[LUKeychainAccess standardKeychainAccess] setObject:refreshToken forKey:@"refreshToken"];
        
        // 処理が終了したときに実行(アクセストークンを返す)
        success(accessToken);
      }
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      // 失敗した場合
      NSError *err;
      NSData *data = [[error userInfo] objectForKey:@"com.alamofire.serialization.response.error.data"];
      if(data) {
        // エラーの中身がある場合
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
      }
      // 失敗を返す
      failure(error);
    }];
    
  } else {
    // 必須パラメータがない場合
    // TODO: エラーオブジェクトを生成して返す
    failure(nil);
  }
}

#pragma mark - token

- (void)setToken:(NSString *)token
{
  if (token) {
    [self keychain][kServiceName] = token;
  }
  else {
    [self keychain][kServiceName] = nil;
  }
}

- (NSString *)token
{
  return [self keychain][kServiceName];
}

#pragma mark - keychain

- (UICKeyChainStore *)keychain
{
  return [UICKeyChainStore keyChainStoreWithService:kServiceName];
}

- (BOOL)isLogin
{
  if ([self keychain][kServiceName]) {
    return YES;
  }
  return NO;
}

- (void)setConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
  _consumerKey = consumerKey;
  _consumerSecret = consumerSecret;
}

@end
