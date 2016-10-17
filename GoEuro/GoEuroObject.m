//
//  GoEuroObject.m
//  GoEuro
//
//  Created by Oguz Birinci on 11/10/2016.
//  Copyright © 2016 Oguz Birinci. All rights reserved.
//

#import "GoEuroObject.h"

@implementation GoEuroObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self){
        self.Id = [dictionary objectForKey:@"Id"];
        self.logo = [[dictionary objectForKey:@"provider_logo"] stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
        self.price = [dictionary objectForKey:@"price_in_euros"];
        self.depTime = [dictionary objectForKey:@"departure_time"];
        self.arTime = [dictionary objectForKey:@"arrival_time"];
        self.numStop = [dictionary objectForKey:@"number_of_stops"];
    }
    return self;
}

@end
