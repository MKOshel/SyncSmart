//
//  SSignInViewController.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSRequestProtocol.h"
#import <QuartzCore/QuartzCore.h>
#import "SSRequestProtocol.h"

@interface SSignInViewController : UIViewController <UITextFieldDelegate,SSRequestProtocol,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UILabel *labelForgot;
@property (strong, nonatomic) IBOutlet UIButton *sigInButton;
@property (strong, nonatomic) IBOutlet UIView *loginView;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBack;

@property(readwrite,nonatomic)     BOOL didShowInfo;
@property (strong, nonatomic) IBOutlet UIButton *buttonInfo;

-(UIActivityIndicatorView*)getIndicator;
-(void)requestPermissions;

@end
