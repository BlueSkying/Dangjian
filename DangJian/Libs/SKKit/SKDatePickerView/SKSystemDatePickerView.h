//
//  SKSystemDatePickerView.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKSystemDatePickerView : UIView


/**
 输入的时间
 */
@property (nonatomic, copy) NSString *inputDate;

/**
 输出的时间
 */
@property (nonatomic, copy) NSString *outgoingDate;

- (void)show;
- (void)dissmiss;
@end
