//
//  VideoChatSingleVC.h
//  Runner
//
//  Created by mac on 2022/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoChatSingleVC : UIViewController
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *publishStreamID;
@end

NS_ASSUME_NONNULL_END
