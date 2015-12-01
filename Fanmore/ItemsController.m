//
//  ItemsController.m
//  Fanmore
//
//  Created by Cai Jiang on 10/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ItemsController.h"
#import "FMUtils.h"
#import "AppDelegate.h"
#import "ItemCell.h"
#import "BugItemView.h"
#import "BlocksKit+UIKit.h"
#import "ItemsAll.h"

@interface ItemsController ()<UITableViewDataSource,UITableViewDelegate,BuyItemHandler,ItemsKnowlege,MyItemsUpdater>

@property NSArray* items;
@property NSArray* myItems;

@property(weak) BugItemView* buyView;

@property BOOL aming;

@end

@implementation ItemsController

-(NSArray*)returnItems{
    return self.items;
}

-(NSArray*)returnMyItems{
    return self.myItems;
}

-(void)oneItemUpdate:(int)type count:(NSNumber *)count{
    NSMutableArray* newitems = [[NSMutableArray alloc] init];
    for (NSDictionary* item in self.myItems) {
        if ([item getAllItemType]==type) {
            if (count && [count intValue]>0) {
                [newitems addObject:[item newItemNewCount:count]];
            }
        }else{
            [newitems addObject:item];
        }
    }
    self.myItems = [NSArray arrayWithArray:newitems];
    [self itemsUpdateMyUI];
}

-(void)toggleMyItem:(BOOL)show{
    __weak ItemsController* wself = self;
    if (show && self.viewMyitem.frame.size.height>0) {
        return;
    }
    if (!show && self.viewMyitem.frame.size.height==0) {
        return;
    }
    if (show && self.myItems.count==0) {
        return;
    }
    if (self.aming) {
        return;
    }
    self.aming = YES;
    [UIView animateWithDuration:0.5 animations:^{
        if (show) {
            CGRect frame = wself.viewMyitem.frame;
            [wself.viewMyitem setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 121)];
            frame = wself.tableAllItem.frame;
            [wself.tableAllItem setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-121)];
            [wself.labelItemMark offset:0 y:121];
            [wself.tableAllItem offset:0 y:121];
        }else{
            CGRect frame = wself.viewMyitem.frame;
            [wself.viewMyitem setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)];
            frame = wself.tableAllItem.frame;
            [wself.tableAllItem setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+121)];
            [wself.labelItemMark offset:0 y:-121];
            [wself.tableAllItem offset:0 y:-121];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if (show) {
                [wself.labelMyitemIg setText:@"⬆︎"];
            }else{
                [wself.labelMyitemIg setText:@"⬇︎"];
            }
        }
        wself.aming = NO;
    }];
}

-(void)itemsUpdateMyUI{
    
    __weak ItemsController* wself = self;
    
    [[self.viewMyitem subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i=0; i<self.myItems.count; i++) {
        NSDictionary* data = self.myItems[i];
        
        UIView* sv = [[UIView alloc] initWithFrame:CGRectMake(i*80, 0, 80, 121)];
        
        [self.viewMyitem addSubview:sv];
        
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 74, 74)];
        [image setImage:[data getAllItemImage]];
        [sv addSubview:image];
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 82, 43, 17)];
        [image setImage:[UIImage imageNamed:@"daojubg"]];
        [sv addSubview:image];
        
        UILabel* label = [[UILabel alloc] initWithFrame:image.frame];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        [label setText:$str(@"+%@",[data getMyItemAmount])];
        [sv addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, 80, 11)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setText:[data getAllItemName]];
        [sv addSubview:label];
        
        sv.userInteractionEnabled = YES;
        switch ([data getAllItemType]) {
            case 1:
                // 摇徒弟
            {[
              sv bk_whenTapped:^{
                  [wself performSegueWithIdentifier:@"ToYao" sender:nil];
              }];}
                break;
            case 2:
                // 抽奖
            {[
              sv bk_whenTapped:^{
                  [wself performSegueWithIdentifier:@"ToKickme" sender:nil];
              }];}
                break;
            case 3:
                // 任务转发次数
                // desc;转发任务时直接使用
            {[
              sv bk_whenTapped:^{
                  [FMUtils alertMessage:wself.view msg:$str(@"%@；可在转发任务时直接使用。",[data getAllItemDesc])];
              }];}
                break;
            case 4:
            {[
              sv bk_whenTapped:^{
                  [wself performSegueWithIdentifier:@"ToPreview" sender:nil];
              }];}
                // 任务提前浏览
                break;
        }
    }
    
    [self.viewMyitem setContentSize:CGSizeMake(self.myItems.count*80+10, 121)];
    
    if (self.myItems.count==0) {
        [self toggleMyItem:NO];
    }else{
        [self toggleMyItem:YES];
    }
    
    //

}

-(void)itemsUpdate:(NSArray *)items myItems:(NSArray *)myItems{
    
    [self.view stopIndicator];
    
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    [self.labelExp setText:$str(@"EXP. %@",ls.exp)];
    
    self.myItems = myItems;
    self.items = items;
    [self.tableAllItem reloadData];
    [self itemsUpdateMyUI];
    
//    [self.tableMyitem reloadData];
}

-(void)buyItem:(NSDictionary *)item{
    // 出现 遮罩 然后什么什么
    if (self.buyView) {
        return;
    }
    BugItemView* view = [[NSBundle mainBundle] loadNibNamed:@"BugItemView" owner:nil options:nil][0];
    view.handler = self;
    [view show:self item:item];
    self.buyView = view;
}

-(void)reloadData{
    __weak ItemsController* wself = self;
    [[[AppDelegate getInstance] getFanOperations] itemList:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            [wself performSelector:@selector(reloadData) withObject:nil afterDelay:5];
            return;
        }
        [wself itemsUpdate:items myItems:myItems];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    [self.labelMyitemIg setText:@"⬆︎"];
    
    UIView* vv = [[UIView alloc] initWithFrame:self.viewTop.frame];
    vv.backgroundColor = [UIColor colorWithHexString:@"#ff4200"];
    
    UIImageView* ivv = [[UIImageView alloc] initWithFrame:self.imagePicture.frame];
    [ivv setImage:self.imagePicture.image];
    [self.imagePicture removeFromSuperview];
    [vv addSubview:ivv];
    self.imagePicture = ivv;
    
    ivv = [[UIImageView alloc] initWithFrame:self.imageMaskTopView.frame];
    [ivv setImage:self.imageMaskTopView.image];
    [self.imageMaskTopView removeFromSuperview];
    [vv addSubview:ivv];
    self.imageMaskTopView = ivv;
    
    ivv = [[UIImageView alloc] initWithFrame:self.imageJTTopView.frame];
    [ivv setImage:self.imageJTTopView.image];
    [self.imageJTTopView removeFromSuperview];
    [vv addSubview:ivv];
    self.imageJTTopView = ivv;
    
    self.labelExp = [self.labelExp cloneLabel:vv];
//    UILabel* ilv = [[UILabel alloc] initWithFrame:self.labelExp.frame];
//    [ilv setTextColor:self.labelExp.textColor];
//    [ilv setFont:self.labelExp.font];
//    [self.labelExp removeFromSuperview];
//    [vv addSubview:ilv];
//    self.labelExp = ilv;
    
    [self.viewTop removeFromSuperview];
    [self.view addSubview:vv];
    self.viewTop = vv;
    CGFloat y = [self topY];
    
    [self.viewTop setFrame:CGRectMake(0, y, 320, 46)];
    y += 46;
    
    self.labelMyitem = [self.labelMyitem cloneLabel:self.view];
    self.labelMyitemIg = [self.labelMyitemIg cloneLabel:self.view];
    
    [self.labelMyitem moveToY:y];
    [self.labelMyitemIg moveToY:y];
    
    y+= 35;
    
    UIScrollView* svv = [[UIScrollView alloc] initWithFrame:self.viewMyitem.frame];
    [self.viewMyitem removeFromSuperview];
    [self.view addSubview:svv];
    self.viewMyitem = svv;
    
    [self.viewMyitem moveToY:y];
    
    y += 121;
    
    self.labelItemMark = [self.labelItemMark cloneLabel:self.view];
    
    [self.labelItemMark moveToY:y];
    y+= 35;
    
    
    UITableView* tvv = [[UITableView alloc] initWithFrame:self.tableAllItem.frame style:UITableViewStylePlain];
    [tvv registerClass:[ItemCell class] forCellReuseIdentifier:@"ItemCell"];
    tvv.rowHeight = self.tableAllItem.rowHeight;
    [self.tableAllItem removeFromSuperview];
    [self.view addSubview:tvv];
    self.tableAllItem = tvv;
    // 剩余的所有
    CGFloat left = self.view.frame.size.height-y;
    [self.tableAllItem setFrame:CGRectMake(0, y, 320, left)];
    
    __weak ItemsController* wself = self;
    
//    UserInformation* ui =[AppDelegate getInstance].currentUser;
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    
    [ls updateUserPicture:self.imagePicture];
    
    self.tableAllItem.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableAllItem.delegate = self;
    self.tableAllItem.dataSource = self;
    
    self.labelExp.userInteractionEnabled = YES;
    [self.labelExp bk_whenTapped:^{
        [wself performSegueWithIdentifier:@"ToHistory" sender:nil];
    }];
    self.viewTop.userInteractionEnabled = YES;
    [self.viewTop bk_whenTapped:^{
        [wself performSegueWithIdentifier:@"ToHistory" sender:nil];
    }];
    
    self.maskView.userInteractionEnabled = YES;
    [self.maskView bk_whenTapped:^{
        [wself performSegueWithIdentifier:@"ToHistory" sender:nil];
    }];
    
    self.labelMyitem.userInteractionEnabled = YES;
    self.labelMyitemIg.userInteractionEnabled = YES;
    [self.labelMyitem bk_whenTapped:^{
        [wself toggleMyItem:wself.viewMyitem.frame.size.height==0];
    }];
    [self.labelMyitemIg bk_whenTapped:^{
        [wself toggleMyItem:wself.viewMyitem.frame.size.height==0];
    }];
    
    [self.view startIndicator];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.tableAllItem) {
        return self.items.count;
    }
    return self.myItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableAllItem) {
        ItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        cell.handler = self;
        [cell configData:self.items[indexPath.row] path:indexPath];
        return cell;
    }
    
    NSDictionary* data = self.myItems[indexPath.row];
    MyItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyItemCell" forIndexPath:indexPath];
    [cell.imageItem setImage:[data getAllItemImage]];
    [cell.labelDesc setText:[data getAllItemName]];
    [cell.labelCount setText:$str(@"+%@",[data getMyItemAmount])];
//    cell.backgroundColor = [UIColor colorWithHexString:$str(@"%6d",indexPath.row*89)];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableAllItem) {
        NSDictionary* item =self.items[indexPath.row];
        int store = [[item getAllItemStoreTotal] intValue];
        if(store!=-1 && [[item getAllItemStore] intValue]<=0){
            return;
        }
        
        [self buyItem:item];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickHistory:(id)sender {
    [FMUtils toToolRuleController:self attach:@"#daojumimi"];
}
- (IBAction)clickRight:(id)sender {
    [FMUtils toToolRuleController:self attach:@"#daojumimi"];
}
@end
