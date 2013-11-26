//
//  ViewController.h
//  pagingandzoom
//
//  Created by andy hazlett on 8/12/13.
//  Copyright (c) 2013 andy hazlett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>{
    
    
    UIScrollView *bgScorllView;        // background scrollview  control the slide paging
    UIView *bgView;                        // background view is on the bgscrollview
    
    UIImageView *picImageView;    //  the imageview for the photo where in the current screen
    
    UIScrollView *picScrollView;     // the scrollview for the current screen to preform zoom function
    
    UIImageView *preImageView;   // the imageview for the left side of the current screen
    
    UIImageView *nextImageView;  // the imageview for the right side of the current screen
    
    BOOL fingerTap;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scorllView;

@end
