//
//  TPChallengeProvider.h
//  tappyPlane
//
//  Created by Fenkins on 26/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

// This class will imply singleton design pattern

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TPChallengeItem : NSObject
@property (nonatomic) NSString* obstacleKey;
@property (nonatomic) CGPoint position;
+ (instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position;
@end

@interface TPChallengeProvider : NSObject
+(instancetype)getProvider;
-(NSArray*)getRandomChallenge;
@end
