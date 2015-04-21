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

#define ENGLISH_LANGUAGE 0
#define RO_LANGUAGE 1
#define FRENCH_LANGUAGE 2
#define CHINESE_LANGUAGE 3
#define IT_LANGUAGE 4
#define AR_LANGUAGE 11
#define DE_LANGUAGE 5
#define PT_LANGUAGE 6
#define JP_LANGUAGE 7
#define RU_LANGUAGE 8
#define SP_LANGUAGE 9
#define HE_LANGUAGE 10

@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [GPGuardPost setPublicAPIKey:@"pubkey-0yxmbgkg980hdtqv4faxz1uf57wy2t-8"];

    [self initialize];
    
    _selectedLanguage = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] intValue];
    //_oldContactsCount = [_contact getCountOfAllContacts];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = superBlue;
    _syncVC = [[SSyncViewController alloc]initWithNibName:@"SSyncViewController" bundle:nil];
    _signInVC = [[SSignInViewController alloc]initWithNibName:@"SSignInViewController" bundle:nil];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDidFinish:) name:@"notificationDidFinish" object:nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* userEmail = [defaults valueForKey:@"email"];
    
    if (userEmail == nil || [userEmail isEqual:@""] || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied)
    {
        self.window.rootViewController = _signInVC;

    }
    else {
        self.window.rootViewController= _signInVC;
        [_signInVC addChildViewController:_syncVC];
        [_syncVC didMoveToParentViewController:_signInVC];
        [_signInVC.view addSubview:_syncVC.view];
    }

    [self.window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        LanguageViewController* languageVC = [[LanguageViewController alloc]init];
        [_signInVC presentViewController:languageVC animated:YES completion:nil];
    }
    
   // [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)| UIRemoteNotificationTypeAlert];
    
    return YES;
}

-(void)notificationDidFinish:(UILocalNotification*)n
{
    //_oldContactsCount = [_contact getCountOfAllContacts];
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
    int newCount = [_contact getCountOfAllContacts];
    
    if (newCount > _oldContactsCount) {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.alertBody = NSLocalizedString(@"You have contacts that are not saved , please consider backing up !",nil);
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 0;
    
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDidFinish" object:nil];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkContactsAdded) userInfo:nil repeats:YES];
    

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


-(NSString*)languageSelectedStringForKey:(NSString*) key
{
    
    NSString *path;
    if(_selectedLanguage==ENGLISH_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    else if(_selectedLanguage==CHINESE_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
    else if(_selectedLanguage==FRENCH_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"];
    else if (_selectedLanguage == IT_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"it" ofType:@"lproj"];
    else if (_selectedLanguage == AR_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    else if (_selectedLanguage == DE_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"de" ofType:@"lproj"];
    else if (_selectedLanguage == SP_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"es-MX" ofType:@"lproj"];
    else if (_selectedLanguage == JP_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"ja" ofType:@"lproj"];
    else if (_selectedLanguage == RU_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"];
    else if (_selectedLanguage == PT_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"pt" ofType:@"lproj"];
    else if (_selectedLanguage == RO_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"ro" ofType:@"lproj"];
    else if (_selectedLanguage == HE_LANGUAGE)
        path = [[NSBundle mainBundle] pathForResource:@"he" ofType:@"lproj"];
    
    
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
    
    return str;
}

@end
