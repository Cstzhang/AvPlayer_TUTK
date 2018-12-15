//
//  PCMDataPlayer.h
//  BaseProject
//
//  Created by bigfish on 2018/12/15.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_SIZE 3 //队列缓冲个数
#define MIN_SIZE_PER_FRAME 2000 //每帧最小数据长度

@interface PCMDataPlayer : NSObject
{
    AudioStreamBasicDescription audioDescription; ///音频参数
    AudioQueueRef audioQueue; //音频播放队列
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE]; //音频缓存
    BOOL audioQueueUsed[QUEUE_BUFFER_SIZE];
    
    NSLock* sysnLock;
}


/**
 重置播放器
 */
- (void)reset;


/**
 停止播放
 */
- (void)stop;


/**
 播放PCM数据

 @param pcmData PCM数据
 @param length 字节数据长度
 */
- (void)play:(void*)pcmData length:(unsigned int)length;





@end

