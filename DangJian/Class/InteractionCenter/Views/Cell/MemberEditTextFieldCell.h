//
//  MemberEditTextFieldCell.h
//  DangJian
//
//  Created by Sakya on 17/5/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInformationVo.h"
#import "UITextField+IndexPath.h"


@protocol MemberEditTextFieldCellDelegate <NSObject>

- (void)textFieldCellChangeText:(NSString *)content key:(NSString *)key indexPath:(NSIndexPath *)indexPath;

@end

@interface MemberEditTextFieldCell : UITableViewCell

@property (nonatomic, strong) CellCustomVo *customVo;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<MemberEditTextFieldCellDelegate>delegate;

@end
