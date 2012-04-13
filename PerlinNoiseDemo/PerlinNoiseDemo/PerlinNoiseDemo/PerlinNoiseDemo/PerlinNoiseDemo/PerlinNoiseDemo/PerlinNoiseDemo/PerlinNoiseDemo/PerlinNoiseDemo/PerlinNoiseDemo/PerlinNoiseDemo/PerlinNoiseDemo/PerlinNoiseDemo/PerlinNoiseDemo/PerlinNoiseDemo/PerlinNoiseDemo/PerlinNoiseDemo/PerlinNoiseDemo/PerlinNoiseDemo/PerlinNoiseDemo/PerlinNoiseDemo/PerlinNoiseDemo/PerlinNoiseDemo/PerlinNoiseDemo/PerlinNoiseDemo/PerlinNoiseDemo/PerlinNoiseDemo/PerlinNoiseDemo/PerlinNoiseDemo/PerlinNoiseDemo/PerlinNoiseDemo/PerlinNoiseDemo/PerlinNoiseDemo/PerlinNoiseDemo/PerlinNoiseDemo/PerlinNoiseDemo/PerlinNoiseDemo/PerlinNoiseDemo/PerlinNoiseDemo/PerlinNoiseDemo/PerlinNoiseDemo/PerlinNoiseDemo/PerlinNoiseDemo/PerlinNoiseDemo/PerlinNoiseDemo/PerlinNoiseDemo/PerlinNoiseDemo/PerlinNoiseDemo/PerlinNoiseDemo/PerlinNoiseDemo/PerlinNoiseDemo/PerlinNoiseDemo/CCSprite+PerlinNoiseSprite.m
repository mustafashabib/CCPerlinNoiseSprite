//
//  PerlinNoiseSprite.m
//  
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 . All rights reserved.
//
#import "PerlinNoiseSprite.h"

@interface CCSprite (hidden)

+(double) _findNoise:(double)x;
+(double) _findNoise2: (double)x: (double) y;
+(double) _interpolate:(double) a: (double)b: (double) x;
+(double) _noise:(double)x:(double)y;
+(double) _getNoise:(double)x:(double)y:(double)p:(double)zoom:(int)octaves;
+(double) _smoothNoise2: (double)x:(double)y;
+(CCTexture2D*) _generateSprite:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2:(int)octaves;
@end

@implementation CCSprite (PerlinNoiseSprite)


+(double) _smoothNoise2: (double)x:(double)y
{
    double corners,sides,center;
    //smooth corners
    corners = ([CCSprite _findNoise2:x-1:y-1] + 
               [CCSprite _findNoise2:x+1:y-1] +
               [CCSprite _findNoise2:x-1: y+1] +
               [CCSprite _findNoise2:x+1 :y+1])/16;
    
    sides = ([CCSprite _findNoise2:x-1:y] + 
             [CCSprite _findNoise2:x+1:y] +
             [CCSprite _findNoise2:x: y-1] +
             [CCSprite _findNoise2:x :y+1])/8;
    
    center = [CCSprite _findNoise2:x :y+1]/4;
    
    return center + corners + sides;
}

+(double) _findNoise2: (double)x: (double) y
{
    int n=(int)x+(int)y*57;
    n=(n<<13)^n;
    int nn=(n*(n*n*60493+19990303)+1376312589)&0x7fffffff;
    return 1.0-((double)nn/1073741824.0);
}

+(double) _interpolate:(double) a: (double)b: (double) x
{
    double ft=x * 3.1415927;
    double f=(1.0-cos(ft))* 0.5;
    return a*(1.0-f)+b*f;
}

+(double) _noise:(double)x:(double)y
{
    double floorx=(double)((int)x);
    double floory=(double)((int)y);
    double fractional_x = x - floorx;
    double fractional_y = y - floory;
    
    double v1,v2,v3,v4;
    v1 = [CCSprite _smoothNoise2:floorx :floory];
    v2 = [CCSprite _smoothNoise2:floorx+1 :floory];
    v3 = [CCSprite _smoothNoise2:floorx :floory+1];
    v4 = [CCSprite _smoothNoise2:floorx+1 :floory+1];
    
    double int1 = [CCSprite _interpolate:v1 :v2 :fractional_x];
    double int2 = [CCSprite _interpolate:v3 :v4 :fractional_x];
    return [CCSprite _interpolate:int1 :int2 :fractional_y];
    
    
}

+(double) _getNoise:(double)x:(double)y:(double)p:(double)zoom:(int)octaves{
    
    double noise = 0.0;
    for(int i = 0; i < octaves; i++){
        double frequency = pow(2,i);
        double amplitude = pow(p,i);
        noise += [CCSprite _noise:(double)(x*frequency)/zoom :(double)y/(zoom*frequency)]*amplitude;
        
    }
    return noise;
}

+(CCTexture2D*) _generateSprite:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2:(int)octaves
{
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:w height:h];
    [rt begin];
    
    
    for(int y=0; y<h;y++){
        for(int x=0; x < w; x++){
            double noise = [CCSprite _getNoise:x :y :p :zoom :octaves];
            int color = (noise*128)+128.0;
            if(color > 255){
                color = 255;
            }else if(color < 0){
                color = 0;
            }
            int color2 = 255-color;
            
            //todo: this causes artifacts sometimes - need to fix
            ccColor3B three_color = ccc3((int)(((r/255.0)*color) +((r2/255.0)*color2)),
                                         (int)(((g/255.0)*color)+ ((g2/255.0)*color2)),
                                         (int)(((b/255.0)*color)+ ((b2/255.0)*color2)));
            
            ccPointSize(1.0);
            ccDrawColor4B(three_color.r, three_color.g, three_color.b, 255);
            ccDrawPoint(ccp(x, y));
        }
    }
    
    
    
    [rt end];
    
    return rt.sprite.texture;
}


/************
 * w: width
 * h: height
 * zoom: zoom value 
 * p: persistence - controls roughness of image
 * r,g,b: color of image
 ************/
+(CCSprite*) spriteWithPerlinNoise:(int)w :(int)h :(double)zoom :(double)p :(int)r :(int)g :(int)b :(int)r2 :(int)g2 :(int)b2 :(int)octaves
{
    CCLOG(@"oct: %d w: %d h: %d zoom: %f persistence: %f r: %d g: %d b: %d r2: %d g2: %d b2: %d", octaves, w, h, zoom, p, r, g, b, r2, g2, b2);
    CCTexture2D *texture = [CCSprite _generateSprite:w :h :zoom :p :r :g :b :r2 :g2 :b2 :octaves];  
    return [CCSprite spriteWithTexture:texture];
    
}


@end