//
//  SServerUpload.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SServerUpload.h"
#import "SSyncViewController.h"
#import "SSAppDelegate.h"
#import "SBJson.h"
#import "SSRegisterViewController.h"

@interface SServerUpload ()
{
    NSURLConnection *post;
}
@end

@implementation SServerUpload



-(id)init
{
    self=[super init];
    _receivedData = [[NSMutableData alloc]init];
    _contactsFromServer = [[NSMutableArray alloc]init];
    return self;
}



-(NSString*)uploadStringToServer:(NSString *)stringToSend toURL:(NSString *)strUrl
{
	NSURL *cgiUrl = [NSURL URLWithString:strUrl];
    
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
    
	[postRequest setHTTPMethod:@"POST"];

	[postRequest addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
    NSData* dataToSend = [stringToSend dataUsingEncoding:NSUTF8StringEncoding];

	[postBody appendData:dataToSend];
	
	[postRequest setHTTPBody:postBody];
	
//	NSHTTPURLResponse *response = NULL;
//	NSError* error_received = NULL;
    NSString* __block strResponse = nil;
    
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse* response, NSData* receivedData, NSError* error)
    {
        if (error) {
            NSLog(@"LOGIN FAILED %@",error.description);
        }
       strResponse = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary* dict = [strResponse JSONValue];
        
        _apiKey = [dict objectForKey:@"apikey"];
        _contactsNo = [[dict objectForKey:@"len"] intValue];
        appDelegate.syncVC.serverCountLabel.text = [NSString stringWithFormat:@"%i",_contactsNo];
        
        NSLog(@"STRING RESPONSE IS : %@",strResponse);
        
        if ([strResponse rangeOfString:@"apikey"].location == NSNotFound || strResponse == nil)
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               NSString* message = [appDelegate languageSelectedStringForKey:@"Unable to connect, please verify your credentials"];
                               [SSAppDelegate showAlertWithMessage:message andTitle:nil];
                               [[appDelegate.signInVC getIndicator] stopAnimating];
                               [[appDelegate.signInVC getIndicator] setHidden:YES];
                           });
        }
        
        else
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [appDelegate.signInVC requestPermissions];
                               [[appDelegate.signInVC getIndicator] stopAnimating];
                               [[appDelegate.signInVC getIndicator] setHidden:YES];
                           });
    }];
    return strResponse;
    
//	NSData* dResponse = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error_received];
//   if(error_received != nil)
//        return false;
//	NSString* strResponse = [[NSString alloc] initWithData:dResponse encoding:NSUTF8StringEncoding];
//
//    if ([strResponse hasPrefix:@"{\"apikey"] )
//    {
//        NSMutableDictionary *dict = [strResponse JSONValue];
//        _apiKey = [dict objectForKey:@"apikey"];
//
//        NSLog(@"$$$$$ API KEY IS : %@",_apiKey);
//    }
//    return strResponse;
    
}



-(NSString*)uploadDataToServer:(NSString*)data urlToSend:(NSString*)strUrl
{
    NSURL *cgiUrl = [NSURL URLWithString:strUrl];
    
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
    
	[postRequest setHTTPMethod:@"POST"];
    
	[postRequest addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
    NSData* dataToSend = [data dataUsingEncoding:NSUTF8StringEncoding];
    
	[postBody appendData:dataToSend];
	
	[postRequest setHTTPBody:postBody];
	
    	NSHTTPURLResponse *response = NULL;
    	NSError* error_received = NULL;
    
    
    NSData* dResponse = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error_received];
       if(error_received != nil)
            return false;
    NSString* strResponse = [[NSString alloc] initWithData:dResponse encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* dict = [strResponse JSONValue];
    
    _apiKey = [dict objectForKey:@"apikey"];
    _contactsNo = [[dict objectForKey:@"len"] intValue];
    
    appDelegate.syncVC.serverCountLabel.text = [NSString stringWithFormat:@"%i",_contactsNo];
    
    NSLog(@"STRING RESPONSE IS : %@",strResponse);
    
    if ([strResponse rangeOfString:@"apikey"].location == NSNotFound || strResponse == nil)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           NSString* message = [appDelegate languageSelectedStringForKey:@"Unable to connect, please verify your credentials"];
                           [SSAppDelegate showAlertWithMessage:message andTitle:nil];
                           [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"email"];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                          
                           [[appDelegate.signInVC getIndicator] stopAnimating];
                           [[appDelegate.signInVC getIndicator] setHidden:YES];
                       });
    }
    
    else
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [[NSUserDefaults standardUserDefaults] setValue:_apiKey forKey:@"apikey"];
                           [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:_contactsNo] forKey:@"len"];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           
                           [appDelegate.signInVC requestPermissions];
                           [[appDelegate.signInVC getIndicator] stopAnimating];
                           [[appDelegate.signInVC getIndicator] setHidden:YES];
                       });
    
        return strResponse;
}


-(NSString*)uploadPassword:(NSString*)data urlToSend:(NSString*)strUrl
{
    NSURL *cgiUrl = [NSURL URLWithString:strUrl];
    
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
    
	[postRequest setHTTPMethod:@"PUT"];
    
	[postRequest addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
    NSData* dataToSend = [data dataUsingEncoding:NSUTF8StringEncoding];
    
	[postBody appendData:dataToSend];
	
	[postRequest setHTTPBody:postBody];
	
    NSHTTPURLResponse *response = NULL;
    NSError* error_received = NULL;
    
    
    NSData* dResponse = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error_received];
    if(error_received != nil)
        return false;
    NSString* strResponse = [[NSString alloc] initWithData:dResponse encoding:NSUTF8StringEncoding];
    NSLog(@"NEW PASSWORD RESPONSE $$$ %@",strResponse);
    
    return strResponse;
}

/*below method is used only for creating account and contacts uploading */
-(void)uploadStringToServer:(NSString*)strToSend urlToSend:(NSString*)strUrl
{
    NSURL *cgiUrl = [NSURL URLWithString:strUrl];
    
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
    
	[postRequest setHTTPMethod:@"POST"];
    
	[postRequest addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
    NSData* dataToSend = [strToSend dataUsingEncoding:NSUTF8StringEncoding];
    
	[postBody appendData:dataToSend];
	
	[postRequest setHTTPBody:postBody];
	
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:postRequest
                                                                   delegate:self startImmediately:NO];
    
//    [NSURLConnection connectionWithRequest:postRequest delegate:self];
    
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSDefaultRunLoopMode];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc]initWithData:_receivedData encoding:NSUTF8StringEncoding];
//    _strResponse = [[NSString alloc]initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSArray* responseArr = [response JSONValue];
    
    NSLog(@"JSON arr COUNT%lu",(unsigned long)responseArr.count);
    
    if (responseArr.count == 1) {
        NSString* message = [appDelegate languageSelectedStringForKey:@"Account created"];
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:appDelegate.signInVC.registerVC cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
    }
    else if (responseArr.count == 3)
    {
        NSString* message = [appDelegate languageSelectedStringForKey:@"Please insert valid email address"];

        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
    }
    
    else if ([response isEqualToString:@"200"]) {
        NSString* message = [appDelegate languageSelectedStringForKey:@"Upload completed, your contacts have been backed up"];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:appDelegate.syncVC cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 4;
        
        [alertView show];
    }
    else if ([response isEqualToString:@"500"])
    {
        NSString* message = [appDelegate languageSelectedStringForKey:@"Mail already exists"];
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(message,nil) andTitle:@"Oops"];
    }
    
    else if ([response hasPrefix:@"<!DOCTYPE"])
    {
        [SSAppDelegate showAlertWithMessage:NSLocalizedString(@"Server maintenance downtime",nil) andTitle:@"Oops!"];
    }
    else if ([response isEqualToString:@"Internal Server Error"])
    {
        NSString* title = [appDelegate languageSelectedStringForKey:@"Sorry"];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(title,nil) message:NSLocalizedString(@"Internal server error",nil) delegate:appDelegate.syncVC cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 6;
        
        [alert show];
    }
    
    NSLog(@"SERVER RESPONSE ######### %@",response);
    [self performSelector:@selector(hideProgress) withObject:nil afterDelay:0.1];
}

-(void)hideProgress
{
    [appDelegate.syncVC.progressLabel setProgress:0.0];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SSAppDelegate showAlertWithMessage:error.description  andTitle:@"Oops"];

    [self hideProgress];
    
    if([error code] == NSURLErrorCancelled)
    {
        return;
    }
    
    NSLog(@"ERROR ON UPLOADING DATA : %@",error.description);
    
}


// puteam alege pt metoda de request la server sa mai introducem un parametru pentru tipul de HTTP request, de aceea am folosit toate aceste metode separate
-(NSString*)uploadRecoverString:(NSString*)data toURL:(NSString*)strUrl
{
    NSURL *cgiUrl = [NSURL URLWithString:strUrl];
    
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];

	[postRequest setHTTPMethod:@"PATCH"];
    
	[postRequest addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
    NSData* dataToSend = [data dataUsingEncoding:NSUTF8StringEncoding];
    
	[postBody appendData:dataToSend];
	
	[postRequest setHTTPBody:postBody];
	
    NSHTTPURLResponse *response = NULL;
    NSError* error_received = NULL;
    
    
    NSData* dResponse = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error_received];
    if(error_received != nil)
        return false;
    NSString* strResponse = [[NSString alloc] initWithData:dResponse encoding:NSUTF8StringEncoding];
    
    NSLog(@"RECOVER STRING : >>> %@",strResponse);
    
    return strResponse;
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{

    
    [appDelegate.syncVC.progressLabel setProgress:(float)totalBytesWritten/totalBytesExpectedToWrite
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:1.0
                                delay:0.0];
    
//    [appDelegate.syncVC.progressView setHidden:NO];
//    [appDelegate.syncVC.progressView setProgress:(float)totalBytesWritten/totalBytesExpectedToWrite animated:YES];
}

@end
