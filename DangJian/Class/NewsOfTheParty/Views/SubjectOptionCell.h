//
//  SubjectOptionCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubjectOptionCellDelegate <NSObject>

- (void)subjectCellTapGestureDetectedIndex:(NSInteger)index;

@end

@interface SubjectOptionCell : UITableViewCell

@property (nonatomic, strong) NSArray <NSDictionary *>*subjectArray;

@property (nonatomic, weak) id<SubjectOptionCellDelegate>delegate;
@end
