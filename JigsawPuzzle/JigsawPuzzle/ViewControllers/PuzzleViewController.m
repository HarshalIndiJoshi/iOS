//
//  PuzzleViewController.m
//  JigsawPuzzle
//
//  Created by Raviraj Indi on 17/01/13.
//
//

#import "PuzzleViewController.h"
#import "SettingsViewController.h"
#import "TileImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

@interface PuzzleViewController ()
{
    int num;
	
    int rows, cols;
    CGSize screenSize;
    NSString *_fileName;
    NSUserDefaults *prefs;
    BOOL gameOver;
    
}

@property (nonatomic, strong) UIImage *_puzzleImage;
@property (nonatomic, strong) NSString *_fileName;
@property (nonatomic, strong) NSUserDefaults *prefs;
@property (assign) BOOL gameOver;
@end

@implementation PuzzleViewController

@synthesize gameOver;
@synthesize prefs;
@synthesize _puzzleImage;

@synthesize _fileName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated
{
    gameOver = NO;
    prefs = [NSUserDefaults standardUserDefaults];
    screenSize = [[UIScreen mainScreen] bounds].size;
    [self initPuzzle];
	
    // add preferences button
    
    UIButton *prefButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prefButton setBackgroundImage:[UIImage imageNamed:@"19-gear.png"] forState:UIControlStateNormal];
    [prefButton addTarget:self action:@selector(showPreferences:) forControlEvents:UIControlEventTouchUpInside];
    prefButton.frame = CGRectMake(200, 5, 26, 26);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:prefButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self clearView];
    
    
    [self createPuzzle];
	[self scrumblePieces];
}
-(void) scrumblePieces
{
	self.imgViewForUnScrumbledPuzzleImage.hidden = YES;
	
	int index = 0;
	int xPosition,yPosition;
	for (int i = 0; i < rows; i++)
    {
		for (int j = 0; j < cols; j++)
        {
			xPosition = arc4random() % (int)screenSize.width;
			yPosition = arc4random() % (int)screenSize.height;
			
            //TileImageView *piece=nil;
            //			for (UIView *view in self.view_puzzleBoard.subviews) {
            //				if (view.tag==index) {
            //					piece = (TileImageView *)view;
            //					index++;
            //					break;
            //
            //				}
            //					//piece = (TileImageView *)view;
            //
            //			}
			TileImageView *piece = (TileImageView *)[self.view_puzzleBoard.subviews objectAtIndex:index++];
			
			CGRect imgViewFrame = CGRectMake(xPosition, yPosition, piece.frame.size.width, piece.frame.size.height);
			[UIView animateWithDuration:1.3 animations:^{
				piece.frame = imgViewFrame;
			}];
			
			if (piece.hidden)
            {
				piece.hidden = NO;
            }
        }
    }
	
}
-(void)clearView
{
    for (UIImageView *iv in [self.view_puzzleBoard subviews])
    {
        [iv removeFromSuperview];
    }
    self.imgViewForUnScrumbledPuzzleImage.hidden = YES;
    self.imgViewForGrid.hidden = NO;
}
-(void)initPuzzle
{
	
    _fileName = [NSString stringWithFormat:@"pic%d.png", [prefs integerForKey:@"PuzzlePicture"]];
    _puzzleImage = [UIImage imageNamed:_fileName];
    if (![self.navigationController isNavigationBarHidden]) {
        screenSize.height = screenSize.height - 44 - 20;
        [self resizeImage];
    }
    switch ([prefs integerForKey:@"Level"])
    {
            
        case 22:
            num = 0;
            break;
        case 33:
            num = 1;
            break;
        case 44:
            num = 2;
            break;
        case 55:
            num = 3;
            break;
        case 66:
            num = 4;
            break;
        default:
            break;
    }
	
    if ([prefs boolForKey:@"ShowGrid"] == TRUE)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"grid_%dx%d.png",num+2,num+2]];
		self.imgViewForGrid.image = img;
    }
    else
        self.imgViewForGrid.image = nil;
    
}

-(void)resizeImage
{
    CGImageRef sourceImageRef = [_puzzleImage CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, screenSize.width, screenSize.height));
	_puzzleImage = [UIImage imageWithCGImage:newImageRef];
	CGImageRelease(newImageRef);
    //NSLog(@"%@",NSStringFromCGSize(_puzzleImage.size));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPreferences:(id)sender
{
    SettingsViewController *settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsView animated:YES];
}

//Creates images with mask
-(void)createPuzzle
{
    switch (num)
    {
        case 0:
            rows = 2; cols = 2;
            [self level2x2];
            
            break;
        case 1:
            rows = 3; cols = 3;
            [self level3x3];
            break;
        case 2:
            rows = 4; cols = 4;
            [self level4x4];
            break;
        case 3:
            rows = 5; cols = 5;
            [self level5x5];
            break;
        case 4:
            rows = 6; cols = 6;
            [self level6x6];
            break;
        default:
            break;
    }
    //    int x,y;
    //    x = y = 0;
    //    CGSize _size;
    //    NSString *maskImagePath;
    //    int piece_count=1;
    //    for(int i = 1; i <= rows; i++)
    //    {
    //        for(int j = 1; j <= cols; j++)
    //        {
    //            //get the file (mask image) from resource
    //
    //             maskImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"j%d_%dx%d",piece_count++,rows,cols] ofType:@"png"];
    //
    //            UIImage *_maskImg = [[UIImage alloc] initWithContentsOfFile:maskImagePath];
    //
    //            _size = _maskImg.size;
    //
    //            // This function will return the exact CGRect on which to apply the mask image
    //            CGRect imagePart = [self getRectForTag:(((i - 1) * cols) + (j - 1)) andSize:_size];
    //             NSLog(@"imagePart-%@",NSStringFromCGRect(imagePart));
    //            //mask image  and create jigsaw piece
    //            UIImage *_img;
    //            _img = [self maskImage:[self split:imagePart Images:_puzzleImage] withMask:_maskImg];
    //            TileImageView *imgView = [[TileImageView alloc] initWithFrame:CGRectMake(x, y, _size.width, _size.height)];
    //            [imgView setImage:_img];
    //            imgView.userInteractionEnabled = YES;
    //            UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //            pangesture.minimumNumberOfTouches = 1;
    //            pangesture.maximumNumberOfTouches = 2;
    //            [imgView addGestureRecognizer:pangesture];
    //            imgView.tag = piece_count - 1;
    //            //NSLog(@"igView.tag = %d",imgView.tag);
    //            imgView.centerPoint = imgView.center;
    //            imgView.originPoint = CGPointMake(imagePart.origin.x, imagePart.origin.y);
    //            [self.view addSubview:imgView];
    //            [_jigsawPiecesArray addObject:imgView];
    //            x += _size.width;
    //        }
    //        x = 0;
    //        y += _size.height;
    //    }
}

-(void)handlePan:(UIPanGestureRecognizer *)gesture
{
    UIView *piece = [gesture view];
	NSLog(@"piece.tag = %d",piece.tag);
	
    if([prefs boolForKey:@"Vibrate"])
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
	
	TileImageView *tileView = nil;
	for (TileImageView *tiv in self.view_puzzleBoard.subviews) {
		if (piece.tag == tiv.tag)
        {
			tileView = (TileImageView *)piece;
			break;
        }
	}
	
    [self.view bringSubviewToFront:piece];
    //We pass in the gesture to a method that will help us align our touches so that the pan and pinch will seems to originate between the fingers instead of other points or center point of the UIView
    [self adjustAnchorPointForGestureRecognizer:gesture];
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged)
    {
        
        CGPoint translation = [gesture translationInView:[piece superview]];
		NSLog(@"translation = %@",NSStringFromCGPoint(translation));
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+translation.y)];
        [gesture setTranslation:CGPointZero inView:[piece superview]];
		
    }
    else if([gesture state] == UIGestureRecognizerStateEnded)
    {
		
		if ((piece.center.x <= (tileView.centerPoint.x + 10)) || (piece.center.x <= (tileView.centerPoint.x - 10)))
        {
			if ((piece.center.y <= (tileView.centerPoint.y + 10)) || (piece.center.y <= (tileView.centerPoint.y - 10)))
            {
				
				[UIView animateWithDuration:0.3 animations:^{
					CGRect frm = CGRectMake(tileView.originPoint.x, tileView.originPoint.y, piece.frame.size.width, piece.frame.size.height);
					
					piece.frame = frm;
				} completion:^(BOOL finished)
				 {
                     if ([self hasGameFinished]) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Puzzle Completed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                         [alert show];
                     }
                     
				 }];
				if ([prefs boolForKey:@"SoundOn"])
                {
					SystemSoundID pmph;
					id sndpath = [[NSBundle mainBundle]
								  pathForResource:@"FNGRSNAP"
								  ofType:@"WAV"
								  inDirectory:@"/"];
					
					CFURLRef baseURL = (CFURLRef) CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndpath]);
					AudioServicesCreateSystemSoundID (baseURL, &pmph);
					AudioServicesPlaySystemSound(pmph);
                }
            }
        }
		
    }
}
-(BOOL)hasGameFinished
{
    int tileCount = 0;
    
    for (TileImageView *view in [self.view_puzzleBoard subviews])
	{
        NSLog(@"%@,%@",NSStringFromCGPoint(view.frame.origin),NSStringFromCGPoint(view.originPoint));
        int currentX=view.frame.origin.x;
        int currentY=view.frame.origin.y;
        int originX=view.originPoint.x;
        int originY=view.originPoint.y;
        NSLog(@"%d,%d,%d,%d",currentX,currentY,originX,originY);
        int range=2;
        if(currentX-originX<range )
		{
			if (currentY-originY<range)
			{
				tileCount++;
				continue;
			}
            
		}
        else
		{
            gameOver = NO;
            return NO;
		}
	}
    if (tileCount == [[self.view_puzzleBoard subviews] count])
    {
        gameOver = YES;
    }
    return YES;
}
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}


- (UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
	CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef) - 1,
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, true);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    UIImage *_maskedImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    CGImageRelease(mask);
	return _maskedImage;
}

//Split puzzle image in pieces
-(UIImage *) split:(CGRect) imagePart Images:(UIImage*) image {
	
	CGImageRef sourceImageRef = [image CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, imagePart);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
	CGImageRelease(newImageRef);
    
    return newImage;
    
}
-(void)level2x2
{
    int count = 0;
	int tileCount = 101;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[_puzzleImage CGImage]]];
    int x = 0;
    int y = 0;
    for (int i=0; i<rows; i++)
    {
        for (int j=0; j<rows; j++)
        {
            NSString *maskImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"j%d_%dx%d",++count,rows,cols] ofType:@"jpg"];
            UIImage *_maskImage = [UIImage imageWithContentsOfFile:maskImagePath];
            CGSize _maskImageSize = _maskImage.size;
            UIImage *croppedImage = [self imageByCropping:imgView.image toRect:CGRectMake(x,y,_maskImageSize.width, _maskImageSize.height)];
			TileImageView *tileImageView = [[TileImageView alloc] initWithFrame:CGRectMake(x, y, _maskImageSize.width, _maskImageSize.height)];
            [tileImageView setImage:[self maskImage:croppedImage withMask:_maskImage]];
            tileImageView.userInteractionEnabled = YES;
			tileImageView.tag = tileCount++;
            tileImageView.centerPoint = tileImageView.center;
            tileImageView.originPoint = CGPointMake(x,y);
			
            // adding pangesture
            UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            pangesture.minimumNumberOfTouches = 1;
            pangesture.maximumNumberOfTouches = 2;
            [tileImageView addGestureRecognizer:pangesture];
            
            [self.view_puzzleBoard addSubview:tileImageView];
			
            
            if (i==0)//first row
            {
                if (j==0)//first column
                {
                    x = x + 151;
                }
                else
                {
                    x = 0;
                    y = 153;
                }
            }
            else //2nd row
                if (i==1)//first row
                {
                    if (j==0)//first column
                    {
                        x = x + 151;
                    }
                    else // second column
                    {
                        x = 0;
                        y = 0;
                    }
                }
        }
    }
}
-(void)level3x3
{
    int count = 0;
	int tileCount = 101;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[_puzzleImage CGImage]]];
    int x = 0;
    int y = 0;
    for (int i=0; i<rows; i++)
    {
        for (int j=0; j<rows; j++)
        {
            NSString *maskImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"j%d_%dx%d",++count,rows,cols] ofType:@"jpg"];
            UIImage *_maskImage = [UIImage imageWithContentsOfFile:maskImagePath];
            CGSize _maskImageSize = _maskImage.size;
            UIImage *croppedImage = [self imageByCropping:imgView.image toRect:CGRectMake(x,y,_maskImageSize.width, _maskImageSize.height)];
            
            TileImageView *tileImgView = [[TileImageView alloc] initWithFrame:CGRectMake(x, y, _maskImageSize.width, _maskImageSize.height)];
            [tileImgView setImage:[self maskImage:croppedImage withMask:_maskImage]];
            tileImgView.userInteractionEnabled = YES;
            UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            pangesture.minimumNumberOfTouches = 1;
            pangesture.maximumNumberOfTouches = 2;
            [tileImgView addGestureRecognizer:pangesture];
			tileImgView.tag = tileCount++;// count - 1;
            //NSLog(@"igView.tag = %d",imgView.tag);
            tileImgView.centerPoint = tileImgView.center;
            tileImgView.originPoint = CGPointMake(x,y);
            [self.view_puzzleBoard addSubview:tileImgView];
			NSLog(@"Local imageview: %@",tileImgView);
			
            if (i==0)//first row
            {
                switch (j)
                {
                    case 0: // first column
                        x = x + 102;
                        break;
                        
                    case 1: // second column
                        x = x + 72;
                        break;
                        
                    case 2: // third column
                        y = y + 132;
                        x = 0;
                        break;
                    default:
                        break;
                }
            }
            else //2nd row
                if (i==1)//first row
                {
                    switch (j)
                    {
                        case 0: // first column
                            x = x + 103;
                            break;
                            
                        case 1: // second column
                            x = x + 106;
                            y = 89;
                            //NSLog(@"%d,%d",x,y);
                            break;
                            
                        case 2: // third column
                            y = 269;
                            x = 0;
                            break;
                        default:
                            break;
                    }
                }
                else
                    if (i==2)//third row
                    {
                        switch (j)
                        {
                            case 0: // first column
                                x = x + 71;
                                y = 132+97;
                                break;
                                
                            case 1: // second column
                                x = x + 105;
                                
                                
                                break;
                                
                            case 2: // third column
                                y = 0;
                                x = 0;
                                break;
                            default:
                                break;
                        }
                    }
        }
    }
    
}
-(void)level4x4
{
    int count = 0;
	int tileCount = 101;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[_puzzleImage CGImage]]];
    int x = 0;
    int y = 0;
    for (int i=0; i<rows; i++)
    {
        for (int j=0; j<rows; j++)
        {
            NSString *maskImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"j%d_%dx%d",++count,rows,cols] ofType:@"jpg"];
            UIImage *_maskImage = [UIImage imageWithContentsOfFile:maskImagePath];
            CGSize _maskImageSize = _maskImage.size;
            UIImage *croppedImage = [self imageByCropping:imgView.image toRect:CGRectMake(x,y,_maskImageSize.width, _maskImageSize.height)];
			
            TileImageView *tileImageView = [[TileImageView alloc] initWithFrame:CGRectMake(x, y, _maskImageSize.width, _maskImageSize.height)];
            [tileImageView setImage:[self maskImage:croppedImage withMask:_maskImage]];
            tileImageView.userInteractionEnabled = YES;
			tileImageView.tag = tileCount++;
			
			tileImageView.centerPoint = tileImageView.center;
			tileImageView.originPoint = CGPointMake(x,y);
			
            // adding getsure
            UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            pangesture.minimumNumberOfTouches = 1;
            pangesture.maximumNumberOfTouches = 2;
            [tileImageView addGestureRecognizer:pangesture];
			
            
            [self.view_puzzleBoard addSubview:tileImageView];
            if (i==0)//first row
            {
                switch (j)
                {
                    case 0: // first column
                        x += 76;
                        break;
                        
                    case 1: // second column
                        x += 56;
                        break;
                        
                    case 2: // third column
                        x += 105;
                        
                        break;
                    case 3: // forth column
                        y = 66;
                        x = 0;
                        break;
                    default:
                        break;
                }
            }
            else //2nd row
                if (i==1)//first row
                {
                    switch (j)
                    {
                        case 0: // first column
                            x = x + 52;
                            y = 98;
                            break;
                            
                        case 1: // second column
                            x = x + 103;
                            y = 66;
                            break;
                            
                        case 2: // third column
                            x = x + 55;
                            y = 98;
                            break;
                        case 3: // forth column
                            y = y +101;
                            x = 0;
                            break;
                        default:
                            break;
                    }
                }
                else
                    if (i==2)//third row
                    {
                        switch (j)
                        {
                            case 0: // first column
                                x = x + 78;
                                y = 167;
                                break;
                                
                            case 1: // second column
                                x = x + 53;
                                y = y + 32;
                                break;
                                
                            case 2: // third column
                                x = x + 104;
                                y = y - 31;
                                break;
                            case 3: // forth column
                                y = y + 100;
                                x = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    else
                        if (i==3)//forth row
                        {
                            switch (j)
                            {
                                case 0: // first column
                                    x = x + 51;
                                    y = y + 30;
                                    break;
                                    
                                case 1: // second column
                                    x = x + 105;
                                    y = y - 31;
                                    
                                    break;
                                    
                                case 2: // third column
                                    x = x + 53;
                                    y = y + 30;
                                    break;
                                case 3: // forth column
                                    y = 0;
                                    x = 0;
                                    break;
                                default:
                                    break;
                            }
                        }
            
        }
    }
    
}
-(void)level5x5
{
    int count = 0;
	int tileCount = 101;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[_puzzleImage CGImage]]];
    int x = 0;
    int y = 0;
    for (int i=0; i<rows; i++)
    {
		for (int j=0; j<rows; j++)
        {
			NSString *maskImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"j%d_%dx%d",++count,rows,cols] ofType:@"jpg"];
			UIImage *_maskImage = [UIImage imageWithContentsOfFile:maskImagePath];
			CGSize _maskImageSize = _maskImage.size;
			UIImage *croppedImage = [self imageByCropping:imgView.image toRect:CGRectMake(x,y,_maskImageSize.width, _maskImageSize.height)];
			TileImageView *tileImageView = [[TileImageView alloc] initWithFrame:CGRectMake(x, y, _maskImageSize.width, _maskImageSize.height)];
			[tileImageView setImage:[self maskImage:croppedImage withMask:_maskImage]];
			tileImageView.userInteractionEnabled = YES;
			
			tileImageView.tag = tileCount++;
			tileImageView.centerPoint = tileImageView.center;
			tileImageView.originPoint = CGPointMake(x,y);
			
            // adding gesture
			UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
			pangesture.minimumNumberOfTouches = 1;
			pangesture.maximumNumberOfTouches = 2;
			[tileImageView addGestureRecognizer:pangesture];
			
			[self.view_puzzleBoard addSubview:tileImageView];
			
			if (i==0)//first row
            {
				switch (j)
                {
                    case 0: // second column
						x += 61;
						
						break;
						
                    case 1: // third column
						x += 65;
						break;
						
                    case 2: // forth column
						x += 64;
						
						break;
                    case 3: // fifth column
						x = x + 62;
						break;
                    case 4: // next row first column
						y = y + 56;
						x = 0;
						break;
                    default:
						break;
                }
            }
			else //2nd row
				if (i==1)//first row
                {
					switch (j)
                    {
                        case 0: // second column
							x = x + 61;
							
							break;
							
                        case 1: // third column
							x = x + 65;
							
							break;
							
                        case 2: // forth column
							x = x + 65;
							
							break;
                        case 3: // fifth column
							x = x + 62;
							break;
                        case 4: // next row first column
							x = 0;
							y = y + 81;
							break;
                        default:
							break;
                    }
                }
				else
					if (i==2)//third row
                    {
						switch (j)
                        {
                            case 0: // second column
								x = x + 60;
								break;
								
                            case 1: // third column
								x = x + 65;
								break;
								
                            case 2: // forth column
								x = x + 65;
								break;
                            case 3: // fifth column
								x = x + 62;
								break;
                            case 4: // next row first column
								y = y + 82;
								x = 0;
								break;
                            default:
								break;
                        }
                    }
					else
						if (i==3)//forth row
                        {
							switch (j)
                            {
                                case 0: // second column
									x = x + 61;
									break;
									
                                case 1: // third column
									x = x + 66;
									break;
									
                                case 2: // forth column
									x = x + 64;
									break;
                                case 3: // fifth colum
									x = x + 61;
									break;
                                case 4: // fifth colum
									x = 0;
									y = y + 82;
									break;
                                default:
									break;
                            }
                        }
						else
							if (i==4)//forth row
                            {
								switch (j)
                                {
                                    case 0: // second column
										x = x + 62;
										break;
										
                                    case 1: // third column
										x = x + 66;
										break;
										
                                    case 2: // forth column
										x = x + 66;
										break;
                                    case 3: // fifth colum
										x = x + 62;
										break;
                                    case 4: // fifth colum
										x = 0;
										y = 0;
										break;
                                    default:
										break;
                                }
                            }
			
        }
    }
}
-(void)level6x6
{
    int count = 0;
	int tileCount = 101;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[_puzzleImage CGImage]]];
    int x = 0;
    int y = 0;
    for (int i=0; i<rows; i++)
    {
        for (int j=0; j<cols; j++)
        {
            NSString *maskImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"j%d_%dx%d",++count,rows,cols] ofType:@"jpg"];
            UIImage *_maskImage = [UIImage imageWithContentsOfFile:maskImagePath];
            CGSize _maskImageSize = _maskImage.size;
            UIImage *croppedImage = [self imageByCropping:imgView.image toRect:CGRectMake(x,y,_maskImageSize.width, _maskImageSize.height)];
			
            TileImageView *tileImageView = [[TileImageView alloc] initWithFrame:CGRectMake(x, y, _maskImageSize.width, _maskImageSize.height)];
            [tileImageView setImage:[self maskImage:croppedImage withMask:_maskImage]];
            tileImageView.userInteractionEnabled = YES;
			tileImageView.tag = tileCount++;
            tileImageView.centerPoint = tileImageView.center;
            tileImageView.originPoint = CGPointMake(x,y);
            
            // adding getsure
            UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            pangesture.minimumNumberOfTouches = 1;
            pangesture.maximumNumberOfTouches = 2;
            [tileImageView addGestureRecognizer:pangesture];
            [self.view_puzzleBoard addSubview:tileImageView];
			
            if (i==0)//first row
            {
                switch (j)
                {
                    case 0: // second column
                        x += 35;
                        break;
						
                    case 1: // third column
                        x += 62;
                        break;
						
                    case 2: // forth column
                        x += 47;
						
                        break;
                    case 3: // fifth column
                        x = x + 63;
                        break;
                    case 4: // sixth column
                        x = x + 46;
                        break;
                    case 5: // next row first column
                        //y = y + 43;
                        x = 0;
                        y = 43;
                    default:
                        break;
                }
            }
            else //second row
                if (i==1)
                {
                    switch (j)
                    {
                        case 0: // second column
                            x = x + 46;
                            y = 56;
                            break;
                            
                        case 1: // third column
                            x = x + 45;
                            y = 42;
                            break;
                            
                        case 2: // forth column
                            x = x + 64;
                            y = 41;
                            
                            break;
                        case 3: // fifth column
                            x = x + 43;
                            y = 41;
                            break;
                        case 4: // sixth row
                            x = x + 64;
                            y = 56;
                            break;
                        case 5: // next row first column
                            x = 0;
                            y = y + 60;
                            break;
                        default:
                            break;
                    }
                }
                else
                    if (i==2)//third row
                    {
                        switch (j)
                        {
                            case 0: // second column
                                x = x + 35;
                                y = y + 15;
                                break;
                                
                            case 1: // third column
                                x = x + 67;
                                y = y - 15;
                                break;
                                
                            case 2: // forth column
                                x = x + 41;
                                
                                break;
                            case 3: // fifth column
                                
                                x = x + 65;
                                break;
                            case 4: // sixth row
                                x = x + 43;
                                y = y + 15;
                                break;
                            case 5: //next row first column
                                x = 0;
                                y = y + 60;
                                break;
                            default:
                                break;
                        }
                    }
                    else
                        if (i==3)//forth row
                        {
                            switch (j)
                            {
                                case 0: // second column
                                    x = x + 44;
                                    y = y + 17;
                                    break;
                                    
                                case 1: // third column
                                    x = x + 46;
                                    y = y - 20;
                                    break;
                                    
                                case 2: // forth column
                                    x = x + 64;
                                    break;
                                case 3: // fifth column
                                    x = x + 43;
                                    break;
                                case 4: // sixth  column
                                    x = x + 65;
                                    y = y + 15;
                                    break;
                                case 5: //next row first column
                                    x = 0;
                                    y = y + 63;
                                    break;
                                default:
                                    break;
                            }
                        }
                        else
                            if (i==4)//fifth row
                            {
                                switch (j)
                                {
                                    case 0: // second column
                                        x = x + 36;
                                        y = y + 15;
                                        break;
                                        
                                    case 1: // third column
                                        x = x + 67;
                                        y = y - 18;
                                        break;
                                        
                                    case 2: // forth column
                                        x = x + 41;
                                        break;
                                    case 3: // fifth column
                                        x = x + 66;
                                        
                                        break;
                                    case 4: // sixth column
                                        x = x + 41;
                                        y = y +12;
                                        break;
                                    case 5:
                                        x = 0;
                                        y = y + 63;
                                        break;
                                    default:
                                        break;
                                }
                            }
                            else
                                if (i==5)//sixth row
                                {
                                    switch (j)
                                    {
                                        case 0: // second column
                                            x = x + 46;
                                            y = y +14;
                                            break;
                                            
                                        case 1: // third column
                                            x = x + 44;
                                            y = y - 16;
                                            break;
                                            
                                        case 2: // forth column
                                            x = x + 65;
                                            break;
                                        case 3: // fifth column
                                            x = x + 44;
                                            y = y +1;
                                            break;
                                        case 4: // sixth column
                                            x = x + 63;
                                            y = y +12;
                                            break;
                                        case 5:
                                            x = 0;
                                            y = 0;
                                            break;
                                        default:
                                            break;
                                    }
                                }
            
            
        }
    }
    
}
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    return cropped;
}
//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
//{
//
//    CGImageRef maskRef = maskImage.CGImage;
//
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//                                        CGImageGetHeight(maskRef),
//                                        CGImageGetBitsPerComponent(maskRef),
//                                        CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef),
//                                        CGImageGetDataProvider(maskRef), NULL, false);
//
//    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
//    return [UIImage imageWithCGImage:masked];
//
//}
-(CGRect) getRectForTag:(int)_tag andSize:(CGSize)_size
{
    if(num == 1)
    {
        rows = 3; cols = 3;
    }
    if(num == 2)
    {
        rows = 3; cols = 4;
    }
    if(num == 3)
    {
        rows = 5; cols = 5;
    }
    if(num == 4)
    {
        rows = 6; cols = 9;
    }
    
    int i = (_tag / cols) +1;
    int j = (_tag % cols) + 1;
    
    float _widthDivision = (_puzzleImage.size.width/cols);
    float _heightDivision = (_puzzleImage.size.height/rows);
    
    
    CGRect imagePart;
    if(i == 1) // first row
    {
        if(j == 1) // first col
        {
            imagePart = CGRectMake( (j - 1) * _heightDivision, (i - 1) * _heightDivision , _size.width , _size.height);
        }
        else
            if(j == cols)
            {
                imagePart = CGRectMake( (j - 1) * _widthDivision - (_size.width - _widthDivision), (i - 1) * _heightDivision , _size.width , _size.height);
            }
            else
            {
                imagePart = CGRectMake( (j - 1) * _widthDivision - ((_size.width - _widthDivision)/2), (i - 1) * _heightDivision , _size.width , _size.height);
            }
        
    }
    else
        if(i == rows)
        {
            if(j == 1) // first col
            {
                imagePart = CGRectMake( (j - 1) * _widthDivision, ((i - 1) * _heightDivision) - (_size.height - _heightDivision), _size.width , _size.height);
            }
            else
                if(j == cols)
                {
                    imagePart = CGRectMake( (j - 1) * _widthDivision - (_size.width - _widthDivision), ((i - 1) * _heightDivision) - (_size.height/10) , _size.width , _size.height);
                }
                else
                {
                    imagePart = CGRectMake( (j - 1) * _widthDivision - (_widthDivision/3), ((i - 1) * _heightDivision) - (_size.height - _heightDivision) , _size.width , _size.height);
                }
        }
        else
        {
            if(j == 1) // first col
            {
                imagePart = CGRectMake( (j - 1) * _widthDivision, ((i - 1) * _heightDivision) - ((_size.height - _heightDivision)/12), _size.width , _size.height);
            }
            else
                if(j == cols)
                {
                    imagePart = CGRectMake( (j - 1) * _widthDivision , ((i - 1) * _heightDivision) - ((_size.height - _heightDivision)/2) , _size.width , _size.height);
                }
                else
                {
                    imagePart = CGRectMake( (j - 1) * _widthDivision , ((i - 1) * _heightDivision) - ((_size.height - _heightDivision)/2) , _size.width , _size.height);
                }
            
            
        }
    
    return  imagePart;
    
}

- (IBAction)scramblePieces:(id)sender
{
	UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    if (btnItem.tag == 11) //scrumble Pieces
    {
		self.imgViewForGrid.hidden = NO;
		[self scrumblePieces];
		btnItem.tag++;
		btnItem.title = @"UnScrumble";
    }
    else if (btnItem.tag == 12)
    {
		self.imgViewForGrid.hidden = YES;
        for (UIImageView *iv in [self.view_puzzleBoard subviews])
        {
            iv.hidden = YES;
        }
        self.imgViewForUnScrumbledPuzzleImage.image = [UIImage imageNamed:_fileName];
        if (self.imgViewForUnScrumbledPuzzleImage.hidden)
        {
            self.imgViewForUnScrumbledPuzzleImage.hidden = NO;
        }
		btnItem.tag--;
		btnItem.title = @"Scrumble";
    }
	
}


- (void)viewDidUnload {
    [self setView_puzzleBoard:nil];
    [self setImgViewForGrid:nil];
    [self setImgViewForUnScrumbledPuzzleImage:nil];
    [super viewDidUnload];
}
@end
