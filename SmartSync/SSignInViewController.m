//
//  SSignInViewController.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSignInViewController.h"
#import "SSyncViewController.h"
#import "SServerRequest.h"
#import "SSContact.h"
#import <AddressBook/AddressBook.h>
#import "UIColor+FlatUI.h"
#import "SBJson.h"
#import "SServerUpload.h"
#import "SSAppDelegate.h"
#import "FXBlurView.h"
#import "SSInfoViewController.h"


#define tagForgot 100


@interface SSignInViewController ()
{
    IBOutlet UILabel *labelEula;
    IBOutlet UILabel *registerLabel;
    UITextField* forgotField;
    NSNumber *contactsCount;
    SSyncViewController *syncVC;
    SSContact *ssContact;
    UITapGestureRecognizer *tapGesture;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    BOOL fieldIsUp;
}
@end

@implementation SSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ssContact = [[SSContact alloc]init];
    [self customizeView];
    [self addTouchToLabel:registerLabel];
    [activityIndicator setHidden:YES];
    [_loginView setHidden:NO];
    [self animateLoginView:_loginView];
    fieldIsUp = NO;
    NSLog(@"SCREEn H : %f",SCREEN_HEIGHT);
    
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgotPressed)];
    [_labelForgot addGestureRecognizer:tapGest];
    
    if (SCREEN_HEIGHT == 568) {
        [_imageViewBack setImage:[UIImage imageNamed:@"Default-568h.png"]];
    }
    else {
        [_imageViewBack setFrame:[UIScreen mainScreen].bounds];
        [_imageViewBack setImage:[UIImage imageNamed:@"Default.png"]];
    }
    [self addLocalization];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translate) name:@"logoutPressed" object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self translate];

    [super viewWillAppear:animated];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



-(void)customizeView
{
    //self.view.backgroundColor = superBlue;
    //self.view.backgroundColor = [UIColor colorWithRed:21/255.0f green:22/255.0f blue:27/255.0f alpha:1];
    UIColor* whiteColor = [UIColor whiteColor];
    _textFieldEmail.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[appDelegate languageSelectedStringForKey:@"email"]
                                                                           attributes:@{NSForegroundColorAttributeName: whiteColor}];
    _textFieldPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[appDelegate languageSelectedStringForKey:@"password"]
                                                                              attributes:@{NSForegroundColorAttributeName: whiteColor}];
    [_textFieldEmail setBackground:[UIImage imageNamed:@"Email_field"]];
    [_textFieldPassword setBackground:[UIImage imageNamed:@"Password_field"]];

    UITapGestureRecognizer* tapFAQ = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoButtonPressed:)];
    UITapGestureRecognizer* tapEULA = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openEULA)];
    
    _labelFAQ.userInteractionEnabled = YES;
    labelEula.userInteractionEnabled = YES;
    [_labelFAQ addGestureRecognizer:tapFAQ];
    [labelEula addGestureRecognizer:tapEULA];

    for (UIButton *button in _loginView.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = LOGIN_BUTTON_COLOR;
            button.layer.cornerRadius = 20.0;
            //button.layer.borderWidth = 1.0;
            //button.layer.borderColor = [UIColor whiteColor].CGColor;
            [button.titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
            button.titleLabel.textColor = [UIColor whiteColor];
        }
    }
    
    [registerLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
    registerLabel.backgroundColor = LOGIN_BUTTON_COLOR;
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.layer.cornerRadius = 20.0;
    registerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    registerLabel.numberOfLines = 1;
//    titleLabel.numberOfLines = 2;
//    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    
    for (UITextField *field in _loginView.subviews)
    {
        if ([field isKindOfClass:[UITextField class]])
        {
            field.layer.borderWidth = 1.0;
            field.layer.borderColor = [UIColor whiteColor].CGColor;
            field.backgroundColor = [UIColor clearColor];
            field.textColor = [UIColor whiteColor];
            field.layer.cornerRadius = 20.0;

        }
    }
}


-(void)addLocalization
{
    _sigInButton.titleLabel.text = NSLocalizedString(@"LOGIN", nil);
    registerLabel.text = NSLocalizedString(@"REGISTER", nil);
    _labelForgot.text = NSLocalizedString(@"Forgot password ?", nil);
    _textFieldEmail.placeholder = NSLocalizedString(@"email", nil);
    _textFieldPassword.placeholder = NSLocalizedString(@"password", nil);
}

-(void)translate
{
    [registerLabel setText:[appDelegate languageSelectedStringForKey:@"REGISTER"]];
    [_labelForgot setText:[appDelegate languageSelectedStringForKey:@"Forgot password ?"]];
    [_sigInButton setTitle:[appDelegate languageSelectedStringForKey:@"LOGIN"] forState:UIControlStateNormal];
    _textFieldEmail.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[appDelegate languageSelectedStringForKey:@"email"]
                                                                           attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _textFieldPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[appDelegate languageSelectedStringForKey:@"password"]
                                                                              attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
}

-(void)addTouchToLabel:(UILabel*)label
{
    tapGesture = [[UITapGestureRecognizer alloc]init];
    [tapGesture addTarget:self action:@selector(goToRegisterScreen:)];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:tapGesture];
}

//login button action
- (IBAction)goToMainScreen:(UIButton *)sender
{
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    
    [_textFieldEmail resignFirstResponder];
    [_textFieldPassword resignFirstResponder];

    [appDelegate.credentials setEmail:_textFieldEmail.text];
    [appDelegate.credentials setPassword:_textFieldPassword.text];
    
    [self saveLoginSession];

    if ([SSAppDelegate isNetwork] == YES) {
        [NSThread detachNewThreadSelector:@selector(beginLogin) toTarget:self withObject:nil];

    }
    else if ([SSAppDelegate isNetwork]==NO) {
        NSString* noInternet = [appDelegate languageSelectedStringForKey:@"No Internet connection"];
        
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(noInternet,nil) andTitle:nil];
        [activityIndicator setHidden:YES];

    }
}


-(void)saveLoginSession
{
    if ([SSAppDelegate isNetwork] == NO) {
        return;
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:appDelegate.credentials.email forKey:@"email"];
    [userDefaults setValue:appDelegate.credentials.password     forKey:@"password"];
    [userDefaults synchronize];
    
}


-(void)beginLogin
{
    SServerUpload *serverUpload = appDelegate.serverUpload;
    
    [serverUpload uploadDataToServer:[appDelegate.credentials getAccountObject] urlToSend:LOGIN_URL];
    
}


-(void)requestPermissions
{
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        NSString* message = [appDelegate languageSelectedStringForKey:@"SyncSmart does not have permissions to use your contacts, check Settings->Privacy"];
        NSString* title = [appDelegate languageSelectedStringForKey:@"Sorry"];
        
        [SSAppDelegate showAlertWithMessage:message andTitle:title];
    }

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion([SSContact getBook], ^(bool granted, CFErrorRef error) {
            if (granted == YES)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [self presentSyncVC];
                               });
            }
            else if (granted == NO)
            {
                NSString* message = [appDelegate languageSelectedStringForKey:@"SyncSmart needs your permission to use the contacts before continuing,go to Settings -> Privacy -> Contacts"];
                NSString* title = [appDelegate languageSelectedStringForKey:@"Sorry"];
                
                [SSAppDelegate showAlertWithMessage:message andTitle:title];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        [self presentSyncVC];
    }
}


-(NSString*)getLoginObject
{
    NSString *email = _textFieldEmail.text;
    NSString *password = _textFieldPassword.text;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:email forKey:@"email"];
    [dict setValue:password forKey:@"password"];
    
    NSString *loginStr = [dict JSONRepresentation];
    
    return loginStr;
}

-(void)animateLoginView:(UIView*)view
{
    CGRect newFrame = view.frame;
    
    newFrame.origin.y = newFrame.origin.y + 200 + _textFieldEmail.frame.size.height;
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.frame = newFrame;
                     }

                     completion:^(BOOL finished)
                     {
//                         [titleLabel setHidden:NO];
//                         [self animateView:titleLabel withTransitionType:kCATransitionFade andSubType:nil];
                         [registerLabel setHidden:NO];
                         [self animateView:registerLabel withTransitionType:kCATransitionFade andSubType:nil];

                     }];

}

-(void)presentSyncVC
{
    
    syncVC = appDelegate.syncVC;
    [self addChildViewController:syncVC];
    [syncVC didMoveToParentViewController:self];
    
    [self animateView:self.view withTransitionType:kCATransitionReveal andSubType:kCATransitionFromBottom];
    [self.view addSubview:syncVC.view];

}

- (void)goToRegisterScreen:(UIButton *)sender
{
   
    _registerVC = [[SSRegisterViewController alloc]initWithNibName:@"SSRegisterViewController" bundle:nil];

    [self presentViewController:_registerVC animated:YES completion:nil];
}


- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self.view endEditing:YES];

    SSInfoViewController* infoVC = [[SSInfoViewController alloc]initWithNibName:@"SSInfoViewController" bundle:nil];
    
    [self presentViewController:infoVC animated:YES completion:nil];
    
}




-(void)forgotPressed
{
    NSString* title = [appDelegate languageSelectedStringForKey:@"Please enter your e-mail address so we can reset your password"];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,nil) message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    myAlertView.tag = tagForgot;
    forgotField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];

    [forgotField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:forgotField];
    [myAlertView show];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    CGRect newFrame = _loginView.frame;
    
    newFrame.origin.y = newFrame.origin.y - 115;
    
    
    if (fieldIsUp == NO && _textFieldEmail.backgroundColor != [UIColor blackColor]) {
        
         [UIView animateWithDuration:0.2
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^{
                         _loginView.frame = newFrame;
                     }
     
                     completion:^(BOOL finished)
                    {
                        [_textFieldEmail setBackgroundColor:[UIColor blackColor]];
                        [_textFieldPassword setBackgroundColor:[UIColor blackColor]];
                           fieldIsUp = YES;
                    }];
    }
//    _fieldIsUp = YES;
   
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (fieldIsUp == YES) {
        [_textFieldEmail setBackgroundColor:[UIColor clearColor]];
        [_textFieldPassword setBackgroundColor:[UIColor clearColor]];
        
        CGRect newFrame = _loginView.frame;
        
        newFrame.origin.y = newFrame.origin.y + 115;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _loginView.frame = newFrame;
                         }
         
                         completion:^(BOOL finished)
         {
             
         }];
        fieldIsUp = NO;
        
    }
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    appDelegate.credentials.email = _textFieldEmail.text;
    appDelegate.credentials.password = _textFieldPassword.text;
    
    [appDelegate.syncVC.labelAccount setText:_textFieldEmail.text];
}


-(void)animateView:(UIView*)view withTransitionType:(NSString*)type andSubType:(NSString*)subType
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = type;
    transition.subtype = subType;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [view.layer addAnimation:transition forKey:@"0shel"];
}

-(UIActivityIndicatorView*)getIndicator
{
    return activityIndicator;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == tagForgot)
    {
        
    NSMutableDictionary* jsonDict = [[NSMutableDictionary alloc]init];
        NSString* dictValue = [alertView textFieldAtIndex:0].text;
    [jsonDict setValue:dictValue forKey:@"email"];
    NSString* recoverStr = [jsonDict JSONRepresentation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       [appDelegate.serverUpload uploadRecoverString:recoverStr toURL:ACCOUNT_URL];
                   });
    }
}


// social actions
- (void)openEULA {
    [self openURL:@"http://syncsmart.ftsapps.com/terms-and-conditions.html"];
}

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
