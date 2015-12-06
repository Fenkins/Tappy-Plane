//
//  TPGameScene.h
//  tappyPlane
//
//  Created by Fenkins on 21/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TPCollectable.h"

@interface TPGameScene : SKScene <SKPhysicsContactDelegate,TPCollectableDelegate>

@end
