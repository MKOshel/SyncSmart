//
//  SSChangePasswordVC.m
//  SmartSync
//
//  Created by Oshel on 5/5/15.
//  Copyright (c) 2015 Dragos Marinescu. All rights reserved.
//

#import "SSChangePasswordVC.h"
#import "SBJson.h"

@interface SSChangePasswordVC ()

@end

@implementation SSChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark change password upload object

-(NSString*)getNewPasswordJsonObject:(NSString*)newPassword
{
    NSMutableDictionary* passwordDict = [NSMutableDictionary new];
    NSString* email  = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    
    [passwordDict setValue:email forKey:@"email"];
    [passwordDict setValue:newPassword forKey:@"password"];
    
    return [passwordDict JSONRepresentation];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
