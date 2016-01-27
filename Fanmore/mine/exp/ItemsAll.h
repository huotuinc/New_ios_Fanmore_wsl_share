//
//  ItemsAll.h
//  Fanmore
//
//  Created by Cai Jiang on 10/27/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#ifndef Fanmore_ItemsAll_h
#define Fanmore_ItemsAll_h

@protocol MyItemsUpdater <NSObject>

-(void)oneItemUpdate:(int)type count:(NSNumber*)count;

@end


#endif
