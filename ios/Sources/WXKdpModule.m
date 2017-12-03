///Users/tralves/code/eyzhub/weex-kdp/ios/Sources/WeexKdpModule.m
//  WeexKdpModule.m
//  WeexPluginTemp
//
//  Created by Tiago Alves on 16/11/17.
//  Copyright © 2017 realeyz. All rights reserved.
//

#import "WXKdpModule.h"
#import "WXKdpComponent.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

@interface WXKdpModule()

@property (nonatomic, weak) WXKdpComponent *kdpComponent;

@end

@implementation WXKdpModule

WX_PlUGIN_EXPORT_MODULE(weexKdp, WXKdpModule)

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(show))

/**
 create actionsheet
 */
-(void)show
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"title" message:@"module weexKdp is created sucessfully" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertview show];
    
}


@end
