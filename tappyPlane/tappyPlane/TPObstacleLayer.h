//
//  TPObstacleLayer.h
//  tappyPlane
//
//  Created by Fenkins on 27/11/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPScrollingNode.h"

@interface TPObstacleLayer : TPScrollingNode
@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;
-(void)reset;
@end
