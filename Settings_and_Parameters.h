//
//  clGray-Scott model settings and parameters
//
//  Created by Johan Van de Koppel on 21-11-2016.
//  Copyright (c) 2014 Johan Van de Koppel. All rights reserved.
//

// Compiler directives
#define ON              1
#define OFF             0

#define Print_All_Devices OFF

#define Device_No       1   // 0: CPU; 1: Intel 4000; 2: Nvidia GT 650M
#define ProgressBarWidth 45

#define WorkGroupSize   16
#define DomainSize      1024

// Thread block size
#define Block_Size_X	(WorkGroupSize)
#define Block_Size_Y	(WorkGroupSize)

// Number of blox
/* I define the Block_Number_ensions of the matrix as product of two numbers
Makes it easier to keep them a multiple of something (16, 32) when using CUDA*/
#define Block_Number_X	(DomainSize/WorkGroupSize)
#define Block_Number_Y	(DomainSize/WorkGroupSize)

// Matrix Block_Number_ensions
// (chosen as multiples of the thread block size for simplicity)
#define Grid_Width  (Block_Size_X * Block_Number_X)			// Matrix A width
#define Grid_Height (Block_Size_Y * Block_Number_Y)			// Matrix A height
#define Grid_Size (Grid_Width*Grid_Height)                  // Grid Size

// DIVIDE_INTO(x/y) for integers, used to determine # of blocks/warps etc.
#define DIVIDE_INTO(x,y) (((x) + (y) - 1)/(y))

//      Parameters		Original value    Explanation and Units
#define F   0.037		//  0.037         - Non-dimensional model parameter, reflecting rainfall
#define	k	0.06   		//  0.06          - Non-dimensional model parameter, reflecting plant losses
#define D_U	0.5		    //  0.2           - Non-dimensional model parameter, reflecting plant spread
#define D_V	0.25	    //  0.1           - Non-dimensional model parameter, reflecting water flow

#define dX	0.375
#define dY	0.375

#define Time      0             // 0      - Start time of the simulation
#define dT        0.025         // 0.0001 - The timestep of the simulation
#define EndTime	  4500          // 60     - The time at which the simulation ends
#define NumFrames 300           // Number of times during the simulation that the data is stored
#define	MAX_STORE (NumFrames+1) //

// Name definitions
#define Substance_U	101
#define Substance_V	102


