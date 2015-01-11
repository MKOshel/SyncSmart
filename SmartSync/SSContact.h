//
//  SSContact.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "SSPhoneNumber.h"

@interface SSContact : NSObject

@property(nonatomic,retain) NSString *firstName;
@property(nonatomic,retain) NSString *lastName;
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSMutableArray *numbers;
@property(nonatomic,retain) NSMutableDictionary *phone;

@property(nonatomic,retain) NSString *phoneNumber;



-(NSArray*)getAllContacts;

-(NSMutableDictionary*)serializeContact:(SSContact*)contact;

+(ABAddressBookRef)getBook;

-(NSString*)getStringOfContacts;

-(int)contactsCount;

-(void)delAllContacts;

-(void)saveReceivedContacts;

-(int)getCountOfAllContacts;

@end
