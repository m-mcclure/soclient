//
//  StackOverflowService.h
//  stackoverflowing
//
//  Created by Matthew McClure on 9/15/15.
//  Copyright (c) 2015 Matthew McClure. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppUser;

@interface StackOverflowService : NSObject

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError*))completionHandler;

+ (void)getAppUserCompletionHandler:(void(^)(AppUser *, NSError*))completionHandler;

@end
