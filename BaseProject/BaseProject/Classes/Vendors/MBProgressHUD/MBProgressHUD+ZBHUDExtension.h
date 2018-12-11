//
//  MBProgressHUD+ZBHUDExtension.h
//  BaseProject
//
//  Created by bigfish on 2018/11/2.
//  Copyright © 2018 bigfish. All rights reserved.
//
#import <MBProgressHUD/MBProgressHUD.h>


@interface MBProgressHUD ()

// MARK:Property
/** < Content text color defaults：ZBHUDContentBlackStyle > */
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudContentStyle)(ZBHUDContentStyle hudContentStyle);
/** < mask color > */
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudMaskColor)(UIColor *hudMaskColor);
/** < Content color > */
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudContentColor)(UIColor *hudContentColor);
/** < container color > */
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudBezelColor)(UIColor *hudBezelColor);
/** < title > */
@property (nonatomic, copy, readonly) MBProgressHUD *(^title)(NSString *title);
/** < Details title > */
@property (nonatomic, copy, readonly) MBProgressHUD *(^detailTitle)(NSString *detailTitle);
/** < title color > */
@property (nonatomic, strong, readonly) MBProgressHUD *(^titleColor)(UIColor *titleColor);
/** < Text display position defaults：ZBHUDPositionCenterStyle > */
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudPositon)(ZBHUDPositionStyle hudPositon);
/*  < Customize image name > */
@property (nonatomic, copy, readonly) MBProgressHUD *(^iconName)(NSString *iconName);
/*  < Cancel button callback > */
@property (nonatomic, copy, readonly) ZBHUDCancelBlock cancelBlock;

@end
