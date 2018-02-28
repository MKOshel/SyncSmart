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
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"apikey"] forHTTPHeaderField:@"X-Access-Token"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];


	self.connection=[[NSURLConnection alloc] initWithRequest:request
               delegate:self];
	if (self.connection) {
		self.receivedData=[NSMutableData data];
	}
    else
    {
        NSLog(@"DOWNLOAD ERROR $$$$$$$$$$$$");
	}
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

	NSString * str = [NSString stringWithFormat:@"Succeeded! Received %lu bytes of data",(unsigned long)[_receivedData length]];
    NSLog(@"%@", str);
    
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
