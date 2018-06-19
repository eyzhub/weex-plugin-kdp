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

@end

@implementation WXKdpModule

WX_PlUGIN_EXPORT_MODULE(weexKdp, WXKdpModule)

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(show))

/**
 create actionsheet
 */
- (void)show
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"title" message:@"module weexKdp is created sucessfully" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertview show];

}

- (void)performBlockWithRef:(NSString *)elemRef block:(void (^)(WXKdpComponent *))block {
    if (!elemRef) {
        return;
    }

    __weak typeof(self) weakSelf = self;

    WXPerformBlockOnComponentThread(^{
        WXKdpComponent *component = (WXKdpComponent *)[weakSelf.weexInstance componentForRef:elemRef];
        if (!component) {
            return;
        }

        [weakSelf performSelectorOnMainThread:@selector(doBlock:) withObject:^() {
            block(component);
        } waitUntilDone:NO];
    });
}

- (void)doBlock:(void (^)())block {
    block();
}

@end
