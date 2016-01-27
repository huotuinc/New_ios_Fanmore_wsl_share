//
//  StoreCell.h
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FmTableCell.h"
#import "Store.h"

@interface StoreCell : FmTableCell
-(void)configureStore:(Store*)store;
@end
