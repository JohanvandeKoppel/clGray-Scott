//
//  Initial_values.cpp
//  clGray-Scott
//
//  Created by Johan Van de Koppel on 21-11-2016.
//  Copyright (c) 2015 Johan Van de Koppel. All rights reserved.
//

#include <stdio.h>

////////////////////////////////////////////////////////////////////////////////
// A point as initial value
////////////////////////////////////////////////////////////////////////////////

void PointInit(float* data, int x_siz, int y_siz, int type)
{
    for(int i=0;i<y_siz;i++)
    {
        for(int j=0;j<x_siz;j++)
        {
            //for every element find the correct initial
            //value using the conditions below
            if(i<(y_siz/2-2)||i>(y_siz/2+2)||j<(x_siz/2-2)||j>(x_siz/2+2))
            {
                if(type==Substance_U)
                {
                    data[i*y_siz+j]=1.0f;
                }
                else if(type==Substance_V)
                {
                    data[i*y_siz+j]=0.0f;
                }
            }
            else
            {
                if(type==Substance_U)
                {
                    data[i*y_siz+j]=10.0f;
                }
                else if(type==Substance_V)
                {
                    data[i*y_siz+j]=0.5f;
                }
            }
        }
    }
} // End PointInit


////////////////////////////////////////////////////////////////////////////////
// Allocates a matrix with random float entries
////////////////////////////////////////////////////////////////////////////////

void randomInit (float* data, int x_siz, int y_siz, int type)
{
    int i,j;
    for(i=0;i<y_siz;i++)
    {
        for(j=0;j<x_siz;j++)
        {
           //for every other element find the correct initial
            //value using the conditions below
            if(type==Substance_V)
            {
                //printf(" %4.5f ",(rand() / (float)RAND_MAX));
                if((rand() / (float)RAND_MAX)<0.00010f)
                    data[i*y_siz+j] = (float)10.0f;
                else
                    data[i*y_siz+j] = (float)0.0f;
            }
            else if(type==Substance_U)
                data[i*y_siz+j]=1.0f;
        }
    }
} // End randomInit

////////////////////////////////////////////////////////////////////////////////
// Prints the model name and additional info
////////////////////////////////////////////////////////////////////////////////

void Print_Label()
{
    //system("clear");
    printf("\n");
    printf(" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \n");
    printf(" * Pattern formation in the Gray-Scott model             * \n");
    printf(" * OpenCL implementation : Johan van de Koppel, 2016     * \n");
    printf(" * Following the model by Pearson, Science 1993          * \n");
    printf(" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \n\n");
    
} // Print_Label
