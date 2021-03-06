#import <Foundation/Foundation.h>

#import "JXTrie.h"

#define DICTIONARY	@"/usr/share/dict/words"
#define TARGET	@"goober"
#define MAX_COST	1

// Apparently, recreating the trie from the raw word list is faster than archiving/unarchiving using NSKeyedArchiver. 

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *target;
	NSUInteger maxCost;
	NSString *dictionary;
	
	NSTimeInterval start;
	NSTimeInterval duration;
	
	if ([[[NSProcessInfo processInfo] arguments] count] < 3) {
		fprintf(stderr, "usage: %s [<search string> <maximum distance>] [<dictionary path>]\n",
				[[[NSProcessInfo processInfo] processName] UTF8String]);
		target = TARGET;
		maxCost = MAX_COST;
	}
	else {
		target = [[[NSProcessInfo processInfo] arguments] objectAtIndex:1];
		maxCost = [[[[NSProcessInfo processInfo] arguments] objectAtIndex:2] integerValue];
	}

	if ([[[NSProcessInfo processInfo] arguments] count] > 3) {
		dictionary = [[[NSProcessInfo processInfo] arguments] objectAtIndex:3];
	}
	else {
		dictionary = DICTIONARY;
	}
	
	// Read dictionary file into a trie
	JXTrie *trie;
	NSArray *wordList;
	
	start = [NSDate timeIntervalSinceReferenceDate];

	NSString *wordListText = [NSString stringWithContentsOfFile:dictionary encoding:NSUTF8StringEncoding error:NULL];
	wordList = [wordListText componentsSeparatedByString:@"\n"];
		
	trie = [JXTrie trieWithStrings:wordList];
	
	duration = [NSDate timeIntervalSinceReferenceDate] - start;
	
	NSLog(@"Read %lu words into %lu nodes. ", (unsigned long)[trie count], (unsigned long)[trie nodeCount]);
	NSLog(@"Creating the trie for \"%@\" took %.4lf s. ", dictionary, (double)duration);
		
	
	NSArray *results = nil;
	
	start = [NSDate timeIntervalSinceReferenceDate];
	results = [trie search:target maximumDistance:maxCost];
    duration = [NSDate timeIntervalSinceReferenceDate] - start;
	
	NSLog(@"\n%@", results);
	
	NSLog(@"Search for \"%@\" took %.4lf s. ", target, (double)duration);
	
	[pool drain];
	return 0;
}
