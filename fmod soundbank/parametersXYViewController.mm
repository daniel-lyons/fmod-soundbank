//	Project:	FMOD_SOUNDBANK
//  File:		parametersXYViewController.mm
//  Created by: Chris Latham of EngineAudio.com
//  Copyright:	2009 Engine Audio All rights reserved.
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
//	File Description: This file controls the X/Y Parameter View.  Allow the user to play sounds and adjust 2 real-time parameters on X/Y grid. 
//


#import "parametersXYViewController.h"



@implementation parametersXYViewController

@synthesize uiParam01, uiParam02, X, Y, backButton;



//makes view animate when it appears
- (void)viewWillAppear:(BOOL)animated
{
	
	//creates new sharedSoundManager
	sharedSoundManager = [SingletonSoundManager sharedSoundManager];
    
	//stop sounds
    [sharedSoundManager stopSound];
}



//flips to other view
- (IBAction)goBack {
	
	//set the delegate
	fmod_soundbankAppDelegate *mainDelegate = (fmod_soundbankAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//flip to new view
	[mainDelegate flipToFront];
}	



//called when screen is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)evnt{
	
	float       param01= 0.0f;
	float       param02= 0.0f;
	float       param01Max= 0.0f;
	float       param02Max= 0.0f;
	
	//prints to the console "touches began count" with number of count
	NSLog(@"touches began count %d, %@", [touches count], touches);
    
	//set the animation duration to 5
	[UIView setAnimationDuration:5];
	
	//set the begin of animation at current point
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	//begin stalk animation
	[UIView beginAnimations:@"stalk" context:nil];
	
	//create a touch
	UITouch *touch = [touches anyObject]; 
	
	//set the center of the stalker to the location of touch
	stalker.center = [touch locationInView:nil];
	
	//do the animation
	[UIView commitAnimations];
	
	//print to the console "The center X location is at:"
	NSLog(@"The center X location is at:'%f'", stalker.center.x);
	
	//math to set the stalker X center as a percentage
	param01 = ( (stalker.center.x - 1) / (319 - 1) ) * (1 - 0) + 0;
	
	//prints to the console "The center Y location is at:"
	NSLog(@"The center Y location is at:'%f'", stalker.center.y);
	
	//math to set the stalker Y cneter as a percentage
	param02 = ( (stalker.center.y - 22) / (475 - 22) ) * (1 - 0) + 0;
	
	//prints to the console "The volume is set at:"
	NSLog(@"The volume is set at:'%f'", param01);
	
	//prints to the console "The param is set at:"
	NSLog(@"The param is set at:'%f'", param02);
    
	//sets the X label to the stalker X center
	X.text   = [NSString stringWithFormat:@"%i", stalker.center.x];
	
	//sets the Y label to the stalker Y center
	Y.text   = [NSString stringWithFormat:@"%i", stalker.center.y];
    
	//getNumParameters from event
	int numparameters = [sharedSoundManager getNumOfParameters];
	
	//if the number of parameters is 1
	if (numparameters == 1) {
		
		//get the param01 max
		param01Max =  [sharedSoundManager getParam01Max];
		
		//multiply the param01 against the paramMax01 to find the range
		param01 = param01 * param01Max;
		
		//set the param01 text
		uiParam01.text   = [NSString stringWithFormat:@"%.3f", param01];
		
		//set param01 in the sharedSoundSystem
		[sharedSoundManager setParam01Value:param01];
    }
	
	//if the number of parameters is 2
	if (numparameters == 2) {
		
		//get the param01 max
		param01Max =  [sharedSoundManager getParam01Max];
		
		//multiply the param01 against the param01Max to find the range
		param01 = param01 * param01Max;
		
		//set the param01 text
		uiParam01.text   = [NSString stringWithFormat:@"%.3f", param01];
		
		//set param01 in the shareSoundSystem
		[sharedSoundManager setParam01Value:param01];
		
		//get the param02 max
		param02Max =  [sharedSoundManager getParam02Max];
		
		//multiply the param02 against the param02Max to find the range
		param02 = param02 * param02Max;
		
		//set the param02 text
		uiParam02.text   = [NSString stringWithFormat:@"%.3f", param02];
		
		//set param02 in the sharedSoundSystem
		[sharedSoundManager setParam02Value:param02];
        
	}
    
	//play event
	[sharedSoundManager playSound];
	
    
}


//called when touches are moved
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)evnt{
	
	float       param01= 0.0f;
	float       param02= 0.0f;
	float       param01Max= 0.0f;
	float       param02Max= 0.0f;
    
	
	//prints to the console: "touches began count"
	NSLog(@"touches began count %d, %@", [touches count], touches);
	
	//set the animation duration to 5
	[UIView setAnimationDuration:5];
	
	//set the begin of animation at current point
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	//begin stalk animation
	[UIView beginAnimations:@"stalk" context:nil];
	
	//create a touch
	UITouch *touch = [touches anyObject]; 
	
	//set the begin of animation at current point
	stalker.center = [touch locationInView:nil];
	
	//do the animation
	[UIView commitAnimations];
    
	//print to the console "The center X location is at:"
	NSLog(@"The center X location is at :'%f'", stalker.center.x);
    
	//math to set the stalker x center as a percentage
	param01 = ( (stalker.center.x - 1) / (319 - 1) ) * (1 - 0) + (0);
	
	//print to the console "The center Y location is at:"
	NSLog(@"The center Y location is at :'%f'", stalker.center.y);
	
	//math to set the stalker Y center as a percentage
	param02 = ( (stalker.center.y - 22) / (475 - 22) ) * (1 - 0) + 0;
	
	//print to the console "The volume is set at:"
	NSLog(@"The volume is set at :'%f'", param01);
	
	//print to the console "The param is set at:"
	NSLog(@"The param is set at :'%f'", param02);
    
	//sets the X label to the stalker X center
	X.text   = [NSString stringWithFormat:@"%.0f", stalker.center.x];
	
	//sets the Y label to the stalker X center
	Y.text   = [NSString stringWithFormat:@"%.0f", stalker.center.y];
	
	//getNumParameters
	int numparameters = [sharedSoundManager getNumOfParameters];
	
	
	//if number of parameters is equal to 1
	if (numparameters == 1) {
		
		//get param01 max
		param01Max =  [sharedSoundManager getParam01Max];
		
		//multiply the param01 against the param01Max to find the range
		param01 = param01 * param01Max;
		
		//set the param01 text
		uiParam01.text   = [NSString stringWithFormat:@"%.3f", param01];
		
		//set param01 in the sharedSoundSystem
		[sharedSoundManager setParam01Value:param01];
		
	}
	
	//if number of parameters is equal to 2
	if (numparameters == 2) {
		
		//get param01 max
		param01Max =  [sharedSoundManager getParam01Max];
		
		//multiply the param01 against the param01Max to find the range
		param01 = param01 * param01Max;
		
		//set the param01 text
		uiParam01.text   = [NSString stringWithFormat:@"%.3f", param01];
		
		//set param01 in the sharedSoundSystem
		[sharedSoundManager setParam01Value:param01];
		
		//get param02 max
		param02Max =  [sharedSoundManager getParam02Max];
		
		//multiply the param02 against the param02Max to find the range
		param02 = param02 * param02Max;
		
		//set the param02 text
		uiParam02.text   = [NSString stringWithFormat:@"%.3f", param02];
		
		//set the param02 in the sharedSoundSystem
		[sharedSoundManager setParam02Value:param02];
		
	}
}


//called when touches end
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)evnt{
	
	//print to the console "touches began count"
	NSLog(@"touches began count %d, %@", [touches count], touches);
	
	//stop sounds
	[sharedSoundManager stopSound];
    
	
}


//called if memory warning is recieved
- (void)didReceiveMemoryWarning {
    
	//call memory warning on super
	[super didReceiveMemoryWarning]; 
}


//deallocate
- (void)dealloc {
    
	//deallocates super
	[super dealloc];
}


@end
