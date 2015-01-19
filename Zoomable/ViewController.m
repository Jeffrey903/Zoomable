//
//  ViewController.m
//  Zoomable
//
//  Created by Jeffrey Grossman on 1/19/15.
//  Copyright (c) 2015 Confide. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UITextView *textView;
@property (weak, nonatomic) UIImageView *imageView;

@end

#pragma mark -

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // This is meant to demonstrate some difficulties I'm having with zooming with UIScrollView.
    // The UIScrollView contains a UITextView and UIImageView, and I would like the UIImageView to be zoomable, but not the UITextView.
    // When the UIScrollView is partially scrolled (contentOffset.y > 0.0), performing a pinch to zoom causes a noticeable jump.

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 3.0;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.selectable = NO;
    textView.scrollsToTop = NO;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi volutpat turpis nec odio dignissim, ac vehicula nisi malesuada. Proin eu mattis augue. Aenean quis tempus metus, vel condimentum velit. Nunc tincidunt pellentesque lacus eget facilisis. Morbi aliquet felis in felis ultricies suscipit eu non enim. Aliquam at sapien a sapien gravida condimentum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tristique bibendum orci sed gravida. Sed consequat erat in erat dapibus, eget ultrices enim maximus.";
    textView.frame = ({
        CGRect frame = CGRectZero;
        frame.size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.bounds), FLT_MAX)];
        frame;
    });
    [self.scrollView addSubview:textView];
    self.textView = textView;

    UIImage *image = [UIImage imageNamed:@"Image.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = ({
        CGRect frame = CGRectZero;
        frame.origin.y = CGRectGetMaxY(textView.frame);
        frame.size = AVMakeRectWithAspectRatioInsideRect(image.size, self.view.bounds).size;
        frame;
    });
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;

    [self updateContentSize];
}

- (void)alignTextView
{
    CGRect frame = self.textView.frame;
    frame.origin.x = self.scrollView.contentOffset.x;
    self.textView.frame = frame;
}

- (void)updateContentSize
{
    CGFloat width = MAX(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.imageView.frame));
    CGFloat height = CGRectGetMaxY(self.imageView.frame);
    self.scrollView.contentSize = CGSizeMake(width, height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self alignTextView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self alignTextView];
    [self updateContentSize];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
