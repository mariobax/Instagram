//
//  ProfileViewController.m
//  Instagram
//
//  Created by mariobaxter on 7/9/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the title of the nav item to be the Instagram icon and put it in the middle
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1200px-Instagram_logo.svg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    imageView.frame = titleView.bounds;
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
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
