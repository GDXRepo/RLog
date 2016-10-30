//
//  RLog.h
//
//  Created by Георгий Малюков on 30.10.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMessage.h"

NS_ASSUME_NONNULL_BEGIN

#define STRING_PRETTY_FUNCTION [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]
#define RLENTRY RLINFO(@"")
#define RLINFO(format, ...) [[RLog instance] log:RL_INFO function:STRING_PRETTY_FUNCTION formatString:format, ##__VA_ARGS__]
#define RLWARN(format, ...) [[RLog instance] log:RL_WARN function:STRING_PRETTY_FUNCTION formatString:format, ##__VA_ARGS__]
#define RLERROR(format, ...) [[RLog instance] log:RL_ERROR function:STRING_PRETTY_FUNCTION formatString:format, ##__VA_ARGS__]
#define RLFATAL(format, ...) [[RLog instance] log:RL_FATAL function:STRING_PRETTY_FUNCTION formatString:format, ##__VA_ARGS__]

/**
 Messages filtering block
 @param message Message to filter.
 @return Should return <tt>YES</tt> if specified message satisfies the filter's requirements, otherwise <tt>NO</tt>.
 */
typedef BOOL (^RLFilterBlock)(RLMessage *message);

/// Represents logging subsystem.
@interface RLog : NSObject {
    
}
/// Indicates whether all incoming messages should immediately be printed in a system console. <tt>YES</tt> by default.
@property (assign, nonatomic) BOOL consoleDisplayMessages;

/// Minimum message log level to display in a system console. <tt>RL_ALL</tt> by default.
@property (assign, nonatomic) RLMessageLevel consoleLogLevel;


#pragma mark - Root

/**
 Returns shared <tt>RLog</tt> class instance.
 @return Shared <tt>RLog</tt> class instance.
 */
+ (instancetype)instance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


#pragma mark - Logging

/**
 Logs the specified message for a concrete function with specific message level. It may be more convenient to use special macroses instead.
 @param level Message log level.
 @param prettyFunction Formatted <tt>__PRETTY_FUNCTION__</tt> value.
 @param format Message format string with variadic arguments.
 */
- (void)log:(RLMessageLevel)level function:(NSString *)prettyFunction formatString:(NSString *)format, ...;

/**
 Returns list of messages with specified optional filter.
 @param block Optional messages filter.
 @return List of filtered logged messages.
 */
- (NSArray<RLMessage *> *)filterWithBlock:(_Nullable RLFilterBlock)block;

/**
 Flushes all logged messages to specified file. If succeed, all messages will be removed from memory.
 @param path Path to target file. If file is already exists it will be overwritten.
 @param block Optional messages filter.
 */
- (void)flushToFileAtPath:(NSString *)path usingFilter:(_Nullable RLFilterBlock)block;

/// Completely removes all logged messages. Be careful, this operation can't be undone.
- (void)clear;

@end

NS_ASSUME_NONNULL_END
