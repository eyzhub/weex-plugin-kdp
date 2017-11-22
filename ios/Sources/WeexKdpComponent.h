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
#import <GLKit/GLKit.h>

@interface WeexKdpComponent : WXComponent

@property(nonatomic, strong) UIView* kdpview;
@property(nonatomic, assign) CGRect componentFrame;

@end

#endif /* WeexKdpComponent_h */
