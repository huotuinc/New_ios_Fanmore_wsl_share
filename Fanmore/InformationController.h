//
//  InformationController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"
#import "CYCustomMultiSelectPickerView.h"
#import "TextChangeController.h"
#import "LoginState.h"

@interface InformationController : UITableViewController<UITableViewDelegate,TextChangeDelegate>

@property(weak) UserInformation* user;
@property(weak) LoginState* loginData;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellName;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSex;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellBirth;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCarser;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellIncoming;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFavs;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellArea;
@property (weak, nonatomic) IBOutlet UILabel *labelRegtime;
@property (strong, nonatomic) IBOutlet UIDatePicker *dataPicker;
- (IBAction)touchupOutside:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UIImageView *imageSex;

@end
