//
//  InformationController.m
//  Fanmore
//
//  Created by Cai Jiang on 2/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "InformationController.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "LayoutContext.h"
#import "InputController.h"
#import "RegexKitLite.h"
#import "FMUtils.h"
#import "ImagePicker.h"

@interface PickManager : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property NSArray* keys;
+(instancetype)manager:(NSDictionary*)dict;

@end

@interface InformationController ()<ImagePickerDelegate>

@property UIPickerView* uipicker;

@property PickManager* industry;
@property PickManager* incoming;
@property ImagePicker* picker;

@end

@implementation InformationController

//@synthesize user;

-(void)displayValues{
    
    AppDelegate* ad = [AppDelegate getInstance];
    
    self.loginData = ad.loadingState.userData;
    self.user = ad.currentUser;
    
    self.labelRegtime.text =[ad.loadingState.userData.regTime fmStandStringDateOnly];
    self.cellArea.detailTextLabel.text = self.user.area;
    
    self.industry = [PickManager manager:ad.industryList];
    self.incoming = [PickManager manager:ad.incomeList];
    //    self.favs = [PickManager manager:ad.favoriteList];
    
    self.cellName.detailTextLabel.text = self.user.name;
    //    self.cellSex.detailTextLabel.text = [self.user sexLabel];
    [self.imageSex setImage:[self.user sexImage]];
    [self.loginData updateUserPicture:self.imagePicture];
    self.cellBirth.detailTextLabel.text = [self.user.birth fmStandStringDateOnly];
    self.cellCarser.detailTextLabel.text = [self.user industryLabel];
    self.cellIncoming.detailTextLabel.text = [self.user incomeLabel];
    self.cellFavs.detailTextLabel.text = [self.user favoritesLabel];
}

-(void)synUser{
    __weak InformationController* wself = self;
    
    AppDelegate* ad = [AppDelegate getInstance];
    
    [[ad getFanOperations] updateUserInfo:nil block:^(NSString *a, NSError *b) {
        [[ad getFanOperations] login:nil block:^(LoginState *login, NSError *error) {
            if ($safe(error)) {
                NSLog(@"error on updateuser %@",error);
                [FMUtils alertMessage:self.view msg:@"服务器繁忙，请稍后再试！"];
                return;
            }
            [wself displayValues];
            [FMUtils alertMessage:self.view msg:@"修改成功！"];
        } userName:[ad getLastUsername] password:[ad getLastPassword]];
    } user:self.user];
    
//    [self viewWillAppear:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
    self.user = nil;
}

-(void)docheckcomple{
    if (![self.loginData.completeInfo boolValue]) {
        [FMUtils alertMessage:self.view msg:@"完善用户资料可以获得经验奖励！"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self viewDidLoadGestureRecognizer];
    
    [self displayValues];
    
    [self performSelector:@selector(docheckcomple) withObject:nil afterDelay:2];
}

-(void)submitText:(NSString*)str{
    self.user.name = str;
    [self synUser];
}
-(void)initText:(UITextField*)text andHint:(UILabel*)label{
    text.text = self.user.name;
    label.text = @"";
}
-(BOOL)textChanged:(UITextField*)text OnHint:(UILabel*)label{
    if (text.text.length>=2) {
        return YES;
    }
    [FMUtils alertMessage:self.view msg:@"无效的姓名，请重新输入" block:^{
        [text shake];
    }];
    return NO;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ($eql(@"ToChangeName",segue.identifier)) {
        TextChangeController* tc = segue.destinationViewController;
        tc.delegate = self;
    }
}

-(void)updatePicture:(UIImage*)image{
    __weak InformationController* wself = self;
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [self.imagePicture setImage:image];
    [[[AppDelegate getInstance] getFanOperations] uploadPicture:nil block:^(NSString *tip, NSError *error) {
        LOG(@"%@ %@",tip,[error FMDescription]);
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
        }
        [wself synUser];
    } image:image];
}

- (UIViewController*)viewControllerToDisplayImagePicker:(ImagePicker*)_ImagePicker{
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    return self;
}

- (void)imagePicker:(ImagePicker*)_ImagePicker DidFinishPickingImageFromCamera:(UIImage*)_Image{
    [self updatePicture:_Image];
}
- (void)imagePicker:(ImagePicker*)_ImagePicker DidFinishPickingImageFromGallery:(UIImage*)_Image{
    [self updatePicture:_Image];
}
- (void)imagePickerDeleteImage:(ImagePicker*)_ImagePicker{
}
- (void)imagePickerCancel:(ImagePicker*)_ImagePicker{
    [self.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 320,150
    __weak InformationController* wself = self;
    //UIImagePickerController
    if (indexPath.section==0 && indexPath.row==0) {
        if (!$safe(self.picker)) {
            self.picker = [[ImagePicker alloc] init];
        }
        
        self.picker.mImage = self.imagePicture.image;
        self.picker.mEditable = YES;
        self.picker.mDelegate = NO;
        self.picker.mDelegate = self;
        [self.picker pickImage];
    }else if (indexPath.section==0 && indexPath.row==2) {
//        UIScreen* screen = [UIScreen screens][0];
//        UIPickerView* view = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(screen.bounds)-250,320,250)];
//        PickManager* pmm = [PickManager manager:@{@1: @"男",@2:@"女"}];
//        view.delegate=pmm;
//        view.dataSource=pmm;
//        view.showsSelectionIndicator= YES;
//        if ($safe(self.user.sex)){
//            NSUInteger i = [pmm.keys indexOfObject:self.user.sex];
//            if (i!=NSNotFound) {
//                [view selectRow:i inComponent:0 animated:NO];
//            }
//        }
//        [self.view addSubview:view];
        UIActionSheet* actions = [[UIActionSheet alloc] bk_initWithTitle:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.gender.title",nil,[NSBundle mainBundle],@"性别修改",nil)];
        [actions bk_addButtonWithTitle:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.gender.male",nil,[NSBundle mainBundle],@"男",nil) handler:^{
            wself.user.sex= @1;
            [wself synUser];
            [actions dismissWithClickedButtonIndex:0 animated:YES];
        }];
        [actions bk_addButtonWithTitle:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.gender.female",nil,[NSBundle mainBundle],@"女",nil) handler:^{
            wself.user.sex= @2;
            [wself synUser];
            [actions dismissWithClickedButtonIndex:0 animated:YES];
        }];
        [actions bk_setCancelButtonWithTitle:NSLocalizedStringWithDefaultValue(@"com.huotu.fanmore.button.cancel",nil,[NSBundle mainBundle],@"取消",nil) handler:^{
            [actions dismissWithClickedButtonIndex:0 animated:YES];
            [wself.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
        [actions showInView:self.view];
    }else if (indexPath.section==0 && indexPath.row==3){
        self.dataPicker.date = self.user.birth;
        self.dataPicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:-10*365*24*60*60];
        [InputController popInputView:self view:self.dataPicker worker:^(id d) {
            [wself.dataPicker removeFromSuperview];
            wself.user.birth = wself.dataPicker.date;
            [wself synUser];
        } canceller:^{
            [wself.dataPicker removeFromSuperview];
            [wself.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
    }else if (indexPath.section==1 && indexPath.row==0){
        UIPickerView* picker = $new(UIPickerView);
        picker.delegate = self.industry;
        picker.dataSource = self.industry;
        picker.showsSelectionIndicator = YES;
        self.uipicker = picker;
        if ($safe(self.user.industryId)) {
            id thekey;
            for (id key in self.industry.keys) {
                if ([key intValue]==[self.user.industryId intValue]) {
                    thekey = key;
                    break;
                }
            }
            if ($safe(thekey)) {
                [picker selectRow:[self.industry.keys indexOfObject:thekey] inComponent:0 animated:YES];
            }
        }
        __weak UIPickerView* wpicker = picker;
        
        [InputController popInputView:self view:picker worker:^(id d) {
            [wpicker removeFromSuperview];
            wself.user.industryId=$int([wself.industry.keys[[wpicker selectedRowInComponent:0]] intValue]);
            [wself synUser];
        } canceller:^{
            [wpicker removeFromSuperview];
            [wself.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
    }else if (indexPath.section==1 && indexPath.row==1){
        UIPickerView* picker = $new(UIPickerView);
        picker.delegate = self.incoming;
        picker.dataSource = self.incoming;
        picker.showsSelectionIndicator = YES;
        self.uipicker = picker;
        
        if ($safe(self.user.incomeId)) {
            id thekey;
            for (id key in self.incoming.keys) {
                if ([key intValue]==[self.user.incomeId intValue]) {
                    thekey = key;
                    break;
                }
            }
            if ($safe(thekey)) {
                [picker selectRow:[self.incoming.keys indexOfObject:thekey] inComponent:0 animated:YES];
            }
        }
        __weak UIPickerView* wpicker = picker;
        
        [InputController popInputView:self view:picker worker:^(id d) {
            [wpicker removeFromSuperview];
            wself.user.incomeId=$int([wself.incoming.keys[[wpicker selectedRowInComponent:0]]intValue]);
            [wself synUser];
        } canceller:^{
            [wpicker removeFromSuperview];
            [wself.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
    }else if (indexPath.section==1 && indexPath.row==2){
        
        CYCustomMultiSelectPickerView* multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,0, 320, 216)];
        NSString* numberPattern = @"([0-9]+)";
        //  multiPickerView.backgroundColor = [UIColor redColor];
        NSDictionary* favs = [AppDelegate getInstance].favoriteList;
        __weak NSDictionary* wfavs = favs;
        NSArray* keys = [favs.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            obj1 = [obj1 stringByMatching:numberPattern];
            obj2 = [obj2 stringByMatching:numberPattern];
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSMutableArray* entries = $marrnew;
        for (id key in keys) {
            [entries $push:favs[key]];
        }
        multiPickerView.entriesArray = entries;
        
        NSMutableArray* entriesSelected = $marrnew;
        for (id key in [self.user favoritesList]) {
            
            [entriesSelected $push:favs[key]];
        }
        
        multiPickerView.entriesSelectedArray = entriesSelected;
        
//        multiPickerView.multiPickerDelegate = self;
        
//        [self.view addSubview:multiPickerView];
        __weak CYCustomMultiSelectPickerView* wview= multiPickerView;
        [multiPickerView pickerShow];
        [InputController popInputView:self view:wview worker:^(id a) {
            NSMutableArray* mytmparr = $marrnew;
            for (NSString* f in wview.selectionStatesDic.allKeys) {
                if ([wview.selectionStatesDic[f] boolValue]) {
                    [mytmparr $push:[wfavs allKeysForObject:f][0]];
                }
            }
            [wself.user updateFavorites:mytmparr];
            [wself synUser];
            [wview removeFromSuperview];
            [wself.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        } canceller:^{
            [wview removeFromSuperview];
            [wself.tableView selectRowAtIndexPath:Nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];

    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchupOutside:(id)sender {
    LOG(@"touchOutside");
    [self.dataPicker removeFromSuperview];
}
@end

@interface PickManager ()
@property(weak) NSDictionary* datas;
@end

@implementation PickManager

+(instancetype)manager:(NSDictionary*)dict{
    PickManager* pm  = $new(self);
    pm.keys = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];    pm.datas = dict;
    return pm;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.datas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.datas[self.keys[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}


@end
