//
//  SettingsViewController.h
//  JigsawPuzzle
//
//  Created by Raviraj Indi on 24/01/13.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingsList;

@property (weak, nonatomic) IBOutlet UITableView *gridValueTable;
@property (nonatomic, strong) NSMutableArray *settingsData;
@property (nonatomic, strong) NSMutableArray *gridValues;
@end
