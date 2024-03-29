//
//  HelloWorldLayer.m
//  
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright Mustafa Shabib 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCSprite+PerlinNoiseSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)genBackground {
    [_background removeFromParentAndCleanup:YES];
    [_label removeFromParentAndCleanup:YES];
    [_menu removeFromParentAndCleanup:YES];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;

    int octaves = CCRANDOM_0_1()*4+1;
    _background = [CCSprite spriteWithPerlinNoise:winSize.width :winSize.height :CCRANDOM_0_1()*85 :CCRANDOM_0_1():CCRANDOM_0_1()*255 :CCRANDOM_0_1()*255 :CCRANDOM_0_1()*255 :CCRANDOM_0_1()*255 :CCRANDOM_0_1()*255 :CCRANDOM_0_1()*255:octaves];
    
    _background.position = ccp(winSize.width/2, winSize.height/2);        
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE};
    [_background.texture setTexParameters:&tp];
    
    [self addChild:_background];
    // create and initialize a Label
    _label = [CCLabelTTF labelWithString:@"Perlin Noise Test" fontName:@"Marker Felt" fontSize:64];
    
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
	
    // position the label on the center of the screen
    _label.position =  ccp( size.width /2 , size.height/2 );
    
    // add the label as a child to this Layer
    [self addChild: _label];
    
    
    
       // Default font size will be 28 points.
    [CCMenuItemFont setFontSize:28];
     CCMenuItem *regen = [CCMenuItemFont itemWithString:@"Regen" block:^(id sender) {
        [self genBackground];
    }];
    
    _menu = [CCMenu menuWithItems:regen, nil];
    
    [_menu alignItemsHorizontallyWithPadding:20];
    [_menu setPosition:ccp( size.width/2, size.height/2 - 50)];
    
    // Add the menu to the layer
    [self addChild:_menu];

    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        
        srandom(time(NULL));
        [self genBackground];
       

	}
	return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
