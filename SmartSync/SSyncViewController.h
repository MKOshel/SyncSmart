//
//  SSyncViewController.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "SSUpdateManager.h"

@interface SSyncViewController : UIViewController<UIAlertViewDelegate,UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UILabel *contactsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *serverCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *labelAccount;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic,strong) SSUpdateManager *updateManager;
@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UIButton *buttonInstall;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;

@property (strong, nonatomic) NSString* email;
-(void)setCountText;


@end
