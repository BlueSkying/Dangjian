//
//  TheoryReviewCell.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TheoryReviewView : UIView



@end

@protocol TheoryReviewCellDelegate <NSObject>

- (void)theoryReviewCellItemSelectIndex:(NSInteger)index;

@end

@interface TheoryReviewCell : UITableViewCell


@property (nonatomic, weak) id<TheoryReviewCellDelegate>delegate;
@end
