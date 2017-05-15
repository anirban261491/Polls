//
//  LevelsViewController.h
//  Polls
//
//  Created by Anirban on 5/14/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *LevelsTableView;

@end
