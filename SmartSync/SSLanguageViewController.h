//
//  SSLanguageViewController.h
//  SmartSync
//
//  Created by Oshel on 5/3/15.
//  Copyright (c) 2015 Dragos Marinescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSLanguageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* languages;
@end
