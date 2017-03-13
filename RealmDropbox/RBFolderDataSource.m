//
//  RBFolderDataSource.m
//  Realmbox
//
//  Created by Toptal on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "RBFolderDataSource.h"
#import "UIAlertController+Window.h"

@interface RBFolderDataSource()
@property (nonatomic, copy) FolderCoordinatorResponseBlock responseBlock;
@property (nonatomic, readonly, copy) NSString * folderPath;
@property (nonnull, strong) RLMResults * files;


@end
@implementation RBFolderDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _folderPath = kRootFolder;
    }
    return self;
}

- (instancetype) initWithFolderPath:(NSString *) folderPath {
    self = [super init];
    if (self) {
        _folderPath = folderPath;
        [self setupResponseBlock];
    }
    return self;
}

- (void) setupResponseBlock {
    __weak typeof(self) weakSelf = self;
    
    self.responseBlock = ^void(RLMResults<DropboxMeta *> *results, RLMCollectionChange *changes, NSError *error) {
        
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        UITableView *tableView = weakSelf.tableView;
        dispatch_mainqueue(^{
            
            // Initial run of the query will pass nil for the change information
            if (!changes) {
                
                weakSelf.files = results;
                dispatch_mainqueue(^{
                    [tableView reloadData];
                });
                return;
            }
            
            // Query results have changed, so apply them to the UITableView
            
            weakSelf.files = results;
            
            NSMutableArray * deletions = [NSMutableArray arrayWithArray:[changes deletionsInSection:0]];
            NSMutableArray * insertions = [NSMutableArray arrayWithArray:[changes insertionsInSection:0]];
            
            [tableView beginUpdates];
            
            [tableView deleteRowsAtIndexPaths:deletions
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:insertions
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadRowsAtIndexPaths:[changes modificationsInSection:0]
                             withRowAnimation:UITableViewRowAnimationNone];
            
            [tableView endUpdates];
        });
        
    };
    
    self.folderCoordinator = [RBFolderCoordinator coordinatorForFolder:_folderPath responseBlock:self.responseBlock];
    self.folderCoordinator.sortDescriptor = [RLMSortDescriptor sortDescriptorWithKeyPath:@"client_modified" ascending:false];
    self.folderCoordinator.predicate = [NSPredicate predicateWithFormat:@"(parentFolder == %@)", [self.folderPath lowercaseString]];
}


- (DropboxMeta *) itemAtIndexPath:(NSIndexPath *) indexPath {
    return [self.files objectAtIndex:indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.files count];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
 
     DropboxMeta * meta = [self.files objectAtIndex:indexPath.row];
     cell.textLabel.text = meta.name;
     cell.imageView.image = [UIImage imageNamed:meta.isFolder ? @"folder.png" : @"document.png"];
     return cell;
 }

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         DropboxMeta * meta = [self itemAtIndexPath:indexPath];

         UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to delete '%@'? (You can undo this on Dropbox.com)", meta.name] preferredStyle:UIAlertControllerStyleAlert];

         [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
             [[[DBClientsManager authorizedClient].filesRoutes delete_:meta.path]
                setResponseBlock:^(DBFILESMetadata * _Nullable deletedMeta, DBFILESDeleteError * _Nullable deleteError, DBRequestError * _Nullable requestError) {
                    RBError * error = [RBError errorWithDBErrorObject:deleteError ? deleteError : requestError];
                    
                    if (error) {
                        [error displayErrorWhileAttempting:@"To Delete a File"];
                    }
              }];
         }]];
         
         [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         }]];
         
         [alert show:true];
     }
 }

@end
