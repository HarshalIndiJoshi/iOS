//
//  TileImageView.h
//  JigsawPuzzle
//
//  Created by Harshal Joshi on 1/21/13.
//
//

#import <UIKit/UIKit.h>

@interface TileImageView : UIImageView
@property(assign) int tag, leftViewTag, rightViewTag;
@property(assign)CGPoint centerPoint, originPoint;
@end
