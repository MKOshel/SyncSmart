//
//  SSChangePasswordVC.h
//  SmartSync
//
//  Created by Oshel on 5/5/15.
//  Copyright (c) 2015 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSChangePasswordVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *labelPassword;
@property (strong, nonatomic) IBOutlet UITextField *labelConfirmPassword;

@property (strong, nonatomic) IBOutlet UITextField *fieldOldPassword;
@end
