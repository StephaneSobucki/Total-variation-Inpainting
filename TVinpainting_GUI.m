function varargout = TVinpainting_GUI(varargin)
% TVINPAINTING_GUI MATLAB code for TVinpainting_GUI.fig
%      TVINPAINTING_GUI, by itself, creates a new TVINPAINTING_GUI or raises the existing
%      singleton*.
%
%      H = TVINPAINTING_GUI returns the handle to a new TVINPAINTING_GUI or the handle to
%      the existing singleton*.
%
%      TVINPAINTING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TVINPAINTING_GUI.M with the given input arguments.
%
%      TVINPAINTING_GUI('Property','Value',...) creates a new TVINPAINTING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TVinpainting_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TVinpainting_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TVinpainting_GUI

% Last Modified by GUIDE v2.5 03-May-2019 20:00:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TVinpainting_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TVinpainting_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TVinpainting_GUI is made visible.
function TVinpainting_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TVinpainting_GUI (see VARARGIN)

% Choose default command line output for TVinpainting_GUI
handles.output = hObject;
title(handles.axes5,'Noisy image');
title(handles.axes2,'Original image');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TVinpainting_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TVinpainting_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.*','Pick an image file');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
    handles.image1 = imread(strcat(pathname,filename));
    axes(handles.axes2);
    title(handles.axes5,'Noisy image');
    imshow(handles.image1);
    title(handles.axes2,'Original image');
    guidata(hObject, handles);
end

% --- Executes on button press in mask.
function mask_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

workspace;  % Make sure the workspace panel is showing.
grayImage = handles.image1;
axes(handles.axes5);
imshow(grayImage); 
title(handles.axes5,'Noisy image');
axis on;
message = sprintf('Left click and hold to begin drawing a freehand path.\nSimply lift the mouse button to finish.\n');
uiwait(msgbox(message));
% User draws curve on image here.
hFH = drawfreehand('LineWidth',handles.brushSize.Value,'Closed',false);
pos = hFH.Position;
mask = true(size(grayImage,1),size(grayImage,2));
if(size(pos,1) > 2)
    max_x  = size(grayImage,2);
    max_y = size(grayImage,1);
    test = [pos(:,1) < max_x,pos(:,2)<max_y];
    zulul = and(test(:,1),test(:,2));
    idx = find(zulul == 1);
    pos = pos(idx,:);
    x = pos(:,1);
    y = pos(:,2);
    numberOfKnots = length(x);
    samplingRateIncrease = 50;
    newXSamplePoints = linspace(1, numberOfKnots, numberOfKnots * samplingRateIncrease);
    yy = [0, x', 0; 1, y', 1];
    pp = spline(1:numberOfKnots, yy); % Get interpolant
    smoothedY = ppval(pp, newXSamplePoints); % Get smoothed y values in the "gaps".
    % smoothedY is a 2D array with the x coordinates in the top row and the y coordinates in the bottom row.
    smoothedXCoordinates = smoothedY(1, :);
    smoothedYCoordinates = smoothedY(2, :);
    pos = [smoothedXCoordinates;smoothedYCoordinates]';
end
    pos = unique(round(pos),"rows");
    x = pos(:,1);
    y = pos(:,2);
    neighbourhood = round(sqrt(handles.brushSize.Value));
    for i = 1:length(y)
            x_left = x(i)-neighbourhood < 1;
            x_right = x(i)+neighbourhood > size(grayImage,2);
            y_up = y(i)-neighbourhood < 1;
            y_down = y(i)+neighbourhood > size(grayImage,1);
            if(~(x_left || x_right || y_up || y_down))
                mask(y(i)-neighbourhood:y(i)+neighbourhood,x(i)-neighbourhood:x(i)+neighbourhood) = 0;
            end
    end
hold on;
grayImage = double(grayImage);
input = mask.*grayImage;% + 255*(1-mask).*rand(size(grayImage));
imshow(input./255);
title(handles.axes5,'Noisy image');
% % get rid of imfreehand remnant.
delete(hFH);
handles.mask = mask;
hold off;
guidata(hObject, handles);

% --- Executes on button press in inpainting.
function inpainting_Callback(hObject, eventdata, handles)
% hObject    handle to inpainting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
T = str2double(handles.T_value.String);
lambda = str2double(handles.lambda_value.String);
dt = str2double(handles.dt_value.String);
TV(handles.image1,lambda,handles.mask,T,dt,handles);


function T_value_Callback(hObject, eventdata, handles)
% hObject    handle to T_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_value as text
%        str2double(get(hObject,'String')) returns contents of T_value as a double


% --- Executes during object creation, after setting all properties.
function T_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt_value_Callback(hObject, eventdata, handles)
% hObject    handle to dt_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt_value as text
%        str2double(get(hObject,'String')) returns contents of dt_value as a double


% --- Executes during object creation, after setting all properties.
function dt_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambda_value_Callback(hObject, eventdata, handles)
% hObject    handle to lambda_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda_value as text
%        str2double(get(hObject,'String')) returns contents of lambda_value as a double


% --- Executes during object creation, after setting all properties.
function lambda_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function brushSize_Callback(hObject, eventdata, handles)
% hObject    handle to brushSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function brushSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brushSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
