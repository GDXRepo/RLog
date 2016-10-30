//
//  RLMessage.h
//
//  Created by Георгий Малюков on 30.10.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RLMessageLevel) {
    RL_INFO,
    RL_WARN,
    RL_ERROR,
    RL_FATAL
};
// convenient aliases
#define RL_ALL RL_INFO
#define RL_VERBOSE RL_ALL

/// Represents a single log message.
@interface RLMessage : NSObject {
    
}
/// Message instantiation date.
@property (readonly, nonatomic) NSDate *date;

/// Message log level.
@property (readonly, nonatomic) RLMessageLevel level;

/// Message text (format string with injected variadic arguments).
@property (readonly, nonatomic) NSString *message;


#pragma mark - Root

/**
 Instantiates new <tt>RLMessage</tt> class instance.
 @param level Message log level.
 @param message Message formatted text.
 @param function Formatted <tt>__PRETTY_FUNCTION__</tt> value.
 @return <tt>RLMessage</tt> class instance.
 */
- (instancetype)initWithLevel:(RLMessageLevel)level
                      message:(NSString *)message
               prettyFunction:(NSString *)function;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
