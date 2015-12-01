//
//  ItemCell.h
//  Fanmore
//
//  Created by Cai Jiang on 10/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyItemHandler <NSObject>

@required
-(void)buyItem:(NSDictionary*)item;

@end

/**
 *  需要获知Items更新
 */
@protocol ItemsKnowlege <NSObject>

@required
-(void)itemsUpdate:(NSArray*)items myItems:(NSArray*)myItems;
-(NSArray*)returnMyItems;
-(NSArray*)returnItems;

@end

@interface NSDictionary (AllItemD)

-(UIImage*)getAllItemImage;
-(int)getAllItemType;
-(NSString*)getAllItemName;
-(NSString*)getAllItemDesc;
-(NSNumber*)getAllItemPrice;
-(NSNumber*)getAllItemStoreTotal;
-(NSNumber*)getAllItemStore;

-(NSDictionary*)newItemNewCount:(NSNumber*)count;

@end

@interface NSDictionary (MyItemD)

-(NSNumber*)getMyItemAmount;

@end

@interface ItemCell : UITableViewCell
@property(weak) id<BuyItemHandler> handler;

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UIButton *button;

-(void)configData:(NSDictionary*)data path:(NSIndexPath *)indexPath;

@end

@interface MyItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;


@end
