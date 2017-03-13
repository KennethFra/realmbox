# realm-dropbox
Using Realms' notifications along side Dropbox API v2 polling, it keeps you local and remote copies synchronized.  This project currently only syncronizes items at the file level, ignoring content changes.

The best way to 'test' this project is to view your Dropbox folder and the simulator simultaneously.  Add and delete files in Dropbox and view the response in the App OR delete items in the app and see the response in Dropbox.

This makes use of Realm notification blocks to watch records specififed by the predicate for additions, deletions or modifications:
```
    self.notificationToken = [[[DropboxMeta objectsWithPredicate:self.predicate] sortedResultsUsingDescriptors:@[self.sortDescriptor]]
                        addNotificationBlock:^(RLMResults<DropboxMeta *> *results, RLMCollectionChange *changes, NSError *error) {
                                weakSelf.responseBlock(results, changes, error);
}];
```

The results of any changes are sent to this response block and the table view is updated accodingly:

```
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

        [tableView deleteRowsAtIndexPaths:deletions withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView insertRowsAtIndexPaths:insertions  withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:[changes modificationsInSection:0] withRowAnimation:UITableViewRowAnimationNone];

        [tableView endUpdates];
        });
    };
```

When items are deleted, you need only tell Dropbox to delete the item.  The RBDropboxSync object will detect that change via polling built into Dropbox V2 API and update the Realm DB.  This change will then trigger the response block above.  Pretty cool:

```
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
```
