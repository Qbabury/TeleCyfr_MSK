function [ wyjscie ] = filtracja(sygnal,N,W)


%N - Im wiekszy rzad tym wieksza dokladnosc 
filtr=fir1(N,W); %Tworzymy filtr.  fir1-filtr skonczonej odpowiedzi impulsowej
wejscie=zeros(1,length(sygnal)+floor(N/2));
wejscie(1:length(sygnal))=sygnal;
%Filtracja
wyj=filter(filtr,1,wejscie); %filter - digital filter,wejscie-dane
wyjscie=wyj(floor(N/2)+1:length(sygnal)+floor(N/2));

%Zwraca wyjscie filtru z pominieciem poczatkowych probek
%Filtr dolnoprzepustowy dziala jak uklad calkujacy


end