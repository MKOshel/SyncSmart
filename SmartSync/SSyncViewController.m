//
//  SSyncViewController.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSyncViewController.h"
#import "SSContact.h"
#import <AddressBook/AddressBook.h>
#import "SServerUpload.h"
#import "UIColor+FlatUI.h"
#import "SSUpdateManager.h"
#import "SSAppDelegate.h"
#import "SSChangePasswordVC.h"


#define TAG_SEND_CONTACTS 100
#define TAG_INSTALL_CONTACTS 200

@interface SSyncViewController ()
{
    SSContact *contact;
    
    BOOL isShowing;
    UIView* shadowView;

}
@end


@implementation SSyncViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        contact = appDelegate.contact;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isShowing = NO;
    [self addLocalization];
    [self customizeView];

    [self logCredentials];
    
    _labelAccount.text = appDelegate.signInVC.textFieldEmail.text;
    _labelAccount.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    [self setCountText];
}



-(void)customizeProgressLabel
{

    _progressLabel.fillColor = [UIColor clearColor];
    _progressLabel.trackColor = trackCol;
    _progressLabel.progressColor = progressCol;
    _progressLabel.roundedCornersWidth = 10.0;
    
    _progressLabel.progressWidth = 10;
    _progressLabel.trackWidth = 10;
}



-(void)addLocalization
{
    _labelInfoPhoneContacts.text = NSLocalizedString(@"valid contacts on phone", nil);
    _labelInfoServerContacts.text = NSLocalizedString(@"contacts on server", nil);
    _buttonDelete.titleLabel.text = NSLocalizedString(@"Delete Contacts", nil);
    _buttonLogout.titleLabel.text = NSLocalizedString(@"Logout",nil);
}

-(void)setButtonsColor
{

//    [_buttonSend setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
//    [_buttonInstall setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];

}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self translate];
    
    [super viewWillAppear:animated];
}

-(void)translate
{
    NSString* sendTitle = [appDelegate languageSelectedStringForKey:@"Save To Cloud"];
    NSString* installTitle = [appDelegate languageSelectedStringForKey:@"Import Contacts"];
    
    [_buttonSend setTitle:NSLocalizedString(sendTitle,nil) forState:UIControlStateNormal];
    [_buttonInstall setTitle:NSLocalizedString(installTitle,nil) forState:UIControlStateNormal];
    
    _labelInfoPhoneContacts.text = [appDelegate languageSelectedStringForKey:@"valid contacts on phone"];
    _labelInfoServerContacts.text = [appDelegate languageSelectedStringForKey:@"contacts on server"];
    
    [_buttonDelete setTitle:[appDelegate languageSelectedStringForKey:@"Delete Contacts"] forState:UIControlStateNormal];
    [_buttonLogout setTitle:[appDelegate languageSelectedStringForKey:@"Logout"] forState:UIControlStateNormal];
    [_btnLanguage setTitle:[appDelegate languageSelectedStringForKey:@"Select Language"] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setButtonsColor];
   
}



-(void)logCredentials
{
    NSLog(@"%@",appDelegate.credentials.email);
    NSLog(@"%@",appDelegate.credentials.password);
}

-(void)setCountText
{
    _contactsCountLabel.text = [NSString stringWithFormat:@"%d",[contact contactsCount]];
//    [_serverCountLabel setText:[NSString stringWithFormat:@"%i",appDelegate.serverUpload.contactsNo]];
    NSString* serverCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"len"];
    [_serverCountLabel setText:serverCount];
}


- (IBAction)downloadAndInstall:(FUIButton *)sender
{
    if ([SSAppDelegate isNetwork]==NO) {
        
        NSString* message = [appDelegate languageSelectedStringForKey:@"No Internet connection"];
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(message,nil) andTitle:nil];
        return;
    }
   
    NSString* message = [appDelegate languageSelectedStringForKey:@"Install contacts from server ?"];
    NSString* yes = [appDelegate languageSelectedStringForKey:@"Yes"];
    NSString* no =[appDelegate languageSelectedStringForKey:@"No"];
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:self cancelButtonTitle:NSLocalizedString(no,nil) otherButtonTitles:NSLocalizedString(yes,nil), nil];
    av.tag = TAG_INSTALL_CONTACTS;
    
    [av show];
    //[self install];
}

-(void)install
{
    _progressLabel.hidden = NO;
    _updateManager = [[SSUpdateManager alloc] init];

    [_updateManager getDataFromURL:CONTACTS_URL];
    
    [self dataIsSyncing];
}


-(void)customizeView
{
    [self customizeProgressLabel];
         
    for (UIButton *button in _mainView.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            button.layer.borderColor = [UIColor peterRiverColor].CGColor;
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];

        }
    }
    

    _labelAccount.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    _buttonSend.titleLabel.numberOfLines = 3;
    _buttonSend.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonInstall.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonInstall.titleLabel.numberOfLines = 3;
    
    _buttonDelete.titleLabel.numberOfLines = 3;
    _buttonDelete.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonLogout.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonLogout.titleLabel.numberOfLines = 3;
    _btnLanguage.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnLanguage.titleLabel.numberOfLines = 3;

    NSString* sendTitle = [appDelegate languageSelectedStringForKey:@"Save To Cloud"];
    NSString* installTitle = [appDelegate languageSelectedStringForKey:@"Import Contacts"];
    
    [_buttonSend setTitle:NSLocalizedString(sendTitle,nil) forState:UIControlStateNormal];
    [_buttonInstall setTitle:NSLocalizedString(installTitle,nil) forState:UIControlStateNormal];
    
    [_buttonInstall setTitleEdgeInsets:UIEdgeInsetsMake(4.0f, 4.0f, 0.0f, 0.0f)];
        [_buttonSend setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 2.0f, 0.0f, 0.0f)];
    
    [_ivSave addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendContacts:)]];
    
    [_ivInstall addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadAndInstall:)]];

}

- (IBAction)toggleMenu:(UIButton *)sender {
    
    CGRect newFrame = _mainView.frame;
    newFrame.origin.x = _menuView.frame.size.width;
    
    if (isShowing == NO) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _mainView.frame = newFrame;
                         }
         
                         completion:^(BOOL finished)
         {
             isShowing = YES;
             
         }];
    }
    newFrame.origin.x = 0;
    
    if (isShowing == YES) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _mainView.frame = newFrame;
                         }
         
                         completion:^(BOOL finished)
         {
             isShowing = NO;
             
         }];
    }
}

- (IBAction)openMenu:(UIBarButtonItem *)sender
{
    CGRect newFrame = _mainView.frame;
    newFrame.origin.x = _menuView.frame.size.width;
    
    if (isShowing == NO) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _mainView.frame = newFrame;
                         }
         
                         completion:^(BOOL finished)
         {
             isShowing = YES;

         }];
    }
    newFrame.origin.x = 0;
    
     if (isShowing == YES) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _mainView.frame = newFrame;
                         }
         
                         completion:^(BOOL finished)
         {
             isShowing = NO;
 
         }];
    }
}


- (IBAction)sendContacts:(FUIButton *)sender
{
    if ([SSAppDelegate isNetwork]==NO) {
        NSString* noInternet  = [appDelegate languageSelectedStringForKey:@"No Internet connection"];
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(noInternet,nil) andTitle:nil];
        return;
    }
    NSString* message = [appDelegate languageSelectedStringForKey:@"Save contacts to server ? This will overwrite your current backup."];
    NSString* yes = [appDelegate languageSelectedStringForKey:@"Yes"];
    NSString* no =[appDelegate languageSelectedStringForKey:@"No"];
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:self cancelButtonTitle:NSLocalizedString(no,nil) otherButtonTitles:NSLocalizedString(yes,nil),nil];
    av.tag = TAG_SEND_CONTACTS;
    [av show];
//    [NSThread detachNewThreadSelector:@selector(upload) toTarget:self withObject:nil];
//
//    [_progressView setHidden:NO];
}


-(void)upload
{    
    NSString *strForUpload = [contact getStringOfContacts];
    
    SServerUpload *up = appDelegate.serverUpload;

    [up uploadContactsToServer:strForUpload toURL:CONTACTS_URL];

    [self dataIsSyncing];
}



-(void)animateView:(UIView*)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [view.layer addAnimation:transition forKey:@"tralala"];
}



- (IBAction)logoutPressed:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutPressed" object:nil];
    
    CGRect newFrame = _mainView.frame;
    
    newFrame.origin.x = 0;
    
    // to bring mainView back to x origin
    if (isShowing == YES) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _mainView.frame = newFrame;
                         }
         
                         completion:^(BOOL finished)
         {
             isShowing = NO;
             
         }];
    }
    
    
    [appDelegate.credentials resetCredentials];
    [self animateView:appDelegate.signInVC.view];
    [self.view removeFromSuperview];
}

- (IBAction)selectLanguage:(UIButton *)sender {
    SSLanguageViewController* languageVC = [[SSLanguageViewController alloc]initWithNibName:@"SSLanguageViewController" bundle:nil];
    
    [self presentViewController:languageVC animated:YES completion:nil];
}


- (IBAction)deleteAllContacts:(UIButton *)sender
{
    NSString* message = [appDelegate languageSelectedStringForKey:@"We suggest you backup your contacts before proceeding to deletion"];
    NSString* continueTitle = [appDelegate languageSelectedStringForKey:@"Already backed up"];
    NSString* back = [appDelegate languageSelectedStringForKey:@"Back"];
    
    UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:self cancelButtonTitle:NSLocalizedString(back,nil) otherButtonTitles:NSLocalizedString(continueTitle,nil), nil];
    alertV.tag = 5;
    [alertV show];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // yes for contacts deletion
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self dataIsSyncing];
             [NSThread detachNewThreadSelector:@selector(deleteContacts) toTarget:self withObject:nil];
        }
        else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    //all contacts deleted message
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            _contactsCountLabel.text = @"0";
            [self dataSyncingFinished];
        }
    }
    //contacts installed
    if (alertView.tag == 3) {
        int totalCount = 0;
        if (buttonIndex == 0) {
            totalCount = [contact contactsCount];
            NSString *tc = [NSString stringWithFormat:@"%i",totalCount];
            _contactsCountLabel.text = tc;
            [_progressLabel setProgress:0];

            [self dataSyncingFinished];
        }
    }
    //contacts backed up
    if (alertView.tag == 4) {
        if (buttonIndex == 0) {
            NSString* totalCountOfContacts = [NSString stringWithFormat:@"%i",[contact contactsCount]];

            [_serverCountLabel setText:totalCountOfContacts];
            [self dataSyncingFinished];
            [self userDefaultsSetValue:totalCountOfContacts forKey:@"len"];
        }
    }
    // Deletion question
    if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            NSString* yes = [appDelegate languageSelectedStringForKey:@"Yes"];
            NSString* no = [appDelegate languageSelectedStringForKey:@"No"];
            NSString* message = [appDelegate languageSelectedStringForKey:@"Are you sure you want to delete all your contacts ?"];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:self cancelButtonTitle:NSLocalizedString(no,nil) otherButtonTitles:NSLocalizedString(yes,nil), nil];
                alert.tag = 1;
                [alert show];
        }
        else [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (alertView.tag == TAG_SEND_CONTACTS) {
        if (buttonIndex == 1) {
            [self upload];
            //[NSThread detachNewThreadSelector:@selector(upload) toTarget:self withObject:nil];
        }
        else [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    if (alertView.tag == TAG_INSTALL_CONTACTS) {
        if (buttonIndex == 1) {
            [self install];
        }
        else [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

-(void)deleteContacts
{
    [contact delAllContacts];
}


#pragma mark === LOADING SCREEN

-(void)dataIsSyncing
{
    shadowView = [[UIView alloc]initWithFrame:self.view.frame];
    shadowView.alpha = 0.5;
    shadowView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:shadowView];
    [_buttonDelete setEnabled:NO];
    [_buttonInstall setEnabled:NO];
    [_buttonSend setEnabled:NO];
}


-(void)dataSyncingFinished
{

    [_buttonDelete setEnabled:YES];
    [_buttonInstall setEnabled:YES];
    [_buttonSend setEnabled:YES];
    [shadowView removeFromSuperview];

}
#pragma mark

// social
- (IBAction)openEULA:(UIButton *)sender {
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

- (IBAction)presentRecoverVC:(UIButton *)sender {
    SSChangePasswordVC* changeVC = [[SSChangePasswordVC alloc]initWithNibName:@"SSChangePasswordVC" bundle:nil];
    
    //[self.view addSubview:changeVC.view];
    [self presentViewController:changeVC animated:YES completion:nil];
    
}



-(void)userDefaultsSetValue:(NSString*)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
