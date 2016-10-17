
#import <UIKit/UIKit.h>

typedef enum
{
    UIImageViewAlignmentMaskCenter = 0,
    UIImageViewAlignmentMaskLeft   = 1,
    UIImageViewAlignmentMaskRight  = 2,
    UIImageViewAlignmentMaskTop    = 4,
    UIImageViewAlignmentMaskBottom = 8,
    
    UIImageViewAlignmentMaskBottomLeft  = UIImageViewAlignmentMaskBottom | UIImageViewAlignmentMaskLeft,
    UIImageViewAlignmentMaskBottomRight = UIImageViewAlignmentMaskBottom | UIImageViewAlignmentMaskRight,
    UIImageViewAlignmentMaskTopLeft     = UIImageViewAlignmentMaskTop | UIImageViewAlignmentMaskLeft,
    UIImageViewAlignmentMaskTopRight    = UIImageViewAlignmentMaskTop | UIImageViewAlignmentMaskRight,
    
}UIImageViewAlignmentMask;

typedef UIImageViewAlignmentMask UIImageViewAignmentMask __attribute__((deprecated("Use UIImageViewAlignmentMask. Use of UIImageViewAignmentMask (misspelled) is deprecated.")));

@interface UIImageViewAligned : UIImageView

@property (nonatomic) UIImageViewAlignmentMask alignment;

@property (nonatomic) BOOL alignLeft;
@property (nonatomic) BOOL alignRight;
@property (nonatomic) BOOL alignTop;
@property (nonatomic) BOOL alignBottom;

@property (nonatomic) BOOL enableScaleUp;
@property (nonatomic) BOOL enableScaleDown;

@property (nonatomic, readonly) UIImageView* realImageView;

@end
