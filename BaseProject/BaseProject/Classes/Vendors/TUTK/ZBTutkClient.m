//
//  ZBTutkClient.m
//  BaseProject
//
//  Created by bigfish on 2018/12/11.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import "ZBTutkClient.h"

#import "IOTCAPIs.h"
#import "AVAPIs.h"
#import "AVIOCTRLDEFs.h"
#import "AVFRAMEINFO.h"

#import <sys/time.h>
#import <pthread.h>

//#import "TEST.h"
//#import "PCMDataPlayer.h"



#define AUDIO_BUF_SIZE  1024
#define VIDEO_BUF_SIZE  204800
#define SESSIONS        4
#define ACCOUNT         "admin"
//#define PASSWORD      "12345678"
#define PASSWORD        "cvte123456"


@implementation ZBTutkClient


/**
 接收到图像数据

 @param arg p2p信息
 */
void *thread_ReceiveVideo(void *arg)
{
    NSLog(@"thread ReceiveVideo starting");
    int avIndex  = *(int *)arg;
    char *buf    = malloc(VIDEO_BUF_SIZE);
    unsigned int frameNumber;
    int re;
    FRAMEINFO_t frameInfo;
    
    int pActualFrameSize[]     = {0};
    int pExpectedFameSize[]    = {0};
    int pActualFrameInfoSize[] = {0};
    
//    __block int videoOrder = 0;
    
    //循环处理接收到的图像数据
    while (1) {
        
        re = avRecvFrameData2(avIndex,
                              buf,
                              VIDEO_BUF_SIZE,
                              pActualFrameSize,
                              pExpectedFameSize,
                              (char *)&frameInfo,//frameInfo.flags IPC_FRAME_FLAG_IFRAME
                              sizeof(FRAMEINFO_t),
                              pActualFrameInfoSize,
                              &frameNumber);
        if (re > 0)
        {
            // 获取到帧数据，通知进行绘制
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *flag = [NSString stringWithFormat:@"%x", frameInfo.flags];// @"1" A/V I frame.
                NSDictionary *dict = @{@"data":[NSData dataWithBytes:buf length:re],
                                       @"timestamp":[NSNumber numberWithUnsignedInt:frameInfo.timestamp],
                                       @"frameInfoFlags" :flag,
                                       };
                //通知进行解码渲染
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewBufferToDecode object:dict];
            });
            usleep(15000);
        }
        else if (re == AV_ER_DATA_NOREADY)
        {
            usleep(10000);
            continue;
        }
        else if (re == AV_ER_LOSED_THIS_FRAME)
        {
            NSLog(@"Lost video frame NO[%d]", frameNumber);
            continue;
        }
        else if (re == AV_ER_INCOMPLETE_FRAME)
        {
            NSLog(@"Incomplete video frame NO[%d]", frameNumber);
            continue;
        }
        else if (re == AV_ER_SESSION_CLOSE_BY_REMOTE)
        {
            NSLog(@"threadReceiveVideo AV_ER_SESSION_CLOSE_BY_REMOTE");
            break;
        }
        else if(re == AV_ER_REMOTE_TIMEOUT_DISCONNECT)
        {
            NSLog(@"threadReceiveVideo AV_ER_REMOTE_TIMEOUT_DISCONNECT");
            break;
        }
        else if(re == IOTC_ER_INVALID_SID)
        {
            NSLog(@"threadReceiveVideo IOTC_ER_INVALID_SID : Session can not  be use");
            break;
        }
    }
    free(buf);
    NSLog(@"threadReceiveVideo thread exit");
    return 0;
    
}

int start_ipcam_stream (int avIndex)
{
    int re;
    unsigned short val = 0;
    if ((re = avSendIOCtrl(avIndex, IOTYPE_INNER_SND_DATA_DELAY, (char *)&val, sizeof(unsigned short)) < 0))
    {
        NSLog(@"start_ipcam_stream_failed[%d]", re);
        return 0;
    }
    SMsgAVIoctrlAVStream ioMsg;
    memset(&ioMsg, 0, sizeof(SMsgAVIoctrlAVStream));
    if ((re = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_START, (char *)&ioMsg, sizeof(SMsgAVIoctrlAVStream)) < 0))
    {
        NSLog(@"start_ipcam_stream_failed[%d]", re);
        return 0;
    }
    
    if ((re = avSendIOCtrl(avIndex, IOTYPE_USER_IPCAM_AUDIOSTART, (char *)&ioMsg, sizeof(SMsgAVIoctrlAVStream)) < 0))
    {
        NSLog(@"start_ipcam_stream_failed[%d]", re);
        return 0;
    }
    
    return 1;
}

void *start_main (NSString *UID)
{
    int re,SID;
    NSLog(@"AVStream Client Start");
    //初始化IOTC
    re = IOTC_Initialize(0, "46.137.188.54", "122.226.84.253", "m2.iotcplatform.com", "m5.iotcplatform.com");
    NSLog(@"IOTC_Initialize() re = %d", re);
    
    if (re != IOTC_ER_NoERROR ) {
        NSLog(@"IOTCAPIs exit...");
        return NULL;
    }
    // alloc 4 sessions for video and two-way audio
    avInitialize(SESSIONS);
    
    SID = IOTC_Get_SessionID();
    //建立链接
    re = IOTC_Connect_ByUID_Parallel((char *)[UID UTF8String], SID);
    printf("Step 2: call IOTC_Connect_ByUID_Parallel(%s) ret(%d).......\n", [UID UTF8String], re);
    //check
    struct st_SInfo Sinfo;
    re = IOTC_Session_Check(SID, &Sinfo);
    if (re >= 0)
    {
        if(Sinfo.Mode == 0)
            printf("Device is from %s:%d[%s] Mode=P2P\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
        else if (Sinfo.Mode == 1)
            printf("Device is from %s:%d[%s] Mode=RLY\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
        else if (Sinfo.Mode == 2)
            printf("Device is from %s:%d[%s] Mode=LAN\n",Sinfo.RemoteIP, Sinfo.RemotePort, Sinfo.UID);
    }
    
    //非必须
    const char cabBuf = 2;
    re = IOTC_Session_Write(SID, &cabBuf, 1, 0);
    if(re < 0)
    {
        printf("IOTC_Session_Write failed[%d]\n", re);
        return NULL;
    }
    
    //启动 avClient
    unsigned int srvType;
    int avIndex = avClientStart(SID, ACCOUNT, PASSWORD, 20000, &srvType, 0);
    printf("Step 3: call avClientStart(%d).......\n", avIndex);
    if(avIndex < 0)
    {
        printf("avClientStart failed[%d]\n", avIndex);
        return NULL;
    }
    
    //通过IOCtrl发送消息开始获取音视频流
    if (start_ipcam_stream(avIndex)>0)
    {
        pthread_t ThreadVideo_ID;
        //pthread_t ThreadVideo_ID, ThreadAudio_ID;
        pthread_create(&ThreadVideo_ID, NULL, &thread_ReceiveVideo, (void *)&avIndex);
        //pthread_create(&ThreadAudio_ID, NULL, &thread_ReceiveAudio, (void *)&avIndex);
        pthread_join(ThreadVideo_ID, NULL);
       // pthread_join(ThreadAudio_ID, NULL);
    }
    
    avClientStop(avIndex);
    NSLog(@"avClientStop OK");
    
    IOTC_Session_Close(SID);
    NSLog(@"IOTC_Session_Close OK");
    
    avDeInitialize();
    IOTC_DeInitialize();
    
    NSLog(@"StreamClient exit...");
    return nil;

}


/**
 创建客户端线程接收线程 开始接收P2P数据

 @param UID UID
 */
- (void)start:(NSString *)UID
{
    pthread_t main_thread;
    pthread_create(&main_thread, NULL, (void *)&start_main, (__bridge void *)UID);
    pthread_detach(main_thread);
    
}






@end
