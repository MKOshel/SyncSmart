//
//  SSAppDelegate.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSignInViewController.h"
#import "SBJson.h"
#import "Reachability.h"
#import "GPGuardPost.h"





@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [GPGuardPost setPublicAPIKey:@"pubkey-0yxmbgkg980hdtqv4faxz1uf57wy2t-8"];

    [self initialize];
    _oldContactsCount = [_contact contactsCount];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = superBlue;
    _syncVC = [[SSyncViewController alloc]initWithNibName:@"SSyncViewController" bundle:nil];
    _signInVC = [[SSignInViewController alloc]initWithNibName:@"SSignInViewController" bundle:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDidFinish:) name:@"notificationDidFinish" object:nil];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults valueForKey:@"email"] == nil) {
        self.window.rootViewController = _signInVC;

    }
    else {
        self.window.rootViewController= _syncVC;
    }
   //  self.window.rootViewController = _signInVC;

    [self.window makeKeyAndVisible];
    
   // [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)| UIRemoteNotificationTypeAlert];
    
    return YES;
}

-(void)notificationDidFinish:(UILocalNotification*)n
{
    _oldContactsCount = [_contact contactsCount];
    
}


-(void)initialize
{
    _credentials = [[SSCredentials alloc]init];
    _serverUpload = [[SServerUpload alloc]init];
    _contact = [[SSContact alloc]init];
}


+(void)showAlertWithMessage:(NSString*)message andTitle:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title  message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
    [alert show];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)checkContactsAdded
{
    int newCount = [_contact contactsCount];
    
    if (newCount > _oldContactsCount) {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.alertBody = @"You have contacts that are not saved , please consider backing up !";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 0;
    
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDidFinish" object:nil];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkContactsAdded) userInfo:nil repeats:YES];
    

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    _oldContactsCount = [_contact contactsCount];
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_syncVC setCountText];
//    _oldContactsCount = [_contact contactsCount];
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//
//    _deviceToken = [[[deviceToken description]
//                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
//                   stringByReplacingOccurrencesOfString:@" "
//                   withString:@""];
//    
//    NSLog(@"DEVICE TOKEN %@:",_deviceToken);
//}



+(BOOL)isNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    if (myStatus == NotReachable) {
        return NO;
    }
    if (myStatus == ReachableViaWiFi) {
        return YES;
    }
    if (myStatus == ReachableViaWWAN) {
        return YES;
    }
    
    return YES;
}
@end
