//
//  SSUpdateManager.m
//  SmartSync
//
//  Created by dragos on 1/13/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSUpdateManager.h"
#import "SBJson.h"
#import "SSContact.h"
#import "SSAppDelegate.h"

@implementation SSUpdateManager

-(BOOL)getDataFromURL:(NSString *)url
{
    _serverRequest = [[SServerRequest alloc]init];
    _serverRequest.delegate = self;
    
    [_serverRequest sendRequest:url];
    
    return YES;
}

-(void) callSuccessDelegate{
    if(_delegate){
        [_delegate onSuccess];
    }
}

-(void) callFailedDelegate{
    if(_delegate)
    {
        [_delegate onFailed];
    }
}

-(void) allDataWasReceived:(NSMutableData *)dataReceived
{
    @try
    {
        NSString *strReceivedData = [[NSString alloc] initWithBytes:[dataReceived bytes] length:[dataReceived length] encoding:NSUTF8StringEncoding];
        NSLog(@"CONTACTS FROM SERVER ARE : %@",strReceivedData);

        BOOL success = [self processResponse:strReceivedData];
     
        if(success)
            [self callSuccessDelegate];
        else {
            [self callFailedDelegate];
        }
	}
	@catch (NSException* exception) {
		NSLog(@"DATA DOWNLOAD EXCEPTION : %@",exception.description);
	}
}


-(BOOL)processResponse:(NSString*)strResponse
{
    @try{
        NSArray* results = [strResponse JSONValue];
        _count = results.count;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            [self processContacts:results];
        });

        return YES;
    }
    @catch (NSException* exception) {
        NSLog(@"EXCEPTION ON PROCESS RESPONSE ! %@",exception.description);
        return NO;
    }
}



-(BOOL)processContacts:(NSArray*)results
{

        NSArray* arrAll = results;

    SServerUpload* serverUpload = appDelegate.serverUpload;
    [serverUpload.contactsFromServer removeAllObjects];
    
    if(arrAll == nil)
        {
            return false;
        }
        
        if([arrAll count] == 0)
        {
            return false;
        }
        
        for(int i = 0 ; i < [arrAll count] ; i++)
        {

//                [appDelegate.syncVC.progressView setProgress:(float)(i/[arrAll count]) animated:YES];
        
            NSDictionary* d = [arrAll objectAtIndex:i];
            
            NSString* firstName = [d objectForKey:@"first"];
            NSString* lastName = [d objectForKey:@"last"];
            NSString* email = [d objectForKey:@"email"];
            NSMutableDictionary* phoneNumbers = [d objectForKey:@"phone"];

            SSContact *contact = [[SSContact alloc]init];
            
            contact.firstName = firstName;
            contact.lastName = lastName;
            contact.phone = phoneNumbers;
            contact.email = email;
            
            [serverUpload.contactsFromServer addObject:contact];

        }

        SSContact* c = [[SSContact alloc]init];
       [c saveReceivedContacts];
    
    
        return true;

}


-(void)updateProgressViewWithProgress:(double)progress
{
    [appDelegate.syncVC.progressView setHidden:NO];
    [appDelegate.syncVC.progressView setProgress:progress];
}

-(BOOL)processPhotos:(NSDictionary*)resultDict
{
    return YES;
}

@end
