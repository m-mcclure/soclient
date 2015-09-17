//
//  StackOverflowService.m
//  StackOverflow
//
//  Created by Bradley Johnson on 9/15/15.
//  Copyright (c) 2015 Code Fellows. All rights reserved.
//

#import "StackOverflowService.h"
#import <AFNetworking/AFNetworking.h>
#import "Errors.h"
#import "Question.h"
#import "QuestionJSONParser.h"
#import "AppUser.h"
#import "AppUserJSONParser.h"

@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError*))completionHandler {
  //m8lVvZ3OXiBW82JgM5kdWw((
  NSString *key = @"m8lVvZ3OXiBW82JgM5kdWw((";
  NSString *savedToken = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"token"];
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?key=%@&access_token=%@&order=desc&sort=activity&intitle=%@&site=stackoverflow", key, savedToken, searchTerm];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //    NSLog(@"%ld",operation.response.statusCode);
    //    NSLog(@"%@",responseObject);
    
    NSArray *questions = [QuestionJSONParser questionsResultsFromJSON:responseObject];
    
    NSLog(@"***number of Qs returned: %lu", (unsigned long)questions.count);
    NSLog(@"first Q link %@", [questions[0] questionURL]);
    
    completionHandler(questions,nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,stackOverflowError);
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
        completionHandler(nil, reachabilityError);
      }
    }
  }];
}

+(NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection"}];
    return error;
  }
  return nil;
}

+(NSError *)errorForStatusCode:(NSInteger)statusCode {
  
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 502:
      localizedDescription = @"Too many requests, please slow down";
      errorCode = StackOverFlowTooManyAttempts;
      break;
    case 400:
      localizedDescription = @"Invalid search term, try another search";
      errorCode = StackOverFlowInvalidParameter;
      break;
    case 401:
      localizedDescription = @"You must sign in to access this feature";
      errorCode = StackOverFlowNeedAuthentication;
      break;
    default:
      localizedDescription = @"Could not complete operation, please try again later";
      errorCode = StackOverFlowGeneralError;
      break;
  }
  NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
}

+ (void)getAppUserCompletionHandler:(void(^)(AppUser *, NSError*))completionHandler {
  NSString *key = @"m8lVvZ3OXiBW82JgM5kdWw((";
  NSString *savedToken = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"token"];
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/me?key=%@&access_token=%@&order=desc&sort=reputation&site=stackoverflow", key, savedToken];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //    NSLog(@"%ld",operation.response.statusCode);
    //    NSLog(@"%@",responseObject);
    
    AppUser *appUser = [AppUserJSONParser appUserInfoFromJSON:responseObject];
//    
//    NSLog(@"***number of Qs returned: %lu", (unsigned long)questions.count);
//    NSLog(@"first Q link %@", [questions[0] questionURL]);
    
    completionHandler(appUser,nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,stackOverflowError);
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
        completionHandler(nil, reachabilityError);
      }
    }
  }];
}


@end
