//
//  WXKdpComponent.m
//  Pods-WeexDemo
//
//  Created by Tiago Alves on 20/11/17.
//

#import <Foundation/Foundation.h>
#import "WXKdpComponent.h"
#import <PlayKit/PlayKit-Swift.h>
#import <WeexPluginLoader/WeexPluginLoader.h>

@interface WXKdpComponent()<PlayerDelegate>

@property(nonatomic, assign) CGRect frame;
@property (nonatomic, strong) id<Player> player;
@property (strong, nonatomic) NSTimer *timeTracker;
@property (strong, nonatomic) WXModuleKeepAliveCallback trackTimeCallback;

@end

@implementation WXKdpComponent

WX_PlUGIN_EXPORT_COMPONENT(weexKdp,WXKdpComponent)
WX_EXPORT_METHOD(@selector(play))
WX_EXPORT_METHOD(@selector(pause))
WX_EXPORT_METHOD(@selector(getDuration:))
WX_EXPORT_METHOD(@selector(getCurrentTime:))
WX_EXPORT_METHOD(@selector(trackTime:))
WX_EXPORT_METHOD(@selector(seek:))

/**
 *  @abstract Initializes a new component using the specified  properties.
 *
 *  @param ref          the identity string of component
 *  @param type         component type
 *  @param styles       component's styles
 *  @param attributes   component's attributes
 *  @param events       component's events
 *  @param weexInstance the weexInstance with which the component associated
 *
 *  @return A WXComponent instance.
 */
- (instancetype)initWithRef:(NSString *)ref
    type:(NSString*)type
    styles:(nullable NSDictionary *)styles
    attributes:(nullable NSDictionary *)attributes
    events:(nullable NSArray *)events
    weexInstance:(WXSDKInstance *)weexInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    
    PlayKitManager.logLevel = PKLogLevelInfo;
    
    if (self )
    {
        CGPoint origin = [[UIScreen mainScreen] bounds].origin;
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        if (styles[@"left"])
        {
            origin.x = [styles[@"left"] floatValue];
        }
        
        if (styles[@"top"])
        {
            origin.y = [styles[@"top"] floatValue];
        }
        
        if (styles[@"width"])
        {
            size.width = [styles[@"width"] floatValue];
        }
        
        if (styles[@"height"])
        {
            size.height = [styles[@"height"] floatValue];
        }
        
        self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        self.componentFrame = self.frame;
        
    }
    
    return self;
}

- (BOOL)isViewLoaded
{
    return (self.kdpview != nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:nil error:&error];
    // make sure player loaded
    if (!error) {
        // 2. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        
        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        [self preparePlayer];
    } else {
        // error loading the player
    }
    // [self.player play];
}

- (UIView *)loadView
{
    if(!self.kdpview){
        PlayerView *kdpview = [[PlayerView alloc] initWithFrame:self.frame];
        self.kdpview = kdpview;
    }
    return self.kdpview;
}

- (void)preparePlayer {
    self.player.view = self.kdpview;
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // prepare the player
    [self.player prepare:mediaConfig];
}

- (void)play {
    if(!self.player.isPlaying) {
        [self.player play];
    }
}

- (void)pause {
    if(self.player.isPlaying) {
        [self.player pause];
    }
}

#pragma mark - publish method
- (float)getDuration {
    if (!self.player) {
        return 0.0;
    }
    
    float d = self.player.duration;
    return d;
}

- (void)getDuration:(WXModuleCallback)callback {
    if (!self.player) {
        callback([NSNumber numberWithFloat:0.0]);
    }
    
    callback([NSNumber numberWithFloat:self.player.duration]);
}

- (float)getCurrentTime {
    if (!self.player) {
        return 0.0;
    }
    
    return self.player.currentTime;
}

- (void)getCurrentTime:(WXModuleCallback)callback {
    if (!self.player) {
        callback([NSNumber numberWithFloat:0.0]);
    }
    
    callback([NSNumber numberWithFloat:self.player.currentTime]);
}

-(void)trackTime:(WXModuleKeepAliveCallback) callback {
    self.trackTimeCallback = callback;
    if (!self.timeTracker) {
        self.timeTracker = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(trackTimeUpdate) userInfo:nil repeats:YES];
    }
}
    
- (void)trackTimeUpdate {
    self.trackTimeCallback([NSNumber numberWithFloat:self.player.currentTime], YES);
}

- (void)seek:(float)to {
    self.player.currentTime = to;
}


@end
