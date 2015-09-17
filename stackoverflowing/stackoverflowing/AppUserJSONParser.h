//
//  AppUserJSONParser.h
//  stackoverflowing
//
//  Created by Matthew McClure on 9/17/15.
//  Copyright © 2015 Matthew McClure. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppUser;

@interface AppUserJSONParser : NSObject

+(AppUser *)appUserInfoFromJSON:(NSDictionary *)jsonInfo;

@end
