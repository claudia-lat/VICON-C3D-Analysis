function value = sanitize_name(varargin)

value = varargin{1};

for j = 2:2:nargin-1
    
   %value(value==varargin{j}) =  '';
   eval(['value(value== ''' varargin{j} ''') = '''  varargin{j+1} ''';'])
    
end
