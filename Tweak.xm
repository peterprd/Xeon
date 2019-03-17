#import "./headers/UIImage+ScaledImage.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <Cephei/HBPreferences.h>
#import "./xeonprefs/XENCommon.h"

//Tweak Enabled
static bool isEnabled = true;
//Custom Image
static bool isCustomImageEnabled = true;
static bool imageInFrontOfCarrierText = true;
static bool imageInFrontOfTimeText = true;
static int imageColor = 1;
//Custom Text
static bool isCustomTextEnabled = false;
static bool textInFrontOfCarrierText = false;
static bool textInFrontOfTimeText = false;
static NSString *customText = @"";
//Custom Carrier
static bool isCustomCarrierEnabled = false;
static NSString *customCarrier = @"";
//Custom Theme
static XENTheme *currentTheme;

@interface _UIStatusBarItem : NSObject
@end

@interface _UIStatusBarCellularItem : _UIStatusBarItem
@end

@interface _UIStatusBarStringView : UILabel
@property (nonatomic,copy) NSString * originalText; 
@property (nonatomic, assign) BOOL isServiceView;
@property (nonatomic, assign) BOOL isTime;
-(void)setText:(id)arg1;
@end

@interface SBStatusBarStateAggregator : NSObject
+(id)sharedInstance;
-(void)_updateServiceItem;
@end

@interface SBTelephonySubscriptionInfo : NSObject
-(NSString *)operatorName;
@end

%group Xeon
%hook _UIStatusBarCellularItem 
-(_UIStatusBarStringView *)serviceNameView {
	_UIStatusBarStringView *orig = %orig;
	orig.isServiceView = TRUE;
	return orig;
}
%end
%end

%group XENCustomImage
%hook _UIStatusBarStringView
%property (nonatomic, assign) BOOL isServiceView;
%property (nonatomic, assign) BOOL isTime;
-(void)setText:(id)arg1 {
	%orig;
	if (self.isServiceView) {
		if (imageInFrontOfCarrierText) {
			NSString *space = @" ";
			NSString *carrierText = [space stringByAppendingString:arg1];
			UIImage *img = [currentTheme getIcon:@"logo@3x.png"];
			if (!img) {
				img = [currentTheme getIcon:@"logo@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"etched@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"black@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"silber@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"dark@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"light@3x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"light@2x.png"];
			}
			UIImage *newImage = [img scaleImageToSize:CGSizeMake(20, 20)];

			if (imageColor == 0) {
				newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}

			NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
			imageAttachment.image = newImage;
			CGFloat imageOffsetY = -5.0;
			imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
			NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
			
			NSMutableAttributedString *imageFixText = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
			[imageFixText appendAttributedString:attachmentString];
    		[imageFixText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0] range:NSMakeRange(0, imageFixText.length)];
    		[imageFixText appendAttributedString:[[NSAttributedString alloc] initWithString:@""]];

			NSMutableAttributedString *completeText = [[NSMutableAttributedString alloc] initWithString:@""];
			[completeText appendAttributedString:imageFixText];
			NSMutableAttributedString *textAfterIcon = [[NSMutableAttributedString alloc] initWithString:carrierText];
			[completeText appendAttributedString:textAfterIcon];
			self.textAlignment = NSTextAlignmentRight;
			self.attributedText = completeText;
		}
	}

	if (imageInFrontOfTimeText) {
		if ([arg1 containsString:@":"]) {
			NSString *space = @" ";
			NSString *carrierText = [space stringByAppendingString:arg1];
			UIImage *img = [currentTheme getIcon:@"logo@3x.png"];
			if (!img) {
				img = [currentTheme getIcon:@"logo@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"etched@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"black@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"silber@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"dark@2x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"light@3x.png"];
			}
			if (!img) {
				img = [currentTheme getIcon:@"light@2x.png"];
			}
			UIImage *newImage = [img scaleImageToSize:CGSizeMake(20, 20)];

			if (imageColor == 0) {
				newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}

			NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
			imageAttachment.image = newImage;
			CGFloat imageOffsetY = -5.0;
			imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
			NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
			
			NSMutableAttributedString *imageFixText = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
			[imageFixText appendAttributedString:attachmentString];
    		[imageFixText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0] range:NSMakeRange(0, imageFixText.length)];
    		[imageFixText appendAttributedString:[[NSAttributedString alloc] initWithString:@""]];

			NSMutableAttributedString *completeText = [[NSMutableAttributedString alloc] initWithString:@""];
			[completeText appendAttributedString:imageFixText];
			NSMutableAttributedString *textAfterIcon = [[NSMutableAttributedString alloc] initWithString:carrierText];
			[completeText appendAttributedString:textAfterIcon];
			self.textAlignment = NSTextAlignmentRight;
			self.attributedText = completeText;
			[self setAdjustsFontSizeToFitWidth:YES];
		}
	}
}
%end
%end

%group XENCustomText
%hook _UIStatusBarStringView
%property (nonatomic, assign) BOOL isServiceView;
%property (nonatomic, assign) BOOL isTime;
-(void)setText:(id)arg1 {
	%orig;
	if (self.isServiceView) {
		if (textInFrontOfCarrierText) {
			NSString *carrierString = arg1;
    		NSString *spyString = customText;
    		NSString *statusString = [spyString stringByAppendingString:carrierString];

    		%orig(statusString);
		}
	}
	
	if (textInFrontOfTimeText) {
		if ([arg1 containsString:@":"]) {
			NSString *timeString = arg1;
    		NSString *spyString = customText;
    		NSString *statusString = [spyString stringByAppendingString:timeString];

    		%orig(statusString);
		}
	}
}
%end
%end

%group XENCustomCarrier
%hook SBTelephonySubscriptionInfo
-(NSString *)operatorName {
  return customCarrier;
}
%end
%end

void loadPrefs() {
	HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"com.peterdev.xeon"];
	//Tweak Enabled
    isEnabled = [([file objectForKey:@"kEnabled"] ?: @(YES)) boolValue];
	//Custom Image
	isCustomImageEnabled = [([file objectForKey:@"kEnableCustomImage"] ?: @(YES)) boolValue];
	imageInFrontOfCarrierText = [([file objectForKey:@"kImageCarrierText"] ?: @(YES)) boolValue];
	imageInFrontOfTimeText = [([file objectForKey:@"kImageTimeText"] ?: @(YES)) boolValue];
	imageColor = [([file objectForKey:@"kCustomImageColor"] ?: @(1)) intValue];
	//Custim Text
	isCustomTextEnabled = [([file objectForKey:@"kEnableCustomText"] ?: @(NO)) boolValue];
	textInFrontOfCarrierText = [([file objectForKey:@"kTextCarrierText"] ?: @(NO)) boolValue];
	textInFrontOfTimeText = [([file objectForKey:@"kTextTimeText"] ?: @(NO)) boolValue];
	customText = [file objectForKey:@"kCustomText"];
	if (!customText) customText = @"";
	//Custom Carrier
	isCustomCarrierEnabled = [([file objectForKey:@"kEnableCustomCarrier"] ?: @(NO)) boolValue];
	customCarrier = [file objectForKey:@"kCustomCarrier"];
	if (!customCarrier) customCarrier = @"";
	//Custom Theme
	NSString *iconTheme = [file objectForKey:@"IconTheme"];
    if(!iconTheme){
        iconTheme = @"Default";
    }

	currentTheme = [XENTheme themeWithPath:[XENThemesDirectory stringByAppendingPathComponent:iconTheme]];
}

%ctor {
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, (CFStringRef)XENNotification, NULL, kNilOptions);

	if (isEnabled) {
		if (isCustomImageEnabled || isCustomTextEnabled) %init(Xeon);
		if (isCustomImageEnabled) %init(XENCustomImage);
		if (isCustomTextEnabled) %init(XENCustomText);
		if (isCustomCarrierEnabled) %init(XENCustomCarrier);
	}
}