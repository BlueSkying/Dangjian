//
//  OrganizationalCollectionViewCell.m
//  DangJian
//
//  Created by Sakya on 17/5/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationalCollectionViewCell.h"


@interface OrganizationalStructureTopCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation OrganizationalStructureTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.layer.borderColor = Color_c.CGColor;
    titleLabel.layer.borderWidth = .5f;
    titleLabel.layer.cornerRadius = ControlsCornerRadius;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = Color_3;
    _titleLabel = titleLabel;
    //用的固定大小如果需要多行显示则需要计算高度
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(0);
        make.right.offset(-7);
        make.top.offset(10);
    }];
    
}
@end


@interface OrganizationalStructureTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) CALayer *horizontalLayer;

@property (nonatomic, strong) CALayer *verticalLayer;

@property (nonatomic, assign) OrganizationalStructureCellType cellType;

@end
@implementation OrganizationalStructureTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.layer.borderColor = Color_c.CGColor;
    titleLabel.layer.borderWidth = .5f;
    titleLabel.layer.cornerRadius = ControlsCornerRadius;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textColor = Color_3;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(23);
        make.right.offset(-7);
        make.bottom.offset(0);
        make.height.offset(40);
    }];
    _titleLabel = titleLabel;
    
    CALayer *horizontalLayer = [CALayer layer];
    [horizontalLayer setBackgroundColor:Color_c.CGColor];
    [horizontalLayer setFrame:CGRectMake(15, 34.5, 7, .5)];
    [self.contentView.layer addSublayer:horizontalLayer];
    _horizontalLayer = horizontalLayer;
    
    CALayer *lineLayer = [CALayer layer];
    [lineLayer setBackgroundColor:Color_c.CGColor];
    [lineLayer setFrame:CGRectMake(15, 0, .5, 55)];
    _verticalLayer = lineLayer;
    [self.contentView.layer addSublayer:lineLayer];
    
    
}
- (void)setCellType:(OrganizationalStructureCellType)cellType {
    

    if (cellType == OrganizationalStructureCellTypeMid) {

        _verticalLayer.frame = CGRectMake(15, 0, .5, 55);
    } else if (cellType == OrganizationalStructureCellTypeBottom) {
        
        _verticalLayer.frame = CGRectMake(15, 0, .5, 35);
    }
    
}

@end

@interface OrganizationalCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation OrganizationalCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCustomView];
    }
    
    return self;
}
- (void)initCustomView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _organizationVo.childrenVo.count + 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //选择第一行默认的是第二级组织
        static NSString *ID = @"TopID";
        OrganizationalStructureTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[OrganizationalStructureTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.titleLabel.text = _organizationVo.name;
        return cell;
    } else {
        //第三级组织
        static NSString *ID = @"BottomID";
        OrganizationalStructureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[OrganizationalStructureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (_organizationVo.childrenVo.count == indexPath.row) {
            cell.cellType = OrganizationalStructureCellTypeBottom;
        } else {
            cell.cellType = OrganizationalStructureCellTypeMid;
        }
        cell.titleLabel.text = ((OrganizationalStructureVo *)_organizationVo.childrenVo[indexPath.row - 1]).name;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}
#pragma mark - setter
- (void)setOrganizationVo:(OrganizationalStructureVo *)organizationVo {
    
    _organizationVo = organizationVo;
    [_tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //默认第一级为上一层
    OrganizationalStructureVo *organizationalVo;
    if (indexPath.row == 0) {
        organizationalVo = _organizationVo;
    } else {
        organizationalVo = (OrganizationalStructureVo *)_organizationVo.childrenVo[indexPath.row - 1];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(organizationalViewSelectRowAtIndexPath:organizationVo:)]) {
        [_delegate organizationalViewSelectRowAtIndexPath:indexPath organizationVo:organizationalVo];
    }
}
@end

