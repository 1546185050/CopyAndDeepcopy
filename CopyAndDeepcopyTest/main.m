//
//  main.m
//  CopyAndDeepcopyTest
//
//  Created by dhp on 09/12/16.
//  Copyright © 2016年 dhp. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //浅复制(shallow copy)：在浅复制操作时，对于被复制对象的每一层都是指针复制。
        //深复制(one-level-deep copy)：在深复制操作时，对于被复制对象，至少有一层是深复制。
        //完全复制(real-deep copy)：在完全复制操作时，对于被复制对象的每一层都是对象复制。

        /**
         *  NSString深浅拷贝
         */
        NSString *string = @"origion";
        NSString *stringCopy = [string copy];
        NSMutableString *stringMCopy = [string mutableCopy];
        [stringMCopy appendString:@"!!"];
        NSLog(@"%p:%@;\n%p:%@;\n%p:%@;",string,string,stringCopy,stringCopy,stringMCopy,stringMCopy);
        //对于系统的非容器类对象，我们可以认为，如果对一不可变对象复制，copy是指针复制（浅拷贝）和mutableCopy就是对象复制（深拷贝）。

        /**
         *  NSMutableString深浅拷贝
         */
        NSMutableString *string_1 = [NSMutableString stringWithString: @"origion_1"];
        NSString *stringCopy_1 = [string_1 copy];
        NSMutableString *mStringCopy_1 = [string_1 copy];//实际上是NSString，不可变的
        NSMutableString *stringMCopy_1 = [string_1 mutableCopy];
        NSLog(@"%p:%@;\n%p:%@;\n%p:%@;\n%p:%@;",string_1,string_1,stringCopy_1,stringCopy_1,mStringCopy_1,mStringCopy_1,stringMCopy_1,stringMCopy_1);
        //对于系统的非容器类对象,如果是对可变对象复制，都是深拷贝，但是copy返回的对象是不可变的

        /**
         *  NSArray深浅拷贝
         */
        NSArray *mArray1 = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        NSArray *mArrayCopy2 = [mArray1 copy];
        NSMutableArray *mArrayMCopy1 = [mArray1 mutableCopy];//[NSMutableArray arrayWithArray:mArray1];
        //mArrayCopy2,mArrayMCopy1和mArray1指向的都是不一样的对象，但是其中的元素都是一样的对象——同一个指针
        //一下做测试
        NSMutableString *testString = [mArray1 objectAtIndex:0];
        //testString = @"1a1";//这样会改变testString的指针，其实是将@“1a1”临时对象赋给了testString
        [testString appendString:@" tail"];//这样以上三个数组的首元素都被改变了
        NSLog(@"%p:%@;\n%p:%@;\n%p:%@;",mArray1,mArray1,mArrayCopy2,mArrayCopy2,mArrayMCopy1,mArrayMCopy1);
        //对于容器而言，其元素对象始终是指针复制。如果需要元素对象也是对象复制，就需要实现深拷贝

        /**
         *  完全复制
         */
        NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"first"],[NSMutableString stringWithString:@"b"],@"c",nil];
        NSArray *deepCopyArray=[[NSArray alloc] initWithArray: array copyItems: YES];
        NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                      [NSKeyedArchiver archivedDataWithRootObject: array]];
        NSMutableString *testStr = [array objectAtIndex:0];
        [testStr appendString:@" tail"];
        NSLog(@"%p:%@;\n%p:%@;\n%p:%@",array,array,deepCopyArray,deepCopyArray,trueDeepCopyArray,trueDeepCopyArray);
        //trueDeepCopyArray是完全意义上的深拷贝，而deepCopyArray则不是，对于deepCopyArray内的不可变元素其还是指针复制。或者我们自己实现深拷贝的方法。因为如果容器的某一元素是不可变的，那你复制完后该对象仍旧是不能改变的，因此只需要指针复制即可。除非你对容器内的元素重新赋值，否则指针复制即已足够。


        /**
         *  深拷贝与完全拷贝
         */
        NSMutableArray * dataArray1=[NSMutableArray arrayWithObjects:
                                     [NSMutableString stringWithString:@"1"],
                                     [NSMutableString stringWithString:@"2"],
                                     nil];
        NSMutableArray * dataArray2=[NSMutableArray arrayWithObjects:
                                     [NSMutableString stringWithString:@"one"],
                                     [NSMutableString stringWithString:@"two"],
                                     dataArray1,
                                     nil];

        NSMutableArray * dataArray3;
        NSMutableString * mStr;
        dataArray3=[dataArray2 mutableCopy];

        mStr = dataArray2[0];
        [mStr appendString:@"--ONE"];
        mStr = dataArray1[0];
        [mStr appendString:@"--1"];

        NSLog(@"dataArray3：%@",dataArray3);
        NSLog(@"dataArray2：%@",dataArray2);
        //只会复制一层对象，而不会复制第二层甚至更深层次的对象
        //代码dataArray3=[dataArray2 mutableCopy];只是对数组dataArray2本身进行了内容拷贝，但是里面的字符串对象却没有进行内容拷贝，而是进行的浅复制，那么dataArray2和dataArray3里面的对象是共享同一份的


        NSMutableArray * dataArray1_1=[NSMutableArray arrayWithObjects:
                                     [NSMutableString stringWithString:@"1"],
                                     [NSMutableString stringWithString:@"2"],
                                     nil];
        NSMutableArray * dataArray2_1=[NSMutableArray arrayWithObjects:
                                     [NSMutableString stringWithString:@"one"],
                                     [NSMutableString stringWithString:@"two"],
                                     dataArray1_1,
                                     nil];
        NSMutableArray * dataArray3_1;
        NSMutableString * mStr_1;
        dataArray3_1=[[NSMutableArray alloc]initWithArray:dataArray2_1 copyItems:YES];
        NSMutableArray *mArr_1 = (NSMutableArray *)dataArray2_1[2];
        mStr_1 = mArr_1[0];
        [mStr_1 appendString:@"--ONE"];
        NSLog(@"dataArray3_1：%@",dataArray3_1);
        NSLog(@"dataArray2_1：%@",dataArray2_1);
        //可以看到深复制又失效了，这是因为dataArray3=[[NSMutableArray alloc]initWithArray:dataArray2 copyItems:YES];仅仅能进行一层深复制，对于第二层或者更多层的就无效了
    }
    return 0;
}
