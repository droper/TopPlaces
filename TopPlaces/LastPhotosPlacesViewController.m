//
//  LastPhotosPlacesViewController.m
//  TopPlaces
//
//  Created by Marco Morales on 4/2/12.
//  Copyright (c) 2012 Casa. All rights reserved.
//

#import "LastPhotosPlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"


@interface LastPhotosPlacesViewController ()


@end

@implementation LastPhotosPlacesViewController

@synthesize photos = _photos;
@synthesize place = _place;

//cambio para probar el commit



- (void)setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        // Model changed, so update our View (the table)
        [self.tableView reloadData];
    }
}

- (void)setPlace:(NSDictionary *)place
{
    if (_place != place) {
        _place = place;
            // Model changed, so update our View (the table)
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    //NSDictionary *place = [FlickrFetcher topPlaces].lastObject;
                          
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.photos = photos;
        });
    });
    dispatch_release(downloadQueue);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}


#pragma mark - UITableViewDataSource

/*
- (NSString *)photographerForSection:(NSInteger)section
{
    return [[self.photosByPhotographer allKeys] objectAtIndex:section];
}*/

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self photographerForSection:section];
}*/

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.photosByPhotographer count];
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [self.photos count];
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Place Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    
    if (![[photo objectForKey:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
        cell.textLabel.text = [photo objectForKey:FLICKR_PHOTO_TITLE];
    } else if (![[photo objectForKey:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]) {
        cell.textLabel.text = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    } else {
        cell.textLabel.text = @"Unknown";
    }
    
    
    cell.detailTextLabel.text = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    [segue.destinationViewController setPhotoUrl:[FlickrFetcher urlForPhoto:[self.photos objectAtIndex:path.row] format:FlickrPhotoFormatLarge]];
}



@end
