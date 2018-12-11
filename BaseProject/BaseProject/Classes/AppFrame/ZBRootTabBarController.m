//
//  ZBRootTabBarController.m
//  BaseProject
//
//  Created by bigfish on 2018/10/31.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "ZBRootTabBarController.h"
#import "ZBRootNavigationController.h"
#import "ZBHomeViewController.h"
#import "ZBMeViewController.h"




@interface ZBRootTabBarController ()

@end

@implementation ZBRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //child items
    NSArray *childItemsArray = @[
                                 @{
                                     ROOT_CLASS_KEY          : @"ZBHomeViewController",
                                     ROOT_TITLE_KEY          : @"Home",
                                     ROOT_IMAGE_KEY          : @"",
                                     ROOT_SELECTED_IMAGE_KEY : @""},
                                 @{
                                     ROOT_CLASS_KEY          : @"ZBMeViewController",
                                     ROOT_TITLE_KEY          : @"Me",
                                     ROOT_IMAGE_KEY          : @"",
                                     ROOT_SELECTED_IMAGE_KEY : @""},
                                 ];
    
    //add child controller
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict,
                                                  NSUInteger idx,
                                                  BOOL * _Nonnull stop) {
        UIViewController *vc = [NSClassFromString(dict[ROOT_CLASS_KEY]) new];
        vc.title = dict[ROOT_TITLE_KEY];
        ZBRootNavigationController *nav = [[ZBRootNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[ROOT_TITLE_KEY];
        item.image = [UIImage imageNamed:dict[ROOT_IMAGE_KEY]];
        item.selectedImage = [[UIImage imageNamed:dict[ROOT_SELECTED_IMAGE_KEY]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : GLOBAL_TINTCOLOR} forState:UIControlStateSelected];
        [self addChildViewController:nav];
        
    }];
    
    
    
    
    
    
    
    
    
    
    
}



@end
