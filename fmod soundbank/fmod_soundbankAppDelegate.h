//	Project:	FMOD_SOUNDBANK
//  File:		fmod_soundbankAppDelegate.h
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
//	File Description: The header of the application delegate that controls how the app launches, shuts downs, and animates views  
//




//Define class
@class fmod_soundbankViewController, parametersXYViewController;


//Define interface	
@interface fmod_soundbankAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet fmod_soundbankViewController *soundbankView;
	IBOutlet parametersXYViewController *XYView;
}


//Flips view to XYParameter view
- (void)flipToBack;

//Flips display to SoundBank view
- (void)flipToFront;



@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) fmod_soundbankViewController *soundbankView;
@property (nonatomic, retain) parametersXYViewController *XYView;


@end
