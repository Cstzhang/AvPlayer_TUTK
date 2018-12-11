//
//  ZBHomeViewController.m
//  BaseProject
//
//  Created by bigfish on 2018/10/31.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "ZBHomeViewController.h"
//#import "avformat.h"
@interface ZBHomeViewController ()

@end

@implementation ZBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    //test http

//    [self testHUD];
//    [self testHttp];
    
    
    
    
    
}




#pragma mark - test testHUD
- (void)testHUD
{
    
    //    [MBProgressHUD zb_showActivity:self.view];
    //    [MBProgressHUD zb_showActivityMessage:@"加载中..."
    //                                   toView:self.view];
    //    [MBProgressHUD zb_showSuccess:@"登录成功"
    //                           toView:self.view
    //                       completion:nil];
    
    //    [MBProgressHUD zb_showError:@"失败提示"
    //                         toView:self.view
    //                     completion:nil];
    
    //    [MBProgressHUD zb_showInfo:@"信息提示"
    //                        toView:self.view
    //                    completion:nil];
    
    //    [MBProgressHUD zb_showWarning:@"警告提示"
    //                           toView:self.view
    //                       completion:nil];
    
    
    //    [MBProgressHUD zb_showMessage:@"信息提示"
    //                           toView:self.view
    //                         position:ZBHUDPositionBottomStyle
    //                       completion:^{
    //                           NSLog(@"显示完成");
    //                       }];
    //    [MBProgressHUD zb_showMessage:@"标题"
    //                    detailMessage:@"详情"];
//         __weak typeof(self) weakSelf = self;
//        [MBProgressHUD zb_showModelSwitch:self.view
//                                    title:@"准备下载..."
//                              configBlock:^(MBProgressHUD *hud) {
//                                  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//                                      // Do something useful in the background and update the HUD periodically.
//                                      [weakSelf doSomeWorkWithMixedProgress:hud];
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                          [hud hideAnimated:YES];
//                                      });
//                                  });
//                              }];
    
}

- (void)doSomeWorkWithMixedProgress:(MBProgressHUD *)hud {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"Cleaning up...", @"HUD cleanining up title");
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"MBProgressHUD.bundle/success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
    });
    sleep(2);
}



#pragma mark - test http

- (void)testHttp
{
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.URLString=@"http://39.104.94.117:8088/opssee-api/V1_0/directseedinglogin";
        request.methodType=ZBMethodTypePOST;//默认为GET
        request.apiType=ZBRequestTypeRefresh;//默认为ZBRequestTypeRefresh
        request.requestSerializer = ZBJSONRequestSerializer;
        request.parameters = @{
                               @"userId":@"1234567890",
                               @"idToken":@"1394528869756041231",
                               @"fullName":@"12345678901",
                               @"givenName":@"12345678901",
                               @"familyName":@"12345678901",
                               @"email":@"1234567890@qq.com",
                               @"clientType":@"2",
                               @"thirdType":@"2",
                               @"placeUserId":@"1234567890",
                               };
    } success:^(id responseObject, ZBApiType type, BOOL isCache) {
        
        NSLog(@" responseObject %@",responseObject);
    } failure:^(NSError *error) {
        
        NSLog(@" error %@",error.localizedDescription);
    }];
    
}


@end
