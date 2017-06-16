//
//  EmojiKeyboarView.h
//  CBEmojiKeyboard
//
//  Created by 俊欧巴 on 17/6/5.
//  Copyright © 2017年 俊欧巴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CBExtension.h"

@protocol EmojiKeyboardViewDelegate <NSObject>
-(void)emojiBtnDidClick:(NSString *)emojiStr;
-(void)deleteBtnDicClick:(UIButton *)btn;
@end

@interface EmojiKeyboarView : UIView
@property (nonatomic,weak) UITextView * inputView;
@property (nonatomic,weak)id<EmojiKeyboardViewDelegate>delegate;

@end
