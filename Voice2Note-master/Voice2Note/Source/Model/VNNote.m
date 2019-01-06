//
//  VNNote.m
//  Voice2Note
//
//  Created by liaojinxing on 14-6-11.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "VNNote.h"
#import "NoteManager.h"
#import "NSDate+JKExtension.h"

#define kNoteIDKey      @"NoteID"
#define kTitleKey       @"Title"
#define kContentKey     @"Content"
#define kCreatedDate    @"CreatedDate"
#define kUpdatedDate    @"UpdatedDate"
#define kLocation       @"Location"

@implementation VNNote

@synthesize noteID = _noteID;
@synthesize title = _title;
@synthesize content = _content;
@synthesize createdDate = _createdDate;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate
{
    self = [super init];
    if (self) {
        _noteID = [NSNumber numberWithDouble:[createdDate timeIntervalSince1970]].stringValue;
        _title = title;
        _content = content;
        _createdDate = [NSDate jk_stringWithDate:createdDate format:@"yy-MM-dd HH:mm:ss"];
        if (_title == nil || _title.length == 0) {
            _title = VNNOTE_DEFAULT_TITLE;
        }
        if (_content == nil || _content.length == 0) {
            _content = @"";
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_noteID forKey:kNoteIDKey];
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_content forKey:kContentKey];
    [encoder encodeObject:_createdDate forKey:kCreatedDate];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    NSString *content = [decoder decodeObjectForKey:kContentKey];
    NSString *createDate = [decoder decodeObjectForKey:kCreatedDate];
    NSString *updateDate = [decoder decodeObjectForKey:kUpdatedDate];
    return [self initWithTitle:title
                       content:content
                   createdDate:[NSDate jk_dateWithString:createDate format:@"yy-MM-dd HH:mm:ss"]
                    updateDate:[NSDate jk_dateWithString:updateDate format:@"yy-MM-dd HH:mm:ss"]];
}

- (BOOL)Persistence
{
    return [[NoteManager sharedManager] storeNote:self];
}

- (NSInteger)index
{
    if (!_index) {
        _index = (int)[[NSDate jk_dateWithString:self.createdDate format:@"yy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    }
    return _index;
}

@end

