//
//  TPChallengeProvider.m
//  tappyPlane
//
//  Created by Fenkins on 26/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPChallengeProvider.h"
#import "TPConstants.h"

@implementation TPChallengeItem

+ (instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position {
    TPChallengeItem* item = [[TPChallengeItem alloc]init];
    item.obstacleKey = key;
    item.position = position;
    return item;
}

@end

@interface TPChallengeProvider()
@property (nonatomic) NSMutableArray* challenges;
@end

@implementation TPChallengeProvider

// We will always get the same instance whenever we call this method
+(instancetype)getProvider {
    static TPChallengeProvider *sharedInstance = nil;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[TPChallengeProvider alloc]init];
            // Loading all the challenges when first time initialising the sharedInstance
            [sharedInstance loadChallenges];
        }
        return sharedInstance;
    }
}

-(NSArray*)getRandomChallenge {
    return [self.challenges objectAtIndex:arc4random_uniform((uint)self.challenges.count)];
}

-(void)loadChallenges {
    _challenges = [NSMutableArray array];
    
    // Challenge 1
    NSMutableArray* challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainUp andPosition:CGPointMake(0.0, 0.0)]];
    [self.challenges addObject:challenge];
    
    // Challenge 2
    challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:(NSString*)kTPMountainUp andPosition:CGPointMake(0.0, 0.0)]];
    [self.challenges addObject:challenge];
}
@end
