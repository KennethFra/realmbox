//
//  RBFolderTableViewController.h
//  Realmbox
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Displays a list of files and folders for the corresponding folderpath.
 */
@interface RBFolderTableViewController : UITableViewController


/**
 When initialized in code, you should specific the folder you want the view controller to display.

 @param folderPath Cloud path of folder to display
 @return Instance of type RBFolderTableViewController
 */
- (instancetype) initWithFolderPath:(NSString *) folderPath;

@end
