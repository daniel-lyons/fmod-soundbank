//	Project:	FMOD_SOUNDBANK
//  File:		fmod_soundbankViewController.mm
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
//	File Description:  The View Controller for the fmod_soundbank app.  Controls many of the visual aspects of the application, including play and stop actions, the picker view, and sliders.
//

#import "fmod_soundbankViewController.h"



@implementation fmod_soundbankViewController



@synthesize playButton, stopButton, myPicker, param01Label, param02Label, groupLabel, uiparam01, uiparam02;




//called when view is loaded
- (void) viewDidLoad{
	
	//creates the singleton audio engine (FMOD) to be used by the application
	sharedSoundManager = [SingletonSoundManager sharedSoundManager];
}




//second place launched. Animates the first view to fade in 
- (void)viewWillAppear:(BOOL)animated
{	
	//gets the eventdata dictionary in the sharedSoundManager and assigns it to pickerDict
	pickerDict = [sharedSoundManager provideEventData];
	
	//create a mutable array called mypickerdata
	mypickerdata = [[NSMutableArray arrayWithCapacity:10] retain];
	
	//add the pickerDict to mypickerdata
	[mypickerdata addObject:pickerDict];
	
	//create a picker with a particular size
	myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 15.0, 0.0, 0.0)];
	
	//assign the picker delegate to the application delegate
	myPicker.delegate = self;
	
	//Show selection indicator in picker to YES
	myPicker.showsSelectionIndicator = YES;
	
	//Display picker view in the application view
	[self.view addSubview:myPicker];
	
	//Select the first row in the picker
	[myPicker selectRow:0 inComponent:0 animated:YES];
    
	
}



// returns the number of 'columns' to display. Number is set to 1
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	
	//returns an integer
	return 1;
}



// returns the number of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
	//calls getCount for the number of envents in the sharedSoundManager and assigns it count
	count = [sharedSoundManager getCount];
    
	//returns an integer
	return count;
}



//gets the name of the event at a certain row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{	
	
	//gets the soundname of the event at a particular row
	NSString *nameofevent = [sharedSoundManager getSoundNameAtRow:row];
	
	//returns a string
	return nameofevent;
	
	
}




//load a sound and two real time parameters at a particular row from the picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	
	//sets "None" as a text string for the param none
	NSString *none = @"None";	
	
	
	//load sound from row in shareSoundManager
	[sharedSoundManager loadSoundAtRow:row];
	
	
	
	//getNumParameters
	numparameters = [sharedSoundManager getNumOfParameters];
	
	//if no params then set the slider text to "none"
	if (numparameters == 0) {			
		param01Label.text = none;
		param02Label.text = none;
		return;
	}
	
	//if one param then name first slider and set second slider to "none" 
	if (numparameters == 1) {
		
		//get the name of param01, set it to the label text of param01 slider 
		param01Label.text = [NSString stringWithUTF8String:[sharedSoundManager getParam01Name]];
		
		//set the max value of the first slider to the max of param01
		uiparam01.maximumValue    = [sharedSoundManager getParam01Max];
        
		//set the min value of the first slider to the min of param01		
		uiparam01.minimumValue    = [sharedSoundManager getParam01Min];
		
		//give the first slider a default value of 5.0
		uiparam01.value        = 5.0;
		
		//print to console "uiparam01.value is: "
		NSLog(@"uiparam01.value is: %f", uiparam01.value);
		
		//set param02 Label to none
		param02Label.text = none;
		return;
	}
	
	//if two params then name first slider and second slider
	if (numparameters == 2) {
		
		//get the name of param01, set it to the label text of param01 slider 
		param01Label.text = [NSString stringWithUTF8String:[sharedSoundManager getParam01Name]];
		
		//set the max value of the first slider to the max of param01
		uiparam01.maximumValue    = [sharedSoundManager getParam01Max];
		
		//set the min value of the first slider to the min of param01
		uiparam01.minimumValue    = [sharedSoundManager getParam01Min];
		
		//give the first slider a default value of 5.0		
		uiparam01.value        = 5.0;
		
		//print to console "uiparam01.value is: "
		NSLog(@"uiparam01.value is: %f", uiparam01.value);
		
		//get the name of param02, set it to the label text of param02 slider 
		param02Label.text = [NSString stringWithUTF8String:[sharedSoundManager getParam02Name]];
		
		//set the max value of the second slider to the max of param02
		uiparam02.maximumValue    = [sharedSoundManager getParam02Max];
		
		//set the min value of the second slider to the min of param02
		uiparam02.minimumValue    = [sharedSoundManager getParam02Min];
		
		//give the second slider a default value of 5.0
		uiparam02.value        = 5.0;
		
		//print to console "uiparam02.value is: "
		NSLog(@"uiparam02.value is: %f", uiparam02.value);
		return;
		
	}
}



//if first slider touched then param01 is changed 
- (IBAction)param01Changed:(id)sender
{
	//gets the value of the slider uiparam01
	float val1 = uiparam01.value;
	
	//prints to the console "param01 is: val1"
	NSLog(@"param01 is: %f", val1);
	
	//gets the number of parameters in the event
	numparameters = [sharedSoundManager getNumOfParameters];
	
	//if the event has at least 1 param the set the param01 value to val1
	if (numparameters == 1) [sharedSoundManager setParam01Value:val1];
    
	//if the event has 2 params the set the param01 value to val1
	if (numparameters == 2) [sharedSoundManager setParam01Value:val1];
    
}



//if first slider touched then param01 is changed 
- (IBAction)param02Changed:(id)sender
{
	
	//gets the value of the slider uiparam02	
	float val2 = uiparam02.value;
    
	//prints to the console "param02 is: val2"	
	NSLog(@"param02 is: %f", val2);
	
	//gets the number of parameters in the event	
	numparameters = [sharedSoundManager getNumOfParameters];
	
	//if the event has 2 params the set the param02 value to val2	
	if (numparameters == 2) [sharedSoundManager setParam02Value:val2];
	
}




//when PLAY button is pressed, calls playSound on the sharedSoundManager
- (IBAction)playSound {
	[sharedSoundManager playSound];
}	


//when STOP button is pressed, calls stopSound on sharedSoundManager
- (IBAction)stopSound {
	[sharedSoundManager stopSound];
}



//when X/Y PARAMETER button is pressed, creates a new delegate and flips to show next view
- (IBAction)pushView {
	
	//create new mainDelegate
	fmod_soundbankAppDelegate *mainDelegate = (fmod_soundbankAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//flips to new view 
	[mainDelegate flipToBack];
	
	
}	





//is called if  memory warning is recieved
- (void)didReceiveMemoryWarning {
    
	// Tells the superdelegate that a memory warning was recieved
	[super didReceiveMemoryWarning];
    
}





//deallocation of all memory objects
- (void) dealloc
{
	//release all objects
	[playButton release];
	[playButton release];
	[param01Label release];
	[param02Label release];
	[groupLabel release]; 
	[uiparam01 release];
	[uiparam02 release];
	[myPicker release];
	[super dealloc];
}




@end

