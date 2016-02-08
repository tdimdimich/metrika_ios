//
// Created by Dmitry Korotchenkov on 17/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMTableCellForPlots.h"
#import "YMListControl.h"
#import "YMCheckButton.h"
#import "YMGraphTypeButton.h"

@interface YMTableCellForPlots ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet YMGraphTypeButton *graphTypeButton;
@property(nonatomic, strong) IBOutlet YMListControl *listControl;
@end

@implementation YMTableCellForPlots

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = NSLocalizedString(@"Graph", @"График:");
}

+ (YMTableCellForPlots *)createCell {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YMTableCellForPlots" owner:nil options:nil];
    return [topLevelObjects objectAtIndex:0];
}

- (void)setColor:(UIColor *)color {
    [self.graphTypeButton setColor:color];
    [self.listControl setColor:color];
}

- (void)setListData:(NSArray *)array selectedIndex:(NSUInteger)index target:(NSObject *)target action:(SEL)action {
    [self.listControl setData:array selectedIndex:index target:target action:action];
}

- (void)setChangeTypeTarget:(NSObject *)target action:(SEL)action {
    [self.graphTypeButton addTarget:target action:action];
}

-(void)hideGraphTypeButton {
    self.graphTypeButton.hidden = YES;
}

@end