//
//  PuzzleViewController.h
//  JigsawPuzzle
//
//  Created by Raviraj Indi on 17/01/13.
//
//

#import <UIKit/UIKit.h>

@interface PuzzleViewController : UIViewController
- (IBAction)scramblePieces:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_puzzleBoard;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewForGrid;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewForUnScrumbledPuzzleImage;

@end
