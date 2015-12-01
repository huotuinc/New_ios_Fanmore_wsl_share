//
//  FMTableView.m
//  Fanmore
//
//  Created by Cai Jiang on 6/23/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FMTableView.h"

@implementation FMTableView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    [super drawRect:rect];
//    NSInteger rows = [self.dataSource tableView:self numberOfRowsInSection:0];
//    LOG(@"draw table in %f,%f,%f,%f with %d rows",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height,rows);
//    if (rows==0) {
//        CGRect irect = CGRectMake(rect.origin.x, rect.origin.y+64, rect.size.width, rect.size.height-64);
//        [[UIImage imageNamed:@"bg_empty"] drawInRect:irect];
//    }
//}
//
//-(void)reloadData{
//    [self setNeedsDisplay];
//    [super reloadData];
//}


@end
