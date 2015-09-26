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

@interface TPGameScene ()

@property (nonatomic) TPPlane *player;
@property (nonatomic) TPAlien *alien;
@property (nonatomic) SKNode *world;

@end


@implementation TPGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // Setup world
        _world = [[SKNode alloc]init];
        [self addChild:_world];
        
        // Setup player
        _player = [[TPPlane alloc]init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [_world addChild:_player];
        
        // Setup alien
        _alien = [[TPAlien alloc]init];
        _alien.position = CGPointMake(self.size.width * 0.5 + _alien.size.width, self.size.height * 0.5);
        [_world addChild:_alien];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        self.player.engineRunning = !self.player.engineRunning;
        [self.player setRandomColor];
        [self.alien changeAlien];
    }
}

@end
