//
//  AllGoodsViewController.m
//  Floral_mall
//
//  Created by zd on 2019/3/29.
//  Copyright © 2019 HTXQ. All rights reserved.
//

#import "AllGoodsViewController.h"

#import "AllGoodsListCell.h"

//#import "SDCycleScrollView.h"

#import "SDCycleScrollView.h"

@interface AllGoodsViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *navTitleView;

@property (strong, nonatomic) IBOutlet UIButton *areaButton;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UIView *searchBackgView;


@property (nonatomic, strong) UIScrollView *classScrollView;

@property (nonatomic, strong) NSMutableArray *classifyArr;

@property (nonatomic, strong) UIView *lineView_1;

@property (nonatomic, assign) NSInteger tabbarTag;

@property (nonatomic, strong) UIView *blackBackgView;

@property (nonatomic, strong) UITableView *goodsListView;

@property (nonatomic, strong) UIView *listHeaderView;

@property (nonatomic, strong) UIScrollView *secondClassifySC;

@property (nonatomic, strong) UIView *lineView_2;

@end

@implementation AllGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _navTitleView.frame = CGRectMake(0, 0, self.view.frame.size.width, kNavStatusHeight);
    [self.view addSubview:_navTitleView];
    _searchBackgView.layer.borderColor = [UIColor colorWithHexString:@"#E8E8E8"].CGColor;
    _searchBackgView.layer.borderWidth = 0.5;
    [_searchTextField setValue:Color77 forKeyPath:@"_placeholderLabel.textColor"];
    
    _blackBackgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavStatusHeight, kScreenWidth, kScreenHeight - kNavStatusHeight)];
    _blackBackgView.backgroundColor = [UIColor blackColor];
    _blackBackgView.hidden = YES;
    _blackBackgView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionDismiss)];
    [_blackBackgView addGestureRecognizer:tap];
    [self.view addSubview:_blackBackgView];


    _classifyArr = [NSMutableArray arrayWithObjects:@"鲜花", @"园艺", @"书籍", @"工具", @"资材", nil];
    
    [self loadClassScrollView];
    
    [self setupViews];
    
    [self loadSecondClassifySC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _searchTextField.width = kScreenWidth - 101 - _areaButton.width;
}

- (IBAction)selecteCityBtnClicked:(UIButton *)sender
{
    CityViewController * cvc = [[CityViewController alloc] init];
    cvc.delegete = self;
    cvc.cityName = _areaButton.titleLabel.text;
    [_searchTextField resignFirstResponder];
    [self tapActionDismiss];
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation
{
    [_areaButton setTitle:city forState:UIControlStateNormal];
}

-(void)loadClassScrollView
{
    _classScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavStatusHeight, kScreenWidth, 45)];
    _classScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_classScrollView];
    
    float scrollWidth = 18;
    
    for (int i = 0; i < _classifyArr.count; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(scrollWidth, 0, 50, 39)];
        [btn setTitleColor:Color97 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:regularFont size:16.0f];
        [btn setTitle:kFMString(_classifyArr[i]) forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(classifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.frame = CGRectMake(scrollWidth, 0, btn.width, 39);
        if (i == 0)
        {
            [btn setTitleColor:Color28 forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:mediumFont size:16];
            
            _lineView_1 = [[UIView alloc]initWithFrame:CGRectMake((btn.width - 31)/2 + 18, 42.5, 31, 2.5)];
            _lineView_1.backgroundColor = Color28;
            [_classScrollView addSubview:_lineView_1];
        }
        [_classScrollView addSubview:btn];
        
        scrollWidth += (btn.width + 25);
    }
    _classScrollView.contentSize = CGSizeMake(scrollWidth, 0);
    
    UIView *otherView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, _classScrollView.contentSize.width, 0.5)];
    if (_classScrollView.contentSize.width < kScreenWidth)
    {
        otherView.width = kScreenWidth;
    }
    otherView.backgroundColor = ColorEC;
    [_classScrollView addSubview:otherView];
}

-(void)classifyBtnClicked:(UIButton *)sender
{
    _tabbarTag = sender.tag;
    for (UIView *view in _classScrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btnView = (UIButton *)view;
            if (btnView.tag == sender.tag)
            {
                [btnView setTitleColor:Color28 forState:UIControlStateNormal];
                btnView.titleLabel.font = [UIFont fontWithName:mediumFont size:16];
            }
            else
            {
                [btnView setTitleColor:Color97 forState:UIControlStateNormal];
                btnView.titleLabel.font = [UIFont fontWithName:regularFont size:16.0f];
            }
        }
    }
    
    _lineView_1.x = (sender.width - 31)/2 + sender.x;
    
    if (sender.x + sender.width > _classScrollView.contentOffset.x + kScreenWidth)
    {
        _classScrollView.contentOffset = CGPointMake(sender.x + sender.width - kScreenWidth, 0);
    }
}

-(void)loadSecondClassifySC
{
    NSArray *titleArr = @[@"人气", @"玫瑰玫瑰玫瑰玫瑰", @"满天星", @"郁金香", @"百合", @"兰花", @"芍药", @"人气", @"玫瑰", @"满天星", @"郁金香", @"百合", @"兰花", @"芍药", @"人气", @"玫瑰", @"满天星", @"郁金香", @"百合", @"兰花", @"芍药"];
    
    _secondClassifySC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavStatusHeight + 45 + kScreenWidth/2, 90, kScreenHeight - kTabHeight - kNavStatusHeight - 45 - kScreenWidth/2 - 5)];
    _secondClassifySC.showsHorizontalScrollIndicator = NO;
    _secondClassifySC.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.view addSubview:_secondClassifySC];
    
    for (int i = 0; i < titleArr.count; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45*i, 90, 45)];
        [btn setTitleColor:Color77 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:regularFont size:14.0f];
        [btn setTitle:kFMString(titleArr[i]) forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        btn.tag = i;
        [btn addTarget:self action:@selector(secondClassifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_secondClassifySC addSubview:btn];
        if (i == 0)
        {
            [btn setTitleColor:[UIColor colorWithHexString:@"#58668A"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:mediumFont size:14];
            btn.backgroundColor = [UIColor whiteColor];
            
            [btn setImage:[UIImage imageNamed:@"goods_list_hot"] forState:UIControlStateNormal];
            
            float titleY = (btn.width - btn.titleLabel.bounds.size.width)/2 - (btn.width - btn.titleLabel.bounds.size.width - btn.imageView.size.width - 5)/2;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.size.width + titleY, 0, btn.imageView.size.width)];
            
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width + titleY + 5, 0, -btn.titleLabel.bounds.size.width)];
        }
    }
    
    _lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 4, 15)];
    _lineView_2.backgroundColor = [UIColor colorWithHexString:@"#58668A"];
    [_secondClassifySC addSubview:_lineView_2];

    _secondClassifySC.contentSize = CGSizeMake(0, 45*titleArr.count);
}

-(void)secondClassifyBtnClicked:(UIButton *)sender
{
    for (UIView *view in _secondClassifySC.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btnView = (UIButton *)view;
            if (btnView.tag == sender.tag)
            {
                [btnView setTitleColor:[UIColor colorWithHexString:@"#58668A"] forState:UIControlStateNormal];
                btnView.titleLabel.font = [UIFont fontWithName:mediumFont size:14];
                btnView.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                [btnView setTitleColor:Color77 forState:UIControlStateNormal];
                btnView.titleLabel.font = [UIFont fontWithName:regularFont size:14];
                btnView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
            }
        }
    }
    
    _lineView_2.y = 15 + sender.y;
}

- (void)tapActionDismiss
{
    _blackBackgView.hidden = YES;
    [_searchTextField resignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        _blackBackgView.alpha = 0;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _blackBackgView.hidden = NO;
    [self.view insertSubview:_blackBackgView atIndex:99];
    [UIView animateWithDuration:0.2f animations:^{
        _blackBackgView.alpha = 0.5;
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    FMGoodsThemeViewController * vc = [[FMGoodsThemeViewController alloc] init];
//    vc.themeType = GoodsTheme_Type_Search;
//    vc.name = _searchTextField.text;
//    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"curentCity"];
//    vc.city = city;
//    [_searchTextField resignFirstResponder];
//    [self tapActionDismiss];
//    [self.navigationController pushViewController:vc animated:YES];
    [_searchTextField resignFirstResponder];
    [self tapActionDismiss];
    GoodsSearchViewController *vc = [[GoodsSearchViewController alloc]init];
    vc.textStr = _searchTextField.text;
    vc.cityStr = _areaButton.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}


- (void)setupViews
{
    //    self.data = [NSArray array];
    
    [self reloadTableHeaderView];
    
    self.goodsListView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavStatusHeight + 45, kViewWidth, kScreenHeight - kTabHeight - kNavStatusHeight - 45 - 5) style:UITableViewStyleGrouped];
    self.goodsListView.delegate = self;
    self.goodsListView.dataSource = self;
    self.goodsListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsListView.backgroundColor = [UIColor whiteColor];

    
    [self.view addSubview:self.goodsListView];
    
    UINib *nib = [UINib nibWithNibName:@"AllGoodsListCell" bundle:nil];
    [self.goodsListView registerNib:nib forCellReuseIdentifier:@"AllGoodsListCell"];
    
    [self.goodsListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //    [self.tableView.header beginRefreshing];
    
    [self.goodsListView setTableHeaderView:_listHeaderView];
    
    if (@available(iOS 11.0, *))
    {
        self.goodsListView.estimatedRowHeight = 0;
        self.goodsListView.estimatedSectionHeaderHeight = 0;
        self.goodsListView.estimatedSectionFooterHeight = 0;
    }
}

-(void)reloadTableHeaderView
{
    _listHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2 + 7.5)];
    
    SDCycleScrollView *imgScrollView =[[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    
    NSArray *imageArr = @[@"http://static.htxq.net/UploadFiles/2018/10/25/20181025161706737308.jpg?x-oss-process=image/resize,m_fill,w_400,h_400,limit_0/auto-orient,1/quality,q_90/format,jpg/interlace,1",@"http://static.htxq.net/UploadFiles/2018/09/11/20180911163438503784.jpg?x-oss-process=image/resize,m_fill,w_400,h_400,limit_0/auto-orient,1/quality,q_90/format,jpg/interlace,1",@"http://static.htxq.net/UploadFiles/2018/06/25/20180625144202685847.jpg?x-oss-process=image/resize,m_fill,w_400,h_400,limit_0/auto-orient,1/quality,q_90/format,jpg/interlace,1",@"http://static.htxq.net/UploadFiles/2018/09/11/20180911163438503784.jpg?x-oss-process=image/resize,m_fill,w_400,h_400,limit_0/auto-orient,1/quality,q_90/format,jpg/interlace,1",@"http://static.htxq.net/UploadFiles/2018/10/25/20181025161706737308.jpg?x-oss-process=image/resize,m_fill,w_400,h_400,limit_0/auto-orient,1/quality,q_90/format,jpg/interlace,1"];
    imgScrollView.showPageControl = YES;//设置分页控制器
    imgScrollView.imageURLStringsGroup = imageArr;  //赋值多图
    imgScrollView.delegate = self;
    imgScrollView.infiniteLoop = NO;
    imgScrollView.autoScroll = NO;
    imgScrollView.backgroundColor = [UIColor whiteColor];
    imgScrollView.layer.cornerRadius = 0;
    imgScrollView.clipsToBounds = YES;
    imgScrollView.pageControlBottomOffset = 10;
    imgScrollView.showPageBackgroundView = YES;
    
    [_listHeaderView addSubview:imgScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

-(void)refreshData
{
    [_goodsListView.header endRefreshing];
}

#pragma mark- UITableViewDelegate, UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllGoodsListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AllGoodsListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.videoModel = _videoListArr[indexPath.row];
//    if (_fromWhichView == 2)
//    {
//        cell.videoIsPay = YES;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _goodsListView)
    {
        NSLog(@"%f", scrollView.contentOffset.y);
        
        if ((kNavStatusHeight + 45 + kScreenWidth/2) - scrollView.contentOffset.y >= kNavStatusHeight + 45)
        {
            _secondClassifySC.y = (kNavStatusHeight + 45 + kScreenWidth/2) - scrollView.contentOffset.y;
            _secondClassifySC.height = kScreenHeight - _secondClassifySC.y - kTabHeight;
        }
        else
        {
            _secondClassifySC.y = kNavStatusHeight + 45;
            _secondClassifySC.height = kScreenHeight - kNavStatusHeight - 45 - kTabHeight;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
