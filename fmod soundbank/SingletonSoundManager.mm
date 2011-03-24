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
//	File Description:  The singleton sound manager is initializes and controls the FMOD audio system
//


#import "SingletonSoundManager.h"



@interface SingletonSoundManager (Private)

- (BOOL)initFMOD;

@end



@implementation SingletonSoundManager

@synthesize eventdata;




// initializes a variable to hold the singletonSoundManager
static SingletonSoundManager *sharedSoundManager = nil;

// Class method which provides access to the sharedSoundManager var.
+ (SingletonSoundManager *)sharedSoundManager {
	
	// locks and handles multiple threads at the same time
	@synchronized(self) {
		
		// If nil then
		if(sharedSoundManager == nil) {
			
			// Allocate and initialize the sharedSoundManager
			[[self alloc] init];
		}
	}
	
	// Return the sharedSoundManager
	return sharedSoundManager;
}


//checks that all no processes run outside of the singletonSound Manager
+ (id)allocWithZone:(NSZone *)zone {
    
	//if there are multiple processes
	@synchronized(self) {
        
		//if the sharedSoundManager is nil
		if (sharedSoundManager == nil) {
            
			//then allocate the sharedSoundManager to the zone
			sharedSoundManager = [super allocWithZone:zone];
            
			//return the sharedSoundManager
			return sharedSoundManager;
        }
    }
	
	//if not return nil
    return nil;
}


//returns a copy with the zone
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


//called when sharedSoundManger is initialized
- (id)init {
	
	//if application is being initialized
	if(self == [super init]) {
        
		//initialize FMOD
		[self initFMOD];		
		
		//return intialized FMOD
		return self;
	}
	
	//else release self
	[self release];
	
	//return nothing
	return nil;
}


//error reporting by FMOD audio system
void ERRCHECK(FMOD_RESULT result)
{
	//if result is not OK
	if (result != FMOD_OK)
	{
		//prints to the console "FMOD error!" with the error
		fprintf(stderr, "FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
		
		//crash
		exit(-1);
	}
}




//ran every 1ms to update the event system
- (void)timerUpdate:(NSTimer *)timer 
{
	FMOD_RESULT result  = FMOD_OK;
	
	//update eventSystem
	result = eventSystem->update();
	ERRCHECK(result);
	
	//update the network event system
	result = FMOD::NetEventSystem_Update();
	ERRCHECK(result);
	
}




//call to initialize the FMOD sound system, created each time the singleSharedManager is initialized
- (void) initFMOD {
	
	FMOD_RESULT result	= FMOD_OK;	
	eventSystem			= NULL;
	eventProject		= NULL;
	event				= NULL;
	group				= NULL;
	subgroup			= NULL;
	param01				= NULL;
	param02				= NULL;
	numevents			= 0;
	numgroups			= 0;
	numsubgroups		= 0;
	int index			= 0;
	count				= 0;
	char buffer[200]	= {0};
	char* eventname;
	char* groupname;
	char* subgroupname;
    
	
	//create the FMOD eventSystem, used when working with FMOD Designer
	result = FMOD::EventSystem_Create(&eventSystem); 
	ERRCHECK(result);
	
	//initialize eventSystem, define INIT
	result = eventSystem->init(32, FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE, NULL, FMOD_EVENT_INIT_NORMAL);
	ERRCHECK(result);
	
	//initialize the network audition system
	result = FMOD::NetEventSystem_Init(eventSystem);
	ERRCHECK(result);
	
	//create a 1ms timer with a timerUpdate selector
	timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
	
	
	//creates an array of all the files in the Resources path
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:nil];
	NSString *file;
	
	//looks at each file in the directory
	for (file in dirContents) {
		
		//if the path extension is = ".fev"
		if ([[file pathExtension] isEqualToString:@"fev"]) {
			
			//get the filename and assign it to buffer
			[[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], file] getCString:buffer maxLength:200 encoding:NSASCIIStringEncoding];
		}
	}
	
	//load the .FEV from buffer
	result = eventSystem->load(buffer, NULL, NULL);
	ERRCHECK(result);
	
	//get the first project 
	result = eventSystem->getProjectByIndex(0, &eventProject);
	ERRCHECK(result);
	
	//get the project name
	result = eventProject->getInfo(&projectinfo);
	ERRCHECK(result);
	
	//get the number of event groups in the project
	result = eventProject->getNumGroups(&numgroups);
	ERRCHECK(result);
	
	
	//create a new mutable dictionary called eventdata
	eventdata = [NSMutableDictionary dictionary];
	
	
	//for all groups in project
	for (int groupsindex = 0; groupsindex < numgroups; groupsindex++)
	{
		//get the first group in the groupindex
		result = eventProject->getGroupByIndex(groupsindex, YES, &group);
		ERRCHECK(result);
		
		//get the name of the group
		result = group->getInfo(NULL, &groupname);
		ERRCHECK(result);
		
		//get the number of event subgroups
		result = group->getNumGroups(&numsubgroups);
		ERRCHECK(result);
		
		//if there are no event subgroups
		if (numsubgroups == 0)
		{
			
			//get the number of events in the group
			result = group->getNumEvents(&numevents);
			ERRCHECK(result);
			
			//for each event in the group
			for (int eventsindex = 0; eventsindex < numevents; eventsindex++)
			{
				
				//load each event by eventindex in group
				result = group->getEventByIndex(eventsindex, FMOD_EVENT_DEFAULT, &event);
				ERRCHECK(result);
				
				//get the event name
				result = event->getInfo(NULL, &eventname, NULL);
				ERRCHECK(result);
				
				//create a nameofevent string "nameofevent" with index number
				NSString *nameofevent = [NSString stringWithFormat:@"nameofevent%d", index];
				
				//create a nameofgroup string "nameofgroup" with index number
				NSString *nameofgroup = [NSString stringWithFormat:@"nameofgroup%d", index];
				
				//sets the eventname into the eventdata dictionary
				[eventdata setObject:[NSString stringWithUTF8String:eventname] forKey:nameofevent];
				
				//sets the groupname into the eventdata dictionary
				[eventdata setObject:[NSString stringWithUTF8String:groupname] forKey:nameofgroup];
				
				//increase index
				index++;
				
				//set count to index
				count = index;
				
			}
		}
		
		//if there are 1 or more event subgroups then
		else{
			
			//for each subgroup
			for (int subgroupsindex = 0; subgroupsindex < numsubgroups; subgroupsindex++)
			{
				//get the subgroup
				result = group->getGroupByIndex(subgroupsindex, YES, &subgroup);
				ERRCHECK(result);
				
				//get the name of subgroup
				result = subgroup->getInfo(NULL, &subgroupname);
				ERRCHECK(result);
				
				//get the number of events in subgroup
				result = subgroup->getNumEvents(&numevents);
				ERRCHECK(result);
				
				//for each event in the subgroup
				for (int eventsindex = 0; eventsindex < numevents; eventsindex++)
				{
					
					//load each event by eventindex in group
					result = subgroup->getEventByIndex(eventsindex, FMOD_EVENT_DEFAULT, &event);
					ERRCHECK(result);
					
					//get the name of the event
					result = event->getInfo(NULL, &eventname, NULL);
					ERRCHECK(result);
					
					//create a nameofevent string "nameofevent" with index number
					NSString *nameofevent = [NSString stringWithFormat:@"nameofevent%d", index];
					
					//create a nameofgroup string "nameofgroup" with index number
					NSString *nameofgroup = [NSString stringWithFormat:@"nameofgroup%d", index];
					
					//create a nameofsubgroup string "nameofsubgroup" with index number
					NSString *nameofsubgroup = [NSString stringWithFormat:@"nameofsubgroup%d", index];
                    
					//sets the eventname into the eventdata dictionary
					[eventdata setObject:[NSString stringWithUTF8String:eventname] forKey:nameofevent];
					
					//sets the groupname into the eventdata dictionary
					[eventdata setObject:[NSString stringWithUTF8String:groupname] forKey:nameofgroup];
					
					//sets the subgroupname into the eventdata dictionary
					[eventdata setObject:[NSString stringWithUTF8String:subgroupname] forKey:nameofsubgroup];
					
					//increase index
					index++;
					
					//set count to index
					count = index;
					
				}
			}
		}
	}
    
}




//returns the eventdata as a dictionary
- (id) provideEventData{	
	return eventdata;
}


//get the count of the eventdata
- (NSInteger)getCount{
	return count;
}


//gets the name of a sound at a specified row
- (NSString *)getSoundNameAtRow:(NSInteger)row{
    
	//gets the event name at a specified row
	NSString *nameofevent = [NSString stringWithFormat:@"nameofevent%d", row];
	
	//returns a string from the eventdata dictionary
	return [eventdata objectForKey:nameofevent];
    
}


//loads a sound at a specified row
- (void)loadSoundAtRow:(NSInteger)row{
	
	FMOD_RESULT  result     = FMOD_OK;
	numparameters = 0;
	const char* path;
    
	
	//create a nameofevent string "nameofevent" with row number
	NSString *nameofevent = [NSString stringWithFormat:@"nameofevent%d", row];
	
	//create a nameofgroup string "nameofgroup" with row number
	NSString *nameofgroup = [NSString stringWithFormat:@"nameofgroup%d", row];
	
	//create a nameofsubgroup string "nameofsubgroup" with row number
	NSString *nameofsubgroup = [NSString stringWithFormat:@"nameofsubgroup%d", row];
	
	//creates a grouppath string from the group name at a specified row in eventdata
	NSString *grouppath = [eventdata objectForKey:nameofgroup];
	
	//creates a eventpath string from the event name at a specified row in eventdata
	NSString *eventpath = [eventdata objectForKey:nameofevent];
	
	////creates a projectpath string from the project name
    //NSString *projectpath = [NSString stringWithUTF8String:projectinfo];
	
    //creates a projectpath string from the project name
    NSString* projectpath = [[NSString alloc] initWithCString:projectinfo.name encoding:NSUTF8StringEncoding];

    
	//if there is a subgroup name
	if([eventdata objectForKey:nameofsubgroup] != NULL){
		
		//get the name of the subgroup at a specified row in eventdata
		NSString *subgrouppath = [eventdata objectForKey:nameofsubgroup];
		
		//set the path to be "projectpath/grouppath/subgrouppath/eventpath"
		path = [[NSString stringWithFormat:@"%@/%@/%@/%@", projectpath, grouppath, subgrouppath, eventpath] cString]; 
	}
	
	//if there are no subgroups then
	else
	{	
		//set the path to be "projectpath/grouppath/eventpath"
		path = [[NSString stringWithFormat:@"%@/%@/%@", projectpath, grouppath, eventpath] cString]; 
	}
    
	//load event at path
	result = eventSystem->getEvent(path, FMOD_EVENT_DEFAULT, &event);
	ERRCHECK(result);
	
}


//plays currently loaded event
- (void)playSound{
    
	FMOD_RESULT  result     = FMOD_OK;	
	
	//prints to the console "You pressed play"
	NSLog(@"You pressed play!");
	
	//starts playing the event
    result = event->start();
    ERRCHECK(result);
    
}



//stops all events playing in the project
- (void)stopSound{		
	
	FMOD_RESULT  result     = FMOD_OK;
    
	//prints to the console "You pressed stop!"
	NSLog(@"You pressed stop!");
	
	//stops all events in the project
	result = eventProject->stopAllEvents();
	ERRCHECK(result);
}



//gets the number of parameters an event has
- (NSInteger)getNumOfParameters{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	//get the number of params of the event
	result = event->getNumParameters(&numparameters);
	ERRCHECK(result);
	
	//returns an integer
	return numparameters;
    
}



//gets the name of param02 from event
- (char *)getParam01Name{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	//get param02 from event
	result = event->getParameterByIndex(0, &param01);
	ERRCHECK(result);
    
	//get the param02 name
	result = param01->getInfo(0, &param01name);
	ERRCHECK(result);
	
	//returns a char *
	return param01name;
}



//gets the range of param01 and returns the max
- (float)getParam01Max{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	//gets the range of param02
	result = param01->getRange(&param01Min, &param01Max);
	ERRCHECK(result); 
	
	//returns a float
	return param01Max;
    
}

//gets the range of param01 and returns the min
- (float)getParam01Min{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	
	//gets the range of param02
	result = param01->getRange(&param01Min, &param01Max);
	ERRCHECK(result);
	
	//returns a float
	return param01Min;
	
}


//sets the value of param01 with param01value
- (void)getParam01Value{
    
	FMOD_RESULT  result     = FMOD_OK;
	
	result = param01->getValue(&param01Value);
	ERRCHECK(result);
}



//sets the value of param01 with param01value
- (void)setParam01Value:(float)param01value{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	result = param01->setValue(param01value);
	ERRCHECK(result);
}


//gets param02 from event
- (void)getParam02{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	result = event->getParameterByIndex(1, &param02);
	ERRCHECK(result);
}



//gets the name of param02 from event
- (char *)getParam02Name{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	//get param02 from event
	result = event->getParameterByIndex(1, &param02);
	ERRCHECK(result);
	
	//get the param02 name
	result = param02->getInfo(0, &param02name);
	ERRCHECK(result);
	
	//returns a char *
	return param02name;
}



//gets the range of param02 and returns the max
- (float)getParam02Max{
	
	FMOD_RESULT  result     = FMOD_OK;	
	
	//gets the range of param02
	result = param02->getRange(&param02Min, &param02Max);
	ERRCHECK(result); 
	
	//returns a float
	return param02Max;
	
}


//gets the range of param02 and returns the min
- (float)getParam02Min{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	//gets the range of param02
	result = param02->getRange(&param02Min, &param02Max);
	ERRCHECK(result);
	
	//returns a float
	return param02Min;
	
}


//gets the value of param02 and sets it to param02value
- (void)getParam02Value{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	result = param02->getValue(&param02Value);
	ERRCHECK(result);
}



//sets the value of param02 with param02value
- (void)setParam02Value:(float)param02value{
	
	FMOD_RESULT  result     = FMOD_OK;
	
	result = param02->setValue(param02value);
	ERRCHECK(result);
}



//called when sharedSoundManafer is shutdown
- (void) shutdownSoundManager {
	
	//[timer invalidate];
    
	//if the eventSystems exists
    if (eventSystem)
    {
		//release the eventSystem
		eventSystem->release();
        
		//null the eventSystem
		eventSystem = NULL;
    }   
	
	//shutdown the network event system
	FMOD::NetEventSystem_Shutdown();
	
	//if there are multiple processes
	@synchronized(self) {
		
		//if sharedSoundManager is not nil
		if(sharedSoundManager != nil) {
			
			//deallocate self
			[self dealloc];
		}
	}
}


@end
