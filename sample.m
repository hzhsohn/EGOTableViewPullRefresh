//
//  DeviceList.m
//  discolor-led
//
//  Created by Han.zh on 15/2/7.
//  Copyright (c) 2015年 Han.zhihong. All rights reserved.
//

#import "DeviceList.h"
#import "EGORefreshTableHeaderView.h"


@interface DeviceList ()<EGORefreshTableHeaderDelegate,
                        UITableViewDelegate,
                        UITableViewDataSource,
                        AddDevCellDelegate,
                        McuCtrlNetDelegate>
{

    //下拉列表
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

//-------
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

@implementation DeviceList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        //[view release];
        view=nil;
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - Navigation


/////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            DevListCell *cell = (DevListCell *)[tableView
                                                dequeueReusableCellWithIdentifier: @"DevListCell_ID"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DevListCell"
                                                             owner:self options:nil];
                // NSLog(@"nib %d",[nib count]);
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[DevListCell class]])
                        cell = (DevListCell *)oneObject;
            }
    
            return cell;
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

///////////////////////////////////////////////
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    NSLog(@"刷新列表");
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
 
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

@end
