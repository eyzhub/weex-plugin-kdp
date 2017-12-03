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
#import <PlayKit/PlayKit-Swift.h>
#import <WeexSDK/WeexSDK.h>

@interface WXKdpComponent : WXComponent

@property(nonatomic, strong) PlayerView* kdpview;
@property(nonatomic, assign) CGRect componentFrame;

@end

#endif /* WeexKdpComponent_h */
