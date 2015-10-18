//
//  AuthenticatedUserEntity.h
//  FasterThanZaim
//
//  Created by bs on 2014/10/19.
//  Copyright (c) 2014年 Koichiro Oishi. All rights reserved.
//

#import "BaseEntity.h"

// ユーザ情報
@interface AuthenticatedUserEntity : BaseEntity <NSCoding>

@property (nonatomic) NSString *id;

//GET /api/v2/authenticated_user
//アクセストークンに紐付いたユーザを返します。
//GET /api/v2/authenticated_user HTTP/1.1
//Host: api.example.com
//HTTP/1.1 200
//Content-Type: application/json
//
//{
//  "description": "Hello, world.",
//  "facebook_id": "yaotti",
//  "followees_count": 100,
//  "followers_count": 200,
//  "github_login_name": "yaotti",
//  "id": "yaotti",
//  "items_count": 300,
//  "linkedin_id": "yaotti",
//  "location": "Tokyo, Japan",
//  "name": "Hiroshige Umino",
//  "organization": "Increments Inc",
//  "permanent_id": 1,
//  "profile_image_url": "https://si0.twimg.com/profile_images/2309761038/1ijg13pfs0dg84sk2y0h_normal.jpeg",
//  "twitter_screen_name": "yaotti",
//  "website_url": "http://yaotti.hatenablog.com",
//  "image_monthly_upload_limit": 1048576,
//  "image_monthly_upload_remaining": 524288,
//  "team_only": false
//}

@end
