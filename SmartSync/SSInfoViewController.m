//
//  SSInfoViewController.m
//  SmartSync
//
//  Created by dragos on 4/1/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSInfoViewController.h"
#import "SSAppDelegate.h"

@interface SSInfoViewController ()

@end

@implementation SSInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self customizeView];
    [self localize];
    // Do any additional setup after loading the view from its nib.
}


-(void)localize
{
    _textViewInfo.text = [appDelegate languageSelectedStringForKey:@"Hello ! \nSyncSmartFTS is an easy to use app which can backup your contacts in the cloud and also provides you with the option to transfer/move all of your contacts on different smartphones.\n 1) Create account .\n2) Sign In .\n3) Save your contacts .\n4) Now just sign in from another device and import your contacts.That smart, that simple !! \nTotal count of contacts may be different than the one showed on your phone , depending on what contacts you have selected to be displayed in your contacts app. ! SyncSmartFTS does not take into consideration empty contacts, contact avatars , dates of any kind, addresses , notes and social profile."];
    _textViewInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    _textViewInfo.textColor = [UIColor whiteColor];
    
    [_btnBack setTitle:[appDelegate languageSelectedStringForKey:@"Back"] forState:UIControlStateNormal];
    
}

-(void)customizeView {
    _textViewInfo.text = NSLocalizedString(@"Hello ! \nSyncSmartFTS is an easy to use app which can backup your contacts in the cloud and also provides you with the option to transfer/move all of your contacts on different smartphones.\n 1) Create account .\n2) Sign In .\n3) Save your contacts .\n4) Now just sign in from another device and import your contacts.That smart, that simple !! \nTotal count of contacts may be different than the one showed on your phone , depending on what contacts you have selected to be displayed in your contacts app. ! SyncSmartFTS does not take into consideration empty contacts, contact avatars , dates of any kind, addresses , notes and social profile.", nil);
    _textViewInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    _textViewInfo.textColor = [UIColor whiteColor];
}



- (IBAction)dismissVC:(id)sender
{
//    CGRect newFrame = appDelegate.signInVC.loginView.frame;
//    
//    newFrame.origin.y = newFrame.origin.y - 100;
//    
//  if (appDelegate.signInVC.fieldIsUp == NO && appDelegate.signInVC.didShowInfo == YES)  [UIView animateWithDuration:0.3
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         appDelegate.signInVC.loginView.frame = newFrame;
//                     }
//     
//                     completion:^(BOOL finished)
//     {
//         appDelegate.signInVC.fieldIsUp = YES;
//
//     }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.view removeFromSuperview];
//    [self didMoveToParentViewController:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
