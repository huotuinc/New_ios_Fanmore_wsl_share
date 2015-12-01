//
//  PooCodeView.h
//  Fanmore
//
//  Created by Cai Jiang on 7/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PooCodeView : UIView

@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;

-(void)changeString:(NSString*)str;

@end
