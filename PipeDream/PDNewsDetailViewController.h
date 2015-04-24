//
//  PDNewsDetailViewController.h
//  PipeDream
//
//  Created by elif ece arslan on 4/11/15.
//  Copyright (c) 2015 elif ece arslan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface PDNewsDetailViewController : UIViewController

@property(nonatomic, strong) Article *article;
@property (weak, nonatomic) IBOutlet UILabel *newsArticleTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsArticleAutor;
@property (weak, nonatomic) IBOutlet UIImageView *newsArticleImage;
@property (weak, nonatomic) IBOutlet UITextView *newsArticleBody;



@end
