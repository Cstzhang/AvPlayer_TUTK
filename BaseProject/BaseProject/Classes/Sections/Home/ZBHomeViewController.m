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

@interface ZBHomeViewController ()

@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation ZBHomeViewController{
    BOOL            isFindIFrame;
    BOOL            _firstDecoded;
    CGRect          rect;
    ZBH264Decoder   *_decoder;
    
//    OpenAL2 *_openAl2;
//    PCMDataPlayer *_pcmDataPlayer;
//    PCMAudioRecorder *_pcmRecorder;
//    int  _avchannelForSendAudioData;
//    FILE *_pcmFile;
    unsigned int _timeStamp;
    
}

#pragma mark -  Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    ZBTutkClient *client = [[ZBTutkClient alloc] init];
    
    #warning set your UID
    [client start:@"C1KAB554Z3RMHH6GU1Z1"];
    // add observer to show Ifame image
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBuffer:) name:@"client" object:nil];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    rect = CGRectMake(0, 20, screenWidth, screenWidth * 16 / 9);
    UIView *containerView = [[UIView alloc] initWithFrame:rect];
    self.imageView = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.image = [self getBlackImage];
    
    [containerView addSubview:self.imageView];
    [self.view addSubview:containerView];
    
    [MBProgressHUD zb_showActivity];
    
    
    [self initData];
    
    

}




#pragma mark -  Private Methods

- (void)initData
{
    _decoder = [[ZBH264Decoder alloc] init];
    [_decoder initVideoDecoder];
    
    
    
}

- (BOOL)detectIFrame:(uint8_t *)nalBuffer size:(int)size {
    
    NSString *string1 = @"";
    int dataLength = size > 100 ? 100 : size;
    for (int i = 0; i < dataLength; i ++) {
        NSString *temp = [NSString stringWithFormat:@"%x", nalBuffer[i]&0xff];
        if ([temp length] == 1) {
            temp = [NSString stringWithFormat:@"0%@", temp];
        }
        string1 = [string1 stringByAppendingString:temp];
    }
    //    NSLog(@"%d,,%@",size,string1);
    NSRange range = [string1 rangeOfString:@"00000000165"];
    if (range.location == NSNotFound) {
        isFindIFrame = NO;
        return NO;
    } else {
        isFindIFrame = YES;
        [MBProgressHUD zb_hideHUD];
        return YES;
    }
    
}

- (void)decodeFramesToImage:(uint8_t *)nalBuffer size:(int)inSize timeStamp:(unsigned int)pts {
    
    //    调节分辨率后，能自适应，但清晰度有问题
    //    经过确认，是output值设置的问题。outputWidth、outputHeight代表输出图像的宽高，设置的和分辨率一样，是最清晰的效果

    CGSize fSize = [_decoder decodeNalu:nalBuffer frameSize:inSize timeStamp:pts];
    if (fSize.width == 0) {
        return;
    }
    
    UIImage *image = [_decoder currentImage];
    
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }
}


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


#pragma mark - Public method







- (void)receiveBuffer:(NSNotification *)notification{
    NSDictionary *dict = (NSDictionary *)notification.object;
    NSData *dataBuffer = [dict objectForKey:@"data"];
    unsigned int videoPTS = [[dict objectForKey:@"timestamp"] unsignedIntValue];
    //    NSLog(@"receive: %d", [[dict objectForKey:@"sequence"] intValue]);
    int number =  (int)[dataBuffer length];
    uint8_t *buf = (uint8_t *)[dataBuffer bytes];
    
    if (!isFindIFrame && ![self detectIFrame:buf size:number]) {
        return;
    }
    
    [self decodeFramesToImage:buf size:number timeStamp:videoPTS];
}



@end
