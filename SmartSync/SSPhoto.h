//
//  SSPhoto.h
//  SmartSync
//
//  Created by dragos on 1/8/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SSPhoto : NSObject

//@property(nonatomic,strong) NSString *stringOfPhoto;
@property(nonatomic,strong) ALAssetsLibrary *assetsLibrary;

-(void)sendAllPhotos;


@end
