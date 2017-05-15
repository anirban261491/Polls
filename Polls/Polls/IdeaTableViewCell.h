//
//  IdeaTableViewCell.h
//  Polls
//
//  Created by Anirban on 5/15/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IdeaDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *TagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UpvoteImageView;
@property (weak, nonatomic) IBOutlet UILabel *UpvoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *DownvoteImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *DownvoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *NeutralImageView;
@property (weak, nonatomic) IBOutlet UILabel *NeutralLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IdeaDescLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TagLabelHeightConstraint;

@end
