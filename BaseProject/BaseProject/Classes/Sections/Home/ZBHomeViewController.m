//
//  ZBHomeViewController.m
//  BaseProject
//
//  Created by bigfish on 2018/10/31.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "ZBHomeViewController.h"
#import "ZBTutkClient.h"
#import "ZBH264Decoder.h"

#import "AVAPIs.h"
#import "AVIOCTRLDEFs.h"
#import "IOTCAPIs.h"
#import "AVFRAMEINFO.h"

#define MAX_SIZE_IOCTRL_BUF        1024

//#define UID                        @"C1KAB554Z3RMHH6GU1Z1"
#define UID                        @"CNYA955MRB7CJH6GY171"

#define IFRAME_FLAGS    @"1"  // IPC_FRAME_FLAG_IFRAME    = 0x01,  // A/V I frame.


@interface ZBHomeViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ZBHomeViewController{
    BOOL            isFindIFrame;
    BOOL            _firstDecoded;
    CGRect          rect; //显示吃尺寸
    ZBH264Decoder   *_decoder;
    
//    OpenAL2 *_openAl2;
//    PCMDataPlayer *_pcmDataPlayer;
//    PCMAudioRecorder *_pcmRecorder;
//    int  _avchannelForSendAudioData;
//    FILE *_pcmFile;
    unsigned int _timeStamp; // audio
    
}

#pragma mark -  Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    rect = CGRectMake(0, 20, screenWidth, screenWidth * 16 / 9);
    UIView *containerView = [[UIView alloc] initWithFrame:rect];
    self.imageView = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.image = [self getBlackImage];
    
    [containerView addSubview:self.imageView];
    [self.view addSubview:containerView];
    
    [MBProgressHUD zb_showActivity];
    
    //初始化解码器
    [self initData];

    //初始化P2P 客户端
    ZBTutkClient *client = [[ZBTutkClient alloc] init];
    [client start:UID];
    
    //添加监听 监听P2P传过来的图像数据，然后去解码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBuffer:) name:kNotificationNewBufferToDecode object:nil];
}




#pragma mark -  Private Methods


/**
初始化解码器
 */
- (void)initData
{
    _decoder = [[ZBH264Decoder alloc] init];
    [_decoder initVideoDecoder];
}

/**
 解码数据

 @param nalBuffer nalBuffer
 @param inSize frame size
 @param pts pts
 */
- (void)decodeFramesToImage:(uint8_t *)nalBuffer size:(int)inSize timeStamp:(unsigned int)pts {
    
    //解码
    CGSize fSize = [_decoder decodeNalu:nalBuffer frameSize:inSize timeStamp:pts];
    
    if (fSize.width == 0) {
        NSLog(@"nalBuffer size is 0");
        return;
    }
    
    //获取当前最新解码的image
    UIImage *image = [_decoder currentImage];
    
    //主线程显示image
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }
}

/**
  判断是不是关键帧

 @param frameInfoFlags IPC_FRAME_FLAG_IFRAME    = 0x01,  // A/V I frame.
 @return yes or no
 */
- (BOOL)detectIFrame:(NSString *)frameInfoFlags
{
    if ([frameInfoFlags isEqualToString:IFRAME_FLAGS]) {
        isFindIFrame = NO;
        return NO;
    } else {
        isFindIFrame = YES;
        [MBProgressHUD zb_hideHUD];
        return YES;
    }
}


/**
 获取一张黑色的图片

 @return Black Image
 */
- (UIImage *)getBlackImage
{
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}


#pragma mark - NSNotificationCenter

/**
 收到通知解码图片

 @param notification 通知信息包含图片data 时间戳
 */
- (void)receiveBuffer:(NSNotification *)notification{
    
    NSDictionary *dict = (NSDictionary *)notification.object;
    
    NSData *dataBuffer = [dict objectForKey:@"data"];
    
    unsigned int videoPTS = [[dict objectForKey:@"timestamp"] unsignedIntValue];
    
    NSString * infoFlag = [dict objectForKey:@"frameInfoFlags"];
    
    int number =  (int)[dataBuffer length];
    
    uint8_t *buf = (uint8_t *)[dataBuffer bytes];
    
    //当前没有收到关键帧 而且当前帧帧不是关键帧  则不渲染（先check 是否已经收到关键帧）
    if (!isFindIFrame && ![self detectIFrame:infoFlag]) {
        NSLog(@"did not find IFrame!");
        return;
    }
    [self decodeFramesToImage:buf size:number timeStamp:videoPTS];
}



@end
