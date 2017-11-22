//
//  WeexKdpComponent.m
//  Pods-WeexDemo
//
//  Created by Tiago Alves on 20/11/17.
//

#import <Foundation/Foundation.h>
#import "WeexKdpComponent.h"
#import <PlayKit/PlayKit-Swift.h>
#import <WeexPluginLoader/WeexPluginLoader.h>

@interface WeexKdpComponent()<PlayerDelegate>

@property(nonatomic, assign) CGRect frame;
@property (nonatomic, strong) id<Player> kPlayer;
@property (strong, nonatomic) IBOutlet PlayerView *playerContainer;


@end

@implementation WeexKdpComponent

WX_PlUGIN_EXPORT_COMPONENT(weexKdp,WeexKdpComponent)

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
weexInstance:(WXSDKInstance *)weexInstance{
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

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self startBasicOVPPlayer];
}

- (UIView *)loadView
{
    if(!self.kdpview){
        UIView *kdpview = [[UIView alloc] initWithFrame:self.frame];
//        UIImageView *imgview = [[UIImageView alloc] initWithFrame:kdpview.bounds];
//        [imgview setImage:[UIImage imageNamed:@"AppIcon"]];
//        [imgview setClipsToBounds:YES];
//        [kdpview addSubview:imgview];
        self.playerContainer = [[PlayerView alloc] initWithFrame:self.frame];
        [kdpview addSubview:self.playerContainer];
        self.kdpview = kdpview;
    }
    return self.kdpview;
}

-(void)startPlayerWithMediaConfig:(MediaConfig*)mediaConfig pluginConfig:(PluginConfig*)pluginConfig {
    NSError* error;
    self.kPlayer = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:pluginConfig error:&error];
    
    // prepare the player with media entry to start the plugin and buffering the media.
    [self.kPlayer prepare:mediaConfig];
    
    self.kPlayer.view.frame = CGRectMake(0, 0, self.playerContainer.frame.size.width,self.playerContainer.frame.size.height);
    
    [self.kPlayer addObserver:self events:@[PlayerEvent.playing, PlayerEvent.durationChanged, PlayerEvent.stateChanged] block:^(PKEvent * _Nonnull event) {
        if ([event isKindOfClass:PlayerEvent.playing]) {
            NSLog(@"playing %@", event);
        } else if ([event isKindOfClass:PlayerEvent.durationChanged]) {
            NSLog(@"duration: %@", event.duration);
        } else if ([event isKindOfClass:PlayerEvent.stateChanged]) {
            NSLog(@"old state: %ld", (long)event.oldState);
            NSLog(@"new state: %ld", (long)event.newState);
        } else {
            NSLog(@"event: %@", event);
        }
    }];
    
    [self.kPlayer addObserver:self events:@[PlayerEvent.error] block:^(PKEvent * _Nonnull event) {
        NSError *error = event.error;
        if (error && error.domain == PKErrorDomain.Player && error.code == 7000) {
            // handle error
        }
    }];
    
    self.kPlayer.delegate = self;
    [self.playerContainer addSubview:self.kPlayer.view];
    [self.kPlayer play];
}

-(void)startBasicOVPPlayer {
    SimpleOVPSessionProvider* sessionProvider = [[SimpleOVPSessionProvider alloc] initWithServerURL:@"https://cdnapisec.kaltura.com" partnerId:2215841 ks:nil];
    OVPMediaProvider* mediaProvider = [[OVPMediaProvider alloc] init:sessionProvider];
    mediaProvider.entryId = @"1_vl96wf1o";
    [mediaProvider loadMediaWithCallback:^(PKMediaEntry * _Nullable mediaEntry, NSError * _Nullable error) {
        [self startPlayerWithMediaConfig:[[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0] pluginConfig:nil];
    }];
}

- (void)startPlayerWithGivenSource {
    
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    
    
    [self startPlayerWithMediaConfig:mediaConfig pluginConfig:nil];
    
}

- (BOOL)playerShouldPlayAd:(id<Player>)player {
    return YES;
}

- (IBAction)playTapped:(id)sender {
    if(!self.kPlayer.isPlaying) {
        [self.kPlayer play];
    }
}

- (IBAction)pauseTapped:(id)sender {
    if(self.kPlayer.isPlaying) {
        [self.kPlayer pause];
    }
}


@end
