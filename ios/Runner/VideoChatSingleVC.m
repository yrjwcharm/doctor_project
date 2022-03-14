//
//  VideoChatSingleVC.m
//  Runner
//
//  Created by mac on 2022/1/17.
//

#import "VideoChatSingleVC.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>
#import "KeyCenter.h"
#import "WMDragView.h"

@interface VideoChatSingleVC ()<ZegoEventHandler>
@property(nonatomic,strong)WMDragView*smallView;
@property(nonatomic,strong)UIView*bigView;
@property (nonatomic, copy) NSString *playStreamID;
@property (nonatomic) ZegoRoomState roomState;
@property (nonatomic) ZegoPublisherState publisherState;
@property (nonatomic) ZegoPlayerState playerState;

@end

@implementation VideoChatSingleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bigView=[[UIView alloc]init];
    _bigView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_bigView];
    _smallView=[[WMDragView alloc]init];
    CGFloat withX=240*9/16;
    _smallView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-withX, 80,withX, 240);
    [self.view addSubview:_smallView];
    UIButton*backBtn=[[UIButton alloc]init];
    backBtn.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-10-60, 40, 60, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:backBtn];
    self.view.backgroundColor=[UIColor yellowColor];
    self.roomID=@"0001";
    self.userID=@"123";
    self.publishStreamID=@"345";
    self.smallView.hidden=YES;
    [self createEngineAndLogin];
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)startLive {
    // Start preview
    ZegoCanvas *previewCavas = [ZegoCanvas canvasWithView:self.bigView];
    
    [[ZegoExpressEngine sharedEngine] startPreview:previewCavas];
    // Start publishing
    [[ZegoExpressEngine sharedEngine] startPublishingStream:self.publishStreamID];
}


- (void)createEngineAndLogin {
    // Create ZegoExpressEngine and set self as delegate (ZegoEventHandler)
    ZegoEngineProfile *profile = [[ZegoEngineProfile alloc] init];
    profile.appID = [KeyCenter appID];
    profile.appSign = [KeyCenter appSign];
    profile.scenario = ZegoScenarioGeneral;
    [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];

    [[ZegoExpressEngine sharedEngine] loginRoom:self.roomID user:[ZegoUser userWithUserID:self.userID]];
}
#pragma mark - ZegoEventHandler
#pragma mark - Room
- (void)onRoomStateUpdate:(ZegoRoomState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    self.roomState = state;
    if (errorCode != 0) {
    }
    if (errorCode == 0 && self.roomState == ZegoRoomStateConnected) {
        [self startLive];
    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (updateType == ZegoUpdateTypeAdd) {
        // When the updateType is Add, stop playing current stream(if exist) and start playing new stream.
        if (self.playerState != ZegoPlayerStateNoPlay) {
            [[ZegoExpressEngine sharedEngine] stopPlayingStream:self.playStreamID];
            self.playStreamID = nil;
        }
        
        // No processing, just play the first stream
        ZegoStream *stream = streamList.firstObject;
        self.playStreamID = stream.streamID;
        ZegoCanvas *playCanvas = [ZegoCanvas canvasWithView:self.smallView];
        [[ZegoExpressEngine sharedEngine] startPlayingStream:self.playStreamID canvas:playCanvas];
        
    } else {
        // When the updateType is Delete, if the stream is being played, stop playing the stream.
        if (self.playerState == ZegoPlayerStateNoPlay) {
            return;
        }
        for (ZegoStream *stream in streamList) {
            if ([self.playStreamID isEqualToString:stream.streamID]) {
                [[ZegoExpressEngine sharedEngine] stopPlayingStream:self.playStreamID];
                self.playStreamID = nil;
            }
        }
    }
}

#pragma mark - Publish
// The callback triggered when the state of stream publishing changes.
- (void)onPublisherStateUpdate:(ZegoPublisherState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
  
    self.publisherState = state;
//    [self appendLog:[NSString stringWithFormat:@"🚩 Publisher State Update State: %lu", state]];
    
}
#pragma mark - Play
// The callback triggered when the state of stream playing changes.
- (void)onPlayerStateUpdate:(ZegoPlayerState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    // If the state is ZegoPlayerStateNoPlay and the errcode is not 0, it means that stream playing has failed and
    // no more retry will be attempted by the engine. At this point, the failure of stream playing can be indicated
    // on the UI of the App.
    self.playerState = state;
//    [self appendLog:[NSString stringWithFormat:@"🚩 Player State Update State: %lu", state]];
    if (state == ZegoPlayerStatePlaying) {
        self.smallView.hidden = NO;
    } else {
        self.smallView.hidden = YES;
    }
}
#pragma mark - Exit

- (void)dealloc {
    // Stop preview
    [[ZegoExpressEngine sharedEngine] stopPreview];
    
    // Stop publishing
    if (self.publisherState != ZegoPublisherStateNoPublish) {
        NSLog(@"📥 Stop publishing stream");
        [[ZegoExpressEngine sharedEngine] stopPublishingStream];
    }
    
    // Stop playing
    if (self.playerState != ZegoPlayerStateNoPlay) {
        NSLog(@"📥 Stop playing stream");
        [[ZegoExpressEngine sharedEngine] stopPlayingStream:self.playStreamID];
    }
    // Logout room
    if (self.roomState != ZegoRoomStateDisconnected) {
        NSLog(@"🚪 Logout room");
        [[ZegoExpressEngine sharedEngine] logoutRoom:self.roomID];
    }
    // Can destroy the engine when you don't need audio and video calls
    NSLog(@"🏳️ Destroy ZegoExpressEngine");
    [ZegoExpressEngine destroyEngine:nil];
}


@end
