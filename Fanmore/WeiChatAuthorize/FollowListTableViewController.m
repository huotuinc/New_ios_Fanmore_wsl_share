//
//  FollowListTableViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/11.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//  徒弟列表

#import "FollowListTableViewController.h"
#import "AppDelegate.h"
#import "FollowList.h"
#import "MJExtension.h"
#import "FollowModel.h"

@interface FollowListTableViewController ()


@property(nonatomic,strong)NSNumber * numbersOfFollowers;

/**徒弟列表*/
@property(nonatomic,strong)NSMutableArray * lists;

/**徒弟列表*/
@property(nonatomic,strong) NSIndexPath * lastIndexPath;

@end

@implementation FollowListTableViewController




- (NSIndexPath *)lastIndexPath{
    if (_lastIndexPath == nil) {
        _lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return _lastIndexPath;
}

- (NSMutableArray *)lists{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{
    __weak FollowListTableViewController * wself = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"徒弟列表";
    id<FanOperations> fos = [[AppDelegate getInstance]getFanOperations];
    [fos followerList:nil block:^(NSNumber *numbersOfFollowers, NSArray *list, NSError *error) {
       
        NSLog(@"%@-----%@",numbersOfFollowers,list);
        
        NSArray * aa = [FollowModel objectArrayWithKeyValuesArray:list];
        [wself ToGroupList:aa];
       
        
    } orderType:1 paging:[Paging paging:10 parameters:@{@"pageTag": @(0)}]];
    
};



- (void)setupRefresh{
    
    
    
    
    
    
}

/**
 *  分组
 *
 *  @param list <#list description#>
 */
- (void)ToGroupList:(NSArray * )list{
    
    for (int i = 0; i<list.count; i++) {
        
        FollowList * mod = [[FollowList alloc] init];
        mod.groupId = i;
        NSMutableArray * marra = [NSMutableArray array];
        [marra addObject:list[i]];
        mod.list = marra;
        
        [self.lists addObject:mod];
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSLog(@"%lu",(unsigned long)self.lists.count);
    return self.lists.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FollowList * ss = self.lists[section];
    NSLog(@"%lu",(unsigned long)ss.list.count);

    return ss.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString * reide = @"reide";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reide];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reide];
            UIImageView * arrView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            arrView.image = [UIImage imageNamed:@"upArrow"];
            cell.accessoryView = arrView;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        
        FollowList * fol =  self.lists[indexPath.section];
        FollowModel * mod = (FollowModel *)fol.list[0];
        cell.imageView.image = [UIImage imageNamed:@"WeiXinIIconViewDefaule"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"我的徒弟%@",mod.userName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"昨日/历史总贡献: %d/%d积分",[mod.recentScore integerValue],[mod.totalScore integerValue]];

        return cell;
        
        

    }else{
        static NSString * reidess = @"reidessssss";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reidess];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reidess];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }
        FollowList * fol =  self.lists[indexPath.section];
        FollowModel * mod = (FollowModel *)fol.list[1];
        cell.textLabel.text = [NSString stringWithFormat:@"昨日浏览/转发量: %d/%d次",[mod.yesterdayBrowseAmount integerValue],[mod.yesterdayTurnAmount integerValue]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"历史浏览/转发量: %d/%d次",[mod.historyTotalBrowseAmount integerValue],[mod.historyTotalTurnAmount integerValue]];
        return cell;
    }
}

#pragma mark - Table view data delegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%d----%d",indexPath.section,indexPath.row);
    
    
    
    
    if (self.lastIndexPath.section == indexPath.section) {
        
        UITableViewCell * cella = [tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell * cellb = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        FollowList * fol = self.lists[indexPath.section];
        if (fol.list.count > 1) {
            [fol.list removeObjectAtIndex:1];
            
             UIImageView *aa = (UIImageView *)cellb.accessoryView;
             aa.image = [UIImage imageNamed:@"upArrow"];
            self.lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        }else{
            
            FollowModel * mod = fol.list[0];
            [fol.list addObject:mod];
            UIImageView *aa = (UIImageView *)cella.accessoryView;
            aa.image = [UIImage imageNamed:@"downArrow"];
            self.lastIndexPath = indexPath;
        }
        
        [self.tableView reloadData];

        return;
        
    }
    
    
    UITableViewCell * cella = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell * cellb = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    
    
    FollowList * fol = self.lists[indexPath.section];
    FollowModel * mod = fol.list[0];
    [fol.list addObject:mod];
    UIImageView *aa = (UIImageView *)cella.accessoryView;
    aa.image = [UIImage imageNamed:@"downArrow"];

    if (indexPath.section != self.lastIndexPath.section && self.lastIndexPath.section >= 0) {
        
        FollowList * fols = self.lists[self.lastIndexPath.section];
        if (fols.list.count == 2) {
            
            [fols.list removeObjectAtIndex:1];
            UIImageView *aa = (UIImageView *)cellb.accessoryView;
            aa.image = [UIImage imageNamed:@"upArrow"];
            
        }
    }
    
    self.lastIndexPath = indexPath;
    
    [self.tableView reloadData];
    
    
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
