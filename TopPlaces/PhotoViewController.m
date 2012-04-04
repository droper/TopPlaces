//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Marco Morales on 4/3/12.
//  Copyright (c) 2012 Casa. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController() <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) UIImage *photoImage;

@end

@implementation PhotoViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize photoUrl = _photoUrl;
@synthesize photoImage;
@synthesize photoTitle = _photoTitle;


- (void)setPhotoUrl:(NSURL *)photoUrl
{
    if (_photoUrl != photoUrl) {
        _photoUrl = photoUrl;
    }
}


- (void)setPhotoTitle:(NSString *)photoTitle
{
    if (_photoTitle != photoTitle) {
        _photoTitle = photoTitle;
    }
}


- (UIImage *)createPhoto:(NSURL *)photoUrl
{
    //Create an NSData with the photo url and then a image
    //with that data
    NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
    UIImage *photo = [UIImage imageWithData:imageData];
    
    return photo;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"URL: %@", self.photoUrl);
    self.imageView.image = [self createPhoto:self.photoUrl];
    self.title = self.photoTitle;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
