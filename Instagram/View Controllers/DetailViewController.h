//
//  DetailViewController.h
//  Instagram
//
//  Created by mariobaxter on 7/9/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) NSString *text;
@end

NS_ASSUME_NONNULL_END
