//
//  SSyncViewController.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSyncViewController.h"
#import "LanguageViewController.h"
#import "SSContact.h"
#import <AddressBook/AddressBook.h>
#import "SServerUpload.h"
#import "UIColor+FlatUI.h"
#import "SSUpdateManager.h"
#import "SSAppDelegate.h"


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

-(void)addLocalization
{
    _labelInfoPhoneContacts.text = NSLocalizedString(@"valid contacts on phone", nil);
    _labelInfoServerContacts.text = NSLocalizedString(@"contacts on server", nil);
    _buttonDelete.titleLabel.text = NSLocalizedString(@"Delete Contacts", nil);
    _buttonLogout.titleLabel.text = NSLocalizedString(@"Logout",nil);
}

-(void)setButtonsColor
{

    [_buttonSend setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [_buttonInstall setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];

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
    
    _labelInfoPhoneContacts.text = [appDelegate languageSelectedStringForKey:_labelInfoPhoneContacts.text];
    _labelInfoServerContacts.text = [appDelegate languageSelectedStringForKey:_labelInfoServerContacts.text];
    
    [_buttonDelete setTitle:[appDelegate languageSelectedStringForKey:_buttonDelete.titleLabel.text] forState:UIControlStateNormal];
    [_buttonLogout setTitle:[appDelegate languageSelectedStringForKey:_buttonLogout.titleLabel.text] forState:UIControlStateNormal];
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
    [_serverCountLabel setText:[NSString stringWithFormat:@"%i",appDelegate.serverUpload.contactsNo]];
    NSNumber* serverCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"len"];
    [_serverCountLabel setText:serverCount.stringValue];
}


- (IBAction)downloadAndInstall:(FUIButton *)sender
{
    if ([SSAppDelegate isNetwork]==NO) {
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(@"No Internet connection",nil) andTitle:nil];
        return;
    }
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Install contacts from server ?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    av.tag = TAG_INSTALL_CONTACTS;
    [av show];
    //[self install];
}

-(void)install
{
    _progressView.hidden = NO;
   // SServerUpload *up = appDelegate.serverUpload;
    _updateManager = [[SSUpdateManager alloc] init];

    NSString* apikey = [[NSUserDefaults standardUserDefaults] valueForKey:@"apikey"];
    [_updateManager getDataFromURL:[DOWN_CONTACTS_URL stringByAppendingString:apikey]];
    
    [self dataIsSyncing];
}


-(void)customizeView
{
     
    _mainView.backgroundColor = BACK_COLOR;
    
    for (UIButton *button in _mainView.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//            button.buttonColor = BACK_COLOR;
            button.layer.borderWidth = 1.5;
            button.layer.cornerRadius = 50.0;
            button.layer.borderColor = [UIColor peterRiverColor].CGColor;
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
            button.layer.masksToBounds = YES;
        }
    }
    
    [_contactsCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21.0]];
    [_serverCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21.0]];
    _labelAccount.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    _buttonSend.titleLabel.numberOfLines = 3;
    _buttonSend.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonInstall.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonInstall.titleLabel.numberOfLines = 3;

    NSString* sendTitle = [appDelegate languageSelectedStringForKey:@"Save To Cloud"];
    NSString* installTitle = [appDelegate languageSelectedStringForKey:@"Import Contacts"];
    
    [_buttonSend setTitle:NSLocalizedString(sendTitle,nil) forState:UIControlStateNormal];
    [_buttonInstall setTitle:NSLocalizedString(installTitle,nil) forState:UIControlStateNormal];
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
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(@"No Internet connection",nil) andTitle:nil];
        return;
    }
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Save contacts to server ? This will overwrite your current backup.",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Yes",nil),nil];
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
    NSString* apikey = [[NSUserDefaults standardUserDefaults] valueForKey:@"apikey"];

    [up uploadStringToServer:strForUpload urlToSend:[UP_CONTACTS_URL stringByAppendingString:apikey]];

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
    CGRect newFrame = _mainView.frame;
    newFrame.origin.x = _menuView.frame.size.width;
    
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
    
    [appDelegate.syncVC.progressView setHidden:YES];
    [appDelegate.credentials resetCredentials];
    [self animateView:appDelegate.signInVC.view];
    [self.view removeFromSuperview];
}

- (IBAction)selectLanguage:(UIButton *)sender {
    LanguageViewController* languageVC = [[LanguageViewController alloc]init];
    
    [self presentViewController:languageVC animated:YES completion:nil];
}


- (IBAction)deleteAllContacts:(UIButton *)sender
{
    NSString* message = [appDelegate languageSelectedStringForKey:@"We suggest you backup your contacts before proceeding to deletion"];
    NSString* continueTitle = [appDelegate languageSelectedStringForKey:@"Already backed up"];
    
    UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Back",nil) otherButtonTitles:NSLocalizedString(continueTitle,nil), nil];
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
            [self dataSyncingFinished];
        }
    }
    //contacts backed up
    if (alertView.tag == 4) {
        if (buttonIndex == 0) {
            [_serverCountLabel setText:[NSString stringWithFormat:@"%i",[contact contactsCount]]];
            [self dataSyncingFinished];
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
            [NSThread detachNewThreadSelector:@selector(upload) toTarget:self withObject:nil];
             [_progressView setHidden:NO];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
