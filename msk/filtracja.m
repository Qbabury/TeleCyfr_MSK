function [ wyjscie ] = filtracja(sygnal,N,W)

%Tworzy filtr o zadanych W=[Wmin Wmax] i rzedzie N
%Im wiekszy rzad tym wieksza dokladnosc
filtr=fir1(N,W); %Tworzymy filtr.  fir1-filtr odpowiedzi impulsowej
wejscie=zeros(1,length(sygnal)+floor(N/2));
wejscie(1:length(sygnal))=sygnal;
%Filtracja
wyj=filter(filtr,1,wejscie); %filter - digital filter,wejscie-dane
wyjscie=wyj(floor(N/2)+1:length(sygnal)+floor(N/2));
%The group delay of the FIR filter designed by fir1 is n/2.
%Zwraca wyjscie filtru z pominieciem poczatkowych probek
end