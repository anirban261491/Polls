//
//  IdeaViewController.m
//  Polls
//
//  Created by Anirban on 5/15/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import "IdeaViewController.h"
#import "MBProgressHUD.h"
#import "IdeaTableViewCell.h"

@interface IdeaViewController ()
{
    NSMutableArray *Ideas;
}
@property NSMutableData *responseData;
@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.IdeaTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-187-137-62.us-west-2.compute.amazonaws.com:8000/polls/getIdeasByLevelIDAndUserID"]];
    NSString *parameter = [NSString stringWithFormat:@"userid=%@&levelid=%@",UserID,_LevelID];
    [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *error;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData: _responseData options: NSJSONReadingMutableContainers error: &error];
    NSString *status=[json valueForKey:@"status"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(error)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Sorry"
                                     message:@"There are some issues with our servers. Please try again later"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if([status isEqualToString:@"1"])
        {
            Ideas=[json valueForKey:@"Ideas"];
            [_IdeaTableView reloadData];
        }
        else
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:[json valueForKey:@"message"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"No network connectivity!"
                                 message:@"Please check your internet connection and try again"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Ideas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"IdeaTableViewCell";
    
    IdeaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[IdeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.IdeaDescLabel.text = [[Ideas objectAtIndex:indexPath.row] valueForKey:@"IdeaContent"];
    cell.TagsLabel.text = [[Ideas objectAtIndex:indexPath.row] valueForKey:@"Tags"];
    if([[[Ideas objectAtIndex:indexPath.row] valueForKey:@"UpvoteByUser"] isEqualToString:@"1"])
    {
        cell.UpvoteLabel.textColor=[UIColor colorWithRed:8.0/255.0 green:150.0/255.0 blue:196.0/255.0 alpha:1];
        cell.UpvoteImageView.image=[UIImage imageNamed:@"upvoteactive.png"];
    }
    else if([[[Ideas objectAtIndex:indexPath.row] valueForKey:@"NeutralVoteByUser"] isEqualToString:@"1"])
    {
        cell.NeutralLabel.textColor=[UIColor colorWithRed:8.0/255.0 green:150.0/255.0 blue:196.0/255.0 alpha:1];
        cell.NeutralImageView.image=[UIImage imageNamed:@"neutralactive.png"];
    }
    else if([[[Ideas objectAtIndex:indexPath.row] valueForKey:@"DownvoteByUser"] isEqualToString:@"1"])
    {
        cell.DownvoteLabel.textColor=[UIColor colorWithRed:8.0/255.0 green:150.0/255.0 blue:196.0/255.0 alpha:1];
        cell.DownvoteImageVIew.image=[UIImage imageNamed:@"downvoteactive.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *LevelID=[[Levels objectAtIndex:indexPath.row] valueForKey:@"LevelID"];
//    IdeaViewController *o=[self.storyboard instantiateViewControllerWithIdentifier:@"IdeaViewController"];
//    o.LevelID=LevelID;
//    [self.navigationController pushViewController:o animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
