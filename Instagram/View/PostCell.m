//
//  PostCell.m
//  Instagram
//
//  Created by mariobaxter on 7/9/19.
//  Copyright © 2019 mariobaxter. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
