# CBEmojiKeyboard

公司使用的键盘的一部分，自己写了一个小的demo，开始的实现，是系统表情，解析起来使用很方便，但是安卓那边不统一，所以重新写了一个图片表情键盘，为了和安卓统一起来显示和解析，大家可以参谋一下，这里面解析用了YYLabel，简单粗暴，大家可以试试！

#2个代理方法：

     #### 第一个是点击了表情按钮的代理方法

 （1）- (void)emojiBtnDidClick:(NSString *)emojiStr

     #### 第二个是点击了删除按钮的代理方法
 （2）-(void)deleteBtnDicClick:(UIButton *)btn

# 演示截图如下：
![image](https://github.com/ChangBoHua/CBEmojiKeyboard/CBEmojiKeyboard/1.png)
