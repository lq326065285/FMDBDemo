//
//  AppDelegate.m
//  FMDBDemo
//
//  Created by 李强 on 14-12-22.
//  Copyright (c) 2014年 思埠集团. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic,assign)UIBackgroundTaskIdentifier backgroundUpdateTask;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self performSelector:@selector(showAlert) withObject:self afterDelay:20];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self beingBackgroundUpdateTask];
    // 在这里加上你需要长久运行的代码
    [self endBackGroundUpdateTask];
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        [self endBackGroundUpdateTask];
    }];
}

- (NSString *)DBFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    
    NSString *a = [NSString stringWithFormat:@"hehe.plist"];
    
    NSString *path = [docsPath stringByAppendingPathComponent:a];
    
    return path;
}


-(void)endBackGroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
//    [self performSelector:@selector(showAlert) withObject:self afterDelay:1];
}

-(void)showAlert
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"哈哈哈哈哈哈哈哈哈哈" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm createFileAtPath:[self DBFilePath] contents:nil attributes:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
