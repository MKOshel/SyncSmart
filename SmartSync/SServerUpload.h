//
//  SServerUpload.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SServerUpload : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property(nonatomic,strong) NSMutableData *receivedData;
@property(nonatomic,strong) NSString* strResponse;
@property(nonatomic,strong) NSString* apiKey;
@property(nonatomic,readwrite) int contactsNo;

-(NSString*)uploadStringToServer:(NSString *)stringToSend toURL:(NSString *)strUrl;
-(void)uploadStringToServer:(NSString*)strToSend urlToSend:(NSString*)strUrl;
//synchronized method
-(NSString*)uploadDataToServer:(NSString*)data urlToSend:(NSString*)strUrl;
-(NSString*)uploadPassword:(NSString*)data urlToSend:(NSString*)strUrl;
-(NSString*)uploadRecoverString:(NSString*)data toURL:(NSString*)strUrl;

@property(nonatomic,strong) NSMutableArray* contactsFromServer;

@end
