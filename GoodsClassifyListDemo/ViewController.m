//
//  ViewController.m
//  GoodsClassifyListDemo
//
//  Created by zd on 2019/4/19.
//  Copyright © 2019 ZD. All rights reserved.
//

#import "ViewController.h"
#import "AllGoodsListCell.h"
#define RandomColor [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1.0]
#define kSTATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height//add by yanghui 2017-10-09 11:02:11
#define kSCREENTOP_HEIGHT kSTATUSBAR_HEIGHT + 44//add by yanghui 2017-10-09 11:02:20
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger provincesTag;//选中省份索引
@property (nonatomic, assign) NSInteger cityTag;//选中城市索引

@property (nonatomic, strong) UITableView *goodsListView;
@property (nonatomic, strong) UIScrollView *secondClassifySC;
@property (nonatomic, strong) UIView *lineView_2;

//@property (nonatomic, strong) NSMutableArray *classNameArr;
//@property (nonatomic, strong) NSMutableArray *subNameArr;

@property(nonatomic, strong)NSMutableArray *provincesArray;//省份
@property(nonatomic, strong)NSMutableArray *cityArray;//城市
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"商品列表";
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [self loadUIData];
    [self setupViews];
    [self loadSecondClassifySC];
    [self secondClassifyBtnClicked:[self.view viewWithTag:self.provincesTag]];
    NSIndexPath *ip=[NSIndexPath indexPathForRow:self.cityTag inSection:0];
    [self.goodsListView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

-(void)loadUIData{
    self.provincesArray = [NSMutableArray arrayWithObjects:@"观花植物",@"观叶植物",@"多肉植物",@"草本植物",@"木本植物",@"水生植物",@"水培植物", nil];
    self.cityArray = [NSMutableArray arrayWithObjects:
  @[@"橙红茑萝", @"红花羊蹄甲",@"大花篮盆花", @"碧冬茄属", @"黄绿贝母兰", @"白花夹竹桃", @"厚萼凌霄", @"达乌里秦艽", @"广布红门兰", @"半钟铁线莲", @"长寿花", @"鸡蛋花", @"六月雪", @"虎刺梅", @"羊蹄甲", @"单瓣黄刺玫", @"仙人指", @"粉紫重瓣木槿", @"粉苞酸脚杆", @"多花野牡丹", @"滇山茶", @"鹿角海棠",@"垂枝红千层",@"扶桑",@"美人蕉",@"令箭荷花",@"沙漠玫瑰",@"倒挂金钟",@"金边瑞香",@"垂笑君子兰"],
  @[@"星点秋海棠", @"美叶凤尾蕉",@"大王黛粉叶", @"紫鹅绒", @"文殊兰", @"水竹", @"橡皮树", @"龟背竹", @"白掌", @"鸭脚木", @"袖珍椰子", @"富贵竹"],
  @[@"紫牡丹", @"白龙球",@"四裂红景天", @"黄雪光", @"蝉翼玉露", @"大型玉露", @"樱麒麟", @"圆头玉露", @"星乙女", @"樱水晶", @"清盛锦", @"玉龙观音", @"绯牡丹", @"特玉莲", @"五十铃玉", @"虹之玉"],
  @[@"大花蕙兰", @"鹤望兰",@"牡丹", @"黑水亚麻", @"爪哇白豆蔻", @"白毛羊胡子草", @"扁茎灯心草", @"阿尔泰菊蒿", @"匙叶茅膏菜", @"大花麦瓶草", @"大花鸡肉参", @"蒙特登慈菇", @"小露兜", @"旋蒴苣苔", @"圆叶茅膏菜", @"卜若地", @"艳红鹿子百合", @"紫瓶子草"],
  @[@"荔枝树", @"山莓",@"人心果", @"佛手", @"蛋黄果", @"桑树", @"无花果树", @"秋海棠花"],
  @[@"靖西海菜花", @"柔毛齿叶睡莲",@"马来眼子菜", @"大薸", @"再力花", @"美人蕉"],
  @[@"荷兰铁", @"朱顶红",@"镜面草", @"玉簪花", @"麒麟掌", @"扶桑", @"仙客来", @"滴水观音"],nil];
    
    for (int i = 0; i<self.cityArray.count; i++) {
        NSInteger inde = [self.cityArray[i] indexOfObject:self.nameStr];
        if (inde != NSNotFound) {
            self.cityTag = inde;
            self.provincesTag = i;
            return;
        }
    }
}

-(void)loadSecondClassifySC{
    CGFloat bottomLayout = kSTATUSBAR_HEIGHT == 44?39:0;
    _secondClassifySC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kSTATUSBAR_HEIGHT + 44, 90, self.view.frame.size.height - kSTATUSBAR_HEIGHT - 44 - bottomLayout)];
    if (@available(iOS 11.0, *)){
        _secondClassifySC.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _secondClassifySC.showsHorizontalScrollIndicator = NO;
    _secondClassifySC.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_secondClassifySC];
    for (int i = 0; i < self.provincesArray.count; i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45*i, 90, 45)];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:self.provincesArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = RandomColor;
        btn.tag = i;
        [btn addTarget:self action:@selector(secondClassifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_secondClassifySC addSubview:btn];
    }
    _lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 4, 15)];
    _lineView_2.backgroundColor = [UIColor colorWithRed:36/255.0 green:156/255.0 blue:155/255.0 alpha:1.0];
    [_secondClassifySC addSubview:_lineView_2];
    _secondClassifySC.contentSize = CGSizeMake(0, 45*self.provincesArray.count);
}

-(void)secondClassifyBtnClicked:(UIButton *)sender{
    NSLog(@"二级分类点击事件");
    self.provincesTag = sender.tag;
    for (UIView *view in _secondClassifySC.subviews){
        if ([view isKindOfClass:[UIButton class]]){
            UIButton *btnView = (UIButton *)view;
            if (btnView.tag == sender.tag){
                [btnView setTitleColor:[UIColor colorWithRed:36/255.0 green:156/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
            }else{
                [btnView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
    }
    _lineView_2.frame = CGRectMake(0, 15 + sender.frame.origin.y, 4, 15);
    if (45*self.provincesTag>self.secondClassifySC.frame.size.height) {
        self.secondClassifySC.contentOffset = CGPointMake(0, 45*self.provincesTag);
    }
    [self.goodsListView reloadData];
}


- (void)setupViews{
    CGFloat bottomLayout = kSTATUSBAR_HEIGHT == 44?39:0;
    self.goodsListView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSTATUSBAR_HEIGHT + 44, self.view.frame.size.width, self.view.frame.size.height - kSTATUSBAR_HEIGHT - 44 - bottomLayout) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)){
        self.goodsListView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.goodsListView.delegate = self;
    self.goodsListView.dataSource = self;
    self.goodsListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsListView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.goodsListView];
}

#pragma mark- UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *subArr = self.cityArray[self.provincesTag];
    return subArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllGoodsListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AllGoodsListCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllGoodsListCell" owner:nil options:nil] firstObject];
    }
    cell.backgroundColor = RandomColor;
    NSArray *subArr = self.cityArray[self.provincesTag];
    cell.titleNameLabel.text = subArr[indexPath.row];
    cell.titleNameLabel.highlightedTextColor = [UIColor colorWithRed:36/255.0 green:156/255.0 blue:155/255.0 alpha:1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *subArr = self.cityArray[self.provincesTag];
    NSLog(@"===============最终选择了：%@",subArr[indexPath.row]);
    self.nameBlock(subArr[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
