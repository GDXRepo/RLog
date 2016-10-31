# RLog
Simple & efficient logging library in Objective-C.

## Adding RLog to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add RLog to your project.

1. Add a pod entry for RLog to your Podfile `pod 'RLog'`
2. Install the pod(s) by running `pod install`.
3. Include RLog library wherever you need it with `#import "RLog.h"`.

### Source files

Alternatively you can directly add all library's source files to your project.

1. Download the [latest code version](https://github.com/GDXRepo/RLog/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop all source files onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include RLog library wherever you need it with `#import "RLog.h"`.

## Usage

At first, configure logging class (you can change this configuration at any time in your application):

```objective-c
// indicates whether logged messages should be displayed in a system console
[RLog instance].consoleDisplayMessages = NO; // YES by default
// contains minimal message log level for displaying in a system console
[RLog instance].consoleLogLevel = RL_WARN; // RL_VERBOSE by default
```
If displaying enabled then all messages which satisfy minimum log level requirement will be displayed in a system Xcode console with standard `NSLog()` function in current thread.

Available log levels (sorted ascending by importance):

* `RL_INFO` (equals to `RL_VERBOSE` and `RL_ALL`). Displays all messages. Aliases made just for convenience.
* `RL_WARN` - warnings and higher levels.
* `RL_ERROR` - errors and higher levels.
* `RL_FATAL` - only critical errors. 

Please note that these levels affects only displaying in a system console. For other purposes you should use filtering (described below).

Next, there are a couple of useful macroses which will help you to log your events:

```objective-c
RLENTRY; // logs empty message, useful for logging methods' entry points
RLINFO(format, ...); // logs info message
RLWARN(format, ...); // logs warning message
RLERROR(format, ...); // logs error message
RLFATAL(format, ...); // logs critical error message
```
`RLog` stores all messages including their creation date (UTC), message, calling method and log level. Later you can use this data for filtering your messages.

### Filtering

All logs you are saving will be stored in memory. Sometimes you may need to extract stored messages for a further purposes.

The first method declared as:

```objective-c
- (NSArray<RLMessage *> *)filterWithBlock:(_Nullable RLFilterBlock)block;
```
It takes an optional filtering block which helps you to filter stored messages. This block has only one input parameter of type `RLMessage` and should return `YES`, if message meets your filtering requirements, otherwise `NO`. This block is optional so you can pass it with `nil` to get all stored messages.

### Saving

Of course you may want to save your log in a physical file. You can do that by calling this method:

```objective-c
- (void)flushToFileAtPath:(NSString *)path usingFilter:(_Nullable RLFilterBlock)block;
```
Optional filter block does the same thing as explained above. If flushing to file will succeed then all in-memory stored messages will be cleaned up automatically.

### Cleaning Up

Sometimes you may need to clear log without flushing it to file. You can do this with method

```objective-c
- (void)clear;
```
This is the destructive operation and it can't be undone, be careful while using it.

## License

MIT
