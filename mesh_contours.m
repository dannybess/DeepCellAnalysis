function mesh_contours(varargin)
% mesh_contours  %  will run with default variables.
% mesh_contours(prefix, 'Pos') % will run on directories that match the prefix
% mesh_contours(remesh, 1), will remesh, even if already meshed in the past and variables are present. normally skips if variables are present
% mesh_contours(directory,'/home/user/matlab',prefix,'Pos') specify path and directory name
% mesh_contours(directory,'/home/user/matlab',prefix,'Pos',remesh,'1') will do all the above
% mesh_contours('area_filt',500) will only contour cells with an area greater than value given ( here at least 500 pxl sqaured)

% the variables you can change. simply list the variable you want to change
% as a string and then the value you want to replace it with. If you ru

% variable defaults
directory = pwd;
prefix = '';
suffix = '';
remesh = 1;
area_filt = 0;

if ~isempty(varargin)
    % print default variable information
    if strcmp(varargin{1},'-h')
        fprintf('To change variables, use: %s(''variablename'',variablevalue,...)\n',mfilename)
        fprintf('Default variables for %s:\n',mfilename)
        myvals = who;
        for n = 1:length(myvals)
            if ~strcmp(myvals{n},'varargin')
                if isstring(eval(myvals{n})) || ischar(eval(myvals{n}))
                    fprintf('%s = ''%s''\n',myvals{n},eval(myvals{n}))
                elseif isinteger(eval(myvals{n})) || isfloat(eval(myvals{n}))
                    fprintf('%s = %s\n',myvals{n},num2str(eval(myvals{n})))
                else
                    fprintf('%s = ''''\n',myvals{n})
                end
            end
        end
       return
    end
    
    % check if even numbered variables
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Improper arguments. Use ''-h'' flag to see options')
        return
    end
    
    % change variables
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if ~strcmp(directory(end),'/')
    directory = [directory '/'];
end

list = dir([directory prefix '*CONTOURS*' suffix '.mat']);
list = list(~cellfun(@(x) strcmp(x(1),'.'),{list.name})); % remove hidden files
  %% mesh contour files
  count = 0;
  for i = 1:numel(list)
    count_file = 0;
    fprintf('Loading: %s\n', list(i).name)
    f = load([directory list(i).name]);
    if isfield(f,'frame')
        if isfield(f.frame(1).object,'mesh') == 0 || remesh
            fprintf('Meshing: %s\n',list(i).name);
            for k = 1:numel(f.frame)
                fprintf('%d ',k)
                for j = 1:numel(f.frame(k).object)
%                     fprintf('%d\t',j);
                    if f.frame(k).object(j).area > area_filt && ~isempty(f.frame(k).object(j).Xcont)
                        [m,l,w] = calculate_mesh(f.frame(k).object(j));
                        f.frame(k).object(j).mesh = m;
                        f.frame(k).object(j).cell_length = l;
                        f.frame(k).object(j).cell_width = w;
                        count_file = count_file + 1;
                        %                 fprintf('%d\t',j)
                    else
                        f.frame(k).object(j).mesh = [];
                        f.frame(k).object(j).cell_length = [];
                        f.frame(k).object(j).cell_width = [];
                    end
                end
            end
            fprintf('\n%s: %d\n',list(i).name,count_file)
            save([directory list(i).name],'-struct','f');
        end
    end
    count = count + count_file;
  end
  disp('Done!')
  fprintf('Total # of cells from file set: %d\n',count)
  
  load handel
sound(y,Fs)
end


