//
//  SSRegisterViewController.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SSRegisterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *accountButton;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBack;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
