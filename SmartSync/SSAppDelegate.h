//
//  SSAppDelegate.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSyncViewController.h"
#import "SSignInViewController.h"
#import "SSCredentials.h"
#import "SServerUpload.h"
#import "SSContact.h"

@interface SSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SSyncViewController *syncVC;
@property (strong,nonatomic) SSignInViewController *signInVC;
@property (strong,nonatomic) SSCredentials* credentials;
@property (strong,nonatomic) SServerUpload* serverUpload;
@property (strong, nonatomic) SSContact* contact;

@property(readwrite,nonatomic) int oldContactsCount;
@property(nonatomic,strong) NSTimer* timer;
//@property(strong,nonatomic) NSString* deviceToken;

+(void)showAlertWithMessage:(NSString*)message andTitle:(NSString*)title;
+(BOOL)isNetwork;

@end
