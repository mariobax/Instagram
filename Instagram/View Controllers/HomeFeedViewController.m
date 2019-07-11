//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by mariobaxter on 7/9/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "Parse/PFUser.h"
#import "Parse/PFQuery.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "InfiniteScrollActivityView.h"


@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView* loadingMoreView;
@property (nonatomic) BOOL hasLoadedEverything;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Initialize an instance of UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.hasLoadedEverything = NO;

    // Set the title of the nav item to be the Instagram icon and put it in the middle
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1200px-Instagram_logo.svg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    imageView.frame = titleView.bounds;
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
    // Set up Infinite Scroll loading indicator
    // (startX, startY, widht, height)
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
    [self updateTable];
}

- (void)updateTable {
    // Get the latest 20 posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"username"];
    
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query setLimit:20];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of objects returned by the call
            self.posts = [NSMutableArray arrayWithArray:posts];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"viewPost"]) {
        DetailViewController *vc = [segue destinationViewController];
        Post *post = (Post *)sender;
        vc.text = post.dateString;
    }
}

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:post.image.url];
    [cell.image setImageWithURL:imageURL];
    [cell.caption setText:post.caption];
    [cell.usernameButton setTitle:post.username forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"viewPost" sender:self.posts[indexPath.row]];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count; 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            [query orderByDescending:@"createdAt"];
            [query setSkip:self.posts.count];
            [query includeKey:@"author"];
            [query includeKey:@"createdAt"];
            [query includeKey:@"username"];
            [query setLimit:20];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
                if (!self.hasLoadedEverything) {
                    if (posts != nil) {
                        if (posts.count < 2) {
                            self.hasLoadedEverything = YES;
                        }
                        // do something with the array of objects returned by the call
                        [self.posts addObjectsFromArray:posts];
                        NSLog(@"%u", (unsigned) self.posts.count);
                        [self.tableView reloadData];
                        self.isMoreDataLoading = false;
                        [self.loadingMoreView stopAnimating];
                    } else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }
            }];
            [self.loadingMoreView stopAnimating];
        }
    }
}

@end
