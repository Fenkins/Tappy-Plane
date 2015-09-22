//
//  TPGameScene.m
//  tappyPlane
//
//  Created by Fenkins on 21/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"

@interface TPGameScene ()

@property (nonatomic) TPPlane *player;
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
    }
    return self;
}

@end
