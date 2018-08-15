//
//  PublickSingleTextFieldCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublickSingleTextFieldCellDelegate <NSObject>

//对应的不同key的值
- (void)textFieldChangedText:(NSString *)text
                         key:(NSString *)key;

@end
@interface PublickSingleTextFieldCell : UITableViewCell


@property (nonatomic, strong) NSDictionary *configParams;

/**
 是否能够输入
 */
@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, copy) NSString *fillInText;

@property (nonatomic, weak) id<PublickSingleTextFieldCellDelegate>delegate;
@end
