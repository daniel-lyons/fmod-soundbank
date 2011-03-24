//	Project:	FMOD_SOUNDBANK
//  File:		SingletonSoundManager.m
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
//	File Description:  The header for the singleton sound manager which initializes and controls the FMOD audio system
//


#import "fmod_event.hpp"
#import "fmod_errors.h"
#import "fmod_event_net.hpp"



@interface SingletonSoundManager : NSObject {
	
	int count;
	int numevents;
	int	numgroups;
	int numsubgroups;
	int numparameters;
	
	char*     param01name;
	char*     param02name;
	float param01Value;
	float param02Value;
	float param01Min;
	float param01Max;
	float param02Min;
	float param02Max;
	NSTimer				*timer;
	NSMutableDictionary *eventdata;
        
	FMOD::EventSystem		*eventSystem;
	FMOD::EventProject		*eventProject;
	FMOD::EventGroup		*group;
	FMOD::EventGroup		*subgroup;
    FMOD::Event				*event;
	FMOD::EventParameter	*param01;
	FMOD::EventParameter	*param02;
	FMOD::System			*system;
	
	FMOD_EVENT_PROJECTINFO	  projectinfo;
    
}

@property (nonatomic, retain) NSMutableDictionary *eventdata;

+ (SingletonSoundManager *)sharedSoundManager;

- (void)initFMOD;
- (void)shutdownSoundManager;
- (id)provideEventData;
- (NSInteger)getCount;
- (void)playSound;
- (void)stopSound;
- (void)loadSoundAtRow:(NSInteger)row;
- (NSInteger)getNumOfParameters;
- (NSString *)getSoundNameAtRow:(NSInteger)row;
- (void)timerUpdate:(NSTimer *)timer;

- (char *)getParam01Name;
- (float)getParam01Max;
- (float)getParam01Min;
- (void)getParam01Value;
- (void)setParam01Value:(float)param01Value;

- (char *)getParam02Name;
- (float)getParam02Max;
- (float)getParam02Min;
- (void)getParam02Value;
- (void)setParam02Value:(float)param02Value;



@end
