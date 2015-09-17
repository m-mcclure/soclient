//
//  QuestionSearchViewController.m
//  stackoverflowing
//
//  Created by Matthew McClure on 9/14/15.
//  Copyright (c) 2015 Matthew McClure. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "Question.h"
#import "DisplayQuestionViewController.h"

@interface QuestionSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self.searchBar resignFirstResponder];
  [StackOverflowService questionsForSearchTerm:self.searchBar.text completionHandler:^(NSArray *questions, NSError *error) {
    self.searchResults = questions;
    NSLog(@"%lu", (unsigned long)self.searchResults.count);
    NSLog(@"%@", self.searchResults[0]);
    
    [self.tableView reloadData];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All images have loaded"
                                                    message:@"Yep"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
      [alert show];
    
  }];
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"questionCell";
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  cell.backgroundColor = [UIColor colorWithRed:249.0/255 green:237.0/255 blue:224.0/255 alpha:1.0];
  
  int dataIndex = (int) indexPath.row % [self.searchResults count];
  Question *thisQuestion = self.searchResults[dataIndex];
  cell.textLabel.text = [NSString stringWithFormat:@"%@", [thisQuestion title]];
  NSURL *imageURL = [NSURL URLWithString:thisQuestion.avatarURL];
  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  cell.imageView.image = [UIImage imageWithData:imageData];
    return cell;
  
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Question *selectedQuestion = _searchResults[indexPath.row];
  DisplayQuestionViewController *displayQVC = [[DisplayQuestionViewController alloc] init];
  displayQVC.passedURLAsString = selectedQuestion.questionURL;
  //UINavigationController *displayQNavigationController = [[UINavigationController alloc] initWithRootViewController:displayQVC];
  [self presentViewController:displayQVC animated:true completion:nil];
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
