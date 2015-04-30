//
//  PDFeedTableViewController.m
//  PipeDream
//
//  Created by elif ece arslan on 4/26/15.
//  Copyright (c) 2015 elif ece arslan. All rights reserved.
//

#import "PDFeedTableViewController.h"
#import "KLCPopup.h"
#import "PDFeedTableViewCell.h"
#import "PDNavigationController.h"
#import "PDShareButton.h"
#import <FBSDKShareKit.h>
#import "PDSingleton.h"
#import <FBSDKShareLinkContent.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PDShareUtility.h"
#import "Article.h"


typedef NS_ENUM(NSInteger,PopupLabel) {
   
    PopupLabelSucces=1,
    PopupLabelFail=2,
    PopupLabelItem_COUNT,
    
    
    
};

@class NSCoder;

@interface PDFeedTableViewController ()<FBSDKSharingDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,NSSecureCoding>



@end


@interface UIColor (PipeDream)
+ (UIColor*)kpdLightGreenColor;
+ (UIColor*)kpdGreenColor;
@end

@implementation PDFeedTableViewController{
    
    FBSDKShareDialog *_facebookSharedDialog;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _shouldDismissAfterDelay = NO;
    self.thumbnailArray=[[NSMutableArray alloc]init];
    
    
    
   
    


}


-(void)setMailButton:(PDShareButton *)mailButton{
    
    
    if (![_mailButton isEqual:mailButton]) {
        _mailButton =mailButton;
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



-(void)notifyUserShareDidCompletePopUp{
    
    UIView *sharedPopUpView=[[UIView alloc]init];
    sharedPopUpView.translatesAutoresizingMaskIntoConstraints=NO;
    sharedPopUpView.backgroundColor=[UIColor grayColor];
    //    burasini sonra duzel renkleri
    sharedPopUpView.layer.cornerRadius=5.0;
    UILabel *popUpSharedLabel=[[UILabel alloc]init];
    
    [popUpSharedLabel setTag:1];
    [popUpSharedLabel setText:@"Shared on Facebook"];
    
    popUpSharedLabel.translatesAutoresizingMaskIntoConstraints=NO;
    popUpSharedLabel.backgroundColor=[UIColor clearColor];
    popUpSharedLabel.textColor=[UIColor whiteColor];
    popUpSharedLabel.font=[UIFont fontWithName:@"Lato-Semibold" size:28.0];
    
    
    [sharedPopUpView addSubview:popUpSharedLabel];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(sharedPopUpView,popUpSharedLabel);
    
    [sharedPopUpView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[popUpSharedLabel]-(10)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [sharedPopUpView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[popUpSharedLabel]-(10)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    KLCPopupLayout layout =KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter , KLCPopupVerticalLayoutCenter);
    KLCPopup * popupSuccess=[KLCPopup popupWithContentView:sharedPopUpView showType:KLCPopupShowTypeSlideInFromRight dismissType:KLCPopupDismissTypeSlideOutToTop maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    
    if (_shouldDismissAfterDelay) {
        [popupSuccess showWithLayout:layout duration:0.5];
    } else {
        [popupSuccess showWithLayout:layout];
    }
    
    
}







-(void)sharingOptionsButtonAction{
    
    
    [PDShareButton supportsSecureCoding];
    
    UIView *popUpView=[[UIView alloc]init];
    popUpView.translatesAutoresizingMaskIntoConstraints=NO;
    popUpView.backgroundColor=[UIColor grayColor];
    //    burasini sonra duzel renkleri
    popUpView.layer.cornerRadius=5.0;
    UILabel *popUpTitleLabel=[[UILabel alloc]init];
    popUpTitleLabel.translatesAutoresizingMaskIntoConstraints=NO;
    popUpTitleLabel.backgroundColor=[UIColor clearColor];
    popUpTitleLabel.textColor=[UIColor whiteColor];
    //    burdaki title labeli icin duzenlemeler yap..
    
    popUpTitleLabel.font=[UIFont fontWithName:@"Lato-Semibold" size:24.0];
    popUpTitleLabel.text=@"Share this article";
    //    facebook button koyman gerekibilir
    
    //    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton=[PDShareButton buttonWithType:UIButtonTypeCustom];
    
    
    
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    _cancelButton.contentEdgeInsets =UIEdgeInsetsMake(10, 100, 10, 100);
    
    
    
    _cancelButton.backgroundColor = [UIColor purpleColor];
    //    renkleri duzelt
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[[_cancelButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:20.0];
    [_cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = 6.0;
    
    
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    iste bu islemler icin share buttonin attributelarini orda belirle
    
    _fbShareButton = [PDShareButton buttonWithType:UIButtonTypeCustom];
    _fbShareButton.translatesAutoresizingMaskIntoConstraints = NO;
    _fbShareButton.contentEdgeInsets =UIEdgeInsetsMake(10, 50, 10, 50);
    _fbShareButton.backgroundColor = [UIColor blueColor];
    [_fbShareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fbShareButton setTitleColor:[[_fbShareButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    _fbShareButton.titleLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:20.0];
    [_fbShareButton setTitle:@"Share on Facebook" forState:UIControlStateNormal];
    _fbShareButton.layer.cornerRadius = 6.0;
    
    [_fbShareButton addTarget:self action:@selector(shareOnFaceBook:) forControlEvents:UIControlEventTouchUpInside];
    
    _mailButton = [PDShareButton buttonWithType:UIButtonTypeCustom];
    
    _mailButton.translatesAutoresizingMaskIntoConstraints = NO;
    _mailButton.contentEdgeInsets =UIEdgeInsetsMake(10, 50, 10, 50);
    _mailButton.backgroundColor = [UIColor blueColor];
    [_mailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_mailButton setTitleColor:[[_mailButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    _mailButton.titleLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:20.0];
    [_mailButton setTitle:@"Mail" forState:UIControlStateNormal];
    _mailButton.layer.cornerRadius = 6.0;
    
    [_mailButton addTarget:self action:@selector(sendwithMail:) forControlEvents:UIControlEventTouchUpInside];
    
    //    facebook share targeti ekle
    
    

    [popUpView addSubview:popUpTitleLabel];
    [popUpView addSubview:_mailButton];
    [popUpView addSubview:_fbShareButton];
    [popUpView addSubview:_cancelButton];
    NSDictionary* views = NSDictionaryOfVariableBindings(popUpView,_mailButton, _cancelButton, popUpTitleLabel,_fbShareButton);
    
    [popUpView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[popUpTitleLabel]-(10)-[_fbShareButton]-(10)-[_mailButton]-(10)-[_cancelButton]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [popUpView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[popUpTitleLabel]-(5)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    // Show in popup
    // Show in popup
    KLCPopupLayout layout =KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter , KLCPopupVerticalLayoutCenter);
    KLCPopup * popup=[KLCPopup popupWithContentView:popUpView showType:KLCPopupShowTypeSlideInFromRight dismissType:KLCPopupDismissTypeSlideOutToTop maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    if (_shouldDismissAfterDelay) {
        [popup showWithLayout:layout duration:2.0];
    } else {
        [popup showWithLayout:layout];
    }
}





#pragma mark update and delete

#pragma utility setter
//facebook share lazy instantiation



- (void)setShareUtility:(PDShareUtility *)shareUtility
{
    if (![_shareUtility isEqual:shareUtility]) {
        _shareUtility.delegate = nil;
        _shareUtility = shareUtility;
    }
}




#pragma  mark - share on facebook action




- (void)shareOnFaceBook:(id)sender{

    if ([sender isKindOfClass:[PDShareButton class]]) {
        [self facebookShare];

        [(UIView*)sender dismissPresentingPopup];

    }
    
    
}

-(void)facebookShare{
    
    
    PDShareUtility *utility=[[PDShareUtility alloc]initWithArticleURL:self.feedArticle.articleURL];
    
    //    FBSDKShareDialog *facebookShareDialog=[utility getShareDialogWithContentURL:fbsharedArticle.sharedArticle.articleURL];
    //    facebookShareDialog.delegate=self;
    
    self.shareUtility=utility;
    utility.delegate=self;
    [utility startSharing];
    


    
}



#pragma mark - mail


-(void)sendwithMail:(id)sender{
//    
    if ([sender isKindOfClass:[PDShareButton class]]) {
        [(PDShareButton*)sender dismissPresentingPopup];
    }
    [self sendArticleViaMail:[self.feedArticle.articleURL absoluteString]];
    
//    NSLog(@"@mothh came!!!%@: ",[self.feedArticle.articleURL absoluteString]);

    
}

#pragma cancellation

- (void)cancelButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}






#pragma mark - mail operations


- (void)sendArticleViaMail:(NSString *)articleURL{
    
    MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];

    
    viewController.mailComposeDelegate = self;
    [viewController setSubject:self.feedArticle.titlePlain];
    [viewController setMessageBody: articleURL isHTML:YES];
    [self presentViewController:viewController animated:YES completion:NULL];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    
}






#pragma mark - PDShare Delegate


-(void)shareUtilityDidCompleteShareOnFacebook{
    

    [self notifyUserShareDidCompletePopUp];
    

    
    
}





-(void)shareUtilityEndWithError{

    
    UIView *alertView=[[UIView alloc]init];
    UILabel *alertLabel=[[UILabel alloc]init];
    
    
    [alertLabel setText:@"canceled sharing"];
    
    [alertView addSubview:alertLabel];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(alertView,alertLabel);
    
    [alertView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[alertLabel]-(10)|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    [alertView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[alertLabel]-(10)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];

    KLCPopupLayout layout =KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter , KLCPopupVerticalLayoutCenter);
    KLCPopup *alertPopup=[KLCPopup popupWithContentView:alertView showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    
    
    
    if (_shouldDismissAfterDelay) {
        [alertPopup showWithLayout:layout duration:2.0];
    } else {
        [alertPopup showWithLayout:layout];
    }
    
   
}

-(void)shareUtilityDidFailShareOnFacebook:(NSError *)error{
    
    
    NSLog(@"Unexpected error when sharing : %@", error);
    
    
    
    
}

@end



#pragma PopUp Colors

@implementation UIColor (PipeDream)

+ (UIColor*)kpdLightGreenColor {
    return [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
}

+ (UIColor*)kpdGreenColor {
    return [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
}






@end









