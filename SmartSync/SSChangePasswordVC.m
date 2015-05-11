//
//  SSChangePasswordVC.m
//  SmartSync
//
//  Created by Oshel on 5/5/15.
//  Copyright (c) 2015 Dragos Marinescu. All rights reserved.
//

#import "SSChangePasswordVC.h"
#import "SBJson.h"
#import "SSAppDelegate.h"
#import "SServerUpload.h"



#define TAG_CHANGE 321
@interface SSChangePasswordVC ()
{
    NSString* jsonToSend;
}
@end

@implementation SSChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)customizeView
{
    //self.view.backgroundColor = BACK_COLOR;
    
    UIColor* whiteColor = [UIColor whiteColor];
    _nwPasswordField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"new password"
                                                                           attributes:@{NSForegroundColorAttributeName: whiteColor}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"old password"
                                                                              attributes:@{NSForegroundColorAttributeName: whiteColor}];
    _repeatTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:
                                              [appDelegate  languageSelectedStringForKey:@"confirm password"]
                                                                            attributes:@{NSForegroundColorAttributeName: whiteColor}];
    
    [_nwPasswordField setBackground:[UIImage imageNamed:@"Password_field"]];
    [_passwordTextField setBackground:[UIImage imageNamed:@"Password_field"]];
    [_repeatTextField setBackground:[UIImage imageNamed:@"Password_field"]];
    
    
    [_accountButton setBackgroundColor:LOGIN_BUTTON_COLOR];
    [_accountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _accountButton.layer.cornerRadius = 15.0;
    [_accountButton.titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
    
    
    for (UITextField *field in self.view.subviews)
    {
        if ([field isKindOfClass:[UITextField class]])
        {
            //field.layer.borderWidth = 1.0;
            //field.layer.borderColor = [UIColor whiteColor].CGColor;
            field.backgroundColor = [UIColor clearColor];
            field.layer.cornerRadius = 15.0;
        }
    }
    
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

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.attributedPlaceholder = nil;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{

    if ([textField isEqual:_repeatTextField])
    {
        if (![_repeatTextField.text isEqualToString:_nwPasswordField.text])
        {
            NSString* alertText = [appDelegate languageSelectedStringForKey:@"Please insert same password in both fields"];
            [SSAppDelegate showAlertWithMessage:NSLocalizedString(alertText,nil) andTitle:nil];
        }
        else {
            NSString* passwordNew = textField.text;
            jsonToSend = [self getNewPasswordJsonObject:passwordNew];
        }
    }
}


- (IBAction)dismissView:(UIButton *)sende
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)changePasswordAction:(UIButton *)sender {
    
    NSString* oldPass =  [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    if (![_passwordTextField.text isEqualToString:oldPass]) {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"This account's password does not match the one you have provided" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to change your password" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    av.tag = TAG_CHANGE;
    [av show];
                       

}


-(void)changePassword
{
    NSString* apikey = [[NSUserDefaults standardUserDefaults] valueForKey:@"apikey"];
    NSString* response =  [appDelegate.serverUpload uploadPassword:jsonToSend urlToSend:[ACCOUNT_CHANGE_URL stringByAppendingString:apikey]];
    
    if ([response isEqualToString:@"200"]) {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:@"Your password is now changed"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        
        [appDelegate.credentials resetCredentials];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)  {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else {
        [NSThread detachNewThreadSelector:@selector(changePassword) toTarget:self withObject:nil];
    }
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
