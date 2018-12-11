//
//  ZBH264Decoder.m
//  BaseProject
//
//  Created by bigfish on 2018/12/11.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "ZBH264Decoder.h"
#import <libavcodec/avcodec.h>
#import <libswscale/swscale.h>
#import <libswresample/swresample.h>
#import "avformat.h"


@interface ZBH264Decoder()

@property CVPixelBufferPoolRef pixelBufferPoolRef;

@end

@implementation ZBH264Decoder{
    AVFrame             *_videoFrame;
    AVCodecContext      *_videoCodecCtx;
    struct SwsContext   *_imageConvertCtx;
    AVPicture           _picture;
    AVPacket            _packet;
    BOOL                _firtDecoded;
    
}


#pragma mark - Decode

- (void)initVideoDecoder
{
    avcodec_register_all();
    
    //video
    AVCodec *codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    _videoCodecCtx = avcodec_alloc_context3(codec);
    int re = avcodec_open2(_videoCodecCtx, codec, nil);
    if (re != 0) {
           NSLog(@"open codec failed :%d",re);
    }
    _videoFrame = av_frame_alloc();
    av_init_packet(&_packet);
}

//decode
- (CGSize)decodeNalu:(uint8_t *)nalBuffer
           frameSize:(int)frameSize
           timeStamp:(unsigned int)pts
{
    _packet.size = frameSize;
    _packet.data = nalBuffer;
    _packet.pts  = pts;
    _packet.dts  = pts;
    
    CGSize fSize = {0,0};
    
    while (frameSize > 0) {
        int gotFrame = 0;
        int len = avcodec_decode_video2(_videoCodecCtx, _videoFrame, &gotFrame, &_packet);
        if (len < 0) {
            NSLog(@"decode video error, skip packet");
            return fSize;
        }
        frameSize -= len;
    }
    fSize.width  = _videoCodecCtx->width;
    fSize.height = _videoCodecCtx->height;
    
    _outputWidth = _videoCodecCtx->width;
    self.outputHeight = _videoCodecCtx->height;
    return fSize;
}











#pragma mark - Private
- (void)setupScale
{
    avpicture_free(&_picture);
    
    sws_freeContext(_imageConvertCtx);
    
    //alloc rgb picture
    avpicture_alloc(&_picture, AV_PIX_FMT_RGB24, _outputWidth, _outputHeight);
    
    //setup scaler
    static int sws_flags = SWS_FAST_BILINEAR;
    _imageConvertCtx = sws_getContext(_videoCodecCtx->width, _videoCodecCtx->height, _videoCodecCtx->pix_fmt, _outputWidth, _outputHeight, AV_PIX_FMT_RGB24, sws_flags, NULL, NULL, NULL);
 
}



- (void)convertFrameToRGB
{
   sws_scale(_imageConvertCtx, (const uint8_t * const*)_videoFrame->data, _videoFrame->linesize, 0, _videoCodecCtx->height, _picture.data, _picture.linesize);
    
}



#pragma mark -  Setter & getter


- (UIImage *)currentImage
{
    if (!_videoFrame->data[0]) {
        return nil;
    }
    
    [self convertFrameToRGB];
    
    return [self imageFromeAVPicture:_picture width:_outputWidth height:_outputHeight];
    
}

- (void)setOutputHeight:(int)outputHeight
{
    if (_outputHeight != outputHeight) {
        _outputHeight = outputHeight;
        [self setupScale];
    }
}


- (void)setOutputWidth:(int)outputWidth
{
    if (_outputWidth != outputWidth) {
        _outputWidth = outputWidth;
        [self setupScale];
    }
    
}


- (UIImage *)imageFromeAVPicture: (AVPicture)picture
                           width: (int)width
                          height: (int)height
{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault,
                                                 picture.data[0],
                                                 picture.linesize[0] * height,
                                                 kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgimage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       picture.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       YES,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [[UIImage alloc] initWithCGImage:cgimage];
    CGImageRelease(cgimage);
    CGDataProviderRelease(provider);
    CFRelease(data);
    return image;
}




#pragma mark - Dealloc

- (void)dealloc
{
    sws_freeContext(_imageConvertCtx);
    avpicture_free(&_picture);
    av_free_packet(&_packet);
    av_free(_videoFrame);
    
    if (_videoCodecCtx) {
        avcodec_close(_videoCodecCtx);
    }
    
}




















@end
