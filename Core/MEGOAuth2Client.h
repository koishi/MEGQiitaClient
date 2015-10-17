//
//  MEGOAuth2Client.h
//  MEGOAuth2Client
//
//  Created by bs on 2015/09/27.
//  Copyright © 2015年 bs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEGOAuth2Client : NSObject

/// シングルトンのインスタンス取得
+ (MEGOAuth2Client *)sharedInstance;

/**
 OAuth2.0認証に必要なリクエストを生成する処理
 @param withPreparedAuthorizationURLHandler OAuth2.0認証に必要なリクエストを返すBlock構文
 */
- (void)requestAccessToAccount:(void (^)(NSURL *preparedURL))withPreparedAuthorizationURLHandler;

/**
 OAuth2.0 認証のリダイレクトURIの一致を確認
 @param request リクエスト
 @return リダイレクトURIの一致の有無
 */
- (BOOL)checkRedirectURI:(NSURLRequest *)request;

/**
 アクセストークンを取得する処理
 @param request アクセストークンの取得に必要なリクエスト
 @param completionHandler アクセストークンの取得処理が完了したら実行される処理
 */
- (void)getAccessToken:(NSURLRequest *)request
     completionHandler:(void (^)(NSString *accessToken))completionHandler
               failure:(void (^)(NSError *error))failure;

/**
 リフレッシュトークンから新しいアクセストークンを取得する処理
 @param success 処理が成功した場合に実行(返却データはアクセストークン)
 @param failure 処理が失敗した場合に実行(返却データはエラーオブジェクト)
 */
- (void)getRefreshAccessToken:(void (^)(NSString *accessToken))success
                      failure:(void (^)(NSError *error))failure;

@property (nonatomic, strong) NSString *token;

- (BOOL)isLogin;

// コンシューマキーのセット
- (void)setConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

extern NSString * const kMEGAOauthLoginStartNotification;
extern NSString * const kMEGAOauthLoginFinishNotification;
extern NSString * const kMEGApplicationLaunchOptionsURLKey;

- (NSURL*)requestUrl;

@end
