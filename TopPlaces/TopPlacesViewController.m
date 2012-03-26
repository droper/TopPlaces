//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Marco Morales on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesViewController()
// keys: placegrapher NSString, values: NSArray of place NSDictionary
@property (nonatomic, strong) NSMutableArray *placesTitles;
@end


@implementation TopPlacesViewController

@synthesize places = _places;
@synthesize placesTitles = _placesTitles;

//cambio para probar el commit


- (void)updatePlacesTitles
{
    /*NSMutableArray *placesTitles = [[NSMutableArray alloc] init];
    for (NSDictionary *place in self.places) {
        NSString *placename = [place objectForKey:FLICKR_PLACE_NAME];
        [placesTitles addObject:placename];
    }
    self.placesTitles = placesTitles;
    */
    
    //NSMutableDictionary *place = [NSMutableDictionary dictionary];
    NSMutableArray *placest = [[NSMutableArray alloc] init];
    for (NSDictionary *place in self.places) {
        [placest addObject:place];
    }
    self.places = placest;
    
}

- (void)setPlaces:(NSArray *)places
{
    if (_places != places) {
        _places = places;
        // Model changed, so update our View (the table)
        //[self updatePlacesTitles];
        [self.tableView reloadData];
    }
}


- (IBAction)refresh:(id)sender
{
    // might want to use introspection to be sure sender is UIBarButtonItem
    // (if not, it can skip the spinner)
    // that way this method can be a little more generic
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *places = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem = sender;
            self.places = places;
        });
    });
    dispatch_release(downloadQueue);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return YES;
}


#pragma mark - UITableViewDataSource


/*- (NSString *)placegrapherForSection:(NSInteger)section
{
    return [[self.placesByplacegrapher allKeys] objectAtIndex:section];
}*/

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self placegrapherForSection:section];
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [self.places count];
    //NSString *placegrapher = [self placegrapherForSection:section];
    //NSArray *placesByplacegrapher = [self.placesByplacegrapher objectForKey:placegrapher];
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr place";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    //NSString *placegrapher = [self placegrapherForSection:indexPath.section];
    //NSArray *placesByplacegrapher = [self.placesByplacegrapher objectForKey:placegrapher];
   // NSDictionary *place = [placesByplacegrapher objectAtIndex:indexPath.row];
    
    //cell.detailTextLabel.text = [place objectForKey:FLICKR_PHOTO_OWNER];
    
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = [place objectForKey:FLICKR_PLACE_NAME];
    cell.detailTextLabel.text = [place objectForKey:FLICKR_TIMEZONE];
    
    return cell;
}



@end
