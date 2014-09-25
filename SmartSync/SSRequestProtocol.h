//
//  SSRequestProtocol.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSRequestProtocol <NSObject>

@required

-(void)allDataWasReceived:(NSMutableData*)receivedData;

@optional

-(void)errorOccured:(NSString*)errorDescriprion;

@end
