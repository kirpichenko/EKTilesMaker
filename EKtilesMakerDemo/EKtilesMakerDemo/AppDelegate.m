//
//  AppDelegate.m
//  EKTilesMakerDemo
//
//  Created by Evgeniy Kirpichenko on 1/30/14.
//  Copyright (c) 2014 Evgeniy Kirpichenko. All rights reserved.
//

#import "AppDelegate.h"

#import "PhotoViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window setRootViewController:[PhotoViewController new]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
