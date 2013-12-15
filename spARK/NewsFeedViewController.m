//
//  NewsFeedViewController.m
//  spARK
//
//  Created by Brenna on 11/3/13.
//  Copyright (c) 2013 uark.edu. All rights reserved.
//

#import "NewsFeedViewController.h"

@interface NewsFeedViewController ()
{
    NSMutableArray *logInArray;
    NSString *filePath;
    NSString *username;
    NSString *userID;
    
    int blockRow;
    int contentDisplay;
}

@end


@implementation NewsFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"News Feed";
    
    contentDisplay = 0;
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    logInArray = [[NSMutableArray alloc] initWithContentsOfFile:[self dataFilePath:(kLoginInfo)]];
    username = [logInArray objectAtIndex:0];
    userID = [logInArray objectAtIndex:2];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadDataFromServer];
    [_tableView reloadData];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _discussionArray = [NSMutableArray array];
        _bulletinArray = [NSMutableArray array];
    }
    
    return self;
}


- (IBAction)postButtonPressed:(id)sender
{
    PostNewContentViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostView"];
    [self.navigationController pushViewController:newViewController animated:YES];
}


- (IBAction)segmentedControllerValueChanged:(UISegmentedControl *)sender
{
    contentDisplay = (int)sender.selectedSegmentIndex;
    [_tableView reloadData];
}


- (IBAction)commentButtonPressed:(id)sender
{    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    CommentViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
    newViewController.originalDiscussion = [_discussionArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:newViewController animated:YES];
}


- (IBAction)ratingUpButtonPressed:(id)sender
{
    NSString *type = @"like";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NewsFeedObject *objectToRate;
    if (contentDisplay == 0)
    {
        objectToRate = [_discussionArray objectAtIndex:indexPath.row];
    }
    
    else if (contentDisplay == 1)
    {
        objectToRate =  [_bulletinArray objectAtIndex:indexPath.row];
    }
    
    NSString *objectID = objectToRate.idString;
    NSString *currentRating = [NSString stringWithFormat:@"%@", objectToRate.ratingFlagString];
    //NSLog(@"Rated: %@", currentRating);
    
    if (![currentRating isEqualToString:@"0"])
    {
        type = @"delete";
    }
    
    NSString *ratingURLString = @"http://csce.uark.edu/~mmmcclel/spark/rating.php?value1=";
    ratingURLString = [ratingURLString stringByAppendingFormat:@"%@&value2=%@&value3=%@", userID, objectID, type];
    
    NSURL *url = [NSURL URLWithString:ratingURLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if(urlData)
    {
        NSError *errorJSON = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
        NSString *successString = [[json objectForKey:@"success"] stringValue];
        
        if ([successString isEqualToString:@"1"])
        {
             NSLog(@"Like success");
            [self loadDataFromServer];
            [_tableView reloadData];
        }
        
        else
        {
            NSLog(@"Like fail");
        }
    }
}


- (IBAction)ratingDownButtonPressed:(id)sender
{  
    NSString *type = @"dislike";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NewsFeedObject *objectToRate;
    if (contentDisplay == 0)
    {
        objectToRate = [_discussionArray objectAtIndex:indexPath.row];
    }
    
    else if (contentDisplay == 1)
    {
        objectToRate =  [_bulletinArray objectAtIndex:indexPath.row];
    }
    
    NSString *objectID = objectToRate.idString;
    NSString *currentRating = [NSString stringWithFormat:@"%@", objectToRate.ratingFlagString];
    //NSLog(@"Rated: %@", currentRating);
    
    if (![currentRating isEqualToString:@"0"])
    {
        type = @"delete";
    }
    
    NSString *ratingURLString = @"http://csce.uark.edu/~mmmcclel/spark/rating.php?value1=";
    ratingURLString = [ratingURLString stringByAppendingFormat:@"%@&value2=%@&value3=%@", userID, objectID, type];
    
    NSURL *url = [NSURL URLWithString:ratingURLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if(urlData)
    {
        NSError *errorJSON = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
        NSString *successString = [[json objectForKey:@"success"] stringValue];
        
        if ([successString isEqualToString:@"1"])
        {
            NSLog(@"Dislike success");
            [self loadDataFromServer];
            [_tableView reloadData];
        }
        
        else
        {
            NSLog(@"Dislike fail");
        }
    }
}


- (IBAction)trashButtonPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSString *contentType;
    
    NewsFeedObject *objectToDelete;
    if (contentDisplay == 0)
    {
        objectToDelete = [_discussionArray objectAtIndex:indexPath.row];
        contentType = @"Discussion";
    }
    
    else if (contentDisplay == 1)
    {
        objectToDelete =  [_bulletinArray objectAtIndex:indexPath.row];
        contentType = @"Bulletin";
    }
    
    NSString *objectID = objectToDelete.idString;
    
    NSString *deleteURLString = @"http://csce.uark.edu/~mmmcclel/spark/deletecontent.php?value1=";
    deleteURLString = [deleteURLString stringByAppendingFormat:@"%@&value2=%@&value3=%@&value4=%@", userID, objectID, contentType, @"0"];
    
    NSURL *url = [NSURL URLWithString:deleteURLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if(urlData)
    {
        NSError *errorJSON = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
        NSString *successString = [[json objectForKey:@"deleteSuccess"] stringValue];
        
        if ([successString isEqualToString:@"1"])
        {
            NSLog(@"Delete success");
            [self loadDataFromServer];
            [_tableView reloadData];
        }
        
        else
        {
            NSLog(@"Delete fail");
        }
    }
}


- (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (void)loadDataFromServer
{
    NSString *discussionURLString = @"http://csce.uark.edu/~mmmcclel/spark/loadnewsfeed.php?value1=";
    discussionURLString = [discussionURLString stringByAppendingFormat:@"%@&value2=%@", username, kDiscussion];
    NSURL *discussionURL = [NSURL URLWithString:discussionURLString];
    NSData *discussionData = [NSData dataWithContentsOfURL:discussionURL];
    NSError *discussionError = nil;
    NSDictionary *discussionJSON = [NSJSONSerialization JSONObjectWithData:discussionData options:kNilOptions error:&discussionError];
    
    [_discussionArray removeAllObjects];
    [_bulletinArray removeAllObjects];
    
    NSArray *discussionArray = [discussionJSON objectForKey:@"contents"];
    for (int i = 0; i < [discussionArray count]; i++)
    {
        NSDictionary *discussion = [discussionArray objectAtIndex:i];
        
        [_discussionArray addObject:[NewsFeedObject
                                     newNewsFeedObjectWithID:[discussion objectForKey:@"id"]
                                     withTitle:[discussion objectForKey:@"title"]
                                     withPostTime:[discussion objectForKey:@"timestamp"]
                                     withUser:[discussion objectForKey:@"username"]
                                     withUserID:[discussion objectForKey:@"userid"]
                                     withMessage:[discussion objectForKey:@"body"]
                                     withUserImage:[discussion objectForKey:@""]
                                     withLatitude:[discussion objectForKey:@"latitude"]
                                     withLongitude:[discussion objectForKey:@"longitude"]
                                     withRating:[discussion objectForKey:@"rating_total"]
                                     withRatingFlag:[discussion objectForKey:@"user_rating"]]];
        
        NSArray *commentsArray = [discussion objectForKey:@"comments"];

        [[_discussionArray objectAtIndex:i] setComments:commentsArray];
        [[_discussionArray objectAtIndex:i] setNumberOfComments:[NSString stringWithFormat:@"%lu", (unsigned long)[commentsArray count]]];
    }
    
    NSString *bulletinURLString = @"http://csce.uark.edu/~mmmcclel/spark/loadnewsfeed.php?value1=";
    bulletinURLString = [discussionURLString stringByAppendingFormat:@"%@&value2=%@", username, kBulletin];
    NSURL *bulletinURL = [NSURL URLWithString:bulletinURLString];
    NSData *bulletinData = [NSData dataWithContentsOfURL:bulletinURL];
    NSError *bulletinError = nil;
    NSDictionary *bulletinJSON = [NSJSONSerialization JSONObjectWithData:bulletinData options:kNilOptions error:&bulletinError];
    
    NSArray *bulletinArray = [bulletinJSON objectForKey:@"contents"];
    
    for (int i = 0; i < [bulletinArray count]; i++)
    {
        NSDictionary *bulletin = [bulletinArray objectAtIndex:i];
        
        [_bulletinArray addObject:[NewsFeedObject
                                     newNewsFeedObjectWithID:[bulletin objectForKey:@"id"]
                                     withTitle:[bulletin objectForKey:@"title"]
                                     withPostTime:[bulletin objectForKey:@"timestamp"]
                                     withUser:[bulletin objectForKey:@"username"]
                                     withUserID:[bulletin objectForKey:@"userid"]
                                     withMessage:[bulletin objectForKey:@"body"]
                                     withUserImage:[bulletin objectForKey:@""]
                                     withLatitude:[bulletin objectForKey:@"latitude"]
                                     withLongitude:[bulletin objectForKey:@"longitude"]
                                     withRating:[bulletin objectForKey:@"rating_total"]
                                     withRatingFlag:[bulletin objectForKey:@"user_rating"]]];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (contentDisplay == 0)
    {
        return [_discussionArray count];
    }
    
    else if (contentDisplay == 1)
    {
        return [_bulletinArray count];
    }
    
    else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsFeedCell";
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NewsFeedObject *objectToDisplay;
    
    if (contentDisplay == 0)
    {
        objectToDisplay = [_discussionArray objectAtIndex:indexPath.row];
        cell.commentsButton.hidden = NO;
    }
    
    else if (contentDisplay == 1)
    {
        objectToDisplay = [_bulletinArray objectAtIndex:indexPath.row];
        cell.commentsButton.hidden = YES;
    }
    
    if ([objectToDisplay.userID isEqualToString:userID] )
    {
        cell.trashButton.hidden = NO;
    }
    
    else
    {
         cell.trashButton.hidden = YES;
    }
    
    cell.titleLabel.text = objectToDisplay.titleString;
    cell.messageTextView.text = objectToDisplay.messageString;
    cell.timePostedLabel.text = objectToDisplay.timePostedString;
    cell.rateLabel.text = [NSString stringWithFormat:@"%@", objectToDisplay.ratingString];
    cell.usernameLabel.text = objectToDisplay.usernameString;
    
    NSString *flagCheckString = [NSString stringWithFormat:@"%@", objectToDisplay.ratingFlagString];

    if ([flagCheckString isEqualToString:@"-1"])
    {
        [cell.voteDownButton setBackgroundImage:[UIImage imageNamed:@"btn_thumbdown_checked.png"] forState:UIControlStateNormal];
        [cell.voteUpButton setBackgroundImage:[UIImage imageNamed:@"btn_thumbup_unchecked.png"] forState:UIControlStateNormal];
    }
    
    else if ([flagCheckString isEqualToString:@"1"])
    {
        [cell.voteUpButton setBackgroundImage:[UIImage imageNamed:@"btn_thumbup_checked.png"] forState:UIControlStateNormal];
        [cell.voteDownButton setBackgroundImage:[UIImage imageNamed:@"btn_thumbdown_unchecked.png"] forState:UIControlStateNormal];
    }
    
    else
    {
        [cell.voteDownButton setBackgroundImage:[UIImage imageNamed:@"btn_thumbdown_unchecked.png"] forState:UIControlStateNormal];
        [cell.voteUpButton setBackgroundImage:[UIImage imageNamed:@"btn_thumbup_unchecked.png"] forState:UIControlStateNormal];
    }

    
    if ([objectToDisplay.numberOfComments isEqualToString:@"1"])
        [cell.commentsButton setTitle:[NSString stringWithFormat:@"%@ comment", objectToDisplay.numberOfComments] forState:UIControlStateNormal];
    else
        [cell.commentsButton setTitle:[NSString stringWithFormat:@"%@ comment", objectToDisplay.numberOfComments] forState:UIControlStateNormal];
    
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longPressGestureRecognizer];
    
    return cell;
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded)
    {
        CGPoint position = [longPress locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:position];
        blockRow = (int)indexPath.row;

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Block this user?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"No"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Yes", nil];
        [actionSheet showInView:self.view];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        NSLog(@"Block that fucker!");
        
        NSString *block = @"Block";
        NSString *contentType;
        
        if (contentDisplay == 0)
        {
            contentType = @"Discussion";
        }
        
        else if (contentDisplay == 1)
        {
            contentType = @"Bulletin";
        }
        
        NSString *blockURLString = @"http://csce.uark.edu/~mmmcclel/spark/blockcontent.php?value1=";
        blockURLString = [blockURLString stringByAppendingFormat:@"%@&value2=%@&value3=%d&value4=%@", block, userID, blockRow, contentType];
        NSLog(@"%@", blockURLString);
        
        NSURL *url = [NSURL URLWithString:blockURLString];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        if (urlData)
        {
            NSError *errorJSON = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&errorJSON];
            NSString *successString = [[json objectForKey:@"blockSuccess"] stringValue];
            
            if ([successString isEqualToString:successString])
            {
                NSLog(@"Block success");
            }
            
            else
            {
                NSLog(@"Block fail");
            }
        }
    }
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end