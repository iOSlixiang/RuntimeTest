//
//  main.m
//  runtimeTest
//
//  Created by 张理想 on 2022/4/14.
//

#import <Foundation/Foundation.h>

#import "ExampleList.h"
#import "LogAllClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ExampleList *example = [[ExampleList alloc]init];
        [example startMethod];
        
//        [LogAllClass startMethod];
    
    }
    return 0;
     
}
 
