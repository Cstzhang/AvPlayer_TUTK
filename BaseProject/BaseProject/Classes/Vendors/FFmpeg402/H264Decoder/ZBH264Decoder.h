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

@property (nonatomic,assign) int outputWidth, outputHeight;

// last decoded picture
@property (nonatomic,strong,readonly) UIImage *currentImage;

// init 
- (void)initVideoDecoder;

//decode nalu
- (CGSize)decodeNalu:(uint8_t *)nalBuffer
           frameSize:(int)frameSize
           timeStamp:(unsigned int)pts;


@end


