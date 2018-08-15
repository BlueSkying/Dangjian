//
//  SKTextField.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKTextField.h"

@interface SKTextField () {
    
    UIImage *_image;
    //风格
    SKTextFieldStyle _textFiledStyle;
}

/**
 左侧imageView
 */
@property (nonatomic, strong) UIImageView *signImageView;

@property (nonatomic, strong) UILabel *titleLabel;
/**
 左侧空隙
 */
@property (nonatomic, assign)  CGFloat spaceViewWidth;
@end

@implementation SKTextField

- (instancetype)initWithFrame:(CGRect)frame
                    leftSpace:(CGFloat)leftSpace
                        style:(SKTextFieldStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        
        _textFiledStyle = style;
        _spaceViewWidth = leftSpace;
        self.tintColor = Color_system_red;

        [self initTextField];
    }
    return self;
}
- (void)initTextField {
    
    self.backgroundColor = [UIColor whiteColor];
    [self setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.font = FONT_16;
    UIView *space;
    if (_textFiledStyle == SKTextFieldNormalStyle) {
        
     
        space = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _spaceViewWidth, self.frame.size.height)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _spaceViewWidth - 15, self.frame.size.height)];
        titleLabel.textColor = Color_6;
        titleLabel.font = FONT_16;
        [space addSubview:titleLabel];
        _titleLabel = titleLabel;
        
    }  else if (_textFiledStyle == SKTextFieldImageStyle) {
        
        self.layer.borderColor = Color_textField_border.CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 4.0f;
        space = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _spaceViewWidth, self.frame.size.height)];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.frame.size.height - 18)/2, 18, 18)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [space addSubview:imageView];
        _signImageView = imageView;
        
    }

    [self setLeftView:space];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

#pragma mark - setter 
- (void)setLeftTitle:(NSString *)leftTitle {
    
    if (_titleLabel) _titleLabel.text = leftTitle;
}
- (void)setImageName:(NSString *)imageName {
    if (_signImageView) {
        _signImageView.image = [UIImage imageNamed:imageName];
    }
}


@end
