//
//  ViewController.m
//  SuperGuessFigure
//
//  Created by  江苏 on 16/4/5.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "Questions.h"
#import "AboutViewController.h"

#define ButtonW 35
#define ButtonH 35
#define Marign 10
#define col 7
#define row 3

@interface ViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *iconButton;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;

@property (strong, nonatomic) IBOutlet UIButton *scoreButton;
@property(strong,nonatomic)NSArray* question;
@property(strong,nonatomic)UIButton* button;
@property(nonatomic)CGRect rect;
/**
 *  顶部索引标识
 */
@property(nonatomic)int index;
@end


@implementation ViewController

- (IBAction)show {
    //初始化
    AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    //视图转换模式动画
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
}

-(NSArray *)question{
    if (_question==nil) {
        Questions *ques = [[Questions alloc] init];
        _question= [ques questions];
    }
    return _question;
}

//重写button的get方法,创建阴影并添加到父控件中，并给阴影增加单击事件
- (UIButton *)button{
    if(_button==nil){
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
        _button.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _button.alpha = 0.0;
        [_button addTarget:self action:@selector(Enlarge:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }
    return _button;
}



//-(UIButton *)button{
//    if (_button==nil) {
//        _button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        _button.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
//        _button.alpha=0.0;
//        [_button addTarget:self action:@selector(Enlarge:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_button];
//    }
//    return _button;
//}

//重写状态栏为浅色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastButton.hidden = YES;
    self.rect=self.iconButton.frame;
    self.index=-1;
    [self nextQuestion:self.nextButton];
}

//改变图片大小
- (IBAction)Enlarge:(UIButton *)sender{
    //根据阴影透明度判断，放大或缩小
    if(self.button.alpha==0.0){//如果当前透明度是0，则需要放大
        [self button];
        [self.view bringSubviewToFront:self.iconButton];
        //放大动画
        [UIView animateWithDuration:0.6 animations:^{
            self.button.alpha = 1.0;
            self.iconButton.frame = CGRectMake(0, (self.view.bounds.size.height-self.view.bounds.size.width)*0.5, self.view.bounds.size.width, self.view.bounds.size.width);
        }];
    }else{//如果当前透明度是0，则需要缩小
        [UIView animateWithDuration:0.6 animations:^{
            self.button.alpha = 0.0;
            self.iconButton.frame = _rect;
        } completion:^(BOOL finished) {
            if(finished){
                [self.view willRemoveSubview:self.button];
            }
        }];
    }
    
}

/**
 * 改变图片大小
 */
//- (IBAction)Enlarge:(UIButton *)sender {
//    if(self.button.alpha==0.0){
//        //调用button的setter方法
//        [self button];
//        [self.view bringSubviewToFront:self.iconButton];
//        //放大动画
//        [UIView animateWithDuration:1.0f animations:^{
//            self.button.alpha=1.0;
//            self.iconButton.frame=CGRectMake(0, (self.view.bounds.size.height-self.view.bounds.size.width)/2, self.view.bounds.size.width, self.view.bounds.size.width);
//        }];
//    }else{
//        //缩小动画
//        [UIView animateWithDuration:1.0f animations:^{
//            self.button.alpha=0.0;
//            self.iconButton.frame=_rect;
//        }];
//    }
//}

#pragma mark-上一题
- (IBAction)lastQuestion:(UIButton *)sender {
    self.index--;
    //通关校验
    if(self.index==self.question.count) return;
    Questions* question=self.question[self.index];
    //每次点击下一题时，都会打乱顺序
    //[question randomOptions];
    //设置基本信息
    [self setUpBasicInfo:question];
    /**防止数组越界*/
    sender.enabled=(self.index!=0);
    self.nextButton.enabled=(self.index<self.question.count-1);
    [self setAnswerButton:question];
    [self setChooseButton:question];
}

#pragma mark-下一题
- (IBAction)nextQuestion:(UIButton *)sender {
    self.index++;
    
    //通关校验
    if(self.index==self.question.count){
        int currentScore=[self.scoreButton.currentTitle intValue];
        NSString *tips;
        if(currentScore < 3000){
            tips = @"抱歉，您通关失败了,";
        }else{
            tips = @"恭喜，您成功过关了,";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"答题完毕" message:[NSString stringWithFormat:@"%@%@",tips,@"请重新答题！"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    Questions* question=self.question[self.index];
    //每次点击下一题时，都会打乱顺序
    //[question randomOptions];
    //设置基本信息
    [self setUpBasicInfo:question];
    /**防止数组越界*/
    self.lastButton.enabled=(self.index!=0);
    sender.enabled=(self.index<self.question.count-1);
    [self setAnswerButton:question];
    [self setChooseButton:question];
    self.chooseView.userInteractionEnabled = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        self.index = -1;
        [self nextQuestion:self.nextButton];
        [self.scoreButton setTitle:@"12000" forState:UIControlStateNormal];
    }
}

/**设置基本信息*/
-(void)setUpBasicInfo:(Questions*)question
{
    self.numLabel.text=[NSString stringWithFormat:@"%d/%lu",self.index+1,(unsigned long)self.question.count];
    self.tipLabel.text=question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
}

/**创建答案区按钮*/
-(void)setAnswerButton:(Questions*)question{
    int count=(int)question.answer.length;
    //让数组里的每一个元素都调用对应的方法
    //    for (UIView* view in self.answerView.subviews) {
    //        [view removeFromSuperview];
    //    }
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat answerButtonX = (self.answerView.bounds.size.width-count*ButtonW-(count-1)*Marign)*0.5;
    for (int i=0; i<count; i++) {
        CGFloat x=answerButtonX+i*(ButtonW+Marign);
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(x, 0, ButtonW, ButtonH)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:btn];
    }
}

/**创建备选区按钮*/
-(void)setChooseButton:(Questions*)question{
    if (self.chooseView.subviews.count!=question.options.count) {
        //        for (UIView* view in self.chooseView.subviews) {
        //            [view removeFromSuperview];
        //        }
        [self.chooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat chooseButtonX=(self.chooseView.bounds.size.width-col*ButtonW-(col-1)*Marign)*0.5;
        for (int i=0; i<question.options.count; i++) {
            CGFloat x=chooseButtonX+i%col*(ButtonW+Marign);
            CGFloat y=i%row*(ButtonH+Marign);
            UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(x, y, ButtonW, ButtonH)];
            [btn setTitle:question.options[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
            btn.tag=i;
            [btn addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.chooseView addSubview:btn];
        }
        //如果按钮已经存在，只需要设置按钮的标题即可
    }else{
        [self performSelector:@selector(changeChooseButtonHidden) withObject:nil afterDelay:0.5];
        int i=0;
        for (UIButton* btn in self.chooseView.subviews) {
            [btn setTitle:question.options[i++] forState:UIControlStateNormal];
        }
    }
}

#pragma mark-候选按钮的监听方法
-(void)chooseButtonClick:(UIButton*)button{
    //如果答案区按钮已满，跳出
    if ([self isFull]) return;
    //1.在答案区找到一个文字为空的按钮
    UIButton* btn=[self findButton];
    //2.将button的标题设置给答案区的按钮
    [btn setTitle:button.currentTitle forState:UIControlStateNormal];
    //设置对应的唯一标记
    [btn setTag:button.tag];
    //3.将button影藏
    button.hidden=YES;
    //4.判断胜负
    [self judgement];
}

/**判断答案区是否已满*/
-(BOOL)isFull{
    BOOL isFull=YES;
    for (UIButton* btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            isFull=NO;
            break;
        }
    }
    if(isFull){
        self.chooseView.userInteractionEnabled = NO;
    }
    return isFull;
}

/**判断胜负*/
-(void)judgement{
    //如果四个按钮都有文字，才需要判断结果
    BOOL isFull=[self isFull];
    if (isFull) {
        //连接每一个字符组成完整答案
        NSMutableString *mulStr = [NSMutableString string];
        for (UIButton *btn in self.answerView.subviews) {
            [mulStr appendString:btn.currentTitle];
        }
        
        //从数据库中获取到正确的答案，进行比较
        Questions* question=self.question[self.index];
        if([mulStr isEqualToString:question.answer]){
            [self performSelector:@selector(nextQuestion:) withObject:self.nextButton afterDelay:0.5];
            [self performSelector:@selector(changeChooseButtonHidden) withObject:nil afterDelay:0.5];
            [self setAnswerButtonColor:[UIColor colorWithRed:0.48 green:0.65 blue:0.35 alpha:1.00]];
            //回答正确增加2000分
            [self scoreButtonChange:2000];
        }else{
            [self setAnswerButtonColor:[UIColor redColor]];
        }
    }
}

/**恢复选择区按钮的不影藏状态*/
-(void)changeChooseButtonHidden{
    for (UIButton* btn in self.chooseView.subviews) {
        btn.hidden=NO;
    }
}

/**设置答案区按钮颜色*/
-(void)setAnswerButtonColor:(UIColor*)color{
    for (UIButton* btn in self.answerView.subviews) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}

/**找到答案区为空的按钮*/
-(UIButton*)findButton{
    for (UIButton* btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            return btn;
        }
    }
    return nil;
}

#pragma mark-答案区按钮的点击方法
-(void)answerButtonClick:(UIButton*)button{
    //1.如果按钮没有字，直接返回
    if (button.currentTitle.length==0) return ;
    //2.如果按钮有字，清除文字，在选择区显示
    UIButton* btn=[self optionButtonWithTitle:button.currentTitle :button.tag];
    //3.显示对应按钮
    btn.hidden=NO;
    //清除按钮文字
    [button setTitle:@"" forState:UIControlStateNormal];
    [self setAnswerButtonColor:[UIColor blackColor]];
    self.chooseView.userInteractionEnabled = YES;
}
/**选择出选择区的按钮文字相同的按钮*/
-(UIButton*)optionButtonWithTitle:(NSString*)title :(long)tag{
    for (UIButton* btn in self.chooseView.subviews) {
        if ([title isEqualToString:btn.currentTitle] && btn.hidden && tag==btn.tag) {
            return btn;
        }
    }
    return nil;
}

#pragma mark-分数的显示
-(void)scoreButtonChange:(int)score{
    int currentScore=[self.scoreButton.currentTitle intValue];
    if(currentScore<=0 && score<0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"您好，您的金币数量不足！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    currentScore+=score;
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%d",currentScore] forState:UIControlStateNormal];
}

#pragma mark-提示按钮
- (IBAction)tipAction:(UIButton *)sender {
    if(self.index>self.question.count-1){
        return;
    }
    [self scoreButtonChange:-1000];
    Questions* question=self.question[self.index];
    //1.先把答案区的按钮全部清空
    for (UIButton* btn in self.answerView.subviews) {
        if(btn.currentTitle.length>0){
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    //2.找到第一个正确的按钮
    NSString* first=[question.answer substringToIndex:1];
    for (UIButton* btn in self.chooseView.subviews) {
        if ([first isEqualToString:btn.currentTitle]) {
            [self chooseButtonClick:btn];
        }
    }
}
@end
