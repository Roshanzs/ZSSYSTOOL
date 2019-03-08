//
//  AppDelegate.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabbarViewController.h"
#import "EasyLoadingGlobalConfig.h"
#import "EasyTextGlobalConfig.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import <UMCommon/UMCommon.h>
#import <Bugly/Bugly.h>

@import GoogleMobileAds;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:BSCREEN];
    BaseTabbarViewController *TabbarVC = [[BaseTabbarViewController alloc]init];
//    MainViewController *mainVC = [[MainViewController alloc]init];
//    BaseNavigationController *mainNV = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = TabbarVC;
    [self.window makeKeyAndVisible];
    [self MonthClearLiuliangData];
    [self OtherSet];
    [self HUD];
    return YES;
}

-(void)OtherSet{
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UMConfigure initWithAppkey:@"5c1f5de1b465f5db5f000b00" channel:@"App Store"];
    [Bugly startWithAppId:@"a31beaeac4"];
    [GADMobileAds configureWithApplicationID:GGADID];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:GGADID];
}

//月初清零流量
-(void)MonthClearLiuliangData{
    [ShareTools CreatDBdate];
    id dic = [ShareTools ReadDicWithKey:SWITCHBTN];
    if ([dic intValue] == 1) {
        NSString *daystr = [ShareTools getNowTimeFromDate];
        NSRange dayrange = NSMakeRange(daystr.length - 2, 2);
        daystr = [daystr substringWithRange:dayrange];
        id clearDic = [ShareTools ReadDicWithKey:DAYMONTHCLEARBOOL];
        if (daystr.intValue == 1 && [clearDic intValue] == 0) {
            [ShareTools MonthClearLiuliangData];
            [ShareTools SaveStateWithValue:@"1" WithKey:DAYMONTHCLEARBOOL];
        }else{
            [ShareTools SaveStateWithValue:@"0" WithKey:DAYMONTHCLEARBOOL];
        }
    }
}


-(void)HUD{
    /**显示加载框**/
    EasyLoadingGlobalConfig *lodingConfig = [EasyLoadingGlobalConfig shared];
    lodingConfig.LoadingType = LoadingShowTypeIndicator;
    lodingConfig.bgColor = [UIColor whiteColor];
    lodingConfig.animationType = LoadingAnimationTypeFade;
    lodingConfig.showOnWindow = YES;
    /**显示文字**/
    EasyTextGlobalConfig *config = [EasyTextGlobalConfig shared];
    config.bgColor = [UIColor whiteColor];
    config.titleColor = [UIColor blackColor];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
