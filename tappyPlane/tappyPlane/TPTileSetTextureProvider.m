//
//  TPTileSetTextureProvider.m
//  tappyPlane
//
//  Created by Fenkins on 11/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPTileSetTextureProvider.h"

@implementation TPTileSetTextureProvider
+(instancetype)getProvider {
    static TPTileSetTextureProvider* provider = nil;

    // Everything we put in here will be protected from running at the same time in different threads
    @synchronized(self) {
        if (!provider) {
            provider = [[TPTileSetTextureProvider alloc]init];
        }
        return provider;
    }
}
@end
