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

-(instancetype)initWithId:(int)Id logo:(NSString *)provider_logo price:(double)price_in_euros depTime:(NSString *)departure_time arTime:(NSString *)arrival_time numStop:(int)number_of_stops;

@property (nonatomic) int Id;
@property (nonatomic,strong) NSString *logo;
@property (nonatomic) double price;
@property (nonatomic,strong) NSString *depTime;
@property (nonatomic,strong) NSString *arTime;
@property (nonatomic) int numStop;

@end
