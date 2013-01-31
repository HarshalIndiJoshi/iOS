//
//  TileImageView.m
//  JigsawPuzzle
//
//  Created by Harshal Joshi on 1/21/13.
//
//

#import "TileImageView.h"

@implementation TileImageView
@synthesize tag, centerPoint,originPoint;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
