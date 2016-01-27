//
//  LayoutContext.m
//  Fanmore
//
//  Created by Cai Jiang on 2/12/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LayoutContext.h"

@interface LayoutContext()
//@property NSMutableDictionary* metrics;
@end

@implementation LayoutContext

//@synthesize views;
//@synthesize metrics;

-(id)init{
    self = [super init];
    _metrics = [NSMutableDictionary dictionary];
    _views = [NSMutableDictionary dictionary];
    return self;
}

+(instancetype)contextByView:(UIView*)view{
    LayoutContext* context = $new(self);
    context.parent = view;
    [context addView:@"_parent" view:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return context;
}

-(instancetype)addMetrics:(NSDictionary *)metrics{
    [self.metrics addEntriesFromDictionary:metrics];
    return self;
}
-(instancetype)addMetirc:(NSString*)name number:(NSNumber*)number{
    [self.metrics setValue:number forKey:name];
    return self;
}
-(instancetype)addViews:(NSDictionary *)views{
    [self.views addEntriesFromDictionary:views];
    return self;
}
-(instancetype)addView:(NSString*)name view:(UIView*)view{
    [self.views setValue:view forKey:name];
    return self;
}
-(instancetype)addLayoutConstraint:(NSLayoutConstraint*)constraint{
    [self.parent addConstraint:constraint];
    return self;
}
-(instancetype)addLayoutConstraint:(NSString*)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(NSString*)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c{
    [self.parent addConstraint:[NSLayoutConstraint constraintWithItem:[self.views $for:view1] attribute:attr1 relatedBy:relation toItem:[self.views $for:view2] attribute:attr2 multiplier:multiplier constant:c]];
    return self;
}

-(instancetype)visualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts{
    [self.parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:self.metrics views:self.views]];
    return self;
}

-(void)commit{
}

#pragma mark - equals
-(instancetype)equalsAtt:(NSString*)view1 view2:(NSString*)view2 attri:(NSLayoutAttribute)attri{
    [self addLayoutConstraint:view1 attribute:attri relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attri multiplier:1 constant:0];
    return self;
}

-(instancetype)equalsRight:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeRight];
}
-(instancetype)equalsTop:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeTop];
}
-(instancetype)equalsBottom:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeBottom];
}
-(instancetype)equalsLeft:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeLeft];
}
-(instancetype)equalsLeading:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeLeading];
}
-(instancetype)equalsTrailing:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeTrailing];
}
-(instancetype)equalsWidth:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeWidth];
}
-(instancetype)equalsHeight:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeHeight];
}
-(instancetype)equalsCenterY:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeCenterY];
}
-(instancetype)equalsCenterX:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeCenterX];
}
-(instancetype)equalsBaseline:(NSString*)view1 view2:(NSString*)view2{
    return [self equalsAtt:view1 view2:view2 attri:NSLayoutAttributeBaseline];
}

@end
