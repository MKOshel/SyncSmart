//
//  SSCredentials.h
//  SmartSync
//
//  Created by dragos on 2/13/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSCredentials : NSObject

@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *password;

-(NSString*)getAccountObject;
-(void)resetCredentials;
@end
