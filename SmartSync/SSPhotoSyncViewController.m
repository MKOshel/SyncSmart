//
//  SSPhotoSyncViewController.m
//  SmartSync
//
//  Created by dragos on 1/23/14.
//  Copyright (c) 2014 Dragos Marinescu. All rights reserved.
//

#import "SSPhotoSyncViewController.h"
#import "SSPhoto.h"

@interface SSPhotoSyncViewController ()
{
    SSPhoto *ssPhoto;
}
@end

@implementation SSPhotoSyncViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ssPhoto = [[SSPhoto alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [self getCountOfPhotos];
    [super viewDidLoad];
    [self customizeView];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)uplodPhotos:(UIButton *)sender
{
    [NSThread detachNewThreadSelector:@selector(uploadPhotoData) toTarget:self withObject:nil];
}


-(void)uploadPhotoData
{
    [ssPhoto sendAllPhotos];
}


-(void)customizeView
{
    for (UIButton *button in self.view.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:212/255.0 green:0/255.0 blue:28/255.0 alpha:1]];
            button.layer.cornerRadius = 50.0;
            [button.titleLabel setFont:[UIFont fontWithName:@"Neris" size:17.0]];
        }
    }
    [_photoCountLabel setFont:[UIFont fontWithName:@"Neris" size:21.0]];

}

-(void)getCountOfPhotos
{
    NSUInteger __block imagesNo = 0;
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result != NULL) {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                imagesNo ++;
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                            _photoCountLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)imagesNo] stringByAppendingString:@"    total photos"];
                               });
            }
        }

    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
        
    };
    
    [ssPhoto.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock: ^(NSError *error) {
                                    NSLog(@"Failure");
                                }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
