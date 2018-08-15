//
//  OrganizationFeedbackDetailsViewController.m
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationFeedbackDetailsViewController.h"
#import "OrganizationJobFeedbackReadCell.h"
#import "SKWebImageAutoSize.h"

@interface OrganizationFeedbackDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation OrganizationFeedbackDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomView];
    [self setUpNavBar];
}
- (void)initCustomView {
    
    _tableView = [SKBuildKit tableViewWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) delegateAgent:self superview:self.view];

    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    
}
- (void)setUpNavBar {
    
    [self setUpNavItemTitle:@"详情"];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (void)setJobFeedbackVo:(OrganizationJobFeedbackModel *)jobFeedbackVo {
    
    JobFeedbackReadModel *image1Vo = [JobFeedbackReadModel new];
    image1Vo.imageUrl = jobFeedbackVo.image1;
    image1Vo.content = jobFeedbackVo.description1;
    image1Vo.jobFeedbackReadType = OrganizationJobFeedbackReadPictureType;

    [self.dataArray addObject:image1Vo];
    
    if (jobFeedbackVo.image2 &&
        jobFeedbackVo.image2.length > 0) {
        JobFeedbackReadModel *image2Vo = [JobFeedbackReadModel new];
        image2Vo.imageUrl = jobFeedbackVo.image2;
        image2Vo.content = jobFeedbackVo.description2;
        image2Vo.jobFeedbackReadType = OrganizationJobFeedbackReadPictureType;
        [self.dataArray addObject:image2Vo];
    }
    JobFeedbackReadModel *contenVo = [JobFeedbackReadModel new];
    contenVo.content = jobFeedbackVo.content;
    contenVo.jobFeedbackReadType = OrganizationJobFeedbackReadContenrType;
    [self.dataArray addObject:contenVo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"OrganizationJobFeedbackReadCell";
    
    JobFeedbackReadModel *readVo = self.dataArray.count > indexPath.row ? self.dataArray[indexPath.row] : nil;

    OrganizationJobFeedbackReadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OrganizationJobFeedbackReadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    __weak __typeof(self)wself = self;
    [cell bindDataJobFeedbackReadVo:readVo imageLoadSuccessBlock:^(UIImage *image) {
        NSURL *imageURL = [NSURL URLWithString:readVo.imageUrl];
        [SKWebImageAutoSize sk_storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            __strong __typeof (wself) sself = wself;

            //reload row
            BOOL reloadState = [SKWebImageAutoSize sk_reloadStateFromCacheForURL:imageURL];
            if(result &&
               !reloadState) {
                [sself.tableView beginUpdates];
                [sself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [sself.tableView endUpdates];

                [SKWebImageAutoSize sk_storeReloadState:YES forURL:imageURL completed:nil];
            }
        }];
    }];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JobFeedbackReadModel *readVo = self.dataArray[indexPath.row];
    return readVo.cellHeight;
}
- (void)dealloc {
    
    [self.dataArray enumerateObjectsUsingBlock:^(JobFeedbackReadModel *readObj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (readObj.imageUrl) {
            [[SDImageCache sharedImageCache] removeImageForKey:readObj.imageUrl fromDisk:NO withCompletion:^{
                
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //解决内存崩溃
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
