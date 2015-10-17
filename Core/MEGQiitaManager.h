//
//  MEGQiitaManager.h
//  MEGOAuth2Client
//
//  Created by bs on 2015/10/10.
//  Copyright © 2015年 bs. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kOauth2ClientAccountType = @"Qiita";
//redirect url
static NSString * const kOauth2ClientRedirectUrl = @"http://localhost/";
//base url
static NSString * const kOauth2ClientBaseUrl = @"https://qiita.com";
//auth url
static NSString * const kOauth2ClientAuthUrl = @"/api/v2/oauth/authorize";
//token url
static NSString * const kOauth2ClientTokenUrl = @"/api/v2/access_tokens";
//scope url
static NSString * const kOauth2ClientScope = @"read_qiita";

@interface MEGQiitaManager : NSObject

// シングルトンのインスタンス取得
+ (MEGQiitaManager *)sharedInstance;

// コンシューマキーのセット
- (void)setConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

// 認証処理
- (void)authorizeWithSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;

// ログアウト
- (void)logout;

@property (strong, nonatomic) NSString *token;

@end
