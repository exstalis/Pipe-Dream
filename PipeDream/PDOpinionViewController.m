//
//  PDOpinionViewController.m
//  PipeDream
//
//  Created by elif ece arslan on 4/11/15.
//  Copyright (c) 2015 elif ece arslan. All rights reserved.
//

#import "PDOpinionViewController.h"
#import "PDOpinionDetailViewController.h"
#import "PDFeedTableViewCell.h"
#import "AppDelegate.h"
#import "PDNetworkClient.h"
#import "PDOpinionTableViewCell.h"

@interface PDOpinionViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
- (IBAction)showMenu:(UIBarButtonItem *)sender;

@property(nonatomic, strong) NSMutableArray *opinionArticlesArray;

@end





@implementation PDOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadOpinionArticles];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _opinionArticlesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OpinionDetailSegue"]) {
        PDOpinionDetailViewController *viewController = (PDOpinionDetailViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Article *selectedArticle = [_opinionArticlesArray objectAtIndex:selectedIndexPath.row];
        viewController.article = selectedArticle;
    }
}

- (void)loadOpinionArticles
{
    PDNetworkClient *manager = [[PDNetworkClient alloc] init];
    [manager getOpinionArticlesWithCompletion:^(NSArray *array, NSError *error) {
        if (error == nil) {
            if (array != nil) {
                [_opinionArticlesArray removeAllObjects];
                [_opinionArticlesArray addObjectsFromArray:array];
                
                [self.tableView reloadData];
            }
        }
    }];
}


- (IBAction)showMenu:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    
    
}


- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    return [[AppDelegate globalDelegate] drawerAnimator];
}


#pragma mark - TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_opinionArticlesArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    PDOpinionTableViewCell *opinionCell=[tableView dequeueReusableCellWithIdentifier:@"opinionCell" forIndexPath:indexPath];
    
    if (opinionCell==nil) {
        opinionCell=[[PDOpinionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"opinionCell"];
        
    }
    
    Article *opinionArticle = [_opinionArticlesArray objectAtIndex:indexPath.row];
    
    opinionCell.opinionTitleLabel.text = opinionArticle.articleTitle;
    opinionCell.opinionExercptLabel.text = opinionArticle.articleExcerpt;
    opinionCell.opinionAuthorLabel.text = opinionArticle.authorName;
    opinionCell.opinionDateLabel.text = opinionArticle.articleDate.description;
    
    
    
    
    return opinionCell;
    
}


@end
