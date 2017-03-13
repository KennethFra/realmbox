//
//  RBFolderDataSource.h
//  Realmbox
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "RBFolderCoordinator.h"

#define CELL_IDENTIFIER @"StandardCell"


/**
 Supplies the dataSource for the RBFolderTableViewController
 */
@interface RBFolderDataSource : NSObject <UITableViewDataSource>


/**
 When instantiated from code, use this method to specify the folder to be displayed.

 @param folderPath Cloud path for the folder
 @return Instan of type RBFolderDataSource
 */
- (instancetype) initWithFolderPath:(NSString *) folderPath;


/**
 The tableView that is using this class as a dataSource
 */
@property (nonatomic, weak) UITableView * tableView;


/**
 Provides callbacks from Realm database changes so the tableView can be updated properly.
 */
@property (nonatomic, strong) RBFolderCoordinator * folderCoordinator;


/**
 Convienience method to retrieve the DropboxMeta from the list of items.

 @param indexPath IndexPath of the item to retrieve
 @return Instance of type DropboxMeta
 */
- (DropboxMeta *) itemAtIndexPath:(NSIndexPath *) indexPath;

@end
