//
//  FmTableCell.m
//  Fanmore
//
//  Created by Cai Jiang on 1/23/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"

@implementation FmTableCell

- (void)fminitialization{
    [self.layer setBorderWidth:5];
    [self.layer setBorderColor:fmTableBorderColor.CGColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self fminitialization];
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self fminitialization];
    return self;
}

- (id)init{
    self = [super init];
    [self fminitialization];
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self fminitialization];
    }
    return self;
}

@end
