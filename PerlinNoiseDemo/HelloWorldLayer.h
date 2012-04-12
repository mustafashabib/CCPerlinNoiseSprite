//
//  HelloWorldLayer.h
//  
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright Mustafa Shabib 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{	
    CCSprite * _background;
    CCLabelTTF * _label;
    CCMenu * _menu;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
