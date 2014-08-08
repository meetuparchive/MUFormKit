//
//  MUFormCCNumberCell.m
//  MeetupApp
//
//  Created by Alistair on 10/2/13.
//  Copyright (c) 2013 Meetup, Inc. All rights reserved.
//


#import "MUFormCCNumberCell.h"

@implementation MUFormCCNumberCell

#pragma mark - MUFormNumberFieldCell overrides

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.placeholder = @"0000 0000 0000 0000";
}

-(NSString*) textFieldText
{
    NSCharacterSet *charactersToRemove = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *textNumbersOnly = [[self.textField.text componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    return textNumbersOnly;
}

- (void)configureWithValue:(id)value info:(NSDictionary *)info
{
    [super configureWithValue:value info:info];
    self.textField.text = [self stringbyCreditCardFormattingWithString:self.textField.text];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - Text Field Delegate -

- (void)textFieldEditingChanged:(UITextField *)textField
{
    textField.text = [self stringbyCreditCardFormattingWithString:textField.text];
    [super textFieldEditingChanged:textField];
}

#pragma mark - Private

/**
Returns a string that is formatted for credit card number entry
 */
-(NSString*) stringbyCreditCardFormattingWithString:(NSString*)string
{
   //Remove anything thats not a number
    NSCharacterSet *charactersToRemove = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *proposedTextNumbersOnly = [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];

    //Partition
    NSString *newStringWithSpaces = [self stringByPartitioningWithString:proposedTextNumbersOnly joinedBy:@" " stride:4];
    return newStringWithSpaces;
}

/**
Returns a string that is partitioned by the joinedBy every stride variabled
 
 @param partitionString The string to partition
 @param joinString The string to insert in each partition
 @param stride the character frequency of each partition
 */
-(NSString*) stringByPartitioningWithString:(NSString*)partitionString joinedBy:(NSString*)joinString stride:(NSUInteger)stride
{
    NSMutableArray *partitionedStringArray = [NSMutableArray array];
    NSUInteger partitions = floorf((CGFloat)partitionString.length / (CGFloat)stride);
    //Add partitions divisble by stride
    for (NSUInteger i=0; i<partitions; i++) {
        NSUInteger start = i*stride;
        NSString *substring = [partitionString substringWithRange:(NSRange){start,stride}];
        [partitionedStringArray addObject:substring];
    }

    //Add remaining partition
    NSUInteger tailPartitionIndex = partitions*stride;
    if (tailPartitionIndex<partitionString.length) {
        NSUInteger length = partitionString.length-tailPartitionIndex;
        MUAssert(length<stride, @"");
        NSString *substring = [partitionString substringWithRange:(NSRange){tailPartitionIndex,length}];
        [partitionedStringArray addObject:substring];
    }
    
    return [partitionedStringArray componentsJoinedByString:joinString];
}

@end
