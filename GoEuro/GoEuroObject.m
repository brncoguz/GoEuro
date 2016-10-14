//
//  GoEuroObject.m
//  GoEuro
//
//  Created by Oguz Birinci on 11/10/2016.
//  Copyright © 2016 Oguz Birinci. All rights reserved.
//

#import "GoEuroObject.h"

@implementation GoEuroObject

-(instancetype)initWithId:(int)Id logo:(NSString *)provider_logo price:(double)price_in_euros depTime:(NSString *)departure_time arTime:(NSString *)arrival_time numStop:(int)number_of_stops;{
    self = [super init];
    if(self){
        self.Id = Id;
        self.logo = provider_logo;
        self.price = price_in_euros;
        self.depTime = departure_time;
        self.arTime = arrival_time;
        self.numStop = number_of_stops;
    }
    return self;
}



@end
