//
//  IdeaViewController.h
//  Polls
//
//  Created by Anirban on 5/15/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *IdeaTableView;
@property NSString *LevelID;
@end
