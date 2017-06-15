//
//  ViewController.m
//  CBEmojiKeyboard
//
//  Created by 俊欧巴 on 17/6/5.
//  Copyright © 2017年 俊欧巴. All rights reserved.
//

#import "ViewController.h"
#import "EmojiKeyboarView.h"
#import "UIView+CBExtension.h"
#import "NSString+DeleteEmojiStr.h"
#import "NSString+SimpleModifier.h"
#import "YYLabel.h"
@interface ViewController ()<EmojiKeyboardViewDelegate>
@property (nonatomic,strong) EmojiKeyboarView * emojiKeyboard;
@property (nonatomic, strong) YYLabel *contentLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addSubViews];
}
- (void)addSubViews{
    [self.view addSubview:self.emojiKeyboard];
    [self.view addSubview:self.contentLabel];
}
- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.frame = CGRectMake(20, 100, self.view.width-40, 200);
        _contentLabel.text = @"";
        _contentLabel.numberOfLines = 0;
        YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
        parser.emoticonMapper  = [NSString retunRichTextDic];
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 22;
        _contentLabel.textParser = parser;
        _contentLabel.linePositionModifier = mod;
    }
    return _contentLabel;
}
- (EmojiKeyboarView *)emojiKeyboard{
    if (!_emojiKeyboard) {
        _emojiKeyboard = [[EmojiKeyboarView alloc] initWithFrame:CGRectMake(0,self.view.height-170.5 , self.view.width, 170.5)];
        _emojiKeyboard.delegate = self;
    }
    return _emojiKeyboard;
}
#pragma mark - emojiKeyboard delegate
- (void)emojiBtnDidClick:(NSString *)emojiStr{
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@",self.contentLabel.text,emojiStr];
}
-(void)deleteBtnDicClick:(UIButton *)btn{

    [NSString setDeleteEmojiStr:self.contentLabel.text returnBlock:^(NSString *returnStr) {
        self.contentLabel.text = returnStr;
    }];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
