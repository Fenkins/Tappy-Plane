//
//  TPCollectable.h
//  tappyPlane
//
//  Created by Fenkins on 06/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TPCollectable;

@protocol TPCollectableDelegate <NSObject>

-(void)wasCollected:(TPCollectable*)collectable;

@end

@interface TPCollectable : SKSpriteNode
@property (nonatomic,weak) id <TPCollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;
-(void)collect;

@end
