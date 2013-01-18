//
//  GenreSelectionViewController.m
//  Bandwidth
//
//  Created by Bergman, Adam on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenreSelectionViewController.h"
#import "AppDelegate.h"

#import "UINavigationControlleriPhone.h"
#import "CNAPI.h"

#import "SVProgressHUD.h"

@interface GenreSelectionViewController ()

@end

@implementation GenreSelectionViewController

@synthesize genres;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithGenres:(NSArray *)genresArray
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self)
    {
        self.genres = [[NSMutableArray alloc] initWithArray:genresArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Stations"
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    
}

- (void)loadGenres
{
    
    if(!genres)
    {
        genres = [[NSMutableArray alloc] init];
    }
    
    [genres removeAllObjects];
    
    [self.tableView reloadData];
    
    [SVProgressHUD showWithStatus:@"Tuning In..." maskType:SVProgressHUDMaskTypeClear];
    
    [CNAPI submitRequest:CNRequestTypeGenres withData:nil onSuccess:^(NSDictionary *response) {
        
        for(NSDictionary *genre in  [response objectForKey:@"genres"])
        {
            CNGenre *g = [[CNGenre alloc] initWithDictionary:genre];
            [genres addObject:g];
        }
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } onFailure:^(NSString *message, NSString *code) {
        NSLog(@"Message: %@, code: %@", message, code);
        [SVProgressHUD dismissWithError:@"Error connecting to cannon.fm" afterDelay:4.0f];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(![CNClient currentLocation])
    {
        CNLocation *loc = [[CNLocation alloc] init];
        loc.locationDisplayName = @"Columbus";
        [CNClient setCurrentLocation:loc];
    }
    
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
   
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
	[titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
	[titleLabel setText:[NSString stringWithFormat:@"%@ Stations", [[CNClient currentLocation] locationDisplayName]]];
    [self.navigationItem setTitleView:titleLabel];
    
    if([[CNAPI instance] hasNowPlaying])
    {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(gotoNowPlaying)];
       
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    [self loadGenres];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return genres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    CNGenre *genre = [genres objectAtIndex:indexPath.row];
    
    if([CNClient currentGenre] && [[genre identifier] isEqual:[[CNClient currentGenre] identifier]])
    {
        [cell.textLabel setTextColor:[UIColor blueColor]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (playing)", [genre displayName]];
    }else{
        cell.textLabel.text = [genre displayName];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CNGenre *genre = [genres objectAtIndex:indexPath.row];
    [CNClient setCurrentGenre:genre];
    [[CNAPI instance] setHasNowPlaying:FALSE];
    [(UINavigationControlleriPhone *)self.navigationController pushPlayerViewController:TRUE];
}

-(void)gotoNowPlaying
{
    [(UINavigationControlleriPhone *)self.navigationController pushPlayerViewController:FALSE];
}

@end
