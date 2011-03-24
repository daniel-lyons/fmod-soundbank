//	Project:	FMOD_SOUNDBANK
//  File:		parametersXYViewController.h
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
//	File Description: The header for the X/Y Parameter View.  Allow the user to play sounds and adjust 2 real-time parameters on X/Y grid. 
//


#import "fmod_soundbankAppDelegate.h"
#import "SingletonSoundManager.h"




@interface parametersXYViewController : UIViewController {
	
	//Interface Variables
	IBOutlet UIButton	*backButton;
	IBOutlet UIView		*stalker;
	IBOutlet UILabel    *uiParam01;
	IBOutlet UILabel    *uiParam02;
	IBOutlet UILabel    *Y;
	IBOutlet UILabel    *X;
    
	//Picker Variables
	NSMutableArray		*mypickerdata;
	
	// Sound Manager
	SingletonSoundManager *sharedSoundManager;
	
    
}

@property (nonatomic, retain) IBOutlet UILabel  *uiParam01;
@property (nonatomic, retain) IBOutlet UILabel  *uiParam02;
@property (nonatomic, retain) IBOutlet UILabel  *X;
@property (nonatomic, retain) IBOutlet UILabel  *Y;
@property (nonatomic, retain) IBOutlet UIButton *backButton;


- (IBAction)goBack;


@end