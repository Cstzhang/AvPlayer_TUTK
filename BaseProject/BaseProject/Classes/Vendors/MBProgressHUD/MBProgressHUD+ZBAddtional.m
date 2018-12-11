//
//  MBProgressHUD+ZBAddtional.m
//  BaseProject
//
//  Created by bigfish on 2018/11/2.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "MBProgressHUD+ZBAddtional.h"
#import "MBProgressHUD+ZBHUDExtension.h"
#import <objc/runtime.h>

NSTimeInterval const kMinShowTime = 1.f;
NSTimeInterval const KHideAfterDelayTime = 1.2f;
NSTimeInterval const kActivityMinDismissTime = 0.5f;

static char kZBHUDCancelKey;


@implementation MBProgressHUD (ZBAddtional)

/** < create HUD > */
+ (MBProgressHUD *)zb_createHUD:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    return [MBProgressHUD showHUDAddedTo:view
                                animated:YES];
}

/** < Set up the HUD > */
+ (MBProgressHUD *)zb_configHUDWithView:(UIView *)view
                                  title:(NSString *)title
                            autoDismiss:(BOOL)autoDismiss
                             completion:(MBProgressHUDCompletionBlock)completion {
    MBProgressHUD *hud = [self zb_createHUD:view];
    /** < Word wrap > */
    hud.label.numberOfLines = 0;
    /** < Prompt words > */
    hud.title(title);
    /** < Remove hidden > */
    hud.removeFromSuperViewOnHide = YES;
    /** <Default content style: white text with black background > */
    hud.hudContentStyle(ZBHUDContentBlackStyle);
    /** < Automatic hidden > */
    if (autoDismiss) {
        [hud hideAnimated:YES
               afterDelay:KHideAfterDelayTime];
    }
    hud.completionBlock = completion;
    return hud;
}

+ (MBProgressHUD *)zb_showActivity {
    return [self zb_showActivityMessage:nil
                                 toView:nil];
}

+ (MBProgressHUD *)zb_showActivity:(UIView *)view {
    return [self zb_showActivityMessage:nil
                                 toView:view];
}

+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message {
    return [self zb_showActivityMessage:message
                                 toView:nil];
}

+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message
                                   toView:(UIView *)view {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:message
                                        autoDismiss:NO
                                         completion:nil];
    hud.mode = MBProgressHUDModeIndeterminate;
    /** < Load prompt minimum display time > */
    hud.minShowTime = kActivityMinDismissTime;
    return hud;
}

+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message
                                   toView:(UIView *)view
                             contentColor:(UIColor *)contentColor
                                maskColor:(UIColor *)maskColor
                               bezelColor:(UIColor *)bezelColor {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:message
                                        autoDismiss:NO
                                         completion:nil];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.hudContentColor(contentColor);
    hud.hudMaskColor(maskColor);
    hud.hudBezelColor(bezelColor);
    /** < Load prompt minimum display time > */
    hud.minShowTime = kActivityMinDismissTime;
    return hud;
}

+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message
                                   toView:(UIView *)view
                               titleColor:(UIColor *)titleColor
                                maskColor:(UIColor *)maskColor
                               bezelColor:(UIColor *)bezelColor {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:message
                                        autoDismiss:NO
                                         completion:nil];
    hud.titleColor(titleColor);
    hud.hudMaskColor(maskColor);
    hud.hudBezelColor(bezelColor);
    /** < Load prompt minimum display time> */
    hud.minShowTime = kActivityMinDismissTime;
    return hud;
}

// MARK:Text
+ (void)zb_showMessage:(NSString *)message {
    [self zb_showMessage:message
                  toView:nil
              completion:nil];
}

+ (void)zb_showMessage:(NSString *)message
         detailMessage:(NSString *)detailMessage {
    [self zb_showMessage:message
             detailTitle:detailMessage
                  toView:nil
                position:ZBHUDPositionCenterStyle
            contentStyle:ZBHUDContentBlackStyle
              completion:nil];
}

+ (void)zb_showMessage:(NSString *)message
         detailMessage:(NSString *)detailMessage
                toView:(UIView *)view
              position:(ZBHUDPositionStyle)position {
    [self zb_showMessage:message
             detailTitle:detailMessage
                  toView:view
                position:position
            contentStyle:ZBHUDContentBlackStyle
              completion:nil];
}

+ (void)zb_showMessage:(NSString *)message
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showMessage:message
                  toView:nil
              completion:completion];
}

+ (void)zb_showMessage:(NSString *)message
                toView:(UIView *)view
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showMessage:message
             detailTitle:nil
                  toView:view
                position:ZBHUDPositionCenterStyle
            contentStyle:ZBHUDContentBlackStyle
              completion:completion];
}

+ (void)zb_showMessage:(NSString *)message
                toView:(UIView *)view
              position:(ZBHUDPositionStyle)position
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showMessage:message
             detailTitle:nil
                  toView:view
                position:position
            contentStyle:ZBHUDContentBlackStyle
              completion:completion];
}

+ (void)zb_showMessage:(NSString *)message
           detailTitle:(NSString *)detailTitle
                toView:(UIView *)view
              position:(ZBHUDPositionStyle)position
          contentStyle:(ZBHUDContentStyle)contentStyle
            completion:(MBProgressHUDCompletionBlock)completion {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:message
                                        autoDismiss:YES
                                         completion:completion];
    hud.mode = MBProgressHUDModeText;
    hud.detailTitle(detailTitle);
    hud.hudPositon(position);
    hud.hudContentStyle(contentStyle);
    hud.minShowTime = kMinShowTime;
}

// MARK:Image
+ (void)zb_showSuccess:(NSString *)success {
    [self zb_showSuccess:success
                  toView:nil
              completion:nil];
}
+ (void)zb_showSuccess:(NSString *)success
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showSuccess:success
                  toView:nil
              completion:completion];
}
+ (void)zb_showSuccess:(NSString *)success
                toView:(UIView *)view
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_show:success
             icon:@"success"
             view:view
       completion:completion];
}

+ (void)zb_showError:(NSString *)error {
    [self zb_showError:error
                toView:nil
            completion:nil];
}

+ (void)zb_showError:(NSString *)error
          completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showError:error
                toView:nil
            completion:completion];
}

+ (void)zb_showError:(NSString *)error
              toView:(UIView *)view
          completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_show:error
             icon:@"error"
             view:view
       completion:completion];
}

+ (void)zb_showInfo:(NSString *)info {
    [self zb_showInfo:info
               toView:nil
           completion:nil];
}

+ (void)zb_showInfo:(NSString *)info
         completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showInfo:info
               toView:nil
           completion:completion];
}

+ (void)zb_showInfo:(NSString *)info
             toView:(UIView *)view
         completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_show:info
             icon:@"ZBHUD_Info"
             view:view
       completion:completion];
}

+ (void)zb_showWarning:(NSString *)warning {
    [self zb_showWarning:warning
                  toView:nil
              completion:nil];
}

+ (void)zb_showWarning:(NSString *)warning
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_showWarning:warning
                  toView:nil
              completion:completion];
}

+ (void)zb_showWarning:(NSString *)warning
                toView:(UIView *)view
            completion:(MBProgressHUDCompletionBlock)completion {
    [self zb_show:warning
             icon:@"ZBHUD_Warn"
             view:view
       completion:completion];
}

+ (void)zb_show:(NSString *)text
           icon:(NSString *)icon
           view:(UIView *)view
     completion:(MBProgressHUDCompletionBlock)completion {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:text
                                        autoDismiss:YES
                                         completion:completion];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.iconName(icon);
}

// MARK:Switch Model
+ (MBProgressHUD *)zb_showModelSwitch:(UIView *)view
                                title:(NSString *)title
                          configBlock:(ZBHUDConfigBlock)configBlock {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:title
                                        autoDismiss:NO
                                         completion:nil];
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (configBlock) {
        configBlock(hud);
    }
    return hud;
}

// MARK:Progress
+ (MBProgressHUD *)zb_showDownloadToView:(UIView *)view
                           progressStyle:(ZBHUDProgressStyle)progressStyle
                                   title:(NSString *)title
                             configBlock:(ZBHUDConfigBlock)configBlock;
{
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:title
                                        autoDismiss:NO
                                         completion:nil];
    if (progressStyle == ZBProgressHUDModeDeterminateStyle) {
        hud.mode = MBProgressHUDModeDeterminate;
    }
    if (progressStyle == ZBProgressHUDModeAnnularDeterminateStyle) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (progressStyle == ZBProgressHUDModeDeterminateHorizontalBarStyle) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    }
    if (configBlock) {
        configBlock(hud);
    }
    return hud;
}

+ (MBProgressHUD *)zb_showDownloadToView:(UIView *)view
                           progressStyle:(ZBHUDProgressStyle)progressStyle
                                   title:(NSString *)title
                             cancelTitle:(NSString *)cancelTitle
                             configBlock:(ZBHUDConfigBlock)configBlock
                             cancelBlock:(ZBHUDCancelBlock)cancelBlock {
    MBProgressHUD *hud = [self zb_configHUDWithView:view
                                              title:title
                                        autoDismiss:NO
                                         completion:nil];
    if (progressStyle == ZBProgressHUDModeDeterminateStyle) {
        hud.mode = MBProgressHUDModeDeterminate;
    }
    if (progressStyle == ZBProgressHUDModeAnnularDeterminateStyle) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (progressStyle == ZBProgressHUDModeDeterminateHorizontalBarStyle) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    }
    [hud.button setTitle:cancelTitle ? : NSLocalizedString(@"Cancel", @"HUD cancel button title")
                forState:UIControlStateNormal];
    [hud.button addTarget:self
                   action:@selector(didClickedCancelBtn)
         forControlEvents:UIControlEventTouchUpInside];
    hud.cancelBlock = cancelBlock;
    
    if (configBlock) {
        configBlock(hud);
    }
    return hud;
}

//#pragma mark --------  Private Method  --------
//#pragma mark
//+ (UIViewController *)zb_getCurrentWindowVc
//{
//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tempWindow in windows)
//        {
//            if (tempWindow.windowLevel == UIWindowLevelNormal)
//            {
//                window = tempWindow;
//                break;
//            }
//        }
//    }
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//    {
//        result = nextResponder;
//    }
//    else
//    {
//        result = window.rootViewController;
//    }
//    return  result;
//}
//
//+ (UIViewController *)zb_getCurrentVc
//{
//    UIViewController  *superVC = [[self class]  zb_getCurrentWindowVc ];
//    if ([superVC isKindOfClass:[UITabBarController class]]) {
//        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
//        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
//            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
//        }
//        return tabSelectVC;
//    }else
//        if ([superVC isKindOfClass:[UINavigationController class]]) {
//            return ((UINavigationController*)superVC).viewControllers.lastObject;
//        }
//    return superVC;
//}

// MARK:Hide
+ (void)zb_hideHUD {
    [self zb_hideHUDForView:nil];
}

+ (void)zb_hideHUDForView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}

// MARK:Set the style
- (MBProgressHUD *(^)(ZBHUDContentStyle))hudContentStyle {
    return ^(ZBHUDContentStyle hudContentStyle) {
        switch (hudContentStyle) {
            case ZBHUDContentBlackStyle:
                self.contentColor = [UIColor whiteColor];
                self.bezelView.backgroundColor = [UIColor blackColor];
                self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
                break;
            case ZBHUDContentCustomStyle:
                self.contentColor = kZBHUDCustomContentColor;
                self.bezelView.backgroundColor = kZBHUDCustomBezelColor;
                self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
                break;
            default:
                self.contentColor = [UIColor blackColor];
                self.bezelView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
                self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
                break;
        }
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))hudMaskColor {
    return ^(UIColor *hudMaskColor) {
        self.backgroundView.backgroundColor = hudMaskColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))hudContentColor {
    return ^(UIColor *hudContentColor) {
        self.contentColor = hudContentColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))hudBezelColor {
    return ^(UIColor *hudBezelColor) {
        self.bezelView.backgroundColor = hudBezelColor;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))title {
    return ^(NSString *title) {
        self.label.text = title;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))detailTitle {
    return ^(NSString *detailTitle) {
        self.detailsLabel.text = detailTitle;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))titleColor {
    return ^(UIColor *titleColor) {
        self.label.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(ZBHUDPositionStyle))hudPositon {
    return ^(ZBHUDPositionStyle hudPositon) {
        switch (hudPositon) {
            case ZBHUDPositionTopStyle:
                self.offset = CGPointMake(0, -MBProgressMaxOffset);
                break;
            case ZBHUDPositionCenterStyle:
                self.offset = CGPointZero;
                break;
            case ZBHUDPositionBottomStyle:
                self.offset = CGPointMake(0, MBProgressMaxOffset);
                break;
            default:
                break;
        }
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))iconName {
    return ^(NSString *iconName) {
        self.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
        return self;
    };
}

- (void)setCancelBlock:(ZBHUDCancelBlock)cancelBlock {
    objc_setAssociatedObject(self, &kZBHUDCancelKey, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZBHUDCancelBlock)cancelBlock {
    return objc_getAssociatedObject(self, &kZBHUDCancelKey);
}

// MARK:Event Response
- (void)didClickedCancelBtn {
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}


@end
