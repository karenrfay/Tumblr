//
//  ViewController.m
//  Tumblr
//
//  Created by Karen Fay on 9/14/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoDetailViewController.h"

@interface PhotosViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *blog;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(tumblrApi) forControlEvents:UIControlEventValueChanged];

    [self tumblrApi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    NSDictionary *post = self.posts[indexPath.section];
    NSString *imageUrl = post[@"photos"][0][@"original_size"][@"url"];
    //NSLog(@"Image url: %@", imageUrl);
    [cell.tumblrImageView setImageWithURL:[NSURL URLWithString:imageUrl]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];

    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;

    NSDictionary *post = self.posts[section];
    NSString *blogName = post[@"blog_name"];
    NSString *imageUrl = [NSString stringWithFormat:@"https://api.tumblr.com/v2/blog/%@/avatar", blogName];

    // Use the section number to get the right URL
    [profileView setImageWithURL:[NSURL URLWithString:imageUrl]];

    [headerView addSubview:profileView];

    UILabel *blogLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 200, 20)];
    blogLabel.numberOfLines = 1;
    blogLabel.font = [UIFont systemFontOfSize:15];
    blogLabel.text = blogName;

    [headerView addSubview:blogLabel];
    
    return headerView;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}

- (void)tumblrApi {
    NSString *clientId = @"Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV";
    NSString *urlString =
    [@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=" stringByAppendingString:clientId];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.blog = responseDictionary[@"response"][@"blog"];
                                                    self.posts = responseDictionary[@"response"][@"posts"];
                                                    [self.tableView reloadData];
                                                    //NSLog(@"blog: %@, posts: %@", self.blog, self.posts);
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }

                                                [self.refreshControl endRefreshing];
                                            }];
    [task resume];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PhotoDetailViewController *photoView = [segue destinationViewController];

    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *post = self.posts[indexPath.row];
    NSString *imageUrl = post[@"photos"][0][@"original_size"][@"url"];

    photoView.photoURL = imageUrl;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
