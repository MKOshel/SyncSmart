//
//  SSLanguageViewController.m
//  SmartSync
//
//  Created by Oshel on 5/3/15.
//  Copyright (c) 2015 Dragos Marinescu. All rights reserved.
//

#import "SSLanguageViewController.h"
#import "SSAppDelegate.h"

@interface SSLanguageViewController ()
{
    
}
@end

@implementation SSLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _languages = (NSMutableArray*)@[@"English",@"Romanian",@"French",@"Chinese",@"Italian",@"German",@"Portuguese",@"Japanese",@"Russian",@"Spanish",@"Hebrew",@"Arabic"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _languages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _languages[indexPath.row];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];
    
    [appDelegate setSelectedLanguage:(int)indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = [appDelegate languageSelectedStringForKey:@"Select Language"];
    
    return title;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
