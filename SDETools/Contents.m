%SDETools
%   Version 1.0, 5-10-12
%
%   Stochastic differential equation (SDE) solvers.
%       sde_euler       - Euler-Maruyama (Ito) and Euler-Heun (Stratonovich) 
%       sde_milstein    - Milstein method, derivative and derivative-free.
%
%   Stochastic differential equation (SDE) processes.
%       sde_gbm         - Geometric Brownian motion process, analytic solution.
%       sde_ou          - Ornstein-Uhlenbeck process, analytic solution.
%
%   Stochastic interpolatolation and SDE solver utilities.
%       sde_interp      - Brownian bridge interpolation.
%       sde_interpq     - Quick Brownian bridge interpolation.
%       sde_interpqn    - Quick linearly-spaced Brownian bridge interpolation.
%       sdeget          - Get SDE OPTIONS structure parameters.
%       sdeset          - Create/alter SDE OPTIONS structure.
%
%   Numerical validation and demos.
%       sde_euler_validate  - Test sde_euler performance and convergence order.

%   Tested with Matlab 7.14.0.739 (R2012a)
%   Mac OS X 10.6.8 (Build: 10K549), Java 1.6.0_31-b04-415-10M3635
%   Compatibility maintained back through Matlab 7.4 (R2007a)

%   Andrew D. Horchler, adh9@case.edu, Created 12-18-11
%   Revision: 1.0, 5-10-12

%   Acknowledgment of support: This material is based upon work supported by the
%   National Science Foundation under Grant No. 1065489. Disclaimer: Any
%   opinions, findings, and conclusions or recommendations expressed in this
%   material are those of the author(s) and do not necessarily reflect the views
%   of the National Science Foundation.