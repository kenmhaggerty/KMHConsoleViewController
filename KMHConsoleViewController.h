//
//  KMHConsoleViewController.h
//  KMHConsoleViewController
//
//  Created by Ken M. Haggerty on 10/21/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // KMHConsoleViewController //

#pragma mark Notifications

extern NSString * const KMHConsoleViewControllerDidLoadNotification;

#pragma mark Forward References

@class KMHConsoleViewController;

#pragma mark Protocols

@protocol KMHConsoleViewDelegate <NSObject>
- (void)consoleViewController:(KMHConsoleViewController *)sender didEnterText:(NSString *)text;
@end

#pragma mark Methods

@interface KMHConsoleViewController : UIViewController
@property (nonatomic, weak) IBOutlet id <KMHConsoleViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *toolbar;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
- (void)enter:(NSString *)text;
- (void)print:(NSString *)text;
@end
