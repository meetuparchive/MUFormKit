
#import "MUNextResponderController.h"

@interface MUNextResponderController ()

//Saved from the datasource, all text fields
@property (nonatomic, strong) NSMutableDictionary *firstResponderIndexPaths;

//Saved from the datasource, when these cells display they always become first responder
@property (nonatomic, strong) NSMutableDictionary *forceFirstResponderIndexPaths;

@end

@implementation MUNextResponderController

- (id)init
{
    self = [super init];
    if (self) {
        self.firstResponderIndexPaths = [NSMutableDictionary dictionary];
        self.forceFirstResponderIndexPaths = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void) setDataSource:(MUFormDataSource *)dataSource {
    _dataSource = dataSource;
    [self updateFirstResponderConformistsFromDatasource];
}

- (void) focusOnNextResponderFromIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL didFindNextResponder))completion
{
    NSIndexPath *nextIndexPath = [self findNextResponderWithIndexPath:indexPath];
    if (nextIndexPath) {
        [self focusOnNextResponderAtIndexPath:nextIndexPath completion:completion];
    } else {
        if (completion) completion(NO);
    }
}

- (void) focusOnNextResponderAtIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL didFindNextResponder))completion
{
    MUParameterAssert(indexPath);
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell becomeFirstResponder];
    } else {
        self.forceFirstResponderIndexPaths[indexPath] = @1;
    }
    
    if (completion) completion(indexPath != nil);
}

- (void) willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL conformsToFirstResponder = [cell conformsToProtocol:@protocol(MUFormNextTextResponder)];
    if (conformsToFirstResponder) {
    
        //Save the cell for later, need for the case of dynamically creating cells, when not specified in the initial datasource
        self.firstResponderIndexPaths[indexPath] = @(1);
        
        if (self.forceFirstResponderIndexPaths[indexPath]) {
            [cell becomeFirstResponder];
            [self.forceFirstResponderIndexPaths removeObjectForKey:indexPath];
        }
    }
}

-(void) updateFirstResponderConformistsFromDatasource
{
    [self.firstResponderIndexPaths removeAllObjects];
    [self.forceFirstResponderIndexPaths removeAllObjects];
    
    NSArray *sections = self.dataSource.rawSections;
    NSInteger sectionIdx=0,rowIdx;
    for (NSDictionary *sectionInfo in sections) {
        NSArray *rows = sectionInfo[MUFormSectionRowsKey];
        rowIdx = 0;
        for (NSDictionary *rowInfo in rows) {
            Class class = NSClassFromString(rowInfo[MUFormCellClassKey]);
            if ([class conformsToProtocol:@protocol(MUFormNextTextResponder)]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx];
                self.firstResponderIndexPaths[indexPath] = @(1);
            }
            
            if ([rowInfo[MUFormBecomeFirstResponderKey] boolValue]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx];
                self.forceFirstResponderIndexPaths[indexPath] = @(1);
            }
            
            rowIdx++;
        }
        sectionIdx++;
    }
}

-(NSIndexPath*) findNextResponderWithIndexPath:(NSIndexPath*)indexPath
{
    NSArray *orderedIndexPaths = [[self.firstResponderIndexPaths allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSUInteger nextIndex = [orderedIndexPaths indexOfObject:indexPath]+1;
    if (nextIndex<[orderedIndexPaths count]) {
        return orderedIndexPaths[nextIndex];
    }
    return nil;
}

@end
