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
    [self customizeView];
    // Do any additional setup after loading the view from its nib.
}

-(void)customizeView {
    _textViewInfo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
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
    

    [self.view removeFromSuperview];
    [self didMoveToParentViewController:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
