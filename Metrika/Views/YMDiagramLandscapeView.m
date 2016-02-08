//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMDiagramLandscapeView.h"
#import "YMListControl.h"

@interface YMDiagramLandscapeView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation YMDiagramLandscapeView

+ (instancetype)createView {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YMLandscapeDiagramView" owner:nil options:nil];
    YMDiagramLandscapeView *instance = [topLevelObjects objectAtIndex:0];
    [instance configUI];
    return instance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = NSLocalizedString(@"Graph", nil);
    self.totalLabel.text = NSLocalizedString(@"Total:", @"Всего:");
    self.totalValueTypeLabel.text = NSLocalizedString(@"VF-seconds", nil);
}

- (void)configUI {
    UIView *view = [[UIView alloc] initWithFrame:self.tableView.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = self.backgroundColor;
    self.tableView.backgroundView = view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[self totalLabel] sizeToFit];
    [[self totalValueLabel] sizeToFit];
    [[self totalValueTypeLabel] sizeToFit];
    self.totalLabel.centerY = self.listControl.centerY;
    self.totalValueLabel.centerY = self.totalLabel.centerY - 1;
    self.totalValueTypeLabel.bottom = self.totalValueLabel.bottom - 3;
    static const int kRightMargin = 12;
    static const int kMarginAfterTotalLabel = 6;
    static const int kMarginBetweenLabels = 4;
    self.totalValueTypeLabel.right = [self.totalValueTypeLabel.superview width] - kRightMargin;
    self.totalValueLabel.right = self.totalValueTypeLabel.left - kMarginBetweenLabels;
    self.totalLabel.right = self.totalValueLabel.left - kMarginAfterTotalLabel;
}

- (void)setTotalValue:(NSString *)totalValue totalType:(NSString *)totalType {
    self.totalValueLabel.text = totalValue ?: @"";
    self.totalValueTypeLabel.text = totalType ?: @"";
    self.totalLabel.hidden = self.totalValueLabel.hidden = self.totalValueTypeLabel.hidden = NO;
    [self setNeedsLayout];
}

- (void)hideTotalValue {
    self.totalValueLabel.text = self.totalValueTypeLabel.text = @"";
    self.totalLabel.hidden = self.totalValueLabel.hidden = self.totalValueTypeLabel.hidden = YES;
    [self setNeedsLayout];
}

@end