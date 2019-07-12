//
//  ProfileViewController.m
//  Instagram
//
//  Created by mariobaxter on 7/9/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCollectionCell.h"
#import "Parse/PFQuery.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat imagesPerLine = 3;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing*(imagesPerLine - 1)) / imagesPerLine;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    [self.collectionView setCollectionViewLayout:layout animated:NO];
    
    [self updateTable];
    
    self.navigationItem.title = [NSString stringWithFormat:@"@%@", [PFUser currentUser].username];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    PFFileObject *imageFile = [PFUser currentUser][@"profilePic"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [self.profilePicture setImage:image];
        }
    }];
}

- (void)updateTable {
    // Get the latest 18 posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    NSLog(@"%@", [PFUser currentUser].username);
    [query whereKey:@"author" containsString:[PFUser currentUser].objectId];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 18;
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        NSLog(@"GOT HEREEEE!");
        if (posts != nil) {
            // do something with the array of objects returned by the call
            NSLog(@"%@", posts[0]);
            self.posts = [NSMutableArray arrayWithArray:posts];
            [self.postCountLabel setText:[NSString stringWithFormat:@"%lu", posts.count]];
            [self.collectionView reloadData];
            //[self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:post.image.url];
    [cell.image setImageWithURL:imageURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
