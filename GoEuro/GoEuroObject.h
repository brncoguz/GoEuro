//
//  GoEuroObject.h
//  GoEuro
//
//  Created by Oguz Birinci on 11/10/2016.
//  Copyright © 2016 Oguz Birinci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GoEuroObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) NSNumber *Id;
@property (nonatomic) NSString *logo;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString *depTime;
@property (nonatomic) NSString *arTime;
@property (nonatomic) NSNumber *numStop;

@end
