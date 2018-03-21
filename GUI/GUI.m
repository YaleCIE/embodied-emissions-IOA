function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 31-Oct-2017 10:55:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)
% 
% handles.dir=get_dir(handles.dir);
% handles.indir=get_indir(handles.indir_in,handles.indir_out);
% handles.EI=get_EI(handles.EI);

load('meta.mat');
handles.country_in.String=meta.countrynames;
handles.country_out.String=meta.countrynames;
handles.lngd={'Energy','Transport','Materials','Industry','Services','Buildings','AFOLU'};

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in select_data.
function select_data_Callback(hObject, eventdata, handles)
% hObject    handle to select_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject,'String');
val=get(hObject,'Value');

switch str{val}
    case 'direct emission'
        country=handles.country_in.String{handles.country_in.Value};
        show=get_dir(country)';
        plot(1995:2015,show);
        xlabel('Year');
        ylabel('Kg CO2');
        legend(handles.lngd);
    case 'indirect emission'
        country_in=handles.country_in.String{handles.country_in.Value};
        country_out=handles.country_out.String{handles.country_out.Value};
        show=get_indir(country_in,country_out);
        for a=1:21
            bar3(show(:,:,a));
            ax=gca;
            ax.XTickLabel=handles.lngd;
            ax.YTickLabel=handles.lngd;
            ax.ZLim=[0 max(max(max(show)))];
            pause(1);
        end
    case 'emission intensity'
        country=handles.country_in.String{handles.country_in.Value};
        show=get_EI(country)';
        plot(1995:2015,show);
        xlabel('Year');
        ylabel('Kg CO2/US$');
        legend(handles.lngd);
    otherwise
        disp('error');
end
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns select_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_data


% --- Executes during object creation, after setting all properties.
function select_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in country_in.
function country_in_Callback(hObject, eventdata, handles)
% hObject    handle to country_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.in=hObject.String{hObject.Value};

% Hints: contents = cellstr(get(hObject,'String')) returns country_in contents as cell array
%        contents{get(hObject,'Value')} returns selected item from country_in


% --- Executes during object creation, after setting all properties.
function country_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to country_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in country_out.
function country_out_Callback(hObject, eventdata, handles)
% hObject    handle to country_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns country_out contents as cell array
%        contents{get(hObject,'Value')} returns selected item from country_out


% --- Executes during object creation, after setting all properties.
function country_out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to country_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
