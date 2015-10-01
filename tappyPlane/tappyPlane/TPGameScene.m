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

@end


@implementation TPGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
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
        _background.position = CGPointZero;
        _background.horyzontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
                
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
    [self.player update];
}

@end
