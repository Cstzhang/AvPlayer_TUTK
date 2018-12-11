//
//  MBProgressHUD+ZBAddtional.h
//  BaseProject
//
//  Created by bigfish on 2018/11/2.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, ZBHUDPositionStyle) {
    ZBHUDPositionTopStyle,      /** < top  > */
    ZBHUDPositionCenterStyle,   /** < Center > */
    ZBHUDPositionBottomStyle    /** < bottom > */
};

typedef NS_ENUM(NSInteger, ZBHUDContentStyle) {
    ZBHUDContentDefaultStyle,   /** < Default white background black word> */
    ZBHUDContentBlackStyle,     /** < black background white word > */
    ZBHUDContentCustomStyle     /** < Custom style > */
};

typedef NS_ENUM(NSInteger, ZBHUDProgressStyle) {
    ZBProgressHUDModeDeterminateStyle,              /*  < A round, pie-chart like, progress view. > */
    ZBProgressHUDModeDeterminateHorizontalBarStyle, /*  < Horizontal progress bar > */
    ZBProgressHUDModeAnnularDeterminateStyle        /*  < Ring-shaped progress view. > */
};

typedef void(^ZBHUDConfigBlock)(MBProgressHUD *hud);
typedef void(^ZBHUDCancelBlock)(MBProgressHUD *hud);

/**  < Minimum display time >  */
UIKIT_EXTERN NSTimeInterval const kMinShowTime;
/**  < Display disappears after a few seconds >  */
UIKIT_EXTERN NSTimeInterval const KHideAfterDelayTime;
/**  < Loading least shows time >  */
UIKIT_EXTERN NSTimeInterval const kActivityMinDismissTime;

/** < Text content color > */
#define kZBHUDCustomContentColor [UIColor colorWithWhite:1.f alpha:0.7f]
/** < Box Color  > */
#define kZBHUDCustomBezelColor [UIColor colorWithWhite:1.f alpha:0.7f]
/** < Custom mask color > */
#define kZBHUDCustomMaskBackgroundColor [[UIColor blackColor] colorWithAlphaComponent:0.5f];



@interface MBProgressHUD (ZBAddtional)
// MARK:Loading
/**
 Only show loading, not automatically disappear (white word + black background)
 
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showActivity;

/**
 Show loading only, not automatically disappear (white word + black background + custom view)
 
 @param view custom display view
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showActivity:(UIView *)view;

/**
 Loading + text (white word + black background)
 
 @param message load word
 @return  MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message;

/**
 Loading + text (white word + black background)
 
 @param message load word
 @param view custom display view
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message
                                   toView:(UIView *)view;

/**
 Loading + text (custom text + content color + mask color + container color)
 
 @param message load word
 @param view custom display view
 @param contentColor content color
 @param maskColor mask color
 @param bezelColor container color
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message
                                   toView:(UIView *)view
                             contentColor:(UIColor *)contentColor
                                maskColor:(UIColor *)maskColor
                               bezelColor:(UIColor *)bezelColor;

/**
 Loading + text (custom text + word color + mask color + container color)
 
 @param message load word
 @param view custom display view
 @param titleColor word color
 @param maskColor mask color
 @param bezelColor container color
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showActivityMessage:(NSString *)message
                                   toView:(UIView *)view
                               titleColor:(UIColor *)titleColor
                                maskColor:(UIColor *)maskColor
                               bezelColor:(UIColor *)bezelColor;

// MARK:Text
/**
 Prompt text (custom text + middle position + display at window)
 
 @param message text
 */
+ (void)zb_showMessage:(NSString *)message;

/**
 Prompt text (title + details text)
 
 @param message text
 @param detailMessage details text
 */
+ (void)zb_showMessage:(NSString *)message
         detailMessage:(NSString *)detailMessage;

/**
 Prompt text (title + details text + custom location + view)
 
 @param message text
 @param detailMessage details text
 @param position view
 */
+ (void)zb_showMessage:(NSString *)message
         detailMessage:(NSString *)detailMessage
                toView:(UIView *)view
              position:(ZBHUDPositionStyle)position;

/**
 Prompt text (custom text + middle position + displayed in window+ complete callback)
 
 @param message text
 @param completion complete callback
 */
+ (void)zb_showMessage:(NSString *)message
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Prompt text (custom text + middle position + custom display view + complete callback)
 
 @param message text
 @param view custom display view
 @param completion complete callback
 */
+ (void)zb_showMessage:(NSString *)message
                toView:(UIView *)view
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Prompt text (custom text + custom position + custom display view)
 
 @param message text
 @param view custom display view
 @param position position
 @param completion complete callback
 */
+ (void)zb_showMessage:(NSString *)message
                toView:(UIView *)view
              position:(ZBHUDPositionStyle)position
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Prompt text (custom text + details text + custom location + content style)
 
 @param message text
 @param detailTitle details text
 @param view custom display view
 @param position position
 @param contentStyle content style
 @param completion complete callback
 */
+ (void)zb_showMessage:(NSString *)message
           detailTitle:(NSString *)detailTitle
                toView:(UIView *)view
              position:(ZBHUDPositionStyle)position
          contentStyle:(ZBHUDContentStyle)contentStyle
            completion:(MBProgressHUDCompletionBlock)completion;

// MARK:Image

/**
 Custom success tips (displayed in window)
 
 @param success text
 */
+ (void)zb_showSuccess:(NSString *)success;

/**
 Custom success tips (displayed in window + complete callback)
 
 @param success text
 @param completion complete callback
 */
+ (void)zb_showSuccess:(NSString *)success
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Custom success prompt (display at window + complete callback + custom display view)
 
 @param success text
 @param view custom display view
 @param completion complete callback
 */
+ (void)zb_showSuccess:(NSString *)success
                toView:(UIView *)view
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Error message (displayed at window)
 
 @param error text
 */
+ (void)zb_showError:(NSString *)error;

/**
 Error message (display at window + complete callback)
 
 @param error text
 @param completion complete callback
 */
+ (void)zb_showError:(NSString *)error
          completion:(MBProgressHUDCompletionBlock)completion;

/**
 Error message (display at window + complete callback + custom display view)
 
 @param error text
 @param view custom display view
 @param completion complete callback
 */
+ (void)zb_showError:(NSString *)error
              toView:(UIView *)view
          completion:(MBProgressHUDCompletionBlock)completion;

/**
 Message prompt (window)
 
 @param info text
 */
+ (void)zb_showInfo:(NSString *)info;

/**
 Message prompt (window + complete callback)
 
 @param info text
 @param completion complete callback
 */
+ (void)zb_showInfo:(NSString *)info
         completion:(MBProgressHUDCompletionBlock)completion;

/**
 Message prompt (window + complete callback + custom display view)
 
 @param info text
 @param view custom display view
 @param completion complete callback
 */
+ (void)zb_showInfo:(NSString *)info
             toView:(UIView *)view
         completion:(MBProgressHUDCompletionBlock)completion;

/**
 Warning alert (window)
 
 @param warning text
 */
+ (void)zb_showWarning:(NSString *)warning;

/**
 Warning (window + complete callback)
 
 @param warning text
 @param completion complete callback
 */
+ (void)zb_showWarning:(NSString *)warning
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Warning prompt (window + complete callback + custom view)
 
 @param warning text
 @param view custom display view
 @param completion complete callback
 */
+ (void)zb_showWarning:(NSString *)warning
                toView:(UIView *)view
            completion:(MBProgressHUDCompletionBlock)completion;

/**
 Custom picture + text prompt
 
 @param text text
 @param icon iamge name
 @param view custom display view
 @param completion complete callback
 */
+ (void)zb_show:(NSString *)text
           icon:(NSString *)icon
           view:(UIView *)view
     completion:(MBProgressHUDCompletionBlock)completion;

// MARK:Switch Model
/**
 Model switching
 
 @param view custom display view
 @param title text
 @param configBlock configuration hud
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showModelSwitch:(UIView *)view
                                title:(NSString *)title
                          configBlock:(ZBHUDConfigBlock)configBlock;

// MARK:Progress
/**
 Text + progress bar
 
 @param view custom display view
 @param progressStyle Progress style
 @param title Prompt words
 @param configBlock Progress block
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showDownloadToView:(UIView *)view
                           progressStyle:(ZBHUDProgressStyle)progressStyle
                                   title:(NSString *)title
                             configBlock:(ZBHUDConfigBlock)configBlock;

/**
 Text + progress bar + cancel button
 
 @param view custom display view
 @param progressStyle Progress style
 @param title Prompt words
 @param cancelTitle Cancel button title
 @param configBlock Progress block
 @param cancelBlock  cancel button clicks  callback
 @return MBProgressHUD Instance objects
 */
+ (MBProgressHUD *)zb_showDownloadToView:(UIView *)view
                           progressStyle:(ZBHUDProgressStyle)progressStyle
                                   title:(NSString *)title
                             cancelTitle:(NSString *)cancelTitle
                             configBlock:(ZBHUDConfigBlock)configBlock
                             cancelBlock:(ZBHUDCancelBlock)cancelBlock;

// MARK:Hide
+ (void)zb_hideHUD;
+ (void)zb_hideHUDForView:(UIView *)view;

@end


