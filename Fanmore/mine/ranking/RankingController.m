//
//  RankingController.m
//  Fanmore
//
//  Created by Cai Jiang on 9/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "RankingController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "RankingCell.h"

@interface RankingController ()<UITableViewDelegate,UITableViewDataSource>

@property UIImage* tempImage;
@property(strong) NSArray* ranking;
@property uint type;
@property NSNumber* myrank;

@end

@implementation RankingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)changeType:(uint)type{
    if (self.type==type) {
        return;
    }
    self.type = type;
    
    [self.bar1Image hidenme];
    [self.bar2Image hidenme];
    [self.bar3Image hidenme];
    [self.bar1Label setTextColor:[UIColor whiteColor]];
    [self.bar2Label setTextColor:[UIColor whiteColor]];
    [self.bar3Label setTextColor:[UIColor whiteColor]];
    
    switch (self.type) {
        case 1:
            [self.bar1Image showme];
            [self.bar1Label setTextColor:fmMainColor];
            break;
        case 2:
            [self.bar2Image showme];
            [self.bar2Label setTextColor:fmMainColor];
            break;
        case 3:
            [self.bar3Image showme];
            [self.bar3Label setTextColor:fmMainColor];
            break;
        default:
            break;
    }
    
    __weak RankingController* wself = self;
    
    [[[AppDelegate getInstance] getFanOperations] ranking:nil block:^(NSNumber *myrank, NSString *desc, NSArray *list, NSError *error) {
        
        [wself.labelDesc setText:desc];
        if (!desc || desc.length<=0) {
            NSLayoutConstraint* asd = [wself.labelDesc constraints][0];
            asd.constant = 10;
        }else{
            NSLayoutConstraint* asd = [wself.labelDesc constraints][0];
            asd.constant = 30;
        }
        wself.ranking = list;
        wself.myrank = myrank;
        [wself.tableView reloadData];
        
    } type:self.type];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self viewDidLoadGestureRecognizer];
    [self viewDidLoadFanmore];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.ranking==Nil) {
        self.ranking = $new(NSArray);
    }
    
    __weak RankingController* wself = self;
    
    [self.bar1Label setUserInteractionEnabled:YES];
    [self.bar1Image setUserInteractionEnabled:YES];
    [self.bar2Label setUserInteractionEnabled:YES];
    [self.bar2Image setUserInteractionEnabled:YES];
    [self.bar3Label setUserInteractionEnabled:YES];
    [self.bar3Image setUserInteractionEnabled:YES];
    
    [self.bar1Label bk_whenTapped:^{
        [wself changeType:1];
    }];
    [self.bar1Image bk_whenTapped:^{
        [wself changeType:1];
    }];
    [self.bar2Label bk_whenTapped:^{
        [wself changeType:2];
    }];
    [self.bar2Image bk_whenTapped:^{
        [wself changeType:2];
    }];
    [self.bar3Label bk_whenTapped:^{
        [wself changeType:3];
    }];
    [self.bar3Image bk_whenTapped:^{
        [wself changeType:3];
    }];
    
    [self changeType:1];
    
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    for (int i = 0; i < 2; i++) {
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        swipeRecognizer.direction = (i == 0 ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft);
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    
//    [self.view addGestureRecognizer:[UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)sender;
//        if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
//            if (wself.type<=1) {
//                [wself doBack];
//            }else{
//                [wself changeType:wself.type-1];
//            }
//        }else if (ssender.direction==UISwipeGestureRecognizerDirectionLeft){
//            if (wself.type<3) {
//                [wself changeType:wself.type+1];
//            }
//        }
//    }]];
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer{
    UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)gestureRecognizer;
    if (ssender.direction==UISwipeGestureRecognizerDirectionLeft){
        if (self.type<3) {
            [self changeType:self.type+1];
        }
    }
    if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
        if (self.type<=1) {
            [self doBack];
        }else{
            [self changeType:self.type-1];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self showNoshadowNavigationBar];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ranking.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RankingCell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        [cell config:indexPath.row myrank:self.myrank data:self.ranking[indexPath.row] type:self.type];
//        [cell config:self.sls[indexPath.row]];
    }
    @catch (NSException *exception) {
        LOG(@"Exception %@",exception);
    }
    @finally {
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
