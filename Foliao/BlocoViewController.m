//
//  BlocoViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "BlocoViewController.h"
#import "SVProgressHUD.h"
#import "ParadeAnnotation.h"
#import "WhoIsGoingViewController.h"
#import "DateUtil.h"

typedef enum viewDomainClass {
    ViewDomainClassBloco = 1,
    ViewDomainClassParade = 2
} ViewDomainClass;

@interface BlocoViewController () {
    ViewDomainClass _domainClass;
    BOOL _mapIsOpen;
    NSMutableArray *friendIds;
}

@property (strong, nonatomic) NSArray *blocoParades;
@property (strong, nonatomic) NSMutableArray *folioes;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *buttonExpandMap;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelInfo;
@property (strong, nonatomic) IBOutlet UIButton *buttonCheckIn;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao0;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao1;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao2;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao3;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao4;

- (void)sizeScrollViewToFit;
- (void)fillBlocoInfo;
- (BOOL)foliaoIsAlreadyGoing:(PFUser *)foliao;
- (void)showWhoIsGoing;
- (void)showFolioesPictures;
- (void)confirmPresenceInParade:(PFObject *)parade;
- (void)addFoliaoToPresencesBox;

- (IBAction)checkInButtonTapped:(UIButton *)sender;
- (IBAction)whoIsGoingButtonTapped:(UIButton *)sender;
- (IBAction)expandMap:(UIButton *)sender;

@end


@implementation BlocoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sizeScrollViewToFit];
    [self fillBlocoInfo];
}

- (void)sizeScrollViewToFit
{
    CGFloat scrollViewHeight = 0.0f;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    for (UIView *view in self.scrollView.subviews) {
        if (!view.hidden) {
            CGFloat y = view.frame.origin.y;
            CGFloat h = view.frame.size.height;
            if (y + h > scrollViewHeight) {
                scrollViewHeight = h + y;
            }
        }
    }
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width, scrollViewHeight+10))];
}

- (void)fillBlocoInfo
{
    if (_domainClass == ViewDomainClassParade) {
        ParadeAnnotation *annotation = [[ParadeAnnotation alloc] initWithParade:self.parade];
        [self.mapView addAnnotation:annotation];
        
        self.buttonCheckIn.enabled = YES;
        self.labelName.text = self.parade[@"bloco"][@"name"];
        
        [self showWhoIsGoing];
        
    } else {
        self.buttonCheckIn.enabled = NO;
        self.labelName.text = self.bloco[@"name"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
        [query includeKey:@"bloco"];
        [query whereKey:@"bloco" equalTo:self.bloco];
        
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        query.maxCacheAge = 0.5 * 60 * 60; // half hour
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.blocoParades = objects;
                if (self.blocoParades.count) {
                    
#warning Mostrar a primeira Parade? As duas juntas?
                    ParadeAnnotation *annotation = [[ParadeAnnotation alloc] initWithParade:self.blocoParades[0]];
                    [self.mapView addAnnotation:annotation];
                    
                    self.buttonCheckIn.enabled = YES;
                    [self showWhoIsGoing];
                }
            }
        }];
    }
}

- (void)showWhoIsGoing
{
    PFQuery *query = [PFQuery queryWithClassName:@"Presence"];
    
    if (_domainClass == ViewDomainClassParade) {
        [query whereKey:@"parade" equalTo:self.parade];
    } else {
        [query whereKey:@"parade" containedIn:self.blocoParades];
    }
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 0.5 * 60 * 60; // half hour
    
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *presences, NSError *error) {
        if (!error) {
            NSLog(@"Found %d presences", presences.count);
            self.folioes = [[NSMutableArray alloc] initWithCapacity:presences.count];
            
            for (PFObject *presence in presences) {
                PFUser *user = presence[@"user"];
                if ([self foliaoIsAlreadyGoing:user])
                    continue;
                
                if ([user.objectId isEqualToString:[PFUser currentUser].objectId])
                    [self.folioes addObject:[PFUser currentUser]]; // just to make an easy sort method
                else
                    [self.folioes addObject:user];
            }
            
            [self showFolioesPictures];
        }
    }];
}

- (BOOL)foliaoIsAlreadyGoing:(PFUser *)foliao
{
    if (!self.folioes.count)
        return NO;
    
    BOOL isAlreadyGoing = NO;
    for (PFUser *foliaoGoing in self.folioes) {
        if ([foliaoGoing.objectId isEqualToString:foliao.objectId]) {
            isAlreadyGoing = YES;
            break;
        }
    }
    
    return isAlreadyGoing;
}

- (void)showFolioesPictures
{
    PF_FBRequest *request = [PF_FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            [self sortFolioesList];
        }
        
        NSArray *pictureTemplates = [NSArray arrayWithObjects:
                                     self.imageViewPictureFoliao0,
                                     self.imageViewPictureFoliao1,
                                     self.imageViewPictureFoliao2,
                                     self.imageViewPictureFoliao3,
                                     self.imageViewPictureFoliao4, nil];
        
        for (int i=0; i < self.folioes.count; i++) {
            NSString *picURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", self.folioes[i][@"facebookId"]];
            UIImageView *profileImageView = (UIImageView *)pictureTemplates[i];
            [profileImageView setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"110x110.gif"]];
            profileImageView.layer.cornerRadius = 3.0;
            profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            profileImageView.clipsToBounds = YES;
        }
    }];
}

- (void)sortFolioesList
{
    // based on my friends...
    [self.folioes sortUsingComparator:^NSComparisonResult(PFUser *user1, PFUser *user2) {
        if ([friendIds containsObject:user1[@"facebookId"]] &&
            ![friendIds containsObject:user2[@"facebookId"]]) {
            return NSOrderedAscending;
        }
        
        if (![friendIds containsObject:user1[@"facebookId"]] &&
            [friendIds containsObject:user2[@"facebookId"]]) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    // ... and "moi" first :)
    if ([self.folioes containsObject:[PFUser currentUser]]) {
        [self.folioes removeObject:[PFUser currentUser]];
        [self.folioes insertObject:[PFUser currentUser] atIndex:0];
    }
}

- (IBAction)checkInButtonTapped:(UIButton *)sender
{
    if (_domainClass == ViewDomainClassParade) {
        [self confirmPresenceInParade:self.parade];
    } else {
        if (self.blocoParades.count == 0)
            return;
    
        else if (self.blocoParades.count == 1)
            [self confirmPresenceInParade:self.blocoParades[0]];
        
        else {
            UIActionSheet *confirmationSheet = [[UIActionSheet alloc] initWithTitle:@"Vai pular em qual dia?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            
            for (PFObject *parade in self.blocoParades) {
                [confirmationSheet addButtonWithTitle:[DateUtil stringFromDate:(NSDate *)parade[@"date"]]];
            }
            
            confirmationSheet.cancelButtonIndex = self.blocoParades.count;
            [confirmationSheet addButtonWithTitle:@"Nenhum"];
            
            confirmationSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [confirmationSheet showInView:self.view];
        }
    }
}

- (IBAction)whoIsGoingButtonTapped:(UIButton *)sender
{
    WhoIsGoingViewController *whoIsGoingViewController = [[WhoIsGoingViewController alloc] init];
    whoIsGoingViewController.folioes = self.folioes;
    [self.navigationController pushViewController:whoIsGoingViewController animated:YES];
}

- (void)confirmPresenceInParade:(PFObject *)parade
{
    PFUser *me = [PFUser currentUser];

    PFQuery *queryMyPresence = [[PFQuery alloc] initWithClassName:@"Presence"];
    [queryMyPresence whereKey:@"user" equalTo:me];
    [queryMyPresence whereKey:@"parade" equalTo:parade];
    [queryMyPresence findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count == 0) {
            PFObject *presence = [[PFObject alloc] initWithClassName:@"Presence"];
            [presence setObject:me forKey:@"user"];
            [presence setObject:parade forKey:@"parade"];
            [presence saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error && succeeded) {
                    NSLog(@"Confirmed!");
                    
                    if ([[PFUser currentUser][@"gender"] isEqualToString:@"male"])
                        [parade incrementKey:@"malePresencesCount"];
                    if ([[PFUser currentUser][@"gender"] isEqualToString:@"female"])
                        [parade incrementKey:@"femalePresencesCount"];
                    
                    [parade incrementKey:@"totalPresencesCount"];
                    [parade saveInBackground];
                    
                    [PFQuery clearAllCachedResults];
                    
                    [SVProgressHUD showSuccessWithStatus:@"Ah muleque!"];
                    [self addFoliaoToPresencesBox];
                } else {
                    NSLog(@"Error when confirming presence.");
                }
            }];
        }
    }];
}

- (void)addFoliaoToPresencesBox
{
#warning TODO and remove HUD.
}

- (IBAction)expandMap:(UIButton *)sender
{
    if (_mapIsOpen) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mapView.frame = CGRectMake(0, 0, 320, 110);
        } completion:^(BOOL finished) {
            [self.buttonExpandMap setTitle:@"+" forState:UIControlStateNormal];
            _mapIsOpen = !_mapIsOpen;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.mapView.frame = self.view.frame;
        } completion:^(BOOL finished) {
            [self.buttonExpandMap setTitle:@"-" forState:UIControlStateNormal];
            _mapIsOpen = !_mapIsOpen;
        }];
    }
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= self.blocoParades.count) // cancelling...
        return;
    
    NSLog(@"Confirming presence...");
    [self confirmPresenceInParade:self.blocoParades[buttonIndex]];
}


#pragma mark - MKMapView delegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    CLLocationCoordinate2D paradeCoordinate = [(ParadeAnnotation *)views[0] coordinate];
    [self.mapView setCenterCoordinate:paradeCoordinate animated:YES];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = paradeCoordinate;
    
    [self.mapView setRegion:region];
}


#pragma mark -

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self sizeScrollViewToFit];
}

- (void)setBloco:(PFObject *)bloco
{
    _bloco = bloco;
    _domainClass = ViewDomainClassBloco;
}

- (void)setParade:(PFObject *)parade
{
    _parade = parade;
    _domainClass = ViewDomainClassParade;
}

@end
