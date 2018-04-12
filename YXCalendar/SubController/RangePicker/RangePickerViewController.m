//
//  RangePickerViewController.m
//  YXCalendar
//
//  Created by 易信 on 2018/4/11.
//  Copyright © 2018年 易信. All rights reserved.
//

#import "RangePickerViewController.h"
#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"

@interface RangePickerViewController ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>
{
    BOOL _isOpen;
}
@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic, weak) UILabel *eventLabel;
@property (nonatomic, weak) UIButton *todayButton;

@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSDate *dateEnd;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation RangePickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"日程";
    }
    return self;
}

- (void)loadView
{
    UIView *caView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    caView.backgroundColor = [UIColor whiteColor];
    self.view = caView;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, caView.width, 371)];
    calendar.dataSource = self;
    calendar.delegate = self;
//    calendar.pagingEnabled = NO;
    calendar.allowsMultipleSelection = YES;
    calendar.swipeToChooseGesture.enabled = YES;
    //
    calendar.backgroundColor = [UIColor whiteColor];
//    calendar.appearance.headerMinimumDissolvedAlpha = 0;
//    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    //
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [caView addSubview:calendar];
    self.calendar = calendar;
    
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = [UIColor blackColor];
    calendar.calendarHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    calendar.calendarWeekdayView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
//    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
//    calendar.weekdayHeight = 0;
    calendar.today = nil;
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    
    calendar.swipeToChooseGesture.enabled = YES;
    
    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:calendar action:@selector(handleScopeGesture:)];
    [calendar addGestureRecognizer:scopeGesture];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.view addSubview:label];
    self.eventLabel = label;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:@"compose_camerabutton_background_highlighted"];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"  设定日期  "]];
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    self.eventLabel.attributedText = attributedText.copy;
    
    //回今天
    UIButton *todayButton = [[UIButton alloc]initWithFrame:CGRectMake(65, 15, 30, 20)];
    todayButton.backgroundColor = [UIColor orangeColor];
    [todayButton setTitle:@"今" forState:UIControlStateNormal];
    [todayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:todayButton];
    self.todayButton = todayButton;
    [self.todayButton addTarget:self action:@selector(todayItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.todayButton.hidden = YES;
    
    _isOpen = YES;
//    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"今" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
//    self.navigationItem.rightBarButtonItem = todayItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.calendar.accessibilityIdentifier = @"calendar";
    
}
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - FSCalendarDataSource
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2018-01-01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:21 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDate *date =[NSDate date];
//    NSDate *date =[self.dateFormatter dateFromString:@"2018-05-06"];
    NSDate *firstDate = calendar.currentPage;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    NSInteger firstYear=[[formatter stringFromDate:firstDate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    NSInteger firstMonth=[[formatter stringFromDate:firstDate]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    NSInteger firstDay=[[formatter stringFromDate:firstDate] integerValue];
    
    if (currentYear == firstYear && currentMonth == firstMonth) {
        if (_isOpen == YES) {
            self.todayButton.hidden = YES;
        }else{
            if (firstDay>currentDay ||currentDay-firstDay > 6 ) {
                self.todayButton.hidden = NO;
            }else{
                self.todayButton.hidden = YES;
            }
        }
        
    }else if (currentMonth != firstMonth){
        NSLog(@"firstMonth:%ld ---currentMonth:%ld", firstMonth, currentMonth);
        NSLog(@"firstday:%ld ---currentDay:%ld", firstDay, currentDay);
        if (_isOpen == YES) {
            self.todayButton.hidden = NO;
        }else{
            NSInteger monthEndDayCount = [self MonthEndDayCountYear:firstYear month:firstMonth day:firstDay];
            NSLog(@"--%ld", monthEndDayCount);
            if ( 6 - monthEndDayCount >= currentDay && currentYear == firstYear && labs(currentMonth-firstMonth)==1){
                self.todayButton.hidden = YES;
            }else{
               self.todayButton.hidden = NO;
            }
            
        }
        
    }
    NSLog(@"---%@---", calendar.currentPage);
}
- (NSInteger)MonthEndDayCountYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSInteger monthDayCount = [CommonMethod monthDayCount:month andYear:year];
    return monthDayCount - day;
}
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    
    self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50);
    if (calendar.height >= 300) {
        _isOpen = YES;
        [self todayButtonStatus:calendar isOpen:YES];
    }else{
        _isOpen = NO;
        [self todayButtonStatus:calendar isOpen:NO];
    }
    
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}
//取消选中
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        if (!self.dateStart) {
            self.dateStart = date;
        }else{
            if (self.dateEnd) {
                [calendar deselectDate:self.dateEnd];
            }
            self.dateEnd = date;
        }
    }else{
        if (self.dateEnd) {
            [calendar deselectDate:self.dateStart];
            [calendar deselectDate:self.dateEnd];
            self.dateStart = date;
            self.dateEnd = nil;
        }else if (!self.dateStart){
            self.dateStart = date;
        }else{
            self.dateEnd = date;
        }
    }
    [self configureVisibleCells];
    
    if ([self.dateStart compare:self.dateEnd] == 1) {
        NSDate *tempdate = self.dateStart;
        self.dateStart = self.dateEnd;
        self.dateEnd = tempdate;
    }
    NSLog(@"startdate:%@----enddate:%@", self.dateStart, self.dateEnd);
    self.eventLabel.text = [NSString stringWithFormat:@"%@ 至 %@", [self.dateFormatter stringFromDate:self.dateStart], [self.dateFormatter stringFromDate:self.dateEnd]];
}


- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@", [self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}


- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods
- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent){
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.dateStart && self.dateEnd) {
        BOOL isMiddle = [date compare:self.dateStart] != [date compare:self.dateEnd];
        rangeCell.middleLayer.hidden = !isMiddle;
    }else{
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.dateStart && [self.gregorian isDate:date inSameDayAsDate:self.dateStart];
    isSelected |= self.dateEnd && [self.gregorian isDate:date inSameDayAsDate:self.dateEnd];
    rangeCell.selectionLayer.hidden = !isSelected;
}

#pragma mark - Target actions
- (void)todayItemClicked
{
    self.todayButton.hidden = YES;
    
    [_calendar setCurrentPage:[NSDate date] animated:YES];
//    [_calendar setCurrentPage:[self.dateFormatter dateFromString:@"2018-05-06"] animated:YES];
}
- (void)todayItemClickedNOAnimat
{
    self.todayButton.hidden = YES;
    [_calendar setCurrentPage:[NSDate date] animated:NO];
//    [_calendar setCurrentPage:[self.dateFormatter dateFromString:@"2018-05-06"] animated:NO];
}
- (void)todayButtonStatus:(FSCalendar *)calendar isOpen:(BOOL)isOpen
{
    NSDate *date =[NSDate date];
//    NSDate *date =[self.dateFormatter dateFromString:@"2018-05-06"];
    NSDate *firstDate = calendar.currentPage;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    NSInteger firstYear=[[formatter stringFromDate:firstDate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    NSInteger firstMonth=[[formatter stringFromDate:firstDate]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    NSInteger firstDay=[[formatter stringFromDate:firstDate] integerValue];
    if (!isOpen) {
        //收起
        if (currentYear == firstYear && currentMonth == firstMonth) {
            if (firstDay==1 && currentDay-firstDay > 6 ) {
                [self performSelector:@selector(todayItemClickedNOAnimat) withObject:nil afterDelay:0.3];
            }
        }else if(currentMonth != firstMonth){
            NSLog(@"firstday:%ld ---currentDay:%ld", firstDay, currentDay);
            NSLog(@"firstMonth:%ld ---currentMonth:%ld", firstMonth, currentMonth);
            NSInteger monthEndDayCount = [self MonthEndDayCountYear:firstYear month:firstMonth day:firstDay];
            if ( 6 - monthEndDayCount >= currentDay && currentYear == firstYear && labs(currentMonth-firstMonth)<=1){
                self.todayButton.hidden = YES;
            }else{
                self.todayButton.hidden = NO;
            }
        }
    }else{
        //拉开
        if (currentYear == firstYear && currentMonth==firstMonth) {
            self.todayButton.hidden = YES;
        }else{
            self.todayButton.hidden = NO;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
