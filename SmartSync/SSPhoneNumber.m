//
//  SSPhoneNumber.m
//  SmartSync
//
//  Created by dragos on 2/12/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSPhoneNumber.h"
#import "SBJson.h"

@implementation SSPhoneNumber

-(id)init
{
    self = [super init];
   
    if (self)
    {

    }
    return self;
}

-(NSMutableDictionary*)serializePhoneNumber:(SSPhoneNumber*)numbers
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:numbers.homeNumber  forKey:@"home"];
    
    [dict setValue:numbers.workNumber forKey:@"work"];
    
    [dict setValue:numbers.iphoneNumber  forKey:@"iphone"];
    
    [dict setValue:numbers.mobileNumber forKey:@"mobile"];
    
    [dict setValue:numbers.mainNumber forKey:@"main"];
    
    [dict setValue:numbers.otherNumber forKey:@"other"];
    
    return dict ;
}

@end
