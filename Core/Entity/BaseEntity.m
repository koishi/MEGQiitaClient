//
//  ZaimBaseModel.m
//  FasterThanZaim
//
//  Created by bs on 2014/10/21.
//  Copyright (c) 2014年 Koichiro Oishi. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super init];
  if (self) {
    [self configureValuesWithDictionary:dictionary];
  }
  return self;
}

- (void)configureValuesWithDictionary:(NSDictionary *)dictionary
{
  for (NSString *key in dictionary) {
    
    if ([key isEqualToString:@"description"]) {
      continue;
    }
    
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
      [self setValue:dictionary[key] forKeyPath:key];
    }
  }
}

@end