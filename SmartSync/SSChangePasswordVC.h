//
//  SSChangePasswordVC.h
//  SmartSync
//
//  Created by Oshel on 5/5/15.
//  Copyright (c) 2015 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSChangePasswordVC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatTextField;
@property (strong, nonatomic) IBOutlet UITextField *nwPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *accountButton;

@end
