//
//  PerlinNoiseSprite.h
//  
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 . All rights reserved.
//
//  For now - generates a CCSprite using Perlin Noise
//  Error in the way it calculates colors - sometimes get weird color spots. 

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCSprite (PerlinNoiseSprite)
{
    
}


+(CCSprite*) spriteWithPerlinNoise:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2:(int)octaves;
@end