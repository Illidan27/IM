//
//  ContactTableViewController.m
//  Main Page
//
//  Created by Ray Shaw on 2019/4/25.
//  Copyright © 2019年 Ray Shaw. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactTableViewCell.h"

@interface ContactTableViewController ()

@property (nonatomic, strong) NSMutableArray<UserModel*> *ContactsArray;
@property (strong, nonatomic) IBOutlet UITableView *ContactTableView;
@property (nonatomic, strong) UserModel* SelectiveUser;
@end


@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ContactsArray = [NSMutableArray array];
    [self initializeTestData];
    
    [self addObserver:self forKeyPath:@"ContactsArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self getContactsFromServer];
    
    self.ContactTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getContactsFromServer
{
    void (^showContacts)(id) = ^void (id object)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"dictionary:%@", object ]);
        
        for (id user in object[@"data"])
        {
             UserModel* ContactUser = [[UserModel alloc] initWithProperties:user[@"Friend"] NickName:user[@"Username"] RemarkName:user[@"Username"] Gender:@"male" Birthplace:@"Jodl" ProfilePicture:@"teemo.jpg"];
            [self willChangeValueForKey:@"ContactsArray"];
            [self.ContactsArray addObject:ContactUser];
            [self didChangeValueForKey:@"ContactsArray"];
            
            
        }
        //[self initializeFakeData];
    };
    
    [SessionHelper sendRequest:@"/contact/info" method:@"get" parameters:@"" handler:showContacts];
    
    
}

- (void)initializeTestData
{
    
    UserModel* TestUser1 = [[UserModel alloc] initWithProperties:@"123" NickName:@"teemo" RemarkName:@"teemo" Gender:@"male" Birthplace:@"Jodl" ProfilePicture:@"teemo.jpg"];
    UserModel* TestUser2 = [[UserModel alloc] initWithProperties:@"321" NickName:@"peppa" RemarkName:@"peppa" Gender:@"female" Birthplace:@"UK" ProfilePicture:@"peppa.jpg"];
    [self willChangeValueForKey:@"ContactsArray"];
    [self.ContactsArray addObject:TestUser1];
    [self.ContactsArray addObject:TestUser2];
    [self didChangeValueForKey:@"ContactsArray"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ContactsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"ContactTableCell";
ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];


    if (cell == nil)
    {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    cell.ContactProfilePicture.image = [UIImage imageNamed:self.ContactsArray[indexPath.row].ProfilePicture];
    cell.ContactName.text = self.ContactsArray[indexPath.row].NickName;
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.SelectiveUser = self.ContactsArray[indexPath.row];
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([[segue identifier] isEqualToString:@"ShowUserInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        InfoViewController *InfoVC = [segue destinationViewController];
        InfoVC.hidesBottomBarWhenPushed = YES;
        InfoVC.User = self.ContactsArray[indexPath.row];
    }
    // Pass the selected object to the new view controller.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"ContactsArray"])
    {
        //NSLog(@"contacts: %@", self.ContactsArray);
        [self.tableView reloadData];
        
    }
}
@end
