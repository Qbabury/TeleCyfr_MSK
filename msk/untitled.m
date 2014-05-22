function varargout = untitled(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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



function untitled_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);



function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function button_mod_msk_wej_Callback(hObject, eventdata, handles)
%%%%%%%Generowanie sygnalu cyfrowego
global dlugosc;    
global x

%%%%%%%Przypadek gdy uzytkownik chce losowac wartosc bitow
if(get(handles.radio_mod_msk_losuj,'Value')==1)
    dlugosc=get(handles.slider_mod_msk_bity,'Value');
        if dlugosc==0
            set(handles.text_mod_msk_wej_value,'String','Podaj niezerowa wartosc');
        else
            dlugosc=floor(dlugosc); %zaokraglanie do calkowitej, zeby nie bylo bledu
            x = randi([0 1],1,dlugosc);% generowanie s³owa o zadanej d³ugoœci
            axes(handles.wykres_mod_msk_wej);
            stairs(0:dlugosc, [x x(dlugosc)]); 
            axis([0 dlugosc -0.1 1.1]);
        end;
end;

%%%%%%%Przypadek gdy uzytkownik chce sam wpisac ciag bitow
if(get(handles.radio_mod_msk_recznie,'Value')==1)
    pyt{1} = 'Wprowadz bity:'; % Tekst przy polu do wprowadzenia zmiennej 1
    tytul = 'Okno do wprowadzania swoich bitow :-)'; % nazwa okna
    %odp = {'5','7'}; % opcjonalne wartoœci domyœlne
    x = inputdlg(pyt, tytul, 1); % wywo³anie okna dialogowego
    x = cell2mat(x);
    x = num2str(x);
    dlugosc=length(x);
%%%%%%%Sprawdza czy uzytkownik wpisal 0 i 1
    isValid = true;
    vec = [];
    for i=1:dlugosc
        if (~(x(i)=='1' || x(i)=='0')) 
           isValid = false;
           break;
        end;
        vec = [vec, str2num(x(i))];
    end;
    x=vec;
    if (isValid)    
        axes(handles.wykres_mod_msk_wej);
        stairs(0:dlugosc, [x x(dlugosc)]); 
        axis([0 dlugosc -0.1 1.1]);
    else 
        msgbox('Wpisz tylko 1 i 0');
    end;
end;



function button_mod_msk_zmod_Callback(hObject, eventdata, handles)
%%%%%%%%Modulacja MSK
global n;
global x;
global sygnal;
global dlugosc;
 
n=100;  % iloœæ próbkowañ w czasie trwania jednego bitu
sygnal=msk_mod(x,n);
axes(handles.wykres_mod_msk_zmod);
plot(1:dlugosc*n,sygnal); % przedstawienie zmodulowanego sygna³u




function button_demod_msk_zdemod_Callback(hObject, eventdata, handles)
%%%%%%%%Demodulacja MSK
global n;
global dlugosc;
global odszum;
global syg_zdem;

axes(handles.wykres_demod_msk_zdemod);
syg_zdem=zeros(1,dlugosc);
%%%%Demodulacja co bit
for i=0:dlugosc-1
    syg_zdem(i+1)=msk_demod(odszum,i*n,(i+1)*n);
end

stairs(0:dlugosc, [syg_zdem syg_zdem(dlugosc)]); 
    axis([0 dlugosc -0.1 1.1]);



function button_demod_msk_ber_Callback(hObject, eventdata, handles)
%%%%%%%%%BER
global roznica;
global syg_zdem;
global x;
global dlugosc;
global BER;
global bledy;

roznica=zeros(1,dlugosc);
roznica=syg_zdem - x;
axes(handles.wykres_demod_msk_wyj);
stairs(0:dlugosc, [roznica roznica(dlugosc)]);
    axis([0 dlugosc -1.1 1.1]);
    
bledy=sum(abs(roznica));
BER=bledy/dlugosc;

set(handles.text_demod_msk_ber_value,'String',num2str(BER));



function button_mod_msk_zaszum_Callback(hObject, eventdata, handles)
%%%%%%%Dodanie szumu AWGN
global sygnal;
global dlugosc;  
global n;
global snr;

snr=get(handles.slider_mod_msk_snr,'Value');
%%%% 1 wersja - szum dodawany funkcja awgn
%syg_szum=awgn(sygnal,snr);
%{
%%%% 2 wersja 
sigma2s = var(sygnal);    % Sigma do kwardratu ( sygnal) , variance
sigma2n = sigma2s/snr; % Sigma do kwardratu ( szum),SNR-stosunek sygnalu do szumu 
nI = sqrt(sigma2n/2) * randn(1, length(0:dlugosc*n-1));  % I component of noise
nQ = sqrt(sigma2n/2) * randn(1, length(0:dlugosc*n-1)); % Q component of noise
nszum = nI + sqrt(-1)*nQ; % wartosc szumu, wartosc zespolona  
% Dodawanie szumu do danych
syg_szum = sygnal + nszum;
%}
if snr==0
    set(handles.text_mod_msk_zaszum_value,'String','Podaj niezerowa wartosc');
else
%%%% 3 wersja
sigma2n=(10^(-snr/10))/2;
nszum=sqrt(sigma2n)*randn(1, length(0:dlugosc*n-1));
syg_szum = sygnal + nszum;
axes(handles.wykres_mod_msk_zaszum);
plot(0:dlugosc*n-1,syg_szum); % przedstawienie zaszumionego sygna³u
end;

%x = randi([0 1],1,50);
%Power=10;
%y=x+sqrt(Power)*randn(size(x));
%steps=length(x);

%Q=0.0004;

%randn('state', sum(100*clock)); %Resets it to a different state each time.

%v = sqrt(Q)*randn(length(time),1);

%handles.wykres_mod_msk_wej=plot(y,'r');



function button_demod_msk_odszum_Callback(hObject, eventdata, handles)
%%%%%%Odszumienie sygna³u
global sygnal;
global n;
global dlugosc;
global odszum;

%W0=[0.016 0.018];
f1=get(handles.slider_demod_msk_odszum_f1,'Value');
f2=get(handles.slider_demod_msk_odszum_f2,'Value');
if f1==0
    set(handles.text_demod_msk_odszum_value_f1,'String','Podaj niezerowa wartosc');
elseif f2==0
    set(handles.text_demod_msk_odszum_value_f2,'String','Podaj niezerowa wartosc');
else
%Wn=(fg/(fs/2)) - fg-czestotliwosc graniczna fs-czestotliwosc probkowania
W1=(f1/(n/2));
W2=(f2/(n/2));
if W1>=1
    set(handles.text_demod_msk_odszum_value_f1,'String','Podaj mniejsza wartosc wartosc');
elseif W2>=1
    set(handles.text_demod_msk_odszum_value_f1,'String','Podaj mniejsza wartosc');
elseif W1>W2
    set(handles.text_demod_msk_odszum_value_f1,'String','Czestotliwosc gorna musi byc wieksza od dolnej');
else
%W1=[0.024 0.026];
W1=[W1 W2];
N=50;
odszum=filtracja(sygnal,N,W1);
end;

axes(handles.wykres_demod_msk_odszum);
plot(0:dlugosc*n-1,odszum);
    axis([0 dlugosc*n -1.1 1.1]);
end;



function slider_mod_msk_snr_Callback(hObject, eventdata, handles)

k=get(hObject,'Value');
set(handles.text_mod_msk_zaszum_value,'String',num2str(k));



function slider_mod_msk_snr_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider_mod_msk_bity_Callback(hObject, eventdata, handles)

k=get(hObject,'Value');
set(handles.text_mod_msk_wej_value,'String',num2str(k));



function slider_mod_msk_bity_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider_mod_msk_probki_Callback(hObject, eventdata, handles)

k=get(hObject,'Value');
set(handles.text_mod_msk_probki_value,'String',num2str(k));



function slider_mod_msk_probki_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider_mod_msk_bity_KeyPressFcn(hObject, eventdata, handles)


function radio_mod_msk_recznie_Callback(hObject, eventdata, handles)


function radio_mod_msk_losuj_Callback(hObject, eventdata, handles)


function slider_demod_msk_odszum_f1_Callback(hObject, eventdata, handles)

k=get(hObject,'Value');
set(handles.text_demod_msk_odszum_value_f1,'String',num2str(k));

 

function slider_demod_msk_odszum_f1_CreateFcn(hObject, eventdata, handles)
 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


 
function slider_demod_msk_odszum_f2_Callback(hObject, eventdata, handles)
 
k=get(hObject,'Value');
set(handles.text_demod_msk_odszum_value_f2,'String',num2str(k));
 

 
function slider_demod_msk_odszum_f2_CreateFcn(hObject, eventdata, handles)
 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
