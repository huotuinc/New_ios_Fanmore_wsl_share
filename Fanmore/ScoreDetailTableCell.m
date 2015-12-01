//
//  ScoreDetailTableCell.m
//  Fanmore
//
//  Created by Cai Jiang on 6/13/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ScoreDetailTableCell.h"
#import "ScoreDetailComment.h"

@interface ScoreDetailTableCell ()

//@property BOOL iright;
@property(weak) UILabel* labelBrowse;
@property(weak) UILabel* labelDate;
@property(weak) ScoreDetailComment* labelComment;
@property(weak) UILabel* labelScore;

@property(weak) UIImageView* imageTop;
@property(weak) UIImageView* imageG;

@end

@implementation ScoreDetailTableCell

//static BOOL _scoreDetailCellright = YES;
CGFloat _scoreDetailCellheight = 90.0f;
CGFloat _scoreDetailCellcyraid = 27.0f;
CGFloat _scoreDetailCell_gap = 3.0f;
CGFloat _scoreDetailCell_line_width = 2.0f;
- (void)fminitialization{
    
//    self.backgroundColor = [UIColor blueColor];
    
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]+2];
    [self addSubview:label];
    self.labelBrowse = label;
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]+2];
    [self addSubview:label];
    self.labelDate = label;
    
    
//    label = [[UILabel alloc] init];
//    label.textColor = [UIColor lightGrayColor];
//    label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
//    label.lineBreakMode = NSLineBreakByCharWrapping;
//    label.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:label];
//    self.labelComment = label;
    ScoreDetailComment* comment = [[ScoreDetailComment alloc] init];
    [self addSubview:comment];
    self.labelComment = comment;
    
    CGFloat lineX = 160.0f-_scoreDetailCell_line_width/2.0f;
    CGFloat lineHeight = _scoreDetailCellheight/2.0f-_scoreDetailCellcyraid;
    
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(lineX, -1, _scoreDetailCell_line_width, lineHeight+2.0f)];
    image.image = [UIImage imageNamed:@"xian"];
    [self addSubview:image];
    self.imageTop = image;
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(lineX, _scoreDetailCellheight-lineHeight, _scoreDetailCell_line_width, lineHeight+2.0f)];
    image.image = [UIImage imageNamed:@"xian"];
    [self addSubview:image];
//    self.imageTop = image;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(160.0f-_scoreDetailCellcyraid, (_scoreDetailCellheight-_scoreDetailCellcyraid*2.0f)/2.0f, _scoreDetailCellcyraid*2.0f, _scoreDetailCellcyraid*2.0f)];
    [self addSubview:image];
    self.imageG = image;
    
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightTextColor];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    [self addSubview:label];
    self.labelScore = label;
}

-(void)configureDay:(ScorePerDay*)day  index:(NSInteger)index{
    
    if (day.time) {
        [self.subviews makeObjectsPerformSelector:@selector(showme)];
    }else{
        //无效！
        [self.subviews makeObjectsPerformSelector:@selector(hidenme)];
        return;
    }
    
    
    [self.labelBrowse setText:$str(@"浏览量：%@",day.browse)];
    [self.labelDate setText:[day.time fmStandStringDateOnlyDot]];
    
    CGSize commentSize = [self.labelComment draw:index%2==0 text:[day listComments]];
    
    if (commentSize.height>0) {
        CGFloat x;
        if (index%2==0) {
            x = 160.0f-_scoreDetailCellcyraid-commentSize.width;
        }else{
            x = 160.0f+_scoreDetailCellcyraid;
        }
        
        CGFloat y = (_scoreDetailCellheight-commentSize.height)/2.0f;
        
        [self.labelComment setFrame:CGRectMake(x, y, commentSize.width, commentSize.height)];
        [self.labelComment setNeedsDisplay];
    }else{
        self.labelComment.hidden = YES;
    }
//    
//    NSArray* comments = [day listComments];
//    if(comments && comments.count>0 && ((NSString*)comments[0]).length>0){
//        //babababa
//        CGFloat x;
//        if (index%2==0) {
//            x = _scoreDetailCell_gap;
//        }else{
//            x = 160.0f+_scoreDetailCellcyraid+_scoreDetailCell_gap;
//        }
//        
////        x += 11.0f;
//        
//        NSMutableString* buffer = [NSMutableString string];
//        [buffer appendString:comments[0]];
//        for (int i=1; i<comments.count; i++) {
//            [buffer appendFormat:@"\n%@",comments[i]];
//        }
//        
//        CGSize size = [buffer sizeWithFont:self.labelComment.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:self.labelComment.lineBreakMode];
//        
//        CGFloat y = (_scoreDetailCellheight-size.height)/2.0f;
//        
//        
//        [self.labelComment setText:buffer];
//        self.labelComment.numberOfLines = comments.count;
//        
//        self.labelComment.hidden = NO;
//    }else{
//        self.labelComment.hidden = YES;
//    }
    
    CGSize browseSize = [self.labelBrowse.text sizeWithFont:self.labelBrowse.font];
    
    CGFloat x;
    if (index%2==0) {
        x = 320.0f/2.0f+_scoreDetailCellcyraid + _scoreDetailCell_gap;
    }else{
//        x = _scoreDetailCell_gap;
        CGSize dateSize = [self.labelDate.text sizeWithFont:self.labelDate.font];
        CGFloat maxW = MAX(dateSize.width,browseSize.width);
        x = 160.0f-_scoreDetailCellcyraid-_scoreDetailCell_gap-maxW;
        if (x<0) {
            x +=_scoreDetailCell_gap;
        }
    }
    CGFloat y = _scoreDetailCellheight/2.0f - browseSize.height;
    [self.labelBrowse setFrame:CGRectMake(x, y, 140.0f, browseSize.height)];
    [self.labelDate setFrame:CGRectMake(x, _scoreDetailCellheight/2.0f, 140.0f, browseSize.height)];
    
    
    if (self.focuxed) {
        self.imageG.image = [UIImage imageNamed:@"g2"];
    }else{
        self.imageG.image = [UIImage imageNamed:@"g"];
    }
    
    NSString* scoreStr = [day.score currencyString:@"" fractionDigits:0];
    CGSize scoreSize = [scoreStr sizeWithFont:self.labelScore.font];
    [self.labelScore centerIn:CGSizeMake(320.0f, _scoreDetailCellheight) as:scoreSize];
    [self.labelScore setText:scoreStr];
}

-(void)setFocuxed:(BOOL)focuxed{
//    LOG(@"setFocuxed %d",focuxed);
    _focuxed = focuxed;
    
    if (_focuxed) {
        self.imageG.image = [UIImage imageNamed:@"g2"];
    }else{
        self.imageG.image = [UIImage imageNamed:@"g"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
