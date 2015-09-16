//
//  QuestionJSONParser.h
//  stackoverflowing
//
//  Created by Matthew McClure on 9/15/15.
//  Copyright (c) 2015 Matthew McClure. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionJSONParser : NSObject
+(NSArray *)questionsResultsFromJSON:(NSDictionary *)jsonInfo;
@end
