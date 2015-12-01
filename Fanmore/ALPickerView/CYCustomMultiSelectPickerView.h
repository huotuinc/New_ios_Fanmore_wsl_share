//
//  CYCustomMultiSelectPickerView.h
//  Courtyard1.1
//
//  Created by iZ on 13-1-21.
//
//

#import <UIKit/UIKit.h>
@protocol CYCustomMultiSelectPickerViewDelegate;

@interface CYCustomMultiSelectPickerView : UIView

@property (nonatomic, strong) NSMutableDictionary *selectionStatesDic;
@property (nonatomic, strong) NSArray *entriesArray;
@property (nonatomic, strong) NSArray *entriesSelectedArray;
@property (nonatomic, weak) id<CYCustomMultiSelectPickerViewDelegate> multiPickerDelegate;

- (void)pickerShow;
@end

@protocol CYCustomMultiSelectPickerViewDelegate <NSObject>
@required
-(void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr;
@end