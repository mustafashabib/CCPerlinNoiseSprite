//
//  PerlinNoiseSprite.m
//  
//
//  Created by Mustafa Shabib on 4/5/12.
//  Copyright 2012 . All rights reserved.
//
#import "PerlinNoiseSprite.h"

@interface PerlinNoiseSprite (hidden)

+(double) _findNoise:(double)x;
+(double) _findNoise2: (double)x: (double) y;
+(double) _interpolate:(double) a: (double)b: (double) x;
+(double) _noise:(double)x:(double)y;
+(double) _getNoise:(double)x:(double)y:(double)p:(double)zoom;
+(double) _smoothNoise2: (double)x:(double)y;
+(CCTexture2D*) _generateTexture:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2;
@end

@implementation PerlinNoiseSprite

static int _octaves = 2;
+(int)Octaves{
    return _octaves;
}
+(void)SetOctaves:(int)o{
    _octaves = o;
}
+(double) _findNoise:(double)x{
    int n = (int)x<<13 ^ (int)x;
    
    return (double)( 1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);	
}

+(double) _smoothNoise2: (double)x:(double)y
{
double corners,sides,center;
//smooth corners
corners = ([PerlinNoiseSprite _findNoise2:x-1:y-1] + 
           [PerlinNoiseSprite _findNoise2:x+1:y-1] +
           [PerlinNoiseSprite _findNoise2:x-1: y+1] +
           [PerlinNoiseSprite _findNoise2:x+1 :y+1])/16;

sides = ([PerlinNoiseSprite _findNoise2:x-1:y] + 
         [PerlinNoiseSprite _findNoise2:x+1:y] +
         [PerlinNoiseSprite _findNoise2:x: y-1] +
         [PerlinNoiseSprite _findNoise2:x :y+1])/8;

center = [PerlinNoiseSprite _findNoise2:x :y+1]/4;
    
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
    v1 = [PerlinNoiseSprite _smoothNoise2:floorx :floory];
    v2 = [PerlinNoiseSprite _smoothNoise2:floorx+1 :floory];
    v3 = [PerlinNoiseSprite _smoothNoise2:floorx :floory+1];
    v4 = [PerlinNoiseSprite _smoothNoise2:floorx+1 :floory+1];
    
    double int1 = [PerlinNoiseSprite _interpolate:v1 :v2 :fractional_x];
    double int2 = [PerlinNoiseSprite _interpolate:v3 :v4 :fractional_x];
    return [PerlinNoiseSprite _interpolate:int1 :int2 :fractional_y];
    

}

+(double) _getNoise:(double)x:(double)y:(double)p:(double)zoom{
   
    double noise = 0.0;
    for(int i = 0; i < [PerlinNoiseSprite Octaves]; i++){
        double frequency = pow(2,i);
        double amplitude = pow(p,i);
        noise += [PerlinNoiseSprite _noise:(double)(x*frequency)/zoom :(double)y/(zoom*frequency)]*amplitude;

    }
    return noise;
}

+(CCTexture2D*) _generateTexture:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2
{
CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:w height:h];
[rt begin];
   
    
    for(int y=0; y<h;y++){
        for(int x=0; x < w; x++){
            double noise = [PerlinNoiseSprite _getNoise:x :y :p :zoom];
            int color = (noise*128)+128.0;
            if(color > 255){
                color = 255;
            }else if(color < 0){
                color = 0;
            }
            
            //todo: this causes artifacts sometimes - need to fix
            ccColor3B three_color = ccc3((int)((r/255.0*color) +((r2/255.0)*(1-color))),
                                         (int)((g/255.0*color)+ ((g2/255.0)*(1-color))),
                                         (int)((b/255.0*color)+ ((b2/255.0)*(1-color))));
         
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
+(CCSprite*) GenerateSprite:(int)w:(int)h:(double)zoom:(double)p:(int)r:(int)g:(int)b:(int)r2:(int)g2:(int)b2:(int)octaves
{
    [PerlinNoiseSprite SetOctaves:octaves];
    CCLOG(@"oct: %d w: %d h: %d zoom: %f persistence: %f r: %d g: %d b: %d r2: %d g2: %d b2: %d", octaves, w, h, zoom, p, r, g, b, r2, g2, b2);
    CCTexture2D *texture = [PerlinNoiseSprite _generateTexture:w :h :zoom :p :r :g :b :r2 :g2 :b2];
	return [CCSprite spriteWithTexture:texture];
    
}


@end
