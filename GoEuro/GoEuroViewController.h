//
//  GoEuroViewController.h
//  GoEuro
//
//  Created by Oguz Birinci on 11/10/2016.
//  Copyright © 2016 Oguz Birinci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoEuroViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
- (void)loadTheData;
- (BOOL)connected;

@end
