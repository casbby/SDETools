function options = sdeset(varargin)
%SDESET  Create/alter SDE OPTIONS structure.
%   OPTIONS = SDESET('NAME1',VALUE1,'NAME2',VALUE2,...) creates an integrator
%   options structure OPTIONS in which the named properties have the specified
%   values. Any unspecified properties have default values. It is sufficient to
%   type only the leading characters that uniquely identify the property. Case
%   is ignored for property names. 
%   
%   OPTIONS = SDESET(OLDOPTS,'NAME1',VALUE1,...) alters an existing options
%   structure OLDOPTS.
%   
%   OPTIONS = SDESET(OLDOPTS,NEWOPTS) combines an existing options structure
%   OLDOPTS with a new options structure NEWOPTS. Any new properties overwrite
%   corresponding old properties. 
%   
%   SDESET with no input arguments displays all property names and their
%   possible values.
%   
%SDESET PROPERTIES
%   
%SDEType - Type of SDE  [ {Stratonovich} | Ito ]
%   This property specifies the form of the SDE to be solved, and therefore if
%   particular SDE integration scheme is based upon the Stratonovich or Ito
%   stochastic integral.
%
%DFFUN - Derivative of the deterministic function  [ function_handle | vector ]
%   Set this property to a function handle in order to specify the derivative of
%   the deterministic function, df(t,y)/dy, to use derivative methods if
%   available. If this property is not set, derivative-free methods are used. If
%   a floating-point matrix is specified instead of a function handle, the
%   ConstFFUN property is implicitly assumed.
%
%DGFUN - Derivative of the stochastic function  [ function_handle | matrix ]
%   Set this property to a function handle in order to specify the derivative of
%   the stochastic function, dg(t,y)/dy, to use derivative methods if available.
%   If this property is not set, derivative-free methods are used. If a
%   floating-point matrix is specified instead of a function handle, the
%   ConstGFUN property is implicitly assumed. If all values are equal to zero,
%   then the ConstDGFUN property is also assumed.
%   
%RandSeed - Create random stream and set seed  [ 0 <= integer < 2^32 ]
%   Create a random number stream separate from Matlab's default stream with the
%   specified seed value. If a seed is not specified, Matlab's current default
%   stream is used.
%
%Antithetic - Use antithetic variates for Wiener increments  [ yes | {no} ]
%   Set this property to 'yes' to use the antithetic variates variance reduction
%   method to calculate the normal variates for the Wiener increments. Half as
%   many normal variates are generated and the remainder are the negative of
%   these. If Matlab's default random number stream is used (i.e., RandSeed not
%   specified) the stream's antithetic property is reset to it's previous state
%   after use.
%
%RandStream - Specify independent random number stream  [RandStream object]
%   Specify an alternative random number stream using a RandStream object
%   created with the RandStream function. The RandSeed and Antithetic properties
%   are ignored if the RandStream property is specified.
%   
%RandFUN - Specify alternative random number function  [ function_handle ]
%   Set this property to a function handle in order to specify an alternative
%   random number generator function, instead of using Matlab's random number
%   generator, to calculate the Wiener increments. The corresponding function
%   must take two arguments, M and N, and output an M by N matrix of normal
%   variates. The RandSeed, RandStream, and Antithetic properties are ignored if
%   the RandFUN property is specified.
%
%DiagonalNoise - Dimension of stochastic function  [ {yes} | no ]
%   In the default diagonal (uncorrelated) noise situation each dimension of the
%   stochastic function is only perturbed by a single component of the
%   D-dimensional Wiener process. GFUN (and DGFUN, if specified) must return a
%   scalar or a column vector of length N = LENGTH(Y0). If a scalar is returned,
%   this value is used across all N dimensions. Set this property to 'no' to use
%   the more general, but more computationaly intense, correlated noise case
%   where each dimension of the stochastic function can be disturbed by multiple
%   components of the Wiener process. In this case, the stochastic function
%   argument, GFUN (and DGFUN, if specified), must return a N-by-D matrix.
%
%ConstFFUN - Deterministic function is constant  [ yes | {no} ]
%   Set this property to 'yes' if the determinstic function, f(t,y), of the SDE
%   is constant and therefore not a function of time or state. The function is
%   then evaluated only once by the integration routine, improving performance.
%
%ConstGFUN - Stochastic function is constant, additive noise  [ yes | {no} ]
%   Set this property to 'yes' in the case of time-independent additive noise,
%   i.e., if the stochastic function, g(t,y), of the SDE is constant and
%   therefore not a function of time or state. The function is then evaluated
%   only once by the integration routine, improving performance.
%
%ConstDGFUN - Derivative of stochastic function is constant  [ yes | {no} ]
%   Set this property to 'yes' if the derivative of th stochastic function,
%   dg(t,y)/dy, of the SDE is constant and therefore not a function of time or
%   state. The function is then evaluated only once by the integration routine,
%   improving performance.
%
%NonNegative - Non-negative components [ yes | {no} | vector of indices ]
%   Set to 'yes' to specify that all components of the solution are
%   non-negative. A vector of indices specifies individual components of the
%   solution vector that must be non-negative. An empty vector, [], is
%   equivalent to 'no'.
%   
%   See also:
%       SDEGET, SDE_EULER, SDE_MILSTEIN, SDE_GBM, SDE_OU, FUNCTION_HANDLE,
%       RANDSTREAM

%   SDESET is based on an updating of version 1.46.4.10 of Matlab's ODESET.

%   Andrew D. Horchler, adh9@case.edu, 10-27-10
%   Revision: 1.0, 4-11-12


Names = {   'SDEType'
            'DFFUN'
            'DGFUN'
            'RandSeed'
            'Antithetic'
            'RandStream'
            'RandFUN'
            'DiagonalNoise'
            'ConstFFUN'
            'ConstGFUN'
            'ConstDGFUN'
            'NonNegative'
        };
Values = {	'{Stratonovich} | Ito'
            'function_handle | vector'
            'function_handle | matrix'
            '0 <= integer < 2^32'
            ' yes  | {no}'
            'RandStream object'
            'function_handle'
            '{yes} |  no '
            ' yes  | {no}'
            ' yes  | {no}'
            ' yes  | {no}'
            ' yes  | {no} | vector'
         };
m = length(Names);

% Print out possible values of properties.
if nargin == 0 && nargout == 0
    len = zeros(m,1);
    for i=1:m
        len(i) = length(Names{i});
    end
    blanks = max(len)-len;
    out = cell(1,m);
    for i=1:m
        out{i} = [char(32*ones(1,blanks(i))) Names{i} ': [ ' Values{i} ' ]\n'];
    end
    fprintf([cell2mat(out) '\n']);
    return;
end

% Combine all leading options structures opt1, opt2,... in sdeset(opt1,opt2,...)
options = cell2struct(cell(m,1),Names,1);
i = 1;
while i<=nargin
	arg = varargin{i};
	if ischar(arg)	% arg is an option name
        break;
	end
	if ~isempty(arg)	% [] is a valid options argument
        if ~isa(arg,'struct')
            error('SDETools:sdeset:NoPropertyNameOrStruct',...
                 ['Expected argument %d to be a string property name or an '...
                  'options structure created with SDESET.'],i);
        end
        for j=1:m
            Name = Names{j};
            if any(strcmp(fieldnames(arg),Name))
                val = arg.(Name);
            else
                val = [];
            end
            if ~isempty(val)
                options.(Name) = val;
            end
        end
	end
	i = i+1;
end

% A finite state machine to parse name-value pairs
if rem(nargin-i+1,2) ~= 0
	error('SDETools:sdeset:ArgNameValueMismatch',...
          'Arguments must occur in name-value pairs.');
end
while i<=nargin
	arg = varargin{i};
    if ~ischar(arg)
        error('SDETools:sdeset:NoPropertyName',...
              'Expected argument %d to be a string property name.',i);
    end
    j = find(strncmpi(arg,Names,length(arg)));
    if isempty(j)	% if no matches
        error('SDETools:sdeset:InvalidPropertyName',...
             ['Unrecognized property name ''%s''.  See SDESET for '...
              'possibilities.'],name);
    elseif length(j) > 1	% if more than one match
        k = find(strcmpi(arg,Names));
        if length(k) == 1
            j = k;
        else
            msg = [Names{j(1)} cell2mat(strcat({', '},Names(j(2:end)))')];
            error('SDETools:sdeset:AmbiguousPropertyName',...
                 ['Ambiguous property name abbreviation ''%s'' '...
                  '(' msg ').'],arg);
        end
    end
    options.(Names{j}) = varargin{i+1};
    i = i+2;
end