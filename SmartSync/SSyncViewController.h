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
#import "KAProgressLabel.h"

@interface SSyncViewController : UIViewController<UIAlertViewDelegate,UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *ivSave;
@property (strong, nonatomic) IBOutlet UIImageView *ivInstall;
@property (strong, nonatomic) IBOutlet UILabel *contactsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *serverCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *labelAccount;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoPhoneContacts;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoServerContacts;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet KAProgressLabel *progressLabel;

@property (nonatomic,strong) SSUpdateManager *updateManager;
@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UIButton *buttonInstall;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogout;

@property (strong, nonatomic) NSString* email;
-(void)setCountText;

@property (strong, nonatomic) IBOutlet UIButton *btnLanguage;

@end
