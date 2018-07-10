//
//  WXKdpComponent.m
//  Pods-WeexDemo
//
//  Created by Tiago Alves on 20/11/17.
//

#import <Foundation/Foundation.h>
#import "WXKdpComponent.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
@import PlayKit;

@interface WXKdpComponent()<PlayerDelegate>

@property(nonatomic, assign) CGRect frame;
@property (nonatomic, strong) id<Player> player;
@property (strong, nonatomic) NSTimer *timeTracker;
@property (strong, nonatomic) WXModuleKeepAliveCallback trackTimeCallback;

@property (strong, nonatomic) NSDictionary *playerConfig;
@property (strong, nonatomic) NSMutableDictionary *eventCallbacks;

@end

@implementation WXKdpComponent

WX_PlUGIN_EXPORT_COMPONENT(weexKdp,WXKdpComponent)
WX_EXPORT_METHOD(@selector(sendNotification:data:))
WX_EXPORT_METHOD(@selector(getProperty:callback:))
WX_EXPORT_METHOD(@selector(kBind:callback:))
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

    PlayKitManager.logLevel = PKLogLevelInfo;

    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];

    [self initializeEventCallbackDictionary];

    self.playerConfig = [attributes objectForKey:@"playerConfig"];

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

// TODO: TEST THIS!
- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"playerConfig"]) {
        self.playerConfig = [attributes objectForKey:@"playerConfig"];
        [self preparePlayer];
    }
}

- (void)initializeEventCallbackDictionary
{
    self.eventCallbacks = [NSMutableDictionary dictionary];
    [self.eventCallbacks setObject: [NSMutableArray array]  forKey: @"timeChange"];
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
    MediaConfig* mediaConfig = [WXKdpComponent makeMediaConfig:self.playerConfig];
    // prepare the player
    if (mediaConfig != nil) {
        [self.player prepare:mediaConfig];
    }
    else {
        NSLog(@"No playerConfig available");
    }
}


- (void)sendNotification:(NSString*)action data:(NSValue*)data {

    if ([action isEqualToString:@"doPlay"]) {
        if(!self.player.isPlaying) {
            [self.player play];
        }
    }
    else if ([action isEqualToString:@"doPause"]) {
        if(self.player.isPlaying) {
            [self.player pause];
        }
    }
    else if ([action isEqualToString:@"doSeek"]) {
        self.player.currentTime = [(NSNumber*)data floatValue];
    }
    else if ([action isEqualToString:@"changeMediaEntry"]) {
        self.playerConfig = (NSDictionary*)data;
        [self preparePlayer];
    }
}

- (void)getProperty:(NSString*)property callback:(WXModuleCallback)callback {

    if ([property isEqualToString:@"time"]) {
        [self getCurrentTime:callback];
    }
    else if ([property isEqualToString:@"duration"]) {
        [self getDuration:callback];
    }
    else if ([property isEqualToString:@"state"]) {
        [self getDuration:callback];
    }
}

-(void)kBind:(NSString*)event callback:(WXModuleKeepAliveCallback)callback {

    [self.eventCallbacks setObject: callback forKey: event];

    if ([event isEqualToString:@"timeChange"]) {
        [self trackTime:callback];
    }
    else if ([event isEqualToString:@"stateChange"]) {
        [self.player addObserver:self
            events:@[PlayerEvent.stateChanged]
            block:^(PKEvent * _Nonnull event) {
                PlayerState oldState = event.oldState;
                PlayerState newState = event.newState;
                NSLog(@"State Chnaged Event:: oldState: %d | newState: %d", (int)oldState, (int)newState);
                callback(@{
                           @"oldState":[WXKdpComponent stringFromPlayerState:oldState],
                           @"newState":[WXKdpComponent stringFromPlayerState:newState]
                        }, YES);
            }];

        [self.player addObserver:self
           event:PlayerEvent.playing
           block:^(PKEvent * _Nonnull event) {
               callback(@{@"newState":@"playing"}, YES);
           }];
        [self.player addObserver:self
           event:PlayerEvent.pause
           block:^(PKEvent * _Nonnull event) {
               callback(@{@"newState":@"paused"}, YES);
           }];
    }
}

-(void)kUnbind:(NSString*)event {

    [self.eventCallbacks removeObjectForKey: event];
}

+(NSString*)stringFromPlayerState:(PlayerState)state
{
    switch ((int)state) {
        case (int)PlayerStateIdle:
            return @"idle";
        case (int)PlayerStateEnded:
            return @"ended";
        case (int)PlayerStateError:
            return @"error";
        case (int)PlayerStateReady:
            return @"ready";
        case (int)PlayerStateUnknown:
            return @"unknown";
        case (int)PlayerStateBuffering:
            return @"buffering";
        default:
            return @"undefined";
    }
}

+(MediaConfig*)makeMediaConfig:(NSDictionary*)playerConfig
{
    if (playerConfig == nil) {
        return nil;
    }

    // create media source and initialize a media entry with that source
    NSString *entryId = [playerConfig objectForKey:@"entryId"];

    NSArray<NSDictionary*>* configSources = [playerConfig objectForKey:@"sources"];
    NSDictionary* configSource;
    NSMutableArray<PKMediaSource*>* sources = [[NSMutableArray alloc] initWithCapacity:[configSources count]];
    for (configSource in configSources) {
        NSURL *contentURL = [[NSURL alloc] initWithString:[configSource objectForKey:@"contentUrl"]];
        NSString *sourceId = [playerConfig objectForKey:@"id"];
        PKMediaSource* source = [[PKMediaSource alloc] init:sourceId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
        [sources addObject:source];
    }

    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];

    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    return mediaConfig;
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

- (void)getCurrentTime:(WXModuleCallback)callback {
    if (!self.player) {
        callback([NSNumber numberWithFloat:0.0]);
    }

    callback([NSNumber numberWithFloat:self.player.currentTime]);
}

-(void)trackTime:(WXModuleKeepAliveCallback) callback {
    self.trackTimeCallback = callback;
    if (!self.timeTracker) {
        self.timeTracker = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(trackTimeUpdate) userInfo:nil repeats:YES];
    }
}

- (void)trackTimeUpdate {
    ((WXModuleKeepAliveCallback)[self.eventCallbacks objectForKey:@"time"])([NSNumber numberWithFloat:self.player.currentTime], YES);
    //self.trackTimeCallback([NSNumber numberWithFloat:self.player.currentTime], YES);
}

- (void)seek:(float)to {
    self.player.currentTime = to;
}


@end
