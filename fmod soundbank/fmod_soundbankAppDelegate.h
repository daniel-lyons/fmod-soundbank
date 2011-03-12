//
//  fmod_soundbankAppDelegate.h
//  fmod soundbank
//
//  Created by Chris Latham on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class fmod_soundbankViewController;

@interface fmod_soundbankAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet fmod_soundbankViewController *viewController;

@end
