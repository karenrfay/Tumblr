//
//  PhotoDetailViewController.h
//  Tumblr
//
//  Created by Karen Fay on 9/14/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController

@property (strong, nonatomic) NSString *photoURL;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end
