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

    [self customizeView];

    [self logCredentials];
    
    _labelAccount.text = appDelegate.signInVC.textFieldEmail.text;
    
    [self setCountText];
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
}


- (IBAction)downloadAndInstall:(FUIButton *)sender
{
    if ([SSAppDelegate isNetwork]==NO) {
        [SSAppDelegate showAlertWithMessage:@"No Internet connection" andTitle:nil];
        return;
    }
    [self install];
}

-(void)install
{
    _progressView.hidden = NO;
    SServerUpload *up = appDelegate.serverUpload;
    _updateManager = [[SSUpdateManager alloc] init];

    [_updateManager getDataFromURL:[DOWN_CONTACTS_URL stringByAppendingString:up.apiKey]];
    
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
            [button.titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
            button.layer.masksToBounds = YES;
        }
    }
    
    [_contactsCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:21.0]];
    [_serverCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:21.0]];
    
    _buttonSend.titleLabel.numberOfLines = 3;
    _buttonSend.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonInstall.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_buttonSend setTitle:@"Save To Cloud" forState:UIControlStateNormal];
    [_buttonInstall setTitle:@"Import Contacts" forState:UIControlStateNormal];
    _buttonInstall.titleLabel.numberOfLines = 3;
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
        [SSAppDelegate showAlertWithMessage:@"No Internet connection" andTitle:nil];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(upload) toTarget:self withObject:nil];

    [_progressView setHidden:NO];
}


-(void)upload
{    
    NSString *strForUpload = [contact getStringOfContacts];
    
    SServerUpload *up = appDelegate.serverUpload;
    [up uploadStringToServer:strForUpload urlToSend:[UP_CONTACTS_URL stringByAppendingString:up.apiKey]];

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



- (IBAction)deleteAllContacts:(UIButton *)sender
{
    

    UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:nil message:@"We suggest you backup your contacts before proceeding to deletion" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Already backed up", nil];
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
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to delete all your contacts ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                alert.tag = 1;
                [alert show];
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
