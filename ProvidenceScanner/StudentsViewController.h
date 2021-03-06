//
//  StudentsViewController.h
//  ProvidenceScanner
//
//  Created by Gregory Lee on 4/17/13.
//  Copyright (c) 2013 Gregory Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZBarSDK.h>

@interface StudentsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ZBarReaderDelegate>{
    zbar_symbol_type_t symbolType;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)reloadTableTapped:(id)sender;
- (IBAction)scanTapped:(id)sender;
- (IBAction)switchURLTapped:(id)sender;

- (IBAction)addStudent:(id)sender;
@property(assign,nonatomic)BOOL isChanged;
@end
