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
            x = randi([0 1],1,dlugosc);% generowanie s?owa o zadanej d?ugo?ci
            axes(handles.wykres_mod_msk_wej);
            stairs(0:dlugosc, [x x(dlugosc)]); 
            axis([0 dlugosc -0.1 1.1]);
        end;
end;

%%%%%%%Przypadek gdy uzytkownik chce sam wpisac ciag bitow
if(get(handles.radio_mod_msk_recznie,'Value')==1)
    pyt{1} = 'Wprowadz bity:'; % Tekst przy polu do wprowadzenia zmiennej 1
    tytul = 'Okno do wprowadzania swoich bitow :-)'; % nazwa okna
    %odp = {'5','7'}; % opcjonalne warto?ci domy?lne
    x = inputdlg(pyt, tytul, 1); % wywo?anie okna dialogowego
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
 
n=100;  % ilo?? próbkowa? w czasie trwania jednego bitu
sygnal=msk_mod(x,n);
axes(handles.wykres_mod_msk_zmod);
plot(1:dlugosc*n,sygnal); % przedstawienie zmodulowanego sygna?u




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
global syg_szum;

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
plot(0:dlugosc*n-1,syg_szum); % przedstawienie zaszumionego sygnalu
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
%%%%%%Odszumienie sygna?u , filtr
global n;
global dlugosc;
global odszum;
global syg_szum;

%W0=[0.016 0.018];
f2=get(handles.slider_demod_msk_odszum_f2,'Value');
if f2==0
    set(handles.text_demod_msk_odszum_value_f2,'String','Podaj niezerowa wartosc');
else
%Wn=(fg/(fs/2)) - fg-czestotliwosc graniczna fs-czestotliwosc probkowania
W2=(f2/(n/2));
if W2>=1
    set(handles.text_demod_msk_odszum_value_f1,'String','Podaj mniejsza wartosc');
else
%W1=[0.024 0.026];
%W1=[0.0000001 W2];
N=50;

odszum=filtracja(syg_szum,N,W2);
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


% --- Executes on button press in button_ber.
function button_ber_Callback(hObject, eventdata, handles)
% hObject    handle to button_ber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%Generowanie sygnalu cyfrowego
global dlugosc2;    
global y;
global n;

%%%%%%%Przypadek gdy uzytkownik chce losowac wartosc bitow
if(get(handles.radio_ber_losuj,'Value')==1)
    dlugosc2=get(handles.slider_ber,'Value');
        if dlugosc2==0
            set(handles.text_ber,'String','Podaj niezerowa wartosc');
        else
            dlugosc2=floor(dlugosc2); %zaokraglanie do calkowitej, zeby nie bylo bledu
            y = randi([0 1],1,dlugosc2);% generowanie s?owa o zadanej d?ugo?ci
            wektor_ber=zeros(1,40);
            %%%% Modulacja
            sygnal_ber=msk_mod(y,n);
            %%%% Szumy
            for snr=1:40

                sigma2n=(10^(-snr/10))/2;
                nszum=sqrt(sigma2n)*randn(1, length(0:dlugosc2*n-1));
                syg_szum = sygnal_ber + nszum;

                %%%% Filtracja
                f2=2;
                W2=(f2/(n/2));
                N=50;
                odszum=filtracja(syg_szum,N,W2);

                %%%% Demodulacja

                syg_zdem=zeros(1,dlugosc2);
                    for i=0:dlugosc2-1
                        syg_zdem(i+1)=msk_demod(odszum,i*n,(i+1)*n);
                    end
                %%%% BER

                roznica=zeros(1,dlugosc2);
                roznica=syg_zdem - y;

                bledy=sum(abs(roznica));
                BER=bledy/dlugosc2;
                
                %%%% Wektor bledow
                
                wektor_ber(snr)=BER;
                       
            end;
            
            axes(handles.wykres_ber);
            semilogy(1:40,wektor_ber,'*-');
            xlabel('SNR');
            ylabel('BER');

        end;
end;

%%%%%%%Przypadek gdy uzytkownik chce sam wpisac ciag bitow
if(get(handles.radio_ber_recznie,'Value')==1)
    pyt{1} = 'Wprowadz bity:'; % Tekst przy polu do wprowadzenia zmiennej 1
    tytul = 'Okno do wprowadzania swoich bitow :-)'; % nazwa okna
    %odp = {'5','7'}; % opcjonalne warto?ci domy?lne
    y = inputdlg(pyt, tytul, 1); % wywo?anie okna dialogowego
    y = cell2mat(y);
    y = num2str(y);
    dlugosc2=length(y);
%%%%%%%Sprawdza czy uzytkownik wpisal 0 i 1
    isValid = true;
    vec = [];
    for i=1:dlugosc2
        if (~(y(i)=='1' || y(i)=='0')) 
           isValid = false;
           break;
        end;
        vec = [vec, str2num(y(i))];
    end;
    y=vec;
    if (isValid)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            wektor_ber=zeros(1,40);
            %%%% Modulacja
            sygnal_ber=msk_mod(y,n);
            %%%% Szumy
            for snr=1:40

                sigma2n=(10^(-snr/10))/2;
                nszum=sqrt(sigma2n)*randn(1, length(0:dlugosc2*n-1));
                syg_szum = sygnal_ber + nszum;

                %%%% Filtracja
                f2=2;
                W2=(f2/(n/2));
                N=50;
                odszum=filtracja(syg_szum,N,W2);

                %%%% Demodulacja

                syg_zdem=zeros(1,dlugosc2);
                    for i=0:dlugosc2-1
                        syg_zdem(i+1)=msk_demod(odszum,i*n,(i+1)*n);
                    end
                %%%% BER

                roznica=zeros(1,dlugosc2);
                roznica=syg_zdem - y;

                bledy=sum(abs(roznica));
                BER=bledy/dlugosc2;
                
                %%%% Wektor bledow
                
                wektor_ber(snr)=BER;
                       
            end;
            
            axes(handles.wykres_ber);
            semilogy(1:40,wektor_ber,'*-');
            xlabel('SNR');
            ylabel('BER');
        %axes(handles.wykres_ber);
        %stairs(0:dlugosc2, [y y(dlugosc2)]); 
        %axis([0 dlugosc2 -0.1 1.1]);
    else 
        msgbox('Wpisz tylko 1 i 0');
    end;
end;



% --- Executes on slider movement.
function slider_ber_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


k=get(hObject,'Value');
set(handles.text_ber,'String',num2str(k));

% --- Executes during object creation, after setting all properties.
function slider_ber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end