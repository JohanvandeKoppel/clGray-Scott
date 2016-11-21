#include "Settings_and_Parameters.h"

////////////////////////////////////////////////////////////////////////////////
// Laplacation operator definition, to calculate diffusive fluxes
////////////////////////////////////////////////////////////////////////////////

float d2_dxy2(__global float* pop, int row, int column)
{
    float retval;
    
    int current = row * Grid_Width + column;
    int left    = row * Grid_Width + column-1;
    int right   = row * Grid_Width + column+1;
    int top     = (row-1) * Grid_Width + column;
    int bottom  = (row+1) * Grid_Width + column;
    
    retval = ( ( pop[left] + pop[right]  - 2*pop[current] ) /dX/dX +
               ( pop[top]  + pop[bottom] - 2*pop[current] ) /dY/dY );
    
    return retval;
}

////////////////////////////////////////////////////////////////////////////////
// Simulation kernel
////////////////////////////////////////////////////////////////////////////////

__kernel void SimulationKernel (__global float* U, __global float* V)
{
    
    float dUdt,dVdt,Reaction;
	
    size_t current  = get_global_id(0);
    int    row		= floor((float)current/(float)Grid_Width);
    int    column	= current%Grid_Width;

	if (row > 0 && row < Grid_Width-1)
    {
        Reaction = U[current] * V[current] * V[current];
        
        dUdt = (F*(1-U[current]) - Reaction + D_U*d2_dxy2(U, row, column));
        dVdt = (Reaction - (F+k)*V[current] + D_V*d2_dxy2(V, row, column));
        
		U[current]=U[current]+dUdt*dT;
		V[current]=V[current]+dVdt*dT;
    }
    
	// Handle Boundaries
	if(row==0)
		//do copy of first row = second last row
    {
        U[current]=U[(Grid_Height-2)*Grid_Width+column];
        V[current]=V[(Grid_Height-2)*Grid_Width+column];
    }
	else if(row==Grid_Height-1)
		//do copy of last row = second row
    {
        U[current]=U[1*Grid_Width+column];
        V[current]=V[1*Grid_Width+column];
    }
    else if(column==0)
    {
        U[row * Grid_Width + column]=U[row * Grid_Width + Grid_Width-2];
        V[row * Grid_Width + column]=V[row * Grid_Width + Grid_Width-2];
    }
    else if(column==Grid_Width-1)
    {
        U[row * Grid_Width + column]=U[row * Grid_Width + 1];
        V[row * Grid_Width + column]=V[row * Grid_Width + 1];
    }
	
} // End KlausmeierKernel

