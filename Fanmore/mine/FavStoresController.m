//
//  FavStoresController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FavStoresController.h"
#import "AppDelegate.h"
#import "Store.h"
#import "StoreCell.h"
#import "Paging.h"
#import "FavStoreDetailController.h"

@interface FavStoresController ()

@property NSArray* favStores;

@end

@implementation FavStoresController

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadGestureRecognizer];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.favStores==Nil) {
        self.favStores = [NSArray array];
    }
    
    id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
     [fos myFavoriteStoreList:Nil block:^(NSArray *stores, NSError *error) {
         self.favStores = stores;
         [self.tableView reloadData];
    } paging:[Paging paging:20 parameters:@{@"autoId":@0}]];    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    @try {
        NSIndexPath* selected = self.tableView.indexPathForSelectedRow;
        if ($safe(selected)) {
            Store* task = [self.favStores $at:selected.row];
            StoreCell *cell = (StoreCell*)[self.tableView cellForRowAtIndexPath:selected];
//            Task* task = [FMUtils dataBy:self.tasks section:selected.section andRow:selected.row];
            if ($safe(cell) && $safe(task)) {
                [cell configureStore:task];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favStores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreCell";
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell configureStore:[self.favStores $at:indexPath.row]];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isMemberOfClass:[StoreCell class]]) {
        @try {
            Store* task = [self.favStores $at:self.tableView.indexPathForSelectedRow.row];
            if ($safe(task)) {
                [[segue destinationViewController]passStore:task];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
}

@end
