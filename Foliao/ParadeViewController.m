//
//  BlocoViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "ParadeViewController.h"
#import "ParadeAnnotation.h"
#import "WhoIsGoingViewController.h"
#import "DateUtil.h"
#import "ThemeManager.h"


@interface ParadeViewController () {
    BOOL _mapIsOpen;
    NSMutableArray *friendIds;
}

@property (strong, nonatomic) NSMutableArray *folioes;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewParadeInfo;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *buttonExpandMap;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelInfo;
@property (strong, nonatomic) IBOutlet UIButton *buttonCheckIn;

@property (strong, nonatomic) IBOutlet UIButton *buttonWhoIsGoing;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao0;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao1;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao2;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao3;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPictureFoliao4;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAccessoryWhoIsGoing;
@property (strong, nonatomic) IBOutlet UILabel *labelEmptyParade;

- (void)sizeScrollViewToFit;
- (void)fillParadeInfo;
- (void)customizeUI;
- (BOOL)foliaoIsAlreadyGoing:(PFUser *)foliao;
- (void)showWhoIsGoing;
- (void)showFolioesPictures;
- (void)confirmPresenceInParade:(PFObject *)parade;
- (void)addFoliaoToPresencesBox;

- (IBAction)checkInButtonTapped:(UIButton *)sender;
- (IBAction)whoIsGoingButtonTapped:(UIButton *)sender;
- (IBAction)expandMap:(UIButton *)sender;

@end


@implementation ParadeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sizeScrollViewToFit];
    [self fillParadeInfo];
    [self customizeUI];
    
    self.mapView.accessibilityLabel = @"Mapa do bloco";
    self.labelName.accessibilityLabel = @"Nome do bloco";
    self.labelInfo.accessibilityLabel = @"Informações do bloco";
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

- (void)fillParadeInfo
{
    ParadeAnnotation *annotation = [[ParadeAnnotation alloc] initWithParade:self.parade];
    [self.mapView addAnnotation:annotation];
    
    self.buttonCheckIn.enabled = YES;
    self.labelName.text = self.parade[@"bloco"][@"name"];
    
    self.labelInfo.text = [NSString stringWithFormat:@"Começa às %@ %@",
                           [DateUtil shortTimeFromDate:self.parade[@"date"]],
                           [self formattedParadeAddress]];
    
    [self showWhoIsGoing];
}

- (NSString *)formattedParadeAddress
{
    NSArray *componentsNo = [NSArray arrayWithObject:@"Largo"];
    NSArray *componentsNos = [NSArray arrayWithObject:@"Arcos"];
    // maybe a "nas" option too
    
    for (NSString *addressType in componentsNo)
        if ([self.parade[@"address"] hasPrefix:addressType])
            return [NSString stringWithFormat:@"no %@", self.parade[@"address"]];
    
    for (NSString *addressType in componentsNos)
        if ([self.parade[@"address"] hasPrefix:addressType])
            return [NSString stringWithFormat:@"nos %@", self.parade[@"address"]];
    
    // default and the default option
    return [NSString stringWithFormat:@"na %@", self.parade[@"address"]];
}

- (void)customizeUI
{
    self.viewParadeInfo.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewParadeInfo.layer.shadowOpacity = 0.2;
    self.viewParadeInfo.layer.shadowRadius = 3;
    self.viewParadeInfo.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    
    self.buttonExpandMap.imageView.contentMode = UIViewContentModeCenter;
    self.buttonExpandMap.imageView.transform = CGAffineTransformRotate(self.buttonExpandMap.imageView.transform, M_PI_2);
}

- (void)showWhoIsGoing
{
    PFQuery *query = [PFQuery queryWithClassName:@"Presence"];
    [query whereKey:@"parade" equalTo:self.parade];

    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 0.5 * 60 * 60; // half hour
    
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *presences, NSError *error) {
        if (!error) {
            if (presences.count == 0) {
                self.labelEmptyParade.hidden = NO;
                self.buttonWhoIsGoing.enabled = NO;
                return;
            }
            
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
        
        int upTo = self.folioes.count;
        if (upTo > 5)
            upTo = 5;
        
        for (int i=0; i < upTo; i++) {
            NSString *picURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", self.folioes[i][@"facebookId"]];
            UIImageView *profileImageView = (UIImageView *)pictureTemplates[i];
            
            [profileImageView setImageWithURL:[NSURL URLWithString:picURL]
                             placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"avatar-%@", self.folioes[i][@"genre"]]]];
            profileImageView.layer.cornerRadius = 3.0;
            profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            profileImageView.clipsToBounds = YES;
        }
        
        self.imageViewAccessoryWhoIsGoing.hidden = NO;
        self.imageViewAccessoryWhoIsGoing.image = [[ThemeManager currentTheme] accessoryViewImage];
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
    [self confirmPresenceInParade:self.parade];
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
    [self.folioes insertObject:[PFUser currentUser] atIndex:0];
    self.labelEmptyParade.hidden = YES;
    
    __block CGRect firstImageFrame = self.imageViewPictureFoliao0.frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageViewPictureFoliao0.frame = self.imageViewPictureFoliao1.frame;
        self.imageViewPictureFoliao1.frame = self.imageViewPictureFoliao2.frame;
        self.imageViewPictureFoliao2.frame = self.imageViewPictureFoliao3.frame;
        self.imageViewPictureFoliao3.frame = self.imageViewPictureFoliao4.frame;
        self.imageViewPictureFoliao4.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.imageViewPictureFoliao4.hidden = YES;
        __block UIImageView *imageViewNewPresence = [[UIImageView alloc] initWithFrame:firstImageFrame];
        imageViewNewPresence.layer.cornerRadius = 3.0;
        imageViewNewPresence.contentMode = UIViewContentModeScaleAspectFill;
        imageViewNewPresence.clipsToBounds = YES;
        imageViewNewPresence.alpha = 0;
        [self.imageViewPictureFoliao1.superview addSubview:imageViewNewPresence];
        
        NSString *picURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [PFUser currentUser][@"facebookId"]];
        
        [imageViewNewPresence setImageWithURL:[NSURL URLWithString:picURL]
                             placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"avatar-%@", [PFUser currentUser][@"genre"]]]
                                      success:^(UIImage *image, BOOL cached) {
                                          
          [UIView animateWithDuration:0.5 animations:^{
              imageViewNewPresence.alpha = 1;
          }];
            
        } failure:^(NSError *error) {}];
    }];
}

- (IBAction)expandMap:(UIButton *)sender
{
    if (_mapIsOpen) {
        // closing ...
        [UIView animateWithDuration:0.2 animations:^{
            self.mapView.frame = CGRectMake(0, 0, 320, 160);
            self.buttonExpandMap.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.buttonExpandMap.frame = CGRectMake(self.buttonExpandMap.frame.origin.x,
                                                    self.mapView.frame.size.height - self.buttonExpandMap.frame.size.height - 5,
                                                    self.buttonExpandMap.frame.size.height,
                                                    self.buttonExpandMap.frame.size.width);
        } completion:^(BOOL finished) {
            _mapIsOpen = !_mapIsOpen;
        }];
    } else {
        // opening ...
        [UIView animateWithDuration:0.2 animations:^{
            self.mapView.frame = self.view.frame;
            self.buttonExpandMap.imageView.transform = CGAffineTransformMakeRotation(3*M_PI_2);
            self.buttonExpandMap.frame = CGRectMake(self.buttonExpandMap.frame.origin.x,
                                                    self.mapView.frame.size.height - self.buttonExpandMap.frame.size.height - 5,
                                                    self.buttonExpandMap.frame.size.height,
                                                    self.buttonExpandMap.frame.size.width);
        } completion:^(BOOL finished) {
            _mapIsOpen = !_mapIsOpen;
        }];
    }
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

@end
