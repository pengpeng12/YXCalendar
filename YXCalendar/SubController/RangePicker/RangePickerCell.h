//
//  RangePickerCell.h
//  YXCalendar
//
//  Created by 易信 on 2018/4/11.
//  Copyright © 2018年 易信. All rights reserved.
//

#import "FSCalendar.h"

@interface RangePickerCell : FSCalendarCell

// The start/end of the range
@property (weak, nonatomic) CALayer *selectionLayer;

// The middle of the range
@property (weak, nonatomic) CALayer *middleLayer;

@end
