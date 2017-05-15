//
//  ViewController.m
//  Polls
//
//  Created by Anirban on 5/8/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MBProgressHUD.h"
#import "LevelsViewController.h"

@interface LoginViewController ()
@property NSMutableData *responseData;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}
- (IBAction)fbLoginClicked:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [self getUserDetails];
         }
     }];

}

-(void)getUserDetails
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,email,name,picture.type(large)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 FBID=result[@"id"];
                 Email=result[@"email"];
                 Name=result[@"name"];
                 PicLink=((result[@"picture"])[@"data"])[@"url"];
                 NSMutableURLRequest *request =
                 [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-187-137-62.us-west-2.compute.amazonaws.com:8000/polls/login"]];
                 [request setHTTPMethod:@"POST"];
                 NSString *parameter = [NSString stringWithFormat:@"email=%@&name=%@&fbid=%@&link=%@",Email,Name,FBID,PicLink];
                 [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
                 
                 NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
             }
         }];
    }
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
            UserID=[json valueForKey:@"userid"];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Congrats"
                                         message:@"You have successfully logged in"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            LevelsViewController *o=[self.storyboard instantiateViewControllerWithIdentifier:@"LevelsViewController"];
                                            [self.navigationController pushViewController:o animated:YES];
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
