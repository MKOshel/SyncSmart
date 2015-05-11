//
//  SSContact.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSContact.h"
#import <AddressBook/AddressBook.h>
#import "SServerUpload.h"
#import "SBJson.h"
#import "SSAppDelegate.h"

@interface SSContact ()
{
    ABMultiValueRef personEmails,personNumbers;
    NSArray *phoneContacts;
    NSMutableArray *allNumbers;
    NSMutableArray *allContacts;
    SSContact *ssContact;
    SSPhoneNumber *number;
}
@end


@implementation SSContact



-(NSArray*)getAllContacts
{
    
    phoneContacts=(NSArray*)ABAddressBookCopyArrayOfAllPeople([SSContact getBook]);
    NSMutableSet* linkedPersonsToSkip = [NSMutableSet set];
    allContacts = [[NSMutableArray alloc]init];
    allNumbers = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < phoneContacts.count; i++)
    {
        ABRecordRef contactPerson = phoneContacts[i];
        int phoneNumbersCount = (int)ABMultiValueGetCount(ABRecordCopyValue(contactPerson, kABPersonPhoneProperty));
        int mailCount = (int)ABMultiValueGetCount(ABRecordCopyValue(contactPerson, kABPersonEmailProperty));
        if (phoneNumbersCount == 0 && mailCount == 0) {
            continue;
        }
        if ([linkedPersonsToSkip containsObject:contactPerson]) {
            continue;
        }
        
        SSContact* person = [self makeContactFromABPerson:contactPerson];
        
        
        NSArray *linked = (NSArray *) ABPersonCopyArrayOfAllLinkedPeople(contactPerson);
        if ([linked count] > 1) {
            [linkedPersonsToSkip addObjectsFromArray:linked];
            
            // merge linked contact info
            for (int m = 0; m < [linked count]; m++) {
                ABRecordRef iLinkedPerson = [linked objectAtIndex:m];
                // don't merge the same contact
                if (iLinkedPerson == contactPerson) {
                    continue;
                }
                person = [self mergeToContact:person infoFrom:iLinkedPerson];
            }
        }
        
        [allContacts addObject:person];
        
        
//        ssContact = [[SSContact alloc]init];
//        number = [[SSPhoneNumber alloc]init];
//        
//        number.homeNumber = [[NSMutableArray alloc]init];
//        number.workNumber = [[NSMutableArray alloc]init];
//        number.mainNumber = [[NSMutableArray alloc]init];
//        number.mobileNumber = [[NSMutableArray alloc]init];
//        number.otherNumber = [[NSMutableArray alloc]init];
//        number.iphoneNumber = [[NSMutableArray alloc]init];
//        
//        ABRecordRef contactPerson =phoneContacts[i];
//        NSArray* linkedPersons = (NSArray*)ABPersonCopyArrayOfAllLinkedPeople(contactPerson);
//        
//        NSLog(@" LINKED {{{ %@ }}}",linkedPersons);
//
//        
//        
//        
//        
//        
//        NSString *firstName = (NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
//        NSString *lastName = (NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
//        
//        ssContact.firstName  = firstName;
//        ssContact.lastName = lastName;
//        
//        [firstName release];
//        [lastName release];
//        
//        personEmails  = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
//        personNumbers = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
//        
//        
//        for (int j = 0; j < ABMultiValueGetCount(personEmails);j++)
//        {
//            NSString *contactMail = (NSString *)ABMultiValueCopyValueAtIndex(personEmails,j);
//            
//            if (j == 0) {
//                ssContact.email = contactMail;
//            }
//            [contactMail release];
//        }
//        
//        for (int k=0; k<ABMultiValueGetCount(personNumbers); k++) {
//            
//            NSString *contactPhoneNo = (NSString*)ABMultiValueCopyValueAtIndex(personNumbers, k);
//            NSString *label = (NSString*)ABMultiValueCopyLabelAtIndex(personNumbers, k);
//             NSLog(@"%@ %@", (NSString *) label, (NSString *) contactPhoneNo);
//           
//            if ([label isEqualToString:@"_$!<Home>!$_"]) {
////               number.homeNumber = (NSString*)contactPhoneNo;
//                [number.homeNumber addObject:(NSString*)contactPhoneNo];
//            }
//            if ([label isEqualToString:@"_$!<Work>!$_"]) {
//                [number.workNumber addObject:(NSString*)contactPhoneNo];
//            }
//            if ([label isEqualToString:@"iPhone"]) {
//                [number.iphoneNumber addObject:(NSString*)contactPhoneNo];
//            }
//            if ([label isEqualToString:@"_$!<Mobile>!$_"]) {
//                [number.mobileNumber addObject:(NSString*)contactPhoneNo];
//            }
//            if ([label isEqualToString:@"_$!<Main>!$_"]) {
//                [number.mainNumber addObject:(NSString*)contactPhoneNo];
//            }
//            if ([label isEqualToString:@"_$!<Other>!$_"]) {
//                [number.otherNumber addObject:(NSString*)contactPhoneNo];
//            }
//            CFRelease(contactPhoneNo);
//        }
//        ssContact.numbers = [[NSMutableArray alloc]init];
//        
//        
//        [ssContact.numbers addObject:number];
//       
//        [allContacts addObject:ssContact];
//        
//        CFRelease(personEmails);
//        CFRelease(personNumbers);
        
    }
    if (phoneContacts !=nil) {
        CFRelease(phoneContacts);
    }
    
    NSLog(@"ARRAY OF CONTACTS IS : %@",allContacts);
   
    return allContacts;
    
}


-(SSContact*)mergeToContact:(SSContact*)person infoFrom:(ABRecordRef)personRef
{
    SSPhoneNumber* phoneNumber = [[SSPhoneNumber alloc]init];
    
    phoneNumber.homeNumber = [[NSMutableArray alloc]init];
    phoneNumber.workNumber = [[NSMutableArray alloc]init];
    phoneNumber.mainNumber = [[NSMutableArray alloc]init];
    phoneNumber.mobileNumber = [[NSMutableArray alloc]init];
    phoneNumber.otherNumber = [[NSMutableArray alloc]init];
    phoneNumber.iphoneNumber = [[NSMutableArray alloc]init];
    
    NSString *firstName = (NSString *)ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
    NSString *lastName = (NSString*)ABRecordCopyValue(personRef, kABPersonLastNameProperty);
    NSData  *imgData = ( NSData *) ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatThumbnail);
    
    
    person.photo = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    person.firstName  = firstName;
    person.lastName = lastName;
    
    [firstName release];
    [lastName release];
    
    personEmails  = ABRecordCopyValue(personRef, kABPersonEmailProperty);
    personNumbers = ABRecordCopyValue(personRef, kABPersonPhoneProperty);
    
    
    for (int j = 0; j < ABMultiValueGetCount(personEmails);j++)
    {
        NSString *contactMail = (NSString *)ABMultiValueCopyValueAtIndex(personEmails,j);
        
        if (j == 0) {
            if ([person.email isEqualToString:@""] || !person.email) {
                person.email = contactMail;
            }
        }
        [contactMail release];
    }
    
    for (int k=0; k<ABMultiValueGetCount(personNumbers); k++) {
        
        NSString *contactPhoneNo = (NSString*)ABMultiValueCopyValueAtIndex(personNumbers, k);
        NSString *label = (NSString*)ABMultiValueCopyLabelAtIndex(personNumbers, k);
        NSLog(@"%@ %@", (NSString *) label, (NSString *) contactPhoneNo);
        
        if ([label isEqualToString:@"_$!<Home>!$_"]) {
            //               number.homeNumber = (NSString*)contactPhoneNo;
            [number.homeNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Work>!$_"]) {
            [number.workNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"iPhone"]) {
            [number.iphoneNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Mobile>!$_"]) {
            [number.mobileNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Main>!$_"]) {
            [number.mainNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Other>!$_"]) {
            [number.otherNumber addObject:(NSString*)contactPhoneNo];
        }
        CFRelease(contactPhoneNo);
    }
    
    
    [person.numbers addObject:number];
    
    CFRelease(personEmails);
    CFRelease(personNumbers);
    [phoneNumber release];
    
    return person;
}


-(SSContact*)makeContactFromABPerson:(ABRecordRef)ref
{
    ssContact = [[SSContact alloc]init];
    number = [[SSPhoneNumber alloc]init];
    
    number.homeNumber = [[NSMutableArray alloc]init];
    number.workNumber = [[NSMutableArray alloc]init];
    number.mainNumber = [[NSMutableArray alloc]init];
    number.mobileNumber = [[NSMutableArray alloc]init];
    number.otherNumber = [[NSMutableArray alloc]init];
    number.iphoneNumber = [[NSMutableArray alloc]init];
    
    
    NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
    NSString *lastName = (NSString*)ABRecordCopyValue(ref, kABPersonLastNameProperty);
    NSData  *imgData = ( NSData *) ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail);
    
    
    ssContact.photo = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    ssContact.firstName  = firstName;
    ssContact.lastName = lastName;
    
    [firstName release];
    [lastName release];
    
    personEmails  = ABRecordCopyValue(ref, kABPersonEmailProperty);
    personNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    
    NSLog(@"PERSON NUMBERS COUNT = %li",ABMultiValueGetCount(personNumbers));
    for (int j = 0; j < ABMultiValueGetCount(personEmails);j++)
    {
        NSString *contactMail = (NSString *)ABMultiValueCopyValueAtIndex(personEmails,j);
        
        if (j == 0) {
            ssContact.email = contactMail;
        }
        [contactMail release];
    }
    
    for (int k=0; k<ABMultiValueGetCount(personNumbers); k++) {
        
        NSString *contactPhoneNo = (NSString*)ABMultiValueCopyValueAtIndex(personNumbers, k);
        NSString *label = (NSString*)ABMultiValueCopyLabelAtIndex(personNumbers, k);
        //NSLog(@"LABEL %@ AND FUCKING PHONE %@", (NSString *) label, (NSString *) contactPhoneNo);
        
        if ([label isEqualToString:@"_$!<Home>!$_"]) {
            //               number.homeNumber = (NSString*)contactPhoneNo;

            [number.homeNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Work>!$_"]) {
            [number.workNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"iPhone"]) {
            [number.iphoneNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Mobile>!$_"]) {
            [number.mobileNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Main>!$_"]) {
            [number.mainNumber addObject:(NSString*)contactPhoneNo];
        }
        if ([label isEqualToString:@"_$!<Other>!$_"]) {
            [number.otherNumber addObject:(NSString*)contactPhoneNo];
        }
        CFRelease(contactPhoneNo);
    }
    ssContact.numbers = [[NSMutableArray alloc]init];
    
    [ssContact.numbers addObject:number];
    
    CFRelease(personEmails);
    CFRelease(personNumbers);

    return ssContact;
}



-(NSMutableDictionary*)serializeContact:(SSContact *)contact
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
        [dict setValue:contact.firstName forKey:@"first"];
    
        [dict setValue:contact.lastName forKey:@"last"];

        [dict setValue:contact.email forKey:@"email"];
    
        [dict setValue:[self getSerializedNumbersForContact:contact] forKey:@"phone"];
        [dict setValue:contact.photo forKey:@"photo"];
   
    return dict;
    [dict release];
}

-(NSDictionary*)getSerializedNumbersForContact:(SSContact*)contact
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (SSPhoneNumber* num in contact.numbers)
    {
        dict = [num serializePhoneNumber:num];
        //[jsonArray addObject:dict];
    }
    return dict;
}

-(NSString*)getStringOfContacts
{
    NSMutableArray *jSonArray = [[NSMutableArray alloc]init];
    NSArray *array = [self getAllContacts];
    
    for (int i=0 ; i < array.count ; i++)
    {
        SSContact *contact = [array objectAtIndex:i];
        NSMutableDictionary* dict = [self serializeContact:contact];
        [jSonArray addObject:dict];
    }
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
    [jsonDict setValue:jSonArray forKey:@"data"];
    
    NSLog(@"CONTACTS ARE : %@",[jsonDict JSONRepresentation]);
  
    return [jsonDict JSONRepresentation];
    [jSonArray release];
    [jsonDict release];
}

// valid contacts count , showed in syncVC
-(int)contactsCount
{
//    int nPeople = ABAddressBookGetPersonCount([SSContact getBook]);
    int nPeople = (int)[self getAllContacts].count;
    return nPeople;
}


-(int)getCountOfAllContacts
{
    int nAll = (int)ABAddressBookGetPersonCount([SSContact getBook]);
    
    return nAll;
    
}

-(void)delAllContacts
{
    int count =  (int)ABAddressBookGetPersonCount([SSContact getBook]);
    
    if(count==0 && [SSContact getBook]!=NULL) {
        return;
    }
    
    CFArrayRef theArray = ABAddressBookCopyArrayOfAllPeople([SSContact getBook]);
    
    for(CFIndex i=0; i < count; i++)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate.syncVC.progressLabel setHidden:NO];

            [appDelegate.syncVC.progressLabel setProgress:(float)i/count
                                                   timing:TPPropertyAnimationTimingEaseOut
                                                 duration:1.0
                                                    delay:0.0];
        });
        ABRecordRef person = CFArrayGetValueAtIndex(theArray, i);
        BOOL result = ABAddressBookRemoveRecord ([SSContact getBook],person,NULL);
        NSLog(@"%i",result);
        if(result==YES) {
            if(person!=NULL) {
                CFRelease(person);
            } else {
                NSLog(@"Couldn't save, breaking out");
                break;
            }
        } else {
            NSLog(@"Couldn't delete, breaking out");
            break;
        }
    }
    ABAddressBookSave([SSContact getBook], NULL);
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // [appDelegate.syncVC.progressLabel setHidden:YES];
        
        [appDelegate.syncVC.progressLabel setProgress:0
                                               timing:TPPropertyAnimationTimingEaseOut
                                             duration:1.0
                                                delay:0.0];
    
        NSString* message = [appDelegate languageSelectedStringForKey:@"Contacts deleted"];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:appDelegate.syncVC cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 2;
        
        [alertView show];
                   
    });

//    if(addressBook!=NULL) {
//        CFRelease(addressBook);
//    }
}


-(void)saveReceivedContacts
{
    CFErrorRef error = NULL;
    int i = 0;
    int count = (int)appDelegate.serverUpload.contactsFromServer.count;
    
    for (SSContact* contact in appDelegate.serverUpload.contactsFromServer)
    {
        i++;
       
        ABRecordRef newPerson = ABPersonCreate();
        
        if (contact.firstName != nil || ![contact.firstName  isEqualToString: @"1"] || ![contact.firstName isEqualToString:@""]) {
            ABRecordSetValue(newPerson, kABPersonFirstNameProperty,contact.firstName, &error);
        }
        if (contact.lastName !=nil || ![contact.lastName isEqualToString:@"1"] || ![contact.lastName isEqualToString:@""]) {
            ABRecordSetValue(newPerson, kABPersonLastNameProperty,contact.lastName, &error);
        }
        
        ABMutableMultiValueRef multiRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueRef multiMail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        if (contact.photo !=nil) {
            NSData* imgData = [[NSData alloc]initWithBase64Encoding:contact.photo];
            CFDataRef cfdata = CFDataCreate(NULL, [imgData bytes], [imgData length]);
            
            ABPersonSetImageData(newPerson, cfdata, &error);
            
        }
        
        if ([contact.phone objectForKey:@"home"] != nil ) {
//            ABMultiValueAddValueAndLabel(multiRef,([contact.phone objectForKey:@"home"]), kABHomeLabel, NULL);
            NSArray* arr = [contact.phone objectForKey:@"home"];
            for (NSString* homeNumber in arr) {
                ABMultiValueAddValueAndLabel(multiRef,(homeNumber), kABHomeLabel, NULL);
            }
        }
        if ([contact.phone objectForKey:@"work"] != nil) {
//            ABMultiValueAddValueAndLabel(multiRef,([contact.phone objectForKey:@"work"]), kABWorkLabel, NULL);
            NSArray* arr = [contact.phone objectForKey:@"work"];
            for (NSString* workNumber in arr) {
                ABMultiValueAddValueAndLabel(multiRef,(workNumber), kABWorkLabel, NULL);
            }
        }
        if ([contact.phone objectForKey:@"mobile"] != nil) {
//            ABMultiValueAddValueAndLabel(multiRef,([contact.phone objectForKey:@"mobile"]), kABPersonPhoneMobileLabel, NULL);
            NSArray* arr = [contact.phone objectForKey:@"mobile"];
            for (NSString* mobileNumber in arr) {
                ABMultiValueAddValueAndLabel(multiRef,(mobileNumber), kABPersonPhoneMobileLabel, NULL);
            }
        }
        if ([contact.phone objectForKey:@"iphone"] != nil) {
//            ABMultiValueAddValueAndLabel(multiRef,([contact.phone objectForKey:@"iphone"]), kABPersonPhoneIPhoneLabel, NULL);
            NSArray* arr = [contact.phone objectForKey:@"iphone"];
            for (NSString* iphNumber in arr) {
                ABMultiValueAddValueAndLabel(multiRef,(iphNumber), kABPersonPhoneIPhoneLabel, NULL);
            }
        }
        if ([contact.phone objectForKey:@"main"] != nil) {
//            ABMultiValueAddValueAndLabel(multiRef,([contact.phone objectForKey:@"main"]), kABPersonPhoneMainLabel, NULL);
            NSArray* arr = [contact.phone objectForKey:@"main"];
            for (NSString* mainNumber in arr) {
                ABMultiValueAddValueAndLabel(multiRef,(mainNumber), kABPersonPhoneMainLabel, NULL);
            }
        }
        if ([contact.phone objectForKey:@"other"] != nil) {
//            ABMultiValueAddValueAndLabel(multiRef,([contact.phone objectForKey:@"other"]), kABOtherLabel, NULL);
            NSArray* arr = [contact.phone objectForKey:@"other"];
            for (NSString* otherNumber in arr) {
                ABMultiValueAddValueAndLabel(multiRef,(otherNumber), kABOtherLabel, NULL);
            }
        }
        if (contact.email !=nil) {
            ABMultiValueAddValueAndLabel(multiMail,(contact.email),
                                         kABHomeLabel, NULL);
        }
        
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiRef,nil);
        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiMail,nil);
        
        CFRelease(multiRef);
        CFRelease(multiMail);
        //
        // For other properties
        //
        ABAddressBookAddRecord([SSContact getBook], newPerson, &error);
        dispatch_async(dispatch_get_main_queue(),^{
           // [appDelegate.syncVC.progressView setProgress:(double)i/count];
            [appDelegate.syncVC.progressLabel setProgress:(float)i/count
                                                   timing:TPPropertyAnimationTimingEaseOut
                                                 duration:1.0
                                                    delay:0.0];
        });
        CFRelease(newPerson);
        if (error != NULL)
        {
            CFStringRef errorDesc = CFErrorCopyDescription(error);
            NSLog(@"Contact not saved: %@", errorDesc);
            CFRelease(errorDesc);
        }
    }
    ABAddressBookSave([SSContact getBook], &error);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showCompletionMessage ];
    });
}

-(void)showCompletionMessage
{
    //[appDelegate.syncVC.progressLabel setHidden:YES];
    [appDelegate.syncVC.progressLabel setProgress:0.0];
//    [appDelegate.syncVC.progressView setHidden:YES];
//    [appDelegate.syncVC.progressView setProgress:0.0];
    
    NSString* message = [appDelegate languageSelectedStringForKey:@"Contacts installed"];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(message,nil) delegate:appDelegate.syncVC cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 3;
    [alert show];
    
}
-(void)dealloc
{
    [ssContact release];
    [number release];
    //CFRelease([SSContact getBook]);
    
    [super dealloc];
}

#pragma mark custom getters

+(ABAddressBookRef)getBook
{
    static ABAddressBookRef addressBook = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,
                  ^{
                      addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                  });
    
    return addressBook;
}



@end
