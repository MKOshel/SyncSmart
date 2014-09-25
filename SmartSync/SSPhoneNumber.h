//
//  SSPhoneNumber.h
//  SmartSync
//
//  Created by dragos on 2/12/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSPhoneNumber : NSObject

@property(nonatomic,retain) NSMutableArray* homeNumber;
@property(nonatomic,retain) NSMutableArray* workNumber;
@property(nonatomic,retain) NSMutableArray* iphoneNumber;
@property(nonatomic,retain) NSMutableArray* mobileNumber;
@property(nonatomic,retain) NSMutableArray* mainNumber;
@property(nonatomic,retain) NSMutableArray* otherNumber;


-(NSMutableDictionary*)serializePhoneNumber:(SSPhoneNumber*)numbers;

@end
