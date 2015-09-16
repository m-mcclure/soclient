//
//  DisplayQuestionViewController.m
//  stackoverflowing
//
//  Created by Matthew McClure on 9/16/15.
//  Copyright (c) 2015 Matthew McClure. All rights reserved.
//

#import "DisplayQuestionViewController.h"
#import <WebKit/WebKit.h>

@interface DisplayQuestionViewController ()



@end

@implementation DisplayQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  NSLog(@"%@", self.passedURLAsString);
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.passedURLAsString]]];
  //didn't work:
  //[self.navigationController popViewControllerAnimated:YES];
 
  //[backButton release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
