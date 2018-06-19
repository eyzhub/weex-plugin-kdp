//
//  WeexKdpComponent.h
//  Pods
//
//  Created by Tiago Alves on 20/11/17.
//

#ifndef WeexKdpComponent_h
#define WeexKdpComponent_h

#import <UIKit/UIKit.h>
#import <WeexSDK/WXComponent.h>
#import <WeexSDK/WeexSDK.h>
@import PlayKit;

@interface WXKdpComponent : WXComponent

@property(nonatomic, strong) PlayerView* kdpview;
@property(nonatomic, assign) CGRect componentFrame;

- (float)getDuration;
- (float)getCurrentTime;

@end

#endif /* WeexKdpComponent_h */
