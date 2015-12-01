//
//  UserInformation.h
//  Fanmore
//
//  Created by Cai Jiang on 2/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanmoreModel.h"


@interface UserInformation : FanmoreModel

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSDate * birth;
@property (nonatomic, retain) NSNumber * industryId;
@property (nonatomic, retain) NSString* favoritesStr;
@property (nonatomic, retain) NSArray* contacts;
@property (nonatomic, retain) NSNumber * incomeId;
@property (nonatomic, retain) NSString * area;

//@property (nonatomic, retain) NSNumber * exp;
//@property (nonatomic, retain) NSNumber * rewarded;
//@property (nonatomic, retain) NSString * pictureURL;




@end
