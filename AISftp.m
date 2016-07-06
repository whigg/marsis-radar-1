function AISftp(folder,filename,hGo,varargin)

if ~isempty(varargin)
    host = varargin{1};
else
    host = 'pds-geosciences.wustl.edu';
end

try
f = ftp(host);
catch exception
    disp(['Could not open FTP connection to ',host])
    throw(exception)
end

try
binary(f)
[~,~,~,mD] = regexp(folder,'RDR\d\d\dX');
mD = lower(mD{1});
mDn = str2double(mD(4:6));

if mDn >= 769 && mDn <= 957 %updated 3 MAR 2012
    remDir = ['mex/mex-m-marsis-3-rdr-ais-ext3-v1/mexmdi_1004/data/active_ionospheric_sounder/' mD];
elseif mDn >= 480 && mDn <= 766
    remDir = ['mex/mex-m-marsis-3-rdr-ais-ext2-v1/mexmdi_1003/data/active_ionospheric_sounder/' mD];
elseif mDn >= 254 && mDn <= 459
    remDir = ['mex/mex-m-marsis-3-rdr-ais-ext1-v1/mexmdi_1002/data/active_ionospheric_sounder/' mD];
elseif mDn <= 253
    remDir = ['mex/mex-m-marsis-3-rdr-ais-v1/mexmdi_1001/data/active_ionospheric_sounder/' mD];
else
    error(['Your orbit: ',filename(end-3:end),' was not found at WUSTL at programming time. You can check manually with a web browser to see if it''s at WUSTL. Otherwise, update AISftp.m'])
end
    
cd(f,remDir);

% get .LBL
temp = mget(f,[filename '.lbl'],folder);
disp(['Downloading ' [filename '.lbl'] ' from ' host])
if ~strcmp(temp,[folder filename '.lbl'])
    warning(['Could not download ' [filename '.lbl'] ' from ' host])
end 

% get .DAT
temp = mget(f,[filename '.dat'],folder);
disp(['Downloading ' [filename '.dat'] ' from ' host])
if ~strcmp(temp,[folder filename '.dat'])
    warning(['Could not download ' [filename '.dat'] ' from ' host])
end

catch exception
    if ~isempty(hGo)
        set(hGo,'String','Go !')
    end
    disp(['Could not download ' filename ' from ' host '.'])
    disp('Here are the available files in this FTP directory ')
    dir(f)
    error([exception.message, ' See above for directory/file listing on the FTP server.'])
end