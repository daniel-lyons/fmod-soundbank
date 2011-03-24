//	Project:	FMOD_SOUNDBANK
//  File:		fmod_soundbankViewController.h
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
//	File Description:  The header of the View Controller for the fmod_soundbank app.  Controls many of the visual aspects of the application, including play and stop actions, the picker view, and sliders.
//

#import "SingletonSoundManager.h"
#import "fmod_soundbankAppDelegate.h"



@interface fmod_soundbankViewController : UIViewController <UIPickerViewDelegate> {
	
    //Project
    char*                   projectname;	
	int                     count;
	int                     numparameters;
	
    
    //UI
	IBOutlet UIButton       *playButton;
	IBOutlet UIButton       *stopButton;
	IBOutlet UILabel        *groupLabel;
	IBOutlet UILabel        *param01Label;
	IBOutlet UILabel        *param02Label;
	IBOutlet UISlider       *uiparam01;
	IBOutlet UISlider       *uiparam02;
	
    
    //Picker
	UIPickerView            *myPicker;
	NSMutableArray          *mypickerdata;
	NSMutableDictionary     *pickerDict;
	
    
    //Singleton SoundManager
	SingletonSoundManager   *sharedSoundManager;
}


@property (nonatomic, retain) IBOutlet UIButton     *playButton;
@property (nonatomic, retain) IBOutlet UIButton     *stopButton;
@property (nonatomic, retain) IBOutlet UILabel      *param01Label;
@property (nonatomic, retain) IBOutlet UILabel      *param02Label;
@property (nonatomic, retain) IBOutlet UISlider     *uiparam01;
@property (nonatomic, retain) IBOutlet UISlider     *uiparam02;
@property (nonatomic, retain) IBOutlet UILabel      *groupLabel;
@property (nonatomic, retain) UIPickerView          *myPicker;



//Called when play button is touched
- (IBAction)playSound;

//Called when stop button is pressed
- (IBAction)stopSound;

//Called to push a new view on window
- (IBAction)pushView;

//Called when param01 slider is changed
- (IBAction)param01Changed:(id)sender;


- (IBAction)param02Changed:(id)sender;




@end
