//
//  SSRegisterViewController.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//
#import "SSAppDelegate.h"
#import "SSRegisterViewController.h"
#import "UIColor+FlatUI.h"
#import "SBJson.h"
#import "SServerUpload.h"
#import "SSCredentials.h"
#import "GPGuardPost.h"


@interface SSRegisterViewController ()
{
    SSCredentials *credentials;
}
@end

@implementation SSRegisterViewController

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
    
    credentials = appDelegate.credentials;

    [self customizeView];
}




- (IBAction)accountAction:(UIButton *)sender
{
    [_activity startAnimating];
 if ([SSAppDelegate isNetwork]==NO) {
        [SSAppDelegate showAlertWithMessage:@"No Internet connection" andTitle:nil];
     [_activity stopAnimating];
     return;
}
    
    [GPGuardPost validateAddress:_emailTextField.text
                         success:^(BOOL validity, NSString* suggestion) {
                             if (validity)
                             {
                                 [self createAccount];
                                 [_activity stopAnimating];
                             }
                             else {
                                 [SSAppDelegate showAlertWithMessage:@"Please use a valid email " andTitle:@"Oh no"];
                                 [_activity stopAnimating];
                             }
                         }
                         failure:^(NSError* error) {
                             [_activity stopAnimating];
    }];
    
    
}

-(void)createAccount
{
    NSString *accountObject = [credentials getAccountObject];
    SServerUpload *serverUpload = appDelegate.serverUpload;
    [serverUpload uploadStringToServer:accountObject urlToSend:ACCOUNT_URL];

}

-(void)customizeView
{
    self.view.backgroundColor = BACK_COLOR;

    [_accountButton setBackgroundColor:[UIColor clearColor]];
    [_accountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _accountButton.layer.cornerRadius = 6.0;
    _accountButton.layer.borderWidth = 1.0;
    _accountButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_accountButton.titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
   
    [_titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
    //_titleLabel.textColor = [UIColor colorWithRed:212/255.0 green:0/255.0 blue:28/255.0 alpha:1];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    
    for (UITextField *field in self.view.subviews)
    {
        if ([field isKindOfClass:[UITextField class]])
        {
            field.layer.borderWidth = 1.0;
            field.layer.borderColor = BLUE_COLOR.CGColor;
            field.backgroundColor = [UIColor clearColor];
//            field.layer.cornerRadius = 6.0;
        }
    }
}

- (IBAction)goBack:(UIBarButtonItem *)sender
{
//    [self.view removeFromSuperview];
//    [self animateView:self.parentViewController.view];
//    [self didMoveToParentViewController:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    credentials.email = _emailTextField.text;
    credentials.password = _passwordTextField.text;
    if (textField == _repeatTextField)
    {
        if (![_repeatTextField.text isEqualToString:_passwordTextField.text])
        {
            [SSAppDelegate showAlertWithMessage:@"Please insert same password in both fields" andTitle:nil];
        }
    }
}



-(void)animateView:(UIView*)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [view.layer addAnimation:transition forKey:@"tralala"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
