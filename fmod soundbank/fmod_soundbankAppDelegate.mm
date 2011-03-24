//	Project:	FMOD_SOUNDBANK
//  File:		fmod_soundbankAppDelegate.m
//  Created by: Chris Latham of EngineAudio.com
//
//	Description: This application runs in the iPhone Simulator to test the FMOD audio engine created by Firelight Technologies
//	The application uses .FEV and .FSB files generated out of the FMOD Designer to laod and play audio then manipulate it real time.
//	The application is made up of two main screens the first allows the user to choose a sound from the FMOD soundbank using a UIPicker, with two sliders to adjust real time parameters.
//	The second screen is used like a X/Y touch controller (similar to a Korg Kaoss pad) to play a sound when touched and adjust two real time parameters along the X and Y axis.
//	To use custom soundbanks replace any .FEV or .FSB files in the Resources folder with custom files generated from "Build project..." in the FMOD Designer
//
//	FMOD Sound System, copyright © Firelight Technologies Pty, Ltd., 1994-2009.
//  To download FMOD and for tutorials go to: http://www.fmod.org/index.php/download
//
//	File Description: The application delegate that controls how the app launches, shuts downs, and animates views  
//

#import "fmod_soundbankAppDelegate.h"
#import "parametersXYViewController.h"


@implementation fmod_soundbankAppDelegate

@synthesize window;
@synthesize soundbankView;
@synthesize XYView;


//called when application is launched
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	//add the subview to the window
    [window addSubview:[soundbankView view]];
	
	//make the window visiable
	[window makeKeyAndVisible];
}


//brings second view to the window with a flip animation
- (void)flipToBack {
	
	//initializes aParametersXYView from parameterXYView.xib
	parametersXYViewController *aParametersXYView = [[parametersXYViewController alloc] initWithNibName:@"parametersXYView" bundle:nil];
	
	//set the aParametersXYView
	[self setXYView:aParametersXYView];
	
	//releases aParameterXYView
	[aParametersXYView release];
	
	//initialize animation
	[UIView beginAnimations:nil context:NULL];
	
	//set the animation duration to 1 sec
	[UIView setAnimationDuration:1.0];
	
	//set flip from left animation
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	
	//add XYView to window
	[self.window addSubview:[XYView view]];
	
	//do the animation
	[UIView commitAnimations];
	
	//remove soundbankView from super
	[[soundbankView view] removeFromSuperview];
	
}


//brings first view to the window with a flip animation
- (void)flipToFront {
	
	//begin animation
	[UIView beginAnimations:nil context:NULL];
	
	//set the animation duration to 1 sec
	[UIView setAnimationDuration:1.0];
	
	//set the flip from right animation
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:NO];
	
	//add the soundbankView to window
	[self.window addSubview:[soundbankView view]];
	
	//do the animation
	[UIView commitAnimations];
	
	//remove XYView from super
	[XYView.view removeFromSuperview];
    
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



//deallocate
- (void)dealloc {
    
	//release the soundbankView
	[soundbankView release];
	
	//release XYView
	[XYView release];
	
	//release the window
	[window release];
	
	//deallocate the super
	[super dealloc];
}
@end
