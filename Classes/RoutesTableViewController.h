//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>

@interface RoutesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	NSMutableArray *listOfItems;
}

@property (nonatomic, retain) UITableView *tableView;

- (void)loadRoutes;

@end
