//
//  PhotoDetailViewController.m
//  Tumblr
//
//  Created by Karen Fay on 9/14/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.photoImageView setImageWithURL:[NSURL URLWithString:self.photoURL]];
    NSLog(@"PhotoDetailViewController viewDidLoad");
}
@end
