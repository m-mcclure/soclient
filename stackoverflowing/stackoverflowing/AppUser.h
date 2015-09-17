//
//  AppUser.h
//  stackoverflowing
//
//  Created by Matthew McClure on 9/17/15.
//  Copyright © 2015 Matthew McClure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUser : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPic;
@property (strong, nonatomic) NSNumber *reputation;

@end
