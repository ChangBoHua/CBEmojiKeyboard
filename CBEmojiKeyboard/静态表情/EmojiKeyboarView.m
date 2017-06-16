//
//  EmojiKeyboarView.m
//  CBEmojiKeyboard
//
//  Created by 俊欧巴 on 17/6/5.
//  Copyright © 2017年 俊欧巴. All rights reserved.
//

#import "EmojiKeyboarView.h"
#define BGColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NavBarH 64
#define TabBarH 44
#define WIDTH_RATE (SCREEN_WIDTH/375)   // 屏幕宽度系数（以4.7英寸为基准）
#define HEIGHT_RATE (SCREEN_HEIGHT/667)

#define EmojiViewH 170.5
#define ToolBarH 37.5
#define ToolBtnCount 7

#define WidthGap 13 // 可调节布局间距
#define HeightGap 13
#define BtnWH 30*WIDTH_RATE  // 宽高相等

#define MaxCol 8
#define MaxRow 3
#define NumberOfSinglePage 24 // 一个页面可容纳的最多按钮数
#define PageControlH 15
@interface EmojiKeyboarView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * contentScrollView;
@property (nonatomic,weak) UIPageControl * pageControl;
@property (nonatomic,assign) NSInteger btnsCount;
@property (nonatomic,weak) UIButton * lastBtn;

/// 子视图数据
@property (nonatomic,strong) NSArray * dataArr;


@end
@implementation EmojiKeyboarView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self initDataAndSubviews];
    }
    return self;
}

-(void)initDataAndSubviews{
    
    // 加载默认测试数据
    NSLog(@"加载测试数据");
    NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"emojiDataArr.plist" ofType:nil];
    _dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    _btnsCount = 94;
    NSInteger pageCount = _btnsCount / NumberOfSinglePage;
    if (_btnsCount % NumberOfSinglePage > /* DISABLES CODE */ (0)) {
        pageCount += 1;
    }
    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width,EmojiViewH)];
    _contentScrollView = contentScrollView;
    _contentScrollView.delegate = self;
    contentScrollView.backgroundColor = BGColor;
    contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, EmojiViewH);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < pageCount; i++) {
            [self addBtnsWithPageNum:i];
        }
    });

    
    [self addSubview:contentScrollView];
    
    // 添加pageControl
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(SCREEN_WIDTH/2, EmojiViewH-PageControlH, 0, 0);
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = pageCount;
    _pageControl = pageControl;
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
    
}

// 循环添加按钮
-(void)addBtnsWithPageNum:(NSInteger)pageNum{
    
    // 添加按钮
    
    CGFloat btnW = BtnWH;
    CGFloat btnH = BtnWH;
    CGFloat widthMargin = (self.width - (MaxCol*btnW + (MaxCol-1) * WidthGap))/2; // 横向边距
    CGFloat heightMargin = (EmojiViewH - (MaxRow*btnH + (MaxRow-1) * HeightGap))/2; // 纵向边距
    
    NSInteger count = _btnsCount - (pageNum * NumberOfSinglePage);
    NSInteger indexCount;
    if (count > 0 && count <= NumberOfSinglePage) {
        
        indexCount = count;
    }else if(count > NumberOfSinglePage){
        
        indexCount = NumberOfSinglePage;
    }else{
        
        return;
    }
    
    NSLog(@"btnsCount:%ld",indexCount);
    for (int i = 0; i<indexCount; i++) {
        UIButton  * btn = [[UIButton alloc] init];
        
        int col = i % MaxCol;
        int row = i / MaxCol;
        //注意：由于表情中有删除按钮，取表情按钮时需要减个页码号才正确
        NSInteger index = i + (pageNum * NumberOfSinglePage - pageNum);
        
        // 设置图片frame
        
        btn.x = col * (btnW + WidthGap) + widthMargin + pageNum * self.width;
        btn.y = row * (btnH + HeightGap) + heightMargin;
        
        btn.width = btnW;
        btn.height = btnH;
        btn.tag = index;
        
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentScrollView addSubview:btn];
        
        // 主线程处理UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (i== NumberOfSinglePage-1) {
                [btn setImage:[UIImage imageNamed:@"expression_delete"] forState:UIControlStateNormal];
            }else{
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"im_ee_%ld",index+1]] forState:UIControlStateNormal];
            }
        });
    }
    // 如果单页按钮数量少于最大容纳数时，任然需要添加删除按钮
    if (indexCount <= (NumberOfSinglePage-1)) {
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.x = (MaxCol-1) * (btnW + WidthGap) + widthMargin + pageNum * self.width;
        btn.y = (MaxRow-1) * (btnH + HeightGap) + heightMargin;
        
        btn.width = btnW;
        btn.height = btnH;
        btn.tag = ((NumberOfSinglePage-1) + pageNum*(NumberOfSinglePage-1));
        
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentScrollView addSubview:btn];
        // 主线程处理UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [btn setImage:[UIImage imageNamed:@"expression_delete"] forState:UIControlStateNormal];
        });
    }
}

#pragma mark - 点击事件

-(void)emojiBtnClick:(UIButton *)btn{
    
    
    if (btn.tag == ((NumberOfSinglePage-1) + _pageControl.currentPage*(NumberOfSinglePage-1))) { // 减一是为了排除删除按钮
        //NSLog(@"删除:%ld",btn.tag);
        [self.inputView deleteBackward];
        
        if ([self.delegate respondsToSelector:@selector(deleteBtnDicClick:)]) {
            [self.delegate deleteBtnDicClick:btn];
        }
    }else{
        
        [self appendEmojiToInputViewWithTag:btn.tag];
   
        //NSLog(@"点击表情:%ld",btn.tag);
     
        NSString * path = [[NSBundle mainBundle] pathForResource:@"emojiDataArr.plist" ofType:nil];
        NSArray * emojiArr = [NSArray arrayWithContentsOfFile:path];
        
        
        if ([self.delegate respondsToSelector:@selector(emojiBtnDidClick:)]) {
            [self.delegate emojiBtnDidClick:emojiArr[btn.tag]];
        }
    }
    
}



// 映射表情文字
-(void)appendEmojiToInputViewWithTag:(NSInteger )tag{
    //NSAttributedString * attributStr  = [[NSAttributedString alloc] initWithString:emojiArr[tag]];
//    self.inputView.text = [self.inputView.text stringByAppendingString:emojiArr[tag]];
}

#pragma mark - scroll delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger correntCount = (scrollView.contentOffset.x + self.width/2)/self.width;
    self.pageControl.currentPage = correntCount;
}



@end
