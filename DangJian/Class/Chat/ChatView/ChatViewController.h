//
//  ChatViewController.h
//  ThePartyBuild
//
//  Created by Sakya on 17/5/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface ChatViewController : EaseMessageViewController<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
