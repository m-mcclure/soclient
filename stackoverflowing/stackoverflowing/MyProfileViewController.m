//
//  MyProfileViewController.m
//  stackoverflowing
//
//  Created by Matthew McClure on 9/15/15.
//  Copyright (c) 2015 Matthew McClure. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverflowService.h"
#import "AppUser.h"

@interface MyProfileViewController ()

@property (strong,nonatomic) AppUser *thisAppsUser;
@property (assign, nonatomic) IBOutlet UIImageView *profileImage;
@property (assign, nonatomic) IBOutlet UILabel *displayName;
@property (assign, nonatomic) IBOutlet UILabel *reputationLabel;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [StackOverflowService getAppUserCompletionHandler:^(AppUser *appUser, NSError *error) {
    self.thisAppsUser = appUser;
    NSLog(@"YO %@", self.thisAppsUser.displayName);
    NSURL *imageURL = [NSURL URLWithString:appUser.avatarURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.profileImage.image = [UIImage imageWithData:imageData];
    self.displayName.text = appUser.displayName;
//    NSString *numAsString = [appUser.reputation stringValue];
    self.reputationLabel.text = [NSString stringWithFormat: @"StackOverflow Reputation: %@", [appUser.reputation stringValue]];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
