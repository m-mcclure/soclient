//
//  AppUserJSONParser.m
//  stackoverflowing
//
//  Created by Matthew McClure on 9/17/15.
//  Copyright © 2015 Matthew McClure. All rights reserved.
//

#import "AppUserJSONParser.h"
#import "AppUser.h"

@implementation AppUserJSONParser

+(AppUser *)appUserInfoFromJSON:(NSDictionary *)jsonInfo {
  
  AppUser *user= [[AppUser alloc] init];
  
  NSArray *items = jsonInfo[@"items"];
  for(NSDictionary *item in items) {
    user.reputation = item[@"reputation"];
    user.displayName = item[@"display_name"];
    user.avatarURL = item[@"profile_image"];
  }
  
  NSLog(@"%@", user.displayName);
  return user;
}

@end
