//
//  SSOperationResultProtocol.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSOperationResultProtocol <NSObject>
@optional
-(void)userDidLogout;
-(void)onSuccess;
-(void)onFailed;
@end
