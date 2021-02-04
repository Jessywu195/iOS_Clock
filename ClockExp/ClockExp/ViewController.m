//
//  ViewController.m
//  ClockExp
//
//  Created by Ellie Weng on 2021/1/26.
//  Copyright © 2021 Jessie Wu. All rights reserved.
//

#import "ViewController.h"

#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS


#define SET_COLOR(Red, Green, Blue, Alpha) \
[UIColor colorWithRed:(Red)/255.0 green:(Green)/255.0 blue:(Blue)/255.0 alpha:(Alpha)]
//[self.rightBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:0 blue:0 alpha:0.7] forState:UIControlStateNormal];
//self.rightBtn.backgroundColor = [UIColor colorWithRed:100/255.0 green:0 blue:0 alpha:0.5];

//改变按钮的背景颜色及状态(停止)
#define CHANGE_TO_STOP  \
[self.rightBtn setTitle:@"停止" forState:UIControlStateNormal];   \
[self.rightBtn setTitleColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.7] forState:UIControlStateNormal];  \
self.rightBtn.backgroundView.backgroundColor = [UIColor colorWithRed:100/255.0 green:0 blue:0 alpha:0.5];

//SET_COLOR(255, 0, 0, 0.7)
//改变按钮的背景颜色及状态(启动)
#define CHANGE_TO_START  \
[self.rightBtn setTitle:@"启动" forState:UIControlStateNormal];   \
[self.rightBtn setTitleColor:[UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.7] forState:UIControlStateNormal];  \
self.rightBtn.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:100/255.0 blue:0 alpha:0.5];

#import "CircleButton.h"
#import "Masonry.h"
#import "TimeModel.h"
#import "RecordCell.h"
#import "RecordModel.h"
#import "DoubleCircleButton.h"


#pragma - mark 初始化数据
extern CGFloat btnWidth;   //button的直径
extern UIColor *backgroundColor;
static NSString *tag = @"timeRecord";
extern CGFloat border;
static BOOL resetEnabled = NO;   //停止计时时，复位按钮可用
static int flag = 0;            //flag = 0：初始状态； flag = 1：计时状态；   flag = 2：停止计时状态
static int count = 0;       //记录TimeRecord 的“计次”数
static int maxTimeRecordIndex = -1;//保存最大时长及最小时长的记录的index
static int minTimeRecordIndex = -1;  //第二条数据
CGFloat cellEdgeOffset = 10;

@interface ViewController()<UITableViewDataSource,UITableViewDelegate>
//ui控件
@property(nonatomic,weak)UILabel * timeLabel;
@property(nonatomic,weak)DoubleCircleButton * leftBtn;
@property(nonatomic,weak)DoubleCircleButton * rightBtn;
@property(nonatomic,weak)UITableView * recordTableView;

//总时间定时器
@property(nonatomic,weak)NSTimer * totalTimer;
//数据模型
@property(nonatomic,strong)TimeModel *timeModel;
@property(nonatomic,strong)TimeModel * totalTime;
@property(nonatomic,strong)NSMutableArray<RecordModel*> * cellDataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - 数据初始化
    //数据初始化 按钮宽度、各控件背景颜色
    btnWidth = self.view.frame.size.width / 4.5;
    border =  3;
    backgroundColor = [UIColor colorWithRed:(20/255.0) green:(20/255.0) blue:(20/255.0) alpha:(1.0)];
    self.totalTime = [[TimeModel alloc]init];
    self.cellDataArray = [NSMutableArray array];
    
#pragma mark - 添加子控件
    //添加子控件
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];

    UILabel *titleLabel = [[UILabel alloc] init];
    [topView addSubview:titleLabel];
    
    UIView *divider = [[UIView alloc] init];
    [self.view addSubview:divider];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [scrollView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:pageControl];
    
    DoubleCircleButton *leftBtnTemp = [[DoubleCircleButton alloc] init];
    [self.view addSubview:leftBtnTemp];
    self.leftBtn = leftBtnTemp;
    
    DoubleCircleButton *rightBtnTemp = [[DoubleCircleButton alloc] init];
    [self.view addSubview:rightBtnTemp];
    self.rightBtn = rightBtnTemp;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain]; //初始化tableView
     [self.view addSubview:tableView];
     self.recordTableView = tableView;
    
#pragma mark - 设置各控件属性
    //titleLabel
    titleLabel.text = @"秒表";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setNumberOfLines:1];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    //topView
    topView.backgroundColor = [UIColor colorWithRed:(30/255.0) green:(30/255.0) blue:(30/255.0) alpha:1];
    
    //divider
    divider.backgroundColor = [UIColor colorWithRed:(100/255.0) green:(100/255.0) blue:(100/255.0) alpha:1];
    
    //UIScrollView
    scrollView.backgroundColor = backgroundColor;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2 ,0);
    scrollView.bounces = NO;    //弹簧效果
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.pagingEnabled = YES;
    
    //timeLabel
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.text = [NSString stringWithFormat:@"00:00.00"];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont monospacedDigitSystemFontOfSize:200.0 weight:UIFontWeightRegular];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.numberOfLines = 1;
   
    //pageControl
    pageControl.numberOfPages = 2;
    pageControl.pageIndicatorTintColor = topView.backgroundColor;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:pageControl];
   
    //leftBtn
    leftBtnTemp.enabled = NO;
    [leftBtnTemp setTitle:@"计次" forState:UIControlStateDisabled];
    [leftBtnTemp setTitleColor:[UIColor colorWithWhite:100 alpha:0.3] forState:UIControlStateDisabled];
    leftBtnTemp.backgroundView.backgroundColor = [UIColor colorWithRed:(50/255.0) green:(50/255.0) blue:(50/255.0) alpha:0.7];
    leftBtnTemp.layer.borderWidth = border;
    leftBtnTemp.layer.borderColor = scrollView.backgroundColor.CGColor;
    
    //rightBtn
    [rightBtnTemp setTitle:@"启动" forState:UIControlStateNormal];
    [rightBtnTemp setTitleColor:[UIColor colorWithRed:(0/255.0) green:(255/255.0) blue:(0/255.0) alpha:0.7] forState:UIControlStateNormal] ;
    rightBtnTemp.backgroundView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(100/255.0) blue:(0/255.0) alpha:0.5];
    rightBtnTemp.layer.borderWidth = border;
    rightBtnTemp.layer.borderColor = scrollView.backgroundColor.CGColor;
    
    //tableView
    tableView.backgroundColor = scrollView.backgroundColor;
    self.view.backgroundColor = scrollView.backgroundColor;
    tableView.rowHeight = 50;   //设置cell行高
    tableView.bounces = YES;
    //设置cell的分割线
    tableView.separatorInset = UIEdgeInsetsMake(0, cellEdgeOffset, 0, cellEdgeOffset);
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//设置tableView的h滚动条的颜色
    
#pragma mark - 设置约束
    //titleLabel
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.view.topMargin).offset(10);
        make.width.equalTo(50);
    }];

    //topView
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.width);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(titleLabel.bottom).offset(10);
    }];
    
    //divider
    [divider makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom);
        make.width.equalTo(self.view.width);
        make.height.equalTo(1);
    }];
    
    //UIScrollView
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.width);
        make.top.equalTo(divider.bottom);
        make.height.equalTo(self.view.height).offset(-(topView.frame.size.height)).multipliedBy(0.5);
    }];
    
    //timeLabel
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(scrollView.width);
        make.centerX.equalTo(scrollView.centerX);
        make.centerY.equalTo(scrollView.centerY);
    }];
   
    //clockTestLabel
    UILabel *testLabel = [[UILabel alloc]init];
    [scrollView addSubview:testLabel];
    [testLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(scrollView.width);
        make.height.equalTo(100);
        make.left.equalTo(timeLabel.right);
        make.centerY.equalTo(scrollView.centerY);
    }];
     testLabel.backgroundColor = [UIColor redColor];
   
    //UIPageControl
    [pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([pageControl superview].centerX);
        make.top.equalTo(scrollView.bottom);
    }];
    
    //leftBtn
    [leftBtnTemp makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(btnWidth, btnWidth));
        make.centerY.equalTo(pageControl.centerY);
        make.left.equalTo(self.view.left).offset(10);
    }];
    
    //rightBtn
    [rightBtnTemp makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(btnWidth, btnWidth));
        make.centerY.equalTo(pageControl.centerY);
        make.right.equalTo(self.view.right).offset(-10);
    }];
    
    //TableView
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftBtnTemp.bottom).offset(10);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
    }];
    //设置代理
    tableView.delegate = self;
    tableView.dataSource = self;
//    [tableView registerClass:[RecordCell class] forCellReuseIdentifier:tag];    //注册cell

#pragma mark - 监听按钮点击
    [leftBtnTemp addTarget:self action:@selector(clickRecordOrReset) forControlEvents:UIControlEventTouchUpInside]; //leftBtn
    [leftBtnTemp addTarget:self action:@selector(changeBtnBackgroundColor:) forControlEvents:UIControlEventTouchDown];
    
    [rightBtnTemp addTarget:self action:@selector(clickStartOrStop) forControlEvents:UIControlEventTouchUpInside];  //rightBtn
    [rightBtnTemp addTarget:self action:@selector(changeBtnBackgroundColor:) forControlEvents:UIControlEventTouchDown];
    
    //监听“启动”
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTotaltimeMsecond) name:@"startTiming" object:self];
}


#pragma - mark 按钮点击事件
- (void)changeBtnBackgroundColor:(DoubleCircleButton*)btn
{
   btn.backgroundView.backgroundColor = [btn.backgroundView.backgroundColor colorWithAlphaComponent:0.3];
}

- (void)start
{
    [self startTimer];//开启定时器
    CHANGE_TO_STOP  //修改为停止按钮
    [self.leftBtn setTitle:@"计次" forState:UIControlStateNormal];   //修改leftBtn为“计次”
    resetEnabled = NO;//复位按钮不可用
}

- (void)stop
{
    [self stopTimer];   //销毁计时器
    flag++;
    CHANGE_TO_START //修改为启动按钮
    [self.leftBtn setTitle:@"复位" forState:UIControlStateNormal];//修改为复位按钮
    resetEnabled = YES;//复位按钮可用
}



-(void)clickStartOrStop
{
    if (flag){
        if(1 == flag){//停止
            [self stop];
            return;
        }
        else if(2 == flag){//启动
            flag = flag % 2 + 1;
            [self start];
            return;
        }
    }
    //第一次启动 新建一个cell ==》即往数组中添加CellModel（通过修改数组模型改变cell）
    flag++;
    RecordModel *record = [[RecordModel alloc] init];
    record.count = ++count;
    [self.cellDataArray addObject:record];
    [self.recordTableView reloadData];
    
    //改变leftBtn的状态
    self.leftBtn.enabled = YES;
    [self.leftBtn setTitle:@"计次" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBtn.backgroundView.backgroundColor = SET_COLOR(100, 100, 100, 0.7);
    [self startTimer];  //开启定时器，在定时器中通知监听者
    CHANGE_TO_STOP  //修改为停止按钮
}


- (void)clickRecordOrReset
{
    self.leftBtn.backgroundView.backgroundColor = SET_COLOR(100, 100, 100, 0.7);    //修改leftBtn的颜色（highLight-》normal）
    if (!resetEnabled) {//点击"计次"
        //销毁计时器，重新开启一个计时器
        [self stopTimer];
        
        RecordModel *record = [[RecordModel alloc]init];    //在第一行插入一个cell
        record.count = ++count;
        [self.cellDataArray insertObject:record atIndex:0];
        
        [self startTimer];  //开启定时器
        
        //更新最值记录的颜色
        if (self.cellDataArray.count > 3){
            maxTimeRecordIndex++;
            minTimeRecordIndex++;
            RecordModel *newRecord = self.cellDataArray[1];// firstObject];  //取出第一条静态数据
            RecordModel *maxRecord = self.cellDataArray[maxTimeRecordIndex];
            RecordModel *minRecord = self.cellDataArray[minTimeRecordIndex];

            if ([newRecord.timeRecord isBiggerThan:maxRecord.timeRecord]){
                //修改maxIndexI及cell的颜色
                newRecord.recordColor = SET_COLOR(255, 0, 0, 0.7);
                maxRecord.recordColor = [UIColor whiteColor];
                maxTimeRecordIndex = 1;         //最长时间记录的索引
            }
            else if([newRecord.timeRecord isSmallerThan:minRecord.timeRecord]){
                //修改maxIndexI及cell的颜色
                newRecord.recordColor = SET_COLOR(0, 255, 0, 0.7);
                minRecord.recordColor = [UIColor whiteColor];
                minTimeRecordIndex = 1;
            }

        }
        else if(3 == self.cellDataArray.count){//有两条静态记录，初始化最大/小值
            RecordModel *firstRecord = self.cellDataArray[2];
            RecordModel *secondRecord = self.cellDataArray[1];
            if([firstRecord.timeRecord isBiggerThan:secondRecord.timeRecord]){
                maxTimeRecordIndex = 2;
                minTimeRecordIndex = 1;
            }
            else{
                maxTimeRecordIndex = 1;
                minTimeRecordIndex = 2;
            }
            self.cellDataArray[maxTimeRecordIndex].recordColor = SET_COLOR(255, 0, 0, 0.7);//设置原来的max为红色，min为绿色
            self.cellDataArray[minTimeRecordIndex].recordColor = SET_COLOR(0, 255, 0, 0.7);
        }
        [self.recordTableView reloadData];
        return;
    }
    else if(resetEnabled)//点击"复位"
    {
        resetEnabled = NO;
        [self.cellDataArray removeAllObjects];//清空cell模型
        self.totalTime.minute = 0;self.totalTime.second = 0;self.totalTime.msecond = 0;
        self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld",self.totalTime.minute,self.totalTime.second,self.totalTime.msecond]; //修改totalTimeLabel
        maxTimeRecordIndex = 0; //修改最大/最小记录为初始值
        maxTimeRecordIndex = 0;
        [self.recordTableView reloadData];    //更新model
        [self changeLeftBtn_to_DisabledRecordBtn];  //修改leftBtn状态为“不可用计次”
        flag = 0;   //修改flag为初始状态
        count = 0;  //计次重置为第一次
        return;
    }
}

#pragma - mark 修改按钮状态
- (void)changeLeftBtn_to_DisabledRecordBtn
{
    self.leftBtn.enabled = NO;
    [self.leftBtn setTitle:@"计次" forState:UIControlStateDisabled];
    [self.leftBtn setTitleColor:[UIColor colorWithWhite:100 alpha:0.3] forState:UIControlStateDisabled];
    self.leftBtn.backgroundView.backgroundColor = [UIColor colorWithRed:(50/255.0) green:(50/255.0) blue:(50/255.0) alpha:0.7];
}



#pragma - mark 定时器相关
//开启定时器（通知监听者点击了“启动/停止”）
- (void) startTimer
{
   self.totalTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(noticeTiming) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_totalTimer forMode:NSRunLoopCommonModes];
}

//停止定时器
- (void)stopTimer
{
    [self.totalTimer invalidate];
}

/*
 发布通知
 */
-(void) noticeTiming
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startTiming" object:self];     //通知监听者
}

#pragma - mark  Time++
- (void)addTotaltimeMsecond
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //从totalTime中取数据
        TimeModel *totalTime = self.totalTime;
        if (++(totalTime.msecond) == 100) {
            totalTime.msecond = 0;
            if(++(totalTime.second) == 60){
                totalTime.second = 0;
                (totalTime.minute)++;
            }
        }
        RecordModel *cellRecord = self.cellDataArray[0];    //取第一个cell的数据
        //修改cellModel
        if (++(cellRecord.timeRecord.msecond) == 100) {
            cellRecord.timeRecord.msecond = 0;
            if(++(cellRecord.timeRecord.second) == 60){
                cellRecord.timeRecord.second = 0;
                (cellRecord.timeRecord.minute)++;
            }
        }
        //更新UI（将model的值赋给控件的属性）
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timeLabel setText:[NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld",self.totalTime.minute,self.totalTime.second,self.totalTime.msecond] ];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            RecordCell *cell = [self.recordTableView cellForRowAtIndexPath:indexPath];
            cell.cellData = self.cellDataArray[0];
            
        });
    });
}

#pragma - mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
    if (cell == nil) {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
    }
    cell.cellData = self.cellDataArray[indexPath.row];
    return cell;
}

#pragma - mark 设置tableView上的分割线

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    UIView *divider = [[UIView alloc] init];
    [headerView addSubview:divider];
#warning 缺少约束
    [divider makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.top);
        make.bottom.equalTo(headerView.bottom);
        make.width.equalTo(headerView.width).offset(-cellEdgeOffset * 2);
        make.centerX.equalTo(headerView.centerX);
    }];
    divider.backgroundColor = tableView.separatorColor;
    return headerView;
}
@end
