//
//  MemberInformationVo.m
//  ThePartyBuild
//
//  Created by Sakya on 17/5/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MemberInformationVo.h"

@implementation MemberInformationVo

- (NSMutableArray <CellCustomVo *>*)dataArray {
    if (!_dataArray) {
        
        UserInformationVo *user =  [UserOperation shareInstance].user;
        _dataArray = [NSMutableArray arrayWithArray:[self updateUserInfo:user]];
    }
    return _dataArray;
}
/**
 编辑上传参数
 
 @param title 左侧的title
 @param action cellType
 @param key 上传的对应的key
 @param content key对应的value
 @param placeholder 对应的提示语

 */
- (CellCustomVo *)customVoTitle:(NSString *)title
                         action:(NSString *)action
                            key:(NSString *)key
                        content:(id)content
                    placeholder:(NSString *)placeholder
                     alterStyle:(SKPromptStyle)alterStyle
                alterNavBarType:(SKPromptNavBarType)alterNavBarType
{
    
    CellCustomVo *customVo = [CellCustomVo new];
    customVo.title = title;
    customVo.action = action;
    customVo.key = key;
    customVo.content = content;

//    if ([key isEqualToString:@"education"] && content ) {
//        if ([content isEqualToString:@""]) {
//         customVo.content = @"";
//        }
//    }
    customVo.placeholder = placeholder;
    customVo.alterStyle = alterStyle;
    customVo.alterNavBarType = alterNavBarType;
    return customVo;
    
}
- (NSArray *)updateUserInfo:(UserInformationVo *)user {
    
    NSArray *userArray =
    @[@[[self customVoTitle:@"头像"
                     action:@"image"
                        key:@"image"
                    content:user.image
                placeholder:@""
                 alterStyle:SKPromptTextViewType
            alterNavBarType:SKPromptNavBarDefaultType]],
      @[[self customVoTitle:@"姓名"
                     action:@"nickname"
                        key:@"nickname"
                    content:user.nickname
                placeholder:@"请输入您的真实姓名"
                 alterStyle:SKPromptTextViewType
            alterNavBarType:SKPromptNavBarRighrButtonType],
        [self customVoTitle:@"性别"
                     action:@"sex"
                        key:@"sex"
                    content:user.sex
                placeholder:@""
                 alterStyle:SKPromptCustomPickerDefaultType
            alterNavBarType:SKPromptNavBarDefaultType],
        [self customVoTitle:@"籍贯"
                     action:@"nativePlace"
                        key:@"nativePlace"
                    content:user.nativePlace
                placeholder:@"请输入您的籍贯"
                 alterStyle:SKPromptTextViewType
            alterNavBarType:SKPromptNavBarDefaultType],
        [self customVoTitle:@"民族"
                     action:@"nation"
                        key:@"nation"
                    content:user.nation
                placeholder:@"请输入您的民族"
                 alterStyle:SKPromptTextViewType
            alterNavBarType:SKPromptNavBarDefaultType]],
      @[[self customVoTitle:@"岗位"
                     action:@"job"
                        key:@"job"
                    content:user.job
                placeholder:@"请输入您的岗位"
                 alterStyle:SKPromptTextViewType
            alterNavBarType:SKPromptNavBarDefaultType],
        [self customVoTitle:@"学历"
                     action:@"education"
                        key:@"education"
                    content:user.education
                placeholder:@"请输入您的学历"
                 alterStyle:SKPromptTextViewType
            alterNavBarType:SKPromptNavBarDefaultType],
        [self customVoTitle:@"党内职务"
                     action:@"duty" key:@"duty"
                    content:user.duty
                placeholder:@"请输入您的党内职务"
                 alterStyle:SKPromptTextViewType alterNavBarType:SKPromptNavBarDefaultType]],
      @[[self customVoTitle:@"出生年月"
                      action:@"birth"
                         key:@"birth"
                     content:user.birth
                 placeholder:@"请输入您的出生年月"
                  alterStyle:SKPromptDatePickViewType
             alterNavBarType:SKPromptNavBarDefaultType],
         [self customVoTitle:@"入党时间"
                      action:@"partyTime"
                         key:@"partyTime"
                     content:user.partyTime
                 placeholder:@"请输入您的入党时间"
                  alterStyle:SKPromptDatePickViewType
             alterNavBarType:SKPromptNavBarDefaultType],
         [self customVoTitle:@"党内培训记录"
                      action:@"train"
                         key:@"train"
                     content:user.train
                 placeholder:@"请输入您的党内培训记录...（1000字以内）"
                  alterStyle:SKPromptTextViewType
             alterNavBarType:SKPromptNavBarDefaultType],
         [self customVoTitle:@"奖励记录"
                      action:@"award"
                         key:@"award"
                     content:user.award
                 placeholder:@"请输入您的奖励记录...（1000字以内）"
                  alterStyle:SKPromptTextViewType
             alterNavBarType:SKPromptNavBarDefaultType],
         [self customVoTitle:@"惩罚记录"
                      action:@"punishment"
                         key:@"punishment"
                     content:user.punishment
                 placeholder:@"请输入您的惩罚记录...（1000字以内）"
                  alterStyle:SKPromptTextViewType
             alterNavBarType:SKPromptNavBarLeftButtonType]]];
    return userArray;
}
+ (NSString *)checkIsCommit:(BOOL)isCommit text:(NSString *)text {
    
    NSString *returnText;
//    学历：PRIMARY("小学"),JUNIOR("初中"),HIGH("高中"), SECONDARY("中专"), COLLEGE("大专"),BACHELOR("本科"),MASTER("硕士"),DOCTOR("博士") ;

    if (isCommit) {
        if ([text isEqualToString:@"小学"]) {
            returnText = @"PRIMARY";
        } else if ([text isEqualToString:@"初中"]) {
            returnText = @"JUNIOR";
        } else if ([text isEqualToString:@"高中"]) {
            returnText = @"HIGH";
        } else if ([text isEqualToString:@"中专"]) {
            returnText = @"SECONDARY";
        } else if ([text isEqualToString:@"大专"]) {
            returnText = @"COLLEGE";
        } else if ([text isEqualToString:@"本科"]) {
            returnText = @"BACHELOR";
        } else if ([text isEqualToString:@"硕士"]) {
            returnText = @"MASTER";
        } else if ([text isEqualToString:@"博士"]) {
            returnText = @"DOCTOR";
        }
    } else {
        
        
    }
    return returnText;
}
@end

@implementation CellCustomVo


@end
