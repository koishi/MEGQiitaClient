//
//  AuthenticatedUserEntity.m
//  FasterThanZaim
//
//  Created by bs on 2014/10/19.
//  Copyright (c) 2014年 Koichiro Oishi. All rights reserved.
//

#import "AuthenticatedUserEntity.h"

@implementation AuthenticatedUserEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.id forKey:@"id"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    self.id = [aDecoder decodeObjectForKey:@"id"];
  }
  return self;
}

@end
