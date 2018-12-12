//
//  ZBH264Decoder.h
//  BaseProject
//
//  Created by bigfish on 2018/12/11.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ZBH264Decoder : NSObject

//输出图像宽高
@property (nonatomic,assign) int outputWidth, outputHeight;

// 当前解码出来的图像
@property (nonatomic,strong,readonly) UIImage *currentImage;

// init decoder
- (void)initVideoDecoder;

//decode nalu
- (CGSize)decodeNalu:(uint8_t *)nalBuffer
           frameSize:(int)frameSize
           timeStamp:(unsigned int)pts;


@end


