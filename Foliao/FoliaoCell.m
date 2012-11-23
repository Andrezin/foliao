//
//  FolioCell.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/22/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "FoliaoCell.h"

@interface FoliaoCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@end


@implementation FoliaoCell

- (void)setFoliao:(PFObject *)foliao
{
    _foliao = foliao;
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", _foliao[@"firstName"], _foliao[@"lastName"]];
    
    [self.imageViewProfile setImageWithURL:[self foliaoImageURL] placeholderImage:[UIImage imageNamed:@"110x110.gif"]
      success:^(UIImage *image, BOOL cached) {
      
          self.imageViewProfile.layer.cornerRadius = 3.0;
          self.imageViewProfile.contentMode = UIViewContentModeScaleAspectFill;
          self.imageViewProfile.clipsToBounds = YES;
    } failure:^(NSError *error) { }];
}

- (NSURL *)foliaoImageURL
{
    if (!_foliao) return nil;
    
    NSString *pictureURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", _foliao[@"facebookId"]];
    return [NSURL URLWithString: pictureURL];
}

@end