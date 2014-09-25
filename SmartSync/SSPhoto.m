//
//  SSPhoto.m
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSPhoto.h"
#import "SBJson.h"
#import "SServerUpload.h"
#import "SSPhotoSyncViewController.h"

@interface SSPhoto ()
{
//    NSArray *imageArray;
    NSMutableArray *imageArray;
    SSPhotoSyncViewController *photoVC;
}
@end

@implementation SSPhoto

-(id)init
{
    self = [super init];
    if (self) {
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
    }
    return self;
}



-(void)sendAllPhotos
{
    //imageArray = [[NSMutableArray alloc]init];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        @autoreleasepool {
            
        if (result != NULL) {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
            
                ALAssetRepresentation* repr = [result defaultRepresentation];
                Byte *buffer = (Byte*)malloc(repr.size);
                NSInteger bufferSize = [repr getBytes:buffer fromOffset:0.0 length:repr.size error:nil];
                NSData *imageData = [NSData dataWithBytes:buffer length:bufferSize];
                free(buffer);
                NSString *imgStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString *strForUpload = [[self serializePhoto:imgStr] JSONRepresentation];
             //   [SServerUpload uploadStringToServer:strForUpload urlToSend:MAIN_URL];
            }
        }
        }
//        else {
//            NSLog(@"Can't get image !#########");
//        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop)
       {
        if(group != nil)
                {
            		[group enumerateAssetsUsingBlock:assetEnumerator];
            	}
        };
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
           					   usingBlock:assetGroupEnumerator
           					 failureBlock: ^(NSError *error) {
               						 NSLog(@"Failure");
               					 }];
    
}


-(NSMutableDictionary*)serializePhoto:(NSString*)photo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:photo forKey:@"image"];
    
    return  dict;
}



@end
