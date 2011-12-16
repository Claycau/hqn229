#include "mex.h"

// Fast activation function

// mex -v -f ../../entool/tools/mexopts.bat fastact.cpp -O

inline double pl(const double x)
{
  if (x < 1.0)
    return x;
  else
    return 1.0;    
}

inline double piecewice_linear(const double x) 
{
  if (x >= 0)
    return pl(x);
  else
    return -pl(-x);
}

void mexFunction(int nlhs, mxArray  *plhs[], int nrhs, const mxArray  *prhs[])       
{               
  if (nrhs < 1) {
    mexErrMsgTxt("[act] = fastact(x)\n");
    return;
  }
  const long M = mxGetM(prhs[0]);
  const long N = mxGetN(prhs[0]);
  
  plhs[0] = mxCreateDoubleMatrix(M,N, mxREAL);  
  
  const double* in = mxGetPr(prhs[0]);
  double* out = mxGetPr(plhs[0]);
  
  for (long i=0; i < M*N; i++) {
    *(out++) = piecewice_linear(*(in++));
  }
}


