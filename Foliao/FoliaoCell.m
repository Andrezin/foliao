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
#import "ThemeManager.h"

@interface FoliaoCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@end


@implementation FoliaoCell

- (void)setFoliao:(PFObject *)foliao
{
    _foliao = foliao;
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", _foliao[@"firstName"], _foliao[@"lastName"]];
    self.labelName.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    self.accessoryView = [[UIImageView alloc] initWithImage:[[ThemeManager currentTheme] accessoryViewImage]];
    
    [self.imageViewProfile setImageWithURL:[self foliaoImageURL] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"avatar-%@", _foliao[@"gender"]]]
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
