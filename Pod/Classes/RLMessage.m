//
//  RLMessage.m
//
//  Created by Георгий Малюков on 30.10.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "RLMessage.h"


@interface RLMessage () {
    
}

@property (copy, nonatomic) NSString *prettyFunction;


#pragma mark - Private

- (NSString *)stringFromLevel:(RLMessageLevel)level;

@end


@implementation RLMessage

static NSDateFormatter *dfPretty = nil;


#pragma mark - Root

+ (void)initialize {
    dfPretty = [NSDateFormatter new];
    [dfPretty setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dfPretty setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS Z"];
}

- (instancetype)initWithLevel:(RLMessageLevel)level message:(NSString *)message prettyFunction:(NSString *)function {
    self = [super init];
    if (self) {
        _date = [NSDate date];
        _level = level;
        _message = [message copy];
        // save function
        self.prettyFunction = function;
    }
    return self;
}


#pragma mark - NSObject

- (NSString *)description {
    if (self.message.length > 0) {
        return [NSString stringWithFormat:@"%@ %@ [%@] %@",
                [dfPretty stringFromDate:self.date],
                self.prettyFunction,
                [self stringFromLevel:self.level],
                self.message];
    }
    return [NSString stringWithFormat:@"%@ %@ [%@]",
            [dfPretty stringFromDate:self.date],
            self.prettyFunction,
            [self stringFromLevel:self.level]];
}

- (NSString *)debugDescription {
    if (self.message.length > 0) {
        return [NSString stringWithFormat:@"%@ [%@] %@",
                self.prettyFunction,
                [self stringFromLevel:self.level],
                self.message];
    }
    return self.prettyFunction;
}


#pragma mark - Private

- (NSString *)stringFromLevel:(RLMessageLevel)level {
    switch (level) {
        case RL_INFO: {
            return @"INFO";
        }
        case RL_WARN: {
            return @"WARN";
        }
        case RL_ERROR: {
            return @"ERROR";
        }
        case RL_FATAL: {
            return @"FATAL";
        }
    }
}

@end
