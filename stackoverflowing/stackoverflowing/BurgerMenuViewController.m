//
//  BurgerMenuViewController.m
//  StackOverflow
//
//  Created by  on 9/14/15.
//  Copyright (c) 2015 Code Fellows. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "MyProfileViewController.h"
#import "WebViewController.h"
#import "Errors.h"

CGFloat const kburgerOpenScreenDivider = 3.0;
CGFloat const kburgerOpenScreenMultiplier = 2.0;
NSTimeInterval const ktimeToSlideMenuOpen = 0.3;
CGFloat const kburgerButtonWidth = 50.0;
CGFloat const kburgerButtonHeight = 50.0;

@interface BurgerMenuViewController () <UITableViewDelegate, UIWebViewDelegate>

@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) UIButton *burgerButton;
@property (strong,nonatomic) UIPanGestureRecognizer *pan;
@property (strong,nonatomic) NSArray *viewControllers;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSError *error;
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:path];
  
  id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  
  if (error) {
    NSLog(@"domain: %@ code:%ld",error.domain,(long)error.code);
    NSError *myError = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowBadJSON userInfo:nil];
  }
  
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  mainMenuVC.tableView.delegate = self;
  
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearch"];
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  MyProfileViewController *myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile"];
  self.viewControllers = @[questionSearchVC,myQuestionsVC, myProfileVC];
  
  /* not sure how to do this
  UINavigationController *displayQNavigationController = [[UINavigationController alloc] initWithRootViewController:questionSearchVC];
  [self addChildViewController:displayQNavigationController];
  displayQNavigationController.view.frame = self.view.frame;
  [self.view addSubview:displayQNavigationController.view];
  [displayQNavigationController didMoveToParentViewController:self];
  self.topViewController = displayQNavigationController;
  */
  
   [self addChildViewController:questionSearchVC];
   questionSearchVC.view.frame = self.view.frame;
   [self.view addSubview:questionSearchVC.view];
   [questionSearchVC didMoveToParentViewController:self];
   self.topViewController = questionSearchVC;
  
  UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kburgerButtonWidth, kburgerButtonHeight)];
  [burgerButton setImage:[UIImage imageNamed:@"burgerKing"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview:burgerButton];
  [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = burgerButton;
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:pan];
  self.pan = pan;
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSString *savedToken = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"token"];
  if (savedToken == nil) {
    WebViewController *webVC = [[WebViewController alloc] init];
    [self presentViewController:webVC animated:true completion:nil];
  }
}

-(void)burgerButtonPressed:(UIButton *)sender {
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
    
  }];
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
  
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
  
  if (sender.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded) {
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kburgerOpenScreenDivider) {
      NSLog(@"user is opening menu");
      
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
        
      }];
    } else {
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
      }];
    }
  }
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
    
  }];
}

-(void)switchToViewController:(UIViewController *)newVC{
  [UIView animateWithDuration:0.3 animations:^{
    
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width,self.topViewController.view.frame.origin.y,self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    
  } completion:^(BOOL finished) {
    CGRect oldFrame = self.topViewController.view.frame;
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
    }];
  }];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%ld",(long)indexPath.row);
  
  UIViewController *newVC = self.viewControllers[indexPath.row];
  if (![newVC isEqual:self.topViewController]) {
    [self switchToViewController:newVC];
  }
  
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
