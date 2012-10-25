//
//  Color.m
//  HouseholdEncyclopedia
//
//  Created by Ibokan on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Color.h"

#define GETCOLOR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"color.txt"]  //存储颜色文件的路径


@interface Color()

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage; //用来取某张图片某个点的颜色
- (UIColor *) getPixelColorAtLocation:(CGPoint)point;

@end

@implementation Color

@synthesize delegate,imageView;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 198, 155)];  //设置一张图片用来选择颜色
        self.imageView.image = [UIImage imageNamed:@"color.png"];
        [self addSubview:self.imageView];
        [self.imageView release];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  //当在Color上开始一点
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];  //得到点的位置
    if (CGRectContainsPoint(self.imageView.frame, location)) {  //当点在图片内时
        
        //NSLog(@"%@",NSStringFromCGPoint(location));
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setColor:)]) {
            
            [self.delegate setColor:[self getPixelColorAtLocation:location]];   //取得点的颜色
        }
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  //  当在Color上开始滑动时
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.imageView.frame, location)) {   //当点在图片内时
        
        //NSLog(@"%@",NSStringFromCGPoint(location));
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setColor:)]) {
            
            [self.delegate setColor:[self getPixelColorAtLocation:location]];  //取得点的颜色

        }
    }
}

- (UIColor *) getPixelColorAtLocation:(CGPoint)point  //用来取某张图片某个点的颜色
{
    
    UIColor* color = nil;
    
    CGImageRef inImage = self.imageView.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];   //调用下面的方法
    if (cgctx == NULL) {
        return nil; /* error */ 
    }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}}; 
    
    // Draw the image to the bitmap context. Once we draw, the memory 
    // allocated for the context for rendering will then contain the 
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage); 
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y. 
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset]; 
        int red = data[offset+1]; 
        int green = data[offset+2]; 
        int blue = data[offset+3]; 
        NSArray *colorArr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(alpha/255.0f)],[NSNumber numberWithFloat:(red/255.0f)],[NSNumber numberWithFloat:(green/255.0f)],[NSNumber numberWithFloat:(blue/255.0f)], nil];
        [colorArr writeToFile:GETCOLOR atomically:YES];
        //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        
    }
    
    // When finished, release the context
    CGContextRelease(cgctx); 
    // Free image data memory for the context
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage 
{
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

- (void)dealloc 
{
    self.imageView = nil;
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
