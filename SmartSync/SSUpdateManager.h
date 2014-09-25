//
//  SSUpdateManager.h
//  SmartSync
//
//  Created by dragos on 1/13/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SServerRequest.h"
#import "SSRequestProtocol.h"
#import "SSOperationResultProtocol.h"

@interface SSUpdateManager : NSObject <SSRequestProtocol>

@property(nonatomic,strong) SServerRequest *serverRequest;
@property(nonatomic,weak) id <SSOperationResultProtocol> delegate;

-(BOOL)getDataFromURL:(NSString*)url;
@property(nonatomic,readwrite) int count;
@end
