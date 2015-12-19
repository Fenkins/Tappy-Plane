//
//  TPAlien.m
//  tappyPlane
//
//  Created by Fenkins on 25/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPAlien.h"

@interface TPAlien ()
@property NSMutableArray* aliensAnimations;
@end


@implementation TPAlien
- (instancetype)init
{
    self = [super initWithImageNamed:@"alienGreen_walk2"];
    if (self) {
        _aliensAnimations = [[NSMutableArray alloc]init];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"AlienAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString* key in animations) {
            [self.aliensAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        [self changeAlien];
    }
    return self;
}

-(void)changeAlien {
[self runAction:[self.aliensAnimations objectAtIndex:arc4random_uniform((uint)self.aliensAnimations.count)]];
    
}


-(SKAction*)animationFromArray:(NSArray*)textureNames withDuration:(CGFloat)duration {
    // Create array to hold textures
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    
    // Get planes atlas
    SKTextureAtlas *aliensAtlas = [SKTextureAtlas atlasNamed:@"Aliens"];
    
    // Loop trough textureNames array and load textures
    for (NSString *textureName in textureNames) {
        [frames addObject:[aliensAtlas textureNamed:textureName]];
    }
    
    // Calculate time per frame
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    // Create and return animation action
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime]];
}


@end
