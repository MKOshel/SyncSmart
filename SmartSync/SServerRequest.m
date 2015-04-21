//
//  SServerRequest.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SServerRequest.h"

@implementation SServerRequest


-(id)init
{
    self = [super init];
    
    if (self) {
        //
    }
    
    return self;
}

-(void)sendRequest:(NSString*)requestUrl
{
    [self cancelRequest];
    
    NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]                         cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100.0];

	self.connection=[[NSURLConnection alloc] initWithRequest:request
               delegate:self];
	if (self.connection) {
		self.receivedData=[NSMutableData data];
	}
    else
    {
		// inform the user that the download could not be made
	}
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

	NSString * str = [NSString stringWithFormat:@"Succeeded! Received %lu bytes of data",(unsigned long)[_receivedData length]];
    NSLog(str);
    
    if(self.delegate != nil)
        if([self.delegate respondsToSelector:@selector(allDataWasReceived:)])
        {
            [self.delegate allDataWasReceived:_receivedData];
        }
    
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"CONNECTION FAILED WITH ERROR %@",[error description]);
    [self cancelRequest];

}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
}

-(void) cancelRequest{
    if(_connection != nil)
	{
		[_connection cancel];
		_connection = nil;
	}
}

@end
