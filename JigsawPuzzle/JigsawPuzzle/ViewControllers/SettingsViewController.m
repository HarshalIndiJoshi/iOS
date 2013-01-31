//
//  SettingsViewController.m
//  JigsawPuzzle
//
//  Created by Raviraj Indi on 24/01/13.
//
//

#import "SettingsViewController.h"
#import "KGModal.h"
@interface SettingsViewController ()
{
    NSIndexPath *lastIndexPath, *lastIndexPathForSettingsTable;
    UIView *contentView;
    BOOL showGrid, showHoles, autoMove, playSound, vibrate;
    UIImageView *imgViewToShowGrid;
    NSUserDefaults *pref;
    NSString *levelStr;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imgViewToShowGrid;
@property (assign) BOOL showGrid, showHoles, autoMove, playSound, vibrate;
@property (nonatomic, strong) NSUserDefaults *pref;
@property (nonatomic, strong) NSString *levelStr;
@end

@implementation SettingsViewController

@synthesize imgViewToShowGrid;
@synthesize contentView;
@synthesize showGrid;
@synthesize showHoles;
@synthesize autoMove;
@synthesize playSound;
@synthesize vibrate;
@synthesize pref;
@synthesize levelStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    pref = [NSUserDefaults standardUserDefaults];
    self.settingsData = [[NSMutableArray alloc] initWithObjects:@"Show Grid",@"Play Sound",@"Vibrate",@"Auto Move",@"No holes in puzzle",@"Level",@"",@"", nil];
    self.gridValues = [[NSMutableArray alloc]  initWithObjects:@"2 x 2",@"3 x 3",@"4 x 4",@"5 x 5",@"6 x 6", nil];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 210)];
    contentView.hidden = YES;
    [contentView addSubview:self.gridValueTable];
    
    showGrid = YES;
    
    if (showGrid) {
        imgViewToShowGrid = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSettingsList:nil];
    [self setGridValueTable:nil];
    [super viewDidUnload];
}

#pragma mark - tableviewdelegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101)
    {
        return [self.settingsData count];
    }
    return [self.gridValues count];  
}

#pragma mark - tableviewdatasource methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        NSString *cellIdentifier = @"Settingscell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.textLabel.text = [self.settingsData objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        if ([cell.textLabel.text isEqualToString:@"Show Grid"])
        {
            if ([pref boolForKey:@"ShowGrid"])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        if ([cell.textLabel.text isEqualToString:@"Vibrate"])
        {
            if ([pref boolForKey:@"Vibrate"])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        if ([cell.textLabel.text isEqualToString:@"Play Sound"])
        {
            if ([pref boolForKey:@"SoundOn"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"Levelcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIView *selectedBackgroundViewForCell = [UIView new];
            [selectedBackgroundViewForCell setBackgroundColor:[UIColor blackColor]];
            cell.selectedBackgroundView = selectedBackgroundViewForCell;
        }
        cell.textLabel.text = [self.gridValues objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"selectedCellIndex = %d",indexPath.row);
    if (tableView.tag == 101)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            if([selectedCell.textLabel.text isEqualToString:@"Show Grid"])
            {
                showGrid = YES;
                [pref setBool:TRUE forKey:@"ShowGrid"];
                [pref synchronize];
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Show Holes"]){
                showHoles = YES;
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Auto Move"])
            {
                autoMove = YES;
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Play Sound"])
            {
                playSound = YES;
                [pref setBool:TRUE forKey:@"SoundOn"];
                [pref synchronize];
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Vibrate"])
            {
                vibrate = YES;
                vibrate = YES;
                [pref setBool:TRUE forKey:@"Vibrate"];
                [pref synchronize];
            }
        }
        else
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
            if([selectedCell.textLabel.text isEqualToString:@"Show Grid"])
            {
                showGrid = FALSE;
                [pref setBool:FALSE forKey:@"ShowGrid"];
                [pref synchronize];
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Show Holes"]){
                showHoles = NO;
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Auto Move"])
            {
                autoMove = NO;
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Play Sound"])
            {
                playSound = NO;
                [pref setBool:FALSE forKey:@"SoundOn"];
            }
            else if([selectedCell.textLabel.text isEqualToString:@"Vibrate"])
            {
                vibrate = NO;
                vibrate = FALSE;
                [pref setBool:FALSE forKey:@"Vibrate"];
                [pref synchronize];
            }
        }
        
//        UITableViewCell *lastSelectedCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:lastIndexPathForSettingsTable];
//        NSLog(@"lastSelectedCellIndex = %d",lastIndexPathForSettingsTable.row);
//        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        if ([selectedCell.textLabel.text isEqualToString:@"Level"])
        {
            levelStr = [NSString stringWithFormat:@"%@",selectedCell.textLabel.text];
            contentView.hidden = NO;
            self.gridValueTable.hidden = NO;
            [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
        }
        
        //lastIndexPathForSettingsTable = indexPath;
    }
    else
    {
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        switch (indexPath.row)
        {
            case 0:
                [prefs setInteger:22 forKey:@"Level"];
                break;
            case 1:
                [prefs setInteger:33 forKey:@"Level"];
                break;
            case 2:
                [prefs setInteger:44 forKey:@"Level"];
                break;
            case 3:
                [prefs setInteger:55 forKey:@"Level"];
                break;
            case 4:
                [prefs setInteger:66 forKey:@"Level"];
                break;
            default:
                break;
        }
        levelStr = [levelStr stringByAppendingFormat:@"%@",selectedCell.textLabel.text];
        
        UITableViewCell *lastSelectedCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:lastIndexPath];
        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = indexPath;
        
        //[self.delegate puzzleGridDidFinish:self];
        [[KGModal sharedInstance] hideAnimated:YES];
    }
   
}
@end
