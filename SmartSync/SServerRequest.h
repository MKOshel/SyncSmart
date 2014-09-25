//
//  SServerRequest.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSRequestProtocol.h"

@interface SServerRequest : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(strong,nonatomic) NSMutableData* receivedData;
@property(strong,nonatomic) NSURLConnection *connection;
@property(strong,nonatomic) id <SSRequestProtocol> delegate;
-(void)sendRequest:(NSString*)requestUrl;

@end
