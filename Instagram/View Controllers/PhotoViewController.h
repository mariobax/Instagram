//
//  PhotoViewController.h
//  Instagram
//
//  Created by mariobaxter on 7/11/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoViewControllerDelegate <NSObject>
- (void)sendImageBack:(UIImage *)image; //I am thinking my data is NSArray, you can use another object for store your information.
@end

@interface PhotoViewController : UIViewController
@property (nonatomic, weak) id<PhotoViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
