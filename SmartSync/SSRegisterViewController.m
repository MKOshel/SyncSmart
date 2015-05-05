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
    
    [self addLocalization];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self translate];
    [super viewWillAppear:animated];
    
}

-(void)translate
{
    _titleLabel.text = [appDelegate languageSelectedStringForKey:@"Please enter your credentials"];
    [_accountButton setTitle:[appDelegate languageSelectedStringForKey:@"Create Account"] forState:UIControlStateNormal];
//    _repeatTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:
//                                              [appDelegate  languageSelectedStringForKey:@"confirm password"]
//                                                                            attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (IBAction)accountAction:(UIButton *)sender
{
    [_activity startAnimating];
 if ([SSAppDelegate isNetwork]==NO) {
     NSString* message = [appDelegate languageSelectedStringForKey:@"No Internet connection"];
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(message,nil) andTitle:nil];
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
                                 NSString* message = [appDelegate languageSelectedStringForKey:@"Please use a valid email"];
                                 [SSAppDelegate showAlertWithMessage:NSLocalizedString(message,nil) andTitle:nil];
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
    //self.view.backgroundColor = BACK_COLOR;

//    UIColor* whiteColor = [UIColor whiteColor];
//    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"email"
//                                                                           attributes:@{NSForegroundColorAttributeName: whiteColor}];
//    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"password"
//                                                                              attributes:@{NSForegroundColorAttributeName: whiteColor}];
//    _repeatTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:
//                                              [appDelegate  languageSelectedStringForKey:@"confirm password"]
//                                                                            attributes:@{NSForegroundColorAttributeName: whiteColor}];
    
    [_emailTextField setBackground:[UIImage imageNamed:@"Email_field"]];
    [_passwordTextField setBackground:[UIImage imageNamed:@"Password_field"]];
    [_repeatTextField setBackground:[UIImage imageNamed:@"Password_field"]];


    [_accountButton setBackgroundColor:LOGIN_BUTTON_COLOR];
    [_accountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _accountButton.layer.cornerRadius = 15.0;
    [_accountButton.titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
   
    [_titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    
    for (UITextField *field in self.view.subviews)
    {
        if ([field isKindOfClass:[UITextField class]])
        {
            //field.layer.borderWidth = 1.0;
            //field.layer.borderColor = [UIColor whiteColor].CGColor;
            field.backgroundColor = [UIColor clearColor];
            field.layer.cornerRadius = 15.0;
        }
    }

}


-(void)addLocalization
{
    _titleLabel.text = NSLocalizedString(@"Please enter your credentials",nil);
    //_repeatTextField.placeholder = NSLocalizedString(@"confirm password", nil);
    _accountButton.titleLabel.text = NSLocalizedString(@"Create Account",nil);
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
            [SSAppDelegate showAlertWithMessage:NSLocalizedString(@"Please insert same password in both fields",nil) andTitle:nil];
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


#pragma mark Account created
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    appDelegate.signInVC.textFieldEmail.text = credentials.email;
    appDelegate.signInVC.textFieldPassword.text = credentials.password;
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

// social actions
- (IBAction)openFacebookPage:(UIButton *)sender {
    
    [self openURL:@"https://www.facebook.com/SyncSmartFTS?fref=ts"];
}

- (IBAction)openTweeterPage:(UIButton *)sender {
    [self openURL:@"https://twitter.com/search?q=syncsmart&src=typd"];
}

- (IBAction)openVimeoPage:(UIButton *)sender {
    [self openURL:@"https://vimeo.com/103842460"];
}


- (IBAction)openYoutubePage:(UIButton *)sender{
    [self openURL:@"https://www.youtube.com/watch?v=1jwIMV3QwFA"];
}

-(void)openURL:(NSString*)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
