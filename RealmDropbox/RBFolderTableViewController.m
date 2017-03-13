//
//  RBFolderTableViewController.m
//  Realmbox
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "RBFolderTableViewController.h"
#import "RBFolderDataSource.h"
#import "RBDropboxSync.h"
#import "RLMManager.h"

@interface RBFolderTableViewController ()
@property (nonatomic, strong) NSArray * folderContents;
@property (nonatomic, copy) NSString * folderPath;
@property (nonatomic, strong) RBFolderDataSource * dataSource;

@end

@implementation RBFolderTableViewController

-(instancetype) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithFolderPath:(NSString *) folderPath {
    self = [super init];
    if (self) {
        [self commonInit];
        _folderPath = folderPath;
    }
    return self;
}

- (void) commonInit {
    _folderPath = kRootFolder;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureBarButtons) name:NotificationCloudManagerLoginChanged object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.dataSource = [[RBFolderDataSource alloc] initWithFolderPath:_folderPath];
    self.dataSource.tableView = self.tableView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.dataSource = self.dataSource;
    
    DropboxMeta * meta = [[RLMManager sharedInstance] metaForCloudPath:self.folderPath];
    
    [self.navigationItem setTitle:meta ? meta.name : @"Dropbox"];
    
    [self configureBarButtons];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.dataSource.folderCoordinator startWithResync:false];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.dataSource.folderCoordinator stop];
}

- (void) configureBarButtons {
    UIBarButtonItem * logInOutButton = nil;

    if ([DBClientsManager authorizedClient]) {
        logInOutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"Logout text for bar button item") style:UIBarButtonItemStylePlain target:self action:@selector(logInOutButtonAction:)];
    }
    else {
        logInOutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login", @"Login text for bar button item") style:UIBarButtonItemStylePlain target:self action:@selector(logInOutButtonAction:)];
    }

    [self.navigationItem setRightBarButtonItem:logInOutButton];
}

- (void) logInOutButtonAction:(UIBarButtonItem *) button {
    if ([DBClientsManager authorizedClient]) {
        [DBClientsManager unlinkAndResetClients];
        [[RLMManager sharedInstance] deleteEntriesForFolder:kRootFolder];
        [self configureBarButtons];
    }
    else {
        [[RBDropboxSync sharedInstance] authorizeFrom:self completionHandler:^(BOOL success) {
            [self configureBarButtons];
        }];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DropboxMeta * meta = [self.dataSource itemAtIndexPath:indexPath];
    
    if (meta.isFolder) {
        RBFolderTableViewController * tableViewController = [[RBFolderTableViewController alloc] initWithFolderPath:meta.path_lower];
        [self.navigationController pushViewController:tableViewController animated:true];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
