//
//  KMHConsoleViewController.m
//  KMHConsoleViewController
//
//  Created by Ken M. Haggerty on 10/21/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHConsoleViewController.h"

#pragma mark - // KMHConsoleTableFooterView //

#pragma mark // Public Interface //

@interface KMHConsoleTableFooterView : UIView
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintShow;
@property (nonatomic) CGFloat progress;
@property (nonatomic, getter=isProcessing) BOOL processing;
@property (nonatomic, weak) NSString *status;
@property (nonatomic, getter=isVisible) BOOL visible;
- (void)show:(BOOL)show animated:(BOOL)animated;
@end

#pragma mark // Implementation //

@implementation KMHConsoleTableFooterView

#pragma mark // Setters and Getters //

- (void)setProgress:(CGFloat)progress {
    self.progressView.progress = progress;
}

- (CGFloat)progress {
    return self.progressView.progress;
}

- (void)setProcessing:(BOOL)processing {
    processing ? [self.activityIndicator startAnimating] : [self.activityIndicator stopAnimating];
}

- (BOOL)isProcessing {
    return self.activityIndicator.isAnimating;
}

- (void)setStatus:(NSString *)status {
    self.statusLabel.text = status;
}

- (NSString *)status {
    return self.statusLabel.text;
}

- (void)setVisible:(BOOL)visible {
    [self show:visible animated:NO];
}

- (BOOL)isVisible {
    return self.constraintShow.active;
}

#pragma mark // Public Methods //

- (void)show:(BOOL)show animated:(BOOL)animated {
    self.constraintShow.active = show;
    [self.superview setNeedsUpdateConstraints];
    [UIView animateWithDuration:(animated ? 0.33f : 0.0f) animations:^{
        [self.superview layoutIfNeeded];
    }];
}

@end

#pragma mark - // KMHConsoleViewCellItem //

#pragma mark Notifications

NSString * const ConsoleViewCellItemNotificationObjectKey = @"object";

NSString * const ConsoleViewCellItemPromptDidChangeNotification = @"kConsoleViewCellItemPromptDidChangeNotification";
NSString * const ConsoleViewCellItemResponseDidChangeNotification = @"kConsoleViewCellItemResponseDidChangeNotification";
NSString * const ConsoleViewCellItemProcessingDidChangeNotification = @"kConsoleViewCellItemProcessingDidChangeNotification";
NSString * const ConsoleViewCellItemStatusDidChangeNotification = @"kConsoleViewCellItemStatusDidChangeNotification";
NSString * const ConsoleViewCellItemProgressDidChangeNotification = @"kConsoleViewCellItemProgressDidChangeNotification";
NSString * const ConsoleViewCellItemDateDidChangeNotification = @"kConsoleViewCellItemDateDidChangeNotification";

#pragma mark // Public Interface //

@interface KMHConsoleViewCellItem : NSObject
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *response;
@property (nonatomic, getter=isProcessing) BOOL processing;
@property (nonatomic, strong) NSString *status;
@property (nonatomic) float progress;
@property (nonatomic, strong) NSDate *date;
- (id)initWithPrompt:(NSString *)prompt;
@end

#pragma mark // Implementation //

@implementation KMHConsoleViewCellItem

#pragma mark // Setters and Getters //

- (void)setPrompt:(NSString *)prompt {
    if ((!prompt && !self.prompt) || [prompt isEqualToString:self.prompt]) {
        return;
    }
    
    _prompt = prompt;
    
    NSDictionary *userInfo = prompt ? @{ConsoleViewCellItemNotificationObjectKey : prompt} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConsoleViewCellItemPromptDidChangeNotification object:self userInfo:userInfo];
}

- (void)setResponse:(NSString *)response {
    if ((!response && !self.response) || [response isEqualToString:self.response]) {
        return;
    }
    
    _response = response;
    
    NSDictionary *userInfo = response ? @{ConsoleViewCellItemNotificationObjectKey : response} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConsoleViewCellItemResponseDidChangeNotification object:self userInfo:userInfo];
}

- (void)setProcessing:(BOOL)processing {
    if (processing == self.processing) {
        return;
    }
    
    _processing = processing;
    
    NSDictionary *userInfo = @{ConsoleViewCellItemNotificationObjectKey : @(processing)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConsoleViewCellItemProcessingDidChangeNotification object:self userInfo:userInfo];
}

- (void)setStatus:(NSString *)status {
    if ((!status && !self.status) || [status isEqualToString:self.status]) {
        return;
    }
    
    _status = status;
    
    NSDictionary *userInfo = status ? @{ConsoleViewCellItemNotificationObjectKey : status} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConsoleViewCellItemStatusDidChangeNotification object:self userInfo:userInfo];
}

- (void)setProgress:(float)progress {
    if (progress == self.progress) {
        return;
    }
    
    _progress = progress;
    
    NSDictionary *userInfo = @{ConsoleViewCellItemNotificationObjectKey : @(progress)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConsoleViewCellItemProgressDidChangeNotification object:self userInfo:userInfo];
}

- (void)setDate:(NSDate *)date {
    if ((!date && !self.date) || [date isEqualToDate:self.date]) {
        return;
    }
    
    _date = date;
    
    NSDictionary *userInfo = date ? @{ConsoleViewCellItemNotificationObjectKey : date} : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConsoleViewCellItemDateDidChangeNotification object:self userInfo:userInfo];
}

#pragma mark // Inits and Loads //

- (id)initWithPrompt:(NSString *)prompt {
    self = [super init];
    if (self) {
        [self setToDefaults];
        
        _prompt = prompt;
    }
    return self;
}

- (id)init {
    return [self initWithPrompt:nil];
}

#pragma mark // Private Methods //

- (void)setToDefaults {
    _prompt = nil;
    _response = nil;
    _processing = NO;
    _status = nil;
    _progress = 0.0f;
    _date = [NSDate date];
}

@end

#pragma mark - // KMHConsoleTableViewCell //

#pragma mark Constants

CGFloat const KMHConsoleTableViewCellTextViewVerticalInset = 4.0f;

#pragma mark // Public Interface //

@interface KMHConsoleTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UITextView *promptTextView;
@property (nonatomic, strong) IBOutlet UITextView *responseTextView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) NSString *prompt;
@property (nonatomic, weak) NSString *response;
@property (nonatomic, getter=isProcessing) BOOL processing;
@property (nonatomic, weak) NSString *status;
@property (nonatomic) CGFloat progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end

#pragma mark // Implementation //

@implementation KMHConsoleTableViewCell

#pragma mark // Setters and Getters //

- (void)setPrompt:(NSString *)prompt {
    self.promptTextView.text = prompt;
    [self.promptTextView setContentCompressionResistancePriority:((prompt && prompt.length) ? UILayoutPriorityRequired : UILayoutPriorityDefaultLow) forAxis:UILayoutConstraintAxisVertical];
}

- (NSString *)prompt {
    return self.promptTextView.text;
}

- (void)setResponse:(NSString *)response {
    self.responseTextView.text = response;
    [self.responseTextView setContentCompressionResistancePriority:((response && response.length) ? UILayoutPriorityRequired : UILayoutPriorityDefaultLow) forAxis:UILayoutConstraintAxisVertical];
}

- (NSString *)response {
    return self.responseTextView.text;
}

- (void)setProcessing:(BOOL)processing {
    processing ? [self.activityIndicator startAnimating] : [self.activityIndicator stopAnimating];
}

- (BOOL)isProcessing {
    return self.activityIndicator.isAnimating;
}

- (void)setStatus:(NSString *)status {
    self.statusLabel.text = status;
}

- (NSString *)status {
    return self.statusLabel.text;
}

- (void)setProgress:(CGFloat)progress {
    self.progressView.progress = progress;
}

- (CGFloat)progress {
    return self.progressView.progress;
}

#pragma mark // Inits and Loads //

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.promptTextView.textContainerInset = UIEdgeInsetsMake(KMHConsoleTableViewCellTextViewVerticalInset, self.promptTextView.textContainerInset.left, 0.0f, self.promptTextView.textContainerInset.right);
    self.responseTextView.textContainerInset = UIEdgeInsetsMake(KMHConsoleTableViewCellTextViewVerticalInset, self.responseTextView.textContainerInset.left, 0.0f, self.responseTextView.textContainerInset.right);
}

#pragma mark // Public Methods //

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self.progressView setProgress:progress animated:animated];
}

@end

#pragma mark - // UIScrollView (KMHConsoleViewController) //

#pragma mark // Public Interface //

@interface UIScrollView (KMHConsoleViewController)
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
@end

#pragma mark // Implementation //

@implementation UIScrollView (KMHConsoleViewController)

#pragma mark Public Methods

- (void)scrollToTopAnimated:(BOOL)animated {
    [self scrollRectToVisible:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), 1.0f) animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    CGRect frame = self.frame;
    CGRect bounds = self.bounds;
    CGSize contentSize = self.contentSize;
    CGPoint currentOffset = self.contentOffset;
    UIEdgeInsets contentInsets = self.contentInset;
//    [self scrollRectToVisible:CGRectMake(0.0f, self.contentSize.height, CGRectGetWidth(self.frame), 1.0f) animated:animated];
}

@end

#pragma mark - // KMHConsoleViewController //

#pragma mark Notifications 

NSString * const KMHConsoleViewControllerDidLoadNotification = @"kKMHConsoleViewControllerDidLoadNotification";

#pragma mark Constants

CGFloat const ToolbarTopBorderWidth = 0.5f;

#pragma mark // Private Interface //

@interface KMHConsoleViewController () <UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet KMHConsoleTableFooterView *footerView;
@property (nonatomic, strong) CALayer *toolbarBorder;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintBottom;
@property (nonatomic, strong) NSOrderedSet <KMHConsoleViewCellItem *> *cellItems;

// GENERAL //

- (void)setup;
- (void)teardown;

// OBSERVERS //

- (void)addObserversForKeyboard;
- (void)removeObserversForKeyboard;
- (void)addObserversToCellItem:(KMHConsoleViewCellItem *)cellItem;
- (void)removeObserversFromCellItem:(KMHConsoleViewCellItem *)cellItem;

// RESPONDERS //

//- (void)keyboardWillAppear:(NSNotification *)notification;
- (void)keyboardDidAppear:(NSNotification *)notification;
- (void)keyboardWillDisappear:(NSNotification *)notification;
- (void)keyboardFrameWillChange:(NSNotification *)notification;
- (void)keyboardFrameDidChange:(NSNotification *)notification;

- (void)cellItemPromptDidChange:(NSNotification *)notification;
- (void)cellItemResponseDidChange:(NSNotification *)notification;
- (void)cellItemProcessingDidChange:(NSNotification *)notification;
- (void)cellItemStatusDidChange:(NSNotification *)notification;
- (void)cellItemProgressDidChange:(NSNotification *)notification;
- (void)cellItemDateDidChange:(NSNotification *)notification;

// ACTIONS //

- (IBAction)done:(id)sender;

@end

#pragma mark // Implementation //

@implementation KMHConsoleViewController

#pragma mark // Setters and Getters //

@synthesize cellItems = _cellItems;

- (CALayer *)toolbarBorder {
    if (_toolbarBorder) {
        return _toolbarBorder;
    }
    
    _toolbarBorder = [CALayer layer];
    _toolbarBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    _toolbarBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.toolbar.frame), ToolbarTopBorderWidth);
    return _toolbarBorder;
}

- (void)setCellItems:(NSOrderedSet <KMHConsoleViewCellItem *> *)cellItems {
    if ([cellItems isEqualToOrderedSet:self.cellItems]) {
        return;
    }
    
    NSIndexSet *indexes;
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableOrderedSet *updatedSet;
    
    NSMutableArray *removedItems = [NSMutableArray array];
    indexes = [self.cellItems indexesOfObjectsPassingTest:^BOOL(KMHConsoleViewCellItem *cellItem, NSUInteger index, BOOL *stop) {
        if ([cellItems containsObject:cellItem]) {
            return NO;
        }
        
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        [removedItems addObject:cellItem];
        return YES;
    }];
    if (indexPaths.count) {
        updatedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cellItems];
        [updatedSet removeObjectsAtIndexes:indexes];
        for (KMHConsoleViewCellItem *cellItem in removedItems) {
            [self removeObserversFromCellItem:cellItem];
        }
        _cellItems = [NSOrderedSet orderedSetWithOrderedSet:updatedSet];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self setCellItems:cellItems];
        return;
    }
    
    NSMutableArray *addedItems = [NSMutableArray array];
    indexes = [cellItems indexesOfObjectsPassingTest:^BOOL(KMHConsoleViewCellItem *cellItem, NSUInteger index, BOOL *stop) {
        if ([self.cellItems containsObject:cellItem]) {
            return NO;
        }
        
        [addedItems addObject:cellItem];
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        return YES;
    }];
    if (indexPaths.count) {
        updatedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cellItems];
        [updatedSet insertObjects:addedItems atIndexes:indexes];
        for (KMHConsoleViewCellItem *cellItem in addedItems) {
            [self addObserversToCellItem:cellItem];
        }
        _cellItems = [NSOrderedSet orderedSetWithOrderedSet:updatedSet];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self setCellItems:cellItems];
        return;
    }
    
    NSUInteger index;
    NSIndexPath *indexPath;
    for (int i = 0; i < cellItems.count; i++) {
        index = [self.cellItems indexOfObject:cellItems[i]];
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        updatedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cellItems];
        [updatedSet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:index] toIndex:i];
        _cellItems = [NSOrderedSet orderedSetWithOrderedSet:updatedSet];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
}

- (NSOrderedSet *)cellItems {
    if (_cellItems) {
        return _cellItems;
    }
    
    _cellItems = [NSOrderedSet orderedSet];
    return _cellItems;
}

#pragma mark // Inits and Loads //

- (void)dealloc {
    [self teardown];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    
    self.footerView.visible = NO;
    
    [self.toolbar.layer addSublayer:self.toolbarBorder];
    
    self.doneButton.enabled = self.textField.isFirstResponder;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KMHConsoleViewControllerDidLoadNotification object:self userInfo:nil];
}

#pragma mark // Public Methods //

- (void)enter:(NSString *)text {
    KMHConsoleViewCellItem *cellItem = [[KMHConsoleViewCellItem alloc] initWithPrompt:(text ? [NSString stringWithFormat:@"> %@", text] : nil)];
    NSMutableOrderedSet *cellItems = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cellItems];
    [cellItems addObject:cellItem];
    self.cellItems = [NSOrderedSet orderedSetWithOrderedSet:cellItems];
    [self.tableView scrollToBottomAnimated:YES];
    
    if (self.delegate) {
        [self.delegate consoleViewController:self didEnterText:text];
    }
}

- (void)print:(NSString *)text {
    if (!self.cellItems.count) {
        [self enter:nil];
        [self print:text];
        return;
    }
    
    KMHConsoleViewCellItem *cellItem = self.cellItems.lastObject;
    cellItem.response = [(cellItem.response ?: @"") stringByAppendingString:[NSString stringWithFormat:@"%@%@", (cellItem.response ? @"\n" : @""), text]];
    [self.tableView scrollToBottomAnimated:YES];
}

#pragma mark // Category Methods //

#pragma mark // Delegated Methods (UITableViewDataSource) //

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Today";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KMHConsoleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KMHConsoleTableViewCell class]) forIndexPath:indexPath];
    KMHConsoleViewCellItem *cellItem = self.cellItems[indexPath.row];
    cell.prompt = cellItem.prompt;
    cell.response = cellItem.response;
    cell.status = cellItem.status;
    cell.processing = cellItem.isProcessing;
    cell.progress = cellItem.progress;
    return cell;
}

#pragma mark // Delegated Methods (UITableViewDelegate) //

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 128.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == self.cellItems.count-1) {
        [self.footerView show:NO animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == self.cellItems.count-1) {
        KMHConsoleViewCellItem *cellItem = self.cellItems.lastObject;
        if (cellItem.processing || cellItem.status || cellItem.progress) {
            [self.footerView show:YES animated:YES];
        }
    }
}

#pragma mark // Delegated Methods (UITextFieldDelegate) //

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.doneButton.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length) {
        [self enter:textField.text];
        textField.text = nil;
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.doneButton.enabled = NO;
}

#pragma mark // Overwritten Methods //

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.toolbarBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.toolbar.frame), ToolbarTopBorderWidth);
}

#pragma mark // Private Methods (General) //

- (void)setup {
    [self addObserversForKeyboard];
}

- (void)teardown {
    [self removeObserversForKeyboard];
}

#pragma mark // Private Methods (Observers) //

- (void)addObserversForKeyboard {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)removeObserversForKeyboard {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)addObserversToCellItem:(KMHConsoleViewCellItem *)cellItem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellItemPromptDidChange:) name:ConsoleViewCellItemPromptDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellItemResponseDidChange:) name:ConsoleViewCellItemResponseDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellItemProcessingDidChange:) name:ConsoleViewCellItemProcessingDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellItemStatusDidChange:) name:ConsoleViewCellItemStatusDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellItemProgressDidChange:) name:ConsoleViewCellItemProgressDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellItemDateDidChange:) name:ConsoleViewCellItemDateDidChangeNotification object:cellItem];
}

- (void)removeObserversFromCellItem:(KMHConsoleViewCellItem *)cellItem {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ConsoleViewCellItemPromptDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ConsoleViewCellItemResponseDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ConsoleViewCellItemProcessingDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ConsoleViewCellItemStatusDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ConsoleViewCellItemProgressDidChangeNotification object:cellItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ConsoleViewCellItemDateDidChangeNotification object:cellItem];
}

#pragma mark // Private Methods (Responders) //

//- (void)keyboardWillAppear:(NSNotification *)notification {
//    NSValue *frameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
//    NSNumber *animationDurationValue = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
//    
//    self.constraintBottom.constant = frameValue.CGRectValue.size.height;
//    [self.view setNeedsUpdateConstraints];
//    [UIView animateWithDuration:animationDurationValue.doubleValue delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.view layoutIfNeeded];
//        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, fmaxf(self.tableView.contentOffset.y-frameValue.CGRectValue.size.height, 0.0f));
//    } completion:nil];
//}

- (void)keyboardDidAppear:(NSNotification *)notification {
    [self.tableView flashScrollIndicators];
}

- (void)keyboardWillDisappear:(NSNotification *)notification {
    NSNumber *animationDurationValue = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    self.constraintBottom.constant = 0.0f;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:animationDurationValue.doubleValue delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{\
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    NSValue *frameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    NSNumber *animationDurationValue = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    self.constraintBottom.constant = frameValue.CGRectValue.size.height-self.bottomLayoutGuide.length;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:animationDurationValue.doubleValue delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    [self.tableView flashScrollIndicators];
}

- (void)cellItemPromptDidChange:(NSNotification *)notification {
    KMHConsoleViewCellItem *cellItem = notification.object;
    NSString *prompt = notification.userInfo[ConsoleViewCellItemNotificationObjectKey];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cellItems indexOfObject:cellItem] inSection:0];
    KMHConsoleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return;
    }
    
    cell.prompt = prompt;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cellItemResponseDidChange:(NSNotification *)notification {
    KMHConsoleViewCellItem *cellItem = notification.object;
    NSString *response = notification.userInfo[ConsoleViewCellItemNotificationObjectKey];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cellItems indexOfObject:cellItem] inSection:0];
    KMHConsoleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return;
    }
    
    cell.response = response;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cellItemProcessingDidChange:(NSNotification *)notification {
    KMHConsoleViewCellItem *cellItem = notification.object;
    NSNumber *processingValue = notification.userInfo[ConsoleViewCellItemNotificationObjectKey];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cellItems indexOfObject:cellItem] inSection:0];
    KMHConsoleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return;
    }
    
    cell.processing = processingValue.boolValue;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cellItemStatusDidChange:(NSNotification *)notification {
    KMHConsoleViewCellItem *cellItem = notification.object;
    NSString *status = notification.userInfo[ConsoleViewCellItemNotificationObjectKey];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cellItems indexOfObject:cellItem] inSection:0];
    KMHConsoleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return;
    }
    
    cell.status = status;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cellItemProgressDidChange:(NSNotification *)notification {
    KMHConsoleViewCellItem *cellItem = notification.object;
    NSNumber *progressValue = notification.userInfo[ConsoleViewCellItemNotificationObjectKey];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cellItems indexOfObject:cellItem] inSection:0];
    KMHConsoleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return;
    }
    
    cell.progress = progressValue.floatValue;
}

- (void)cellItemDateDidChange:(NSNotification *)notification {
    //
}

#pragma mark // Private Methods (Actions) //

- (IBAction)done:(id)sender {
    [self.textField resignFirstResponder];
}

@end
