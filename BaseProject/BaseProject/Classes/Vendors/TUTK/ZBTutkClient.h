//
//  ZBTutkClient.h
//  BaseProject
//
//  Created by bigfish on 2018/12/11.
//  Copyright © 2018 bigfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@protocol ZBTutkClientDelegate <NSObject>
//
//@optional
//
//- (void)clientDidReceiveImage:(UIImage *)image;
//
//@end


@interface ZBTutkClient : NSObject

- (void)start:(NSString *)UID;

//@property (nonatomic, weak) id<ZBTutkClientDelegate> delegate;

@end


