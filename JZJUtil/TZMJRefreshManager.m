//
//  TZMJRefreshManager.m
//  CQTZ_PROBE
//
//  Created by 余蛟 on 2021/3/10.
//  Copyright © 2021 Yujiao. All rights reserved.
//

#import "TZMJRefreshManager.h"

@implementation TZMJRefreshManager

+ (MJRefreshNormalHeader *)defaultHeader:(MJRefreshComponentAction)refreshingBlock {
//    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    // 往下拉的时候文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    // 松手时候的文字
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    //颜色
    header.stateLabel.textColor = APP_TITLE_COLOR;
    header.lastUpdatedTimeLabel.textColor = APP_TITLE_COLOR;
    
    header.loadingView.color = APP_TITLE_COLOR;

    return header;
}

//MJRefreshBackNormalFooter 最下面，可以选一个最上面
+ (MJRefreshBackNormalFooter *)defaultFooter:(MJRefreshComponentAction)refreshingBlock {
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
    [footer setTitle:@"上拉或点击加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"-到底啦-" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    //颜色
    footer.stateLabel.textColor = APP_TITLE_COLOR;

    return footer;
}

+ (MJRefreshAutoNormalFooter *)loadingDataNoTextFooter:(MJRefreshComponentAction)refreshingBlock {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    [footer setTitle:@"加载失败，点击重新加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"-到底啦-" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    //颜色
    footer.stateLabel.textColor = APP_TITLE_COLOR;
    return footer;
}

@end
