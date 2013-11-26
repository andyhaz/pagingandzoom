//
//  ViewController.m
//  pagingandzoom
//
//  Created by andy hazlett on 8/12/13.
//  Copyright (c) 2013 andy hazlett. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scorllView;

int numberOfPhotos = 3;

int currentpage;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPage :(int) page{
    
    currentpage = page;

    for (UIImageView *sView in bgView.subviews){
      //  NSLog(@"removesubview %@",sView);
        [sView removeFromSuperview];
    }
    
    NSLog(@"page number %d",page);
    //page = 1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"photo%d.png",page]];
    
    NSLog(@"pageA:%@ %@",[NSString stringWithFormat:@"photo%d.png",page],image);
    
    //picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,300,440)];//note use this
    //set image size
    
    picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((page-1)*320+10,0,330,400)];

    picScrollView.delegate = self;
    
    picScrollView.maximumZoomScale = 3;
    picScrollView.minimumZoomScale = 1;
    
    picScrollView.zoomScale =1;
    
    picScrollView.clipsToBounds = YES;
    picScrollView.bounces = YES;
    picScrollView.scrollEnabled = YES;
   // picScrollView.pagingEnabled = YES;
    
    picScrollView.tag = 5;
    
    picImageView = [[UIImageView alloc] initWithImage:image];
    
    [picImageView setFrame:CGRectMake(0, 0, 300,440)];
    
    //resize iamge
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picScrollView addSubview:picImageView];
    
    [bgView addSubview:picScrollView];
  
    int nextpage = page +1;
    
    UIImage *nextimage = [UIImage imageNamed:[NSString stringWithFormat:@"photo%d.png",nextpage]];
   //NSLog(@"pageB:%@",[NSString stringWithFormat:@"photo%d.png",nextpage]);
    nextImageView = [[UIImageView alloc] initWithImage:nextimage];
    
    [nextImageView setFrame:CGRectMake((nextpage-1)*320+10, 10, 300,440)];
    //resize
    nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [bgView addSubview:nextImageView];
    
    int prepage = page -1 ;
    
    UIImage *preimage = [UIImage imageNamed:[NSString stringWithFormat:@"photo%d.png",prepage]];
   // NSLog(@"pageC:%@",[NSString stringWithFormat:@"photo%d.png",prepage]);
    preImageView = [[UIImageView alloc] initWithImage:preimage];
    
    [preImageView setFrame:CGRectMake((prepage-1)*320+10, 10, 300,440)];
    //resize
    preImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [bgView addSubview:preImageView];
    
  //  bgView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // NSLog(@"%@",[UIScreen mainScreen]);
    int mypage = 1;
    
    fingerTap = true;
    bgScorllView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    int width = 320*numberOfPhotos;    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, width,460)];
    
    [self loadPage:mypage];
    
    [bgScorllView  setContentSize:CGSizeMake(width,460)];
    bgScorllView.pagingEnabled = YES;
    
    bgScorllView.delegate = self;
    bgScorllView.backgroundColor = [UIColor blackColor];
    
    //update the scroll view to the right page
  //  [bgScorllView setContentOffset:CGPointMake(mypage,0) animated:YES];

   /*
    CGRect bounds = bgScorllView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * mypage;
    bounds.origin.y = 0;
    [bgScorllView scrollRectToVisible:bounds animated:NO];
    NSLog(@"bgScorllView %@",bgScorllView);*/
    
    [bgScorllView addSubview:bgView];
    
    [scorllView addSubview:bgScorllView];
    
    //[self.view addSubview:bgScorllView];
    // -----------------------------
    // handly double taps
    // -----------------------------
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    
    [scorllView addGestureRecognizer:doubleTapRecognizer];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
 //   NSLog(@"viewforzooming scrollview tag %d",scrollView.tag);
    
    return picImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    //NSLog(@"scrollviewdidzoom scrollview tag %d %f",scrollView.tag,scrollView.zoomScale);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0){
        
       // NSLog(@"viewdisscroll length %f",scrollView.contentOffset.x);
        
        int pageNumber = floor(scrollView.contentOffset.x / 320 + 0.5) +1;
      //  NSLog(@"move page number %d",pageNumber);

        if (pageNumber != currentpage){
           // NSLog(@"load nextpage %d",pageNumber);
            [self loadPage:pageNumber];
        }
    }
}//end 
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView.tag == 0 ){
        // NSLog(@"viewdidendscroll ");
    }//end scroll
}
- (void)gotoPage:(BOOL)animated :(int)pageNum
{
    [self loadPage:pageNum];
	// update the scroll view to the appropriate page
    CGRect bounds = bgScorllView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * pageNum;
    bounds.origin.y = 0;
    [bgScorllView scrollRectToVisible:bounds animated:animated];
    
   // bgScorllView.autoresizingMask = UIViewContentModeScaleAspectFit;
    
    NSLog(@"goto %@",bgScorllView);
}
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {

    if (fingerTap == true) {
      //  NSLog(@"zoom in");
        CGPoint pointInView = [recognizer locationInView:picImageView];
        // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
        CGFloat newZoomScale = picScrollView.zoomScale * 4.5f;
        // NSLog(@"pic to zoom%@",picImageView);
        
        newZoomScale = MIN(newZoomScale, picScrollView.maximumZoomScale);
        // Figure out the rect we want to zoom to, then zoom to it
        CGSize scrollViewSize = self.scorllView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 28.0f);
        CGFloat y = pointInView.y - (h / 28.0f);
        
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        [picScrollView zoomToRect:rectToZoomTo animated:YES];
        // NSLog(@"scroll double tapped %f",newZoomScale);
        fingerTap = false;
    } else {
       // NSLog(@"zoom out");
        // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
        CGFloat newZoomScale = self.scorllView.zoomScale / 1.5f;
        newZoomScale = MAX(newZoomScale, self.scorllView.minimumZoomScale);
        [picScrollView setZoomScale:newZoomScale animated:YES];
        // NSLog(@"scroll double tapped %f",newZoomScale);
        fingerTap = true;
    }
}
@end
