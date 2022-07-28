//
//  TZMJRefreshManager.h
//  CQTZ_PROBE
//
//  Created by 余蛟 on 2021/3/10.
//  Copyright © 2021 Yujiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZMJRefreshManager : NSObject


+ (MJRefreshNormalHeader *)defaultHeader:(MJRefreshComponentAction)refreshingBlock;

+ (MJRefreshAutoNormalFooter *)defaultFooter:(MJRefreshComponentAction)refreshingBlock;

+ (MJRefreshAutoNormalFooter *)loadingDataNoTextFooter:(MJRefreshComponentAction)refreshingBlock;


@end

NS_ASSUME_NONNULL_END
