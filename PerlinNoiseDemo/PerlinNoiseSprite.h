//
//  PerlinNoiseSprite.h
//  
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 . All rights reserved.
//
//  TODO: Make this inherit from CCSprite instead?
//  For now - generates a CCSprite using Perlin Noise
//  Error in the way it calculates colors - sometimes get weird color spots. 

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PerlinNoiseSprite : CCNode
{
    
}

+(int) Octaves;
+(void) SetOctaves:(int)o;

+(CCSprite*) GenerateSprite:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2:(int)octaves;
@end
