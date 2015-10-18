//
//  ViewController.m
//  MEGOAuth2Client
//
//  Created by Koichiro Oishi on 2015/09/27.
//  Copyright © 2015年 bs. All rights reserved.
//

#import "ViewController.h"
#import "MEGOAuth2Client.h"
#import "MEGQiitaManager.h"
#import "MEGLoginWebViewController.h"

static NSString * const kQiitaClientId = @"";
//Client Secret
static NSString * const kQiitaClientSecret = @"";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)tappedButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSString *token = [MEGQiitaManager sharedInstance].token;
  NSLog(@"%@",token);

  if (token) {
    self.label.text = @"OK";
  }
  else {
    self.label.text = @"NO";
  }

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)tappedButton:(id)sender
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQiitaOAuthLoginView:) name:kMEGAOauthLoginStartNotification object:nil];
  [[MEGQiitaManager sharedInstance] setConsumerKey:kQiitaClientId consumerSecret:kQiitaClientSecret];
  [[MEGQiitaManager sharedInstance] logout];
  [[MEGQiitaManager sharedInstance] authorizeWithSuccess:^{
    NSLog(@"成功したぽいです");
  } failure:^(NSError *error) {
    NSLog(@"失敗したぽいです");
  }];
}

-(void)showQiitaOAuthLoginView:(NSNotification *)notification
{
  // Notification削除
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kMEGAOauthLoginStartNotification object:nil];

  // 認証ビューコントローラー準備
  NSURLRequest *req = (NSURLRequest *)notification.object;
  MEGLoginWebViewController *viewController = [[MEGLoginWebViewController alloc] initWithAuthorizationRequest:req];

  // ナビゲーションコントローラー準備、画面遷移
  UINavigationController *navigationController = [[UINavigationController alloc] init];
  navigationController.viewControllers = @[viewController];
  [self presentViewController:navigationController animated:YES completion:nil];
}

@end
