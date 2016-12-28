//
//  RLog.m
//
//  Created by Георгий Малюков on 30.10.16.
//  Copyright © 2016 Georgiy Malyukov. All rights reserved.
//

#import "RLog.h"


@interface RLog () {
    
}

@property (strong, nonatomic) NSMutableArray<RLMessage *> *messages;

@end


@implementation RLog


#pragma mark - Root

+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray new];
        self.consoleDisplayMessages = YES;
        self.consoleLogLevel = RL_VERBOSE;
    }
    return self;
}


#pragma mark - Logging

- (void)log:(RLMessageLevel)level function:(NSString *)prettyFunction formatString:(NSString *)format, ... {
    // read format string
    va_list args;
    va_start(args, format);
    NSString *text = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    // store message
    RLMessage *msg = [[RLMessage alloc] initWithLevel:level message:text prettyFunction:prettyFunction];
    [self.messages addObject:msg];
    // display if necessary
    if (self.consoleDisplayMessages && (msg.level >= self.consoleLogLevel)) {
        NSLog(@"%@", msg.debugDescription); // use debug description to hide data from the message
    }
}

- (NSArray<RLMessage *> *)filterWithBlock:(RLFilterBlock)block {
    NSMutableArray *list = nil;
    
    if (block) {
        list = [NSMutableArray new];
        
        for (RLMessage *msg in self.messages) {
            if (block(msg) && msg) {
                [list addObject:msg];
            }
        }
    }
    else {
        list = self.messages;
    }
    [list sortUsingComparator:^NSComparisonResult(RLMessage *obj1, RLMessage *obj2) {
        return [obj1.date compare:obj2.date];
    }];
    return list;
}

- (void)flushToFileAtPath:(NSString *)path usingFilter:(RLFilterBlock _Nullable)block {
    RLENTRY;
    NSFileManager *fm = [NSFileManager defaultManager];
    // check whether file is NOT a directory
    BOOL isDir;
    if ([fm fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        RLFATAL(@"unable to flush log. Reason: File is expected but directory was found. Path: %@", path);
        return;
    }
    if (![fm isWritableFileAtPath:path]) {
        RLFATAL(@"unable to flush log. Reason: Specified file path has no \"write\" access. Path: %@", path);
        return;
    }
    // write messages
    NSFileHandle *f = [NSFileHandle fileHandleForWritingAtPath:path];
    
    if (!f) {
        RLFATAL(@"unable to flush log. Reason: Unable to open writing file handle. Path: %@", path);
        return;
    }
    // use filter
    NSArray *messages = [self filterWithBlock:block];
    // flush all to file
    for (RLMessage *msg in messages) {
        // use "description" to get fully-formatted message
        NSString *text = msg.description;
        // check newline character
        if (![text hasSuffix:@"\n"]) {
            text = [text stringByAppendingString:@"\n"];
        }
        [f writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [f closeFile];
    // then clear manually to prevent warning message
    [self.messages removeAllObjects];
    RLINFO(@"log successfully flushed to file. Memory was cleaned up. File path: %@", path);
}

- (void)clear {
    [self.messages removeAllObjects];
    RLWARN(@"all messages were removed"); // log this action
}

@end
