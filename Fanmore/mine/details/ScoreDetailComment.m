//
//  ScoreDetailComment.m
//  Fanmore
//
//  Created by Cai Jiang on 6/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ScoreDetailComment.h"

@interface ScoreDetailComment ()

@property UIFont* font;
@property UIColor* color;
@property NSLineBreakMode lineMode;

@property BOOL side;
@property NSString* text;

@end

//extern CGFloat _scoreDetailCell_gap;
CGFloat _ScoreDetailComment_gap = 8.0f;


@implementation ScoreDetailComment

-(id)init{
    self = [super init];
    if (self) {
        self.lineMode = NSLineBreakByWordWrapping;
        self.color = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(CGSize)acturlSize{
    CGFloat max = 130.0f;
    return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(max-20.0f, MAXFLOAT) lineBreakMode:self.lineMode];
}

-(CGSize)draw:(BOOL)side text:(NSArray*)text{
    
    
    if (!text || text.count==0) {
        return CGSizeMake(0, 0);
    }
    
    NSString* first = text[0];
    if (first.length==0) {
        return CGSizeMake(0, 0);
    }
    
    NSMutableString* buffer = [NSMutableString string];
    [buffer appendString:first];
    for (int i=1; i<text.count; i++) {
        [buffer appendFormat:@"\n%@",text[i]];
    }
    
    self.side = side;
    self.text  = buffer;
    
    CGSize size = [self acturlSize];
    
//    CGFloat padding = 5.0f;
    return CGSizeMake(size.width+20, size.height+2*_ScoreDetailComment_gap);
//    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image;
    if (self.side) {
        image = [UIImage imageNamed:@"popop"].CGImage;
    }else{
        image = [UIImage imageNamed:@"popopb"].CGImage;
    }
    
    if (!$safe(self.text)) {
        return;
    }
    
    CGContextDrawImage(context, rect, image);
    
    CGSize size = [self acturlSize];
    
//    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    
    
    [self.text drawInRect:CGRectMake(self.side?9.0f:6.0f+(size.width/130.0f)*12.0f, _ScoreDetailComment_gap, size.width, size.height) withFont:self.font lineBreakMode:self.lineMode];
//    [self.text drawInRect:CGRectMake(self.side?15.0f:20.0f, _ScoreDetailComment_gap, size.width, size.height) withFont:self.font];
}

@end
