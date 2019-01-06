//
//  NoteTableViewCell.h
//  Voice2Note
//
//  Created by 关云秀 on 2018/12/23.
//  Copyright © 2018 jinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VNNote;
NS_ASSUME_NONNULL_BEGIN

@interface NoteTableViewCell : UITableViewCell

- (void)updateWithNote:(VNNote *)note;
@end

NS_ASSUME_NONNULL_END
