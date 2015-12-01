//
//  MockDatas.h
//  Fanmore
//
//  Created by Cai Jiang on 1/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginState.h"
#import "LoadingState.h"
#import "Task.h"
#import "SendRecord.h"
#import "UserInformation.h"
#import "Contact.h"
#import "CashHistory.h"

@interface MockDatas : NSObject



@end

#ifdef FanmoreMock
@interface LoginState (Mock)
+(instancetype)mockLoginState;
@end


@interface LoadingState (Mock)
+(instancetype)mockLoadingState;
@end

@interface Task (Mock)
+(instancetype)mockTask;
+(instancetype)mockTask:(NSArray*)stores;
@end

@interface SendRecord (Mock)
+(instancetype)mockSendRecord;
@end

@interface UserInformation (Mock)
+(instancetype)mockUserInformation;
@end

@interface Contact (Mock)
+(instancetype)mockContact;
@end

@interface Store (Mock)
+(instancetype)mockStore;
+(instancetype)mockStore:(long)type;
@end

@interface CashHistory (Mock)
+(instancetype)mockCashHistory;
@end

#endif