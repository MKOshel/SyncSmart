//
//  SSCredentials.m
//  SmartSync
//
//  Created by dragos on 2/13/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSCredentials.h"
#import "SBJson.h"

@implementation SSCredentials

-(id)init
{
    self = [super init];
    
    return self;
}


-(NSString*)getAccountObject
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:self.email forKey:@"email"];
    [dict setValue:self.password forKey:@"password"];
    
    return [dict JSONRepresentation];
    
}

-(void)resetCredentials
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    self.email = nil;
//    self.password = nil;
}

@end
