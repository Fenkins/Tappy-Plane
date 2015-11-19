//
//  TPGameScene.m
//  tappyPlane
//
//  Created by Fenkins on 21/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"
#import "TPAlien.h"
#import "TPScrollingLayer.h"

@interface TPGameScene ()

@property (nonatomic) TPPlane *player;
@property (nonatomic) TPAlien *alien;
@property (nonatomic) SKNode *world;
@property (nonatomic) TPScrollingLayer *background;
@property (nonatomic) TPScrollingLayer *foreground;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation TPGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // Set background color
        self.backgroundColor = [SKColor colorWithRed:213/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
        
        // Get atlas file
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        // Setup physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        
        // Setup world
        _world = [[SKNode alloc]init];
        [self addChild:_world];
        
        // Setup background
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc]init];
        for (int i=0; i<3; i++) {
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        
        _background = [[TPScrollingLayer alloc]initWithTiles:backgroundTiles];
        _background.position = CGPointMake(0.0, 30.0);
        _background.horyzontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
        
        // Setup foreground
        _foreground = [[TPScrollingLayer alloc]initWithTiles:@[[self generateGroundTile],
                                                               [self generateGroundTile],
                                                               [self generateGroundTile]]];
        _foreground.position = CGPointZero;
        _foreground.horyzontalScrollSpeed = -80.0;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        // Setup player
        _player = [[TPPlane alloc]init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        // We have a code that is setting target node for emitter to parent node, so we need to switch the engineRunning AFTER adding node to the parent
        _player.engineRunning = YES;

        // Setup alien
//        _alien = [[TPAlien alloc]init];
//        _alien.position = CGPointMake(self.size.width * 0.5 + _alien.size.width, self.size.height * 0.5);
//        [_world addChild:_alien];
        
    }
    return self;
}


-(SKSpriteNode*)generateGroundTile {
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    return [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
//        self.player.engineRunning = !self.player.engineRunning;
//        [self.player setRandomColor];
//        [self.alien changeAlien];
        self.player.accelerating = YES;
        self.player.physicsBody.affectedByGravity = YES;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        self.player.accelerating = NO;
    }
}

-(void)update:(NSTimeInterval)currentTime {
    // Calculating time betweet calls
    static NSTimeInterval lastCallTime; // this variable will retain itself between method calls (static)
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    [self.background updateWithTimeElapsed:timeElapsed];
    [self.foreground updateWithTimeElapsed:timeElapsed];
}

@end
