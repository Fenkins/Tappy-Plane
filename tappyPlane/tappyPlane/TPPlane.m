//
//  TPPlane.m
//  tappyPlane
//
//  Created by Fenkins on 22/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPPlane.h"

@implementation TPPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    if (self) {

    }
    return self;
}

-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    // Create array to hold textures
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    
    // Get planes atlas
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Planes"];
    
    // Loop trough textureNames array and load textures
    for (NSString *textureName in textureNames) {
        [frames addObject:[planesAtlas textureNamed:textureName]];
    }
    
    // Calculate time per frame
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    // Create and return animation action
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime]];
}

@end
