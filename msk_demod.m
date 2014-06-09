<<<<<<< HEAD
function [ wyjscie ] = msk_demod(sygnal,n)
demod=zeros(1,n);
ndt=100;
t100=1/100:1/100:1;
for i=1:n   
    if mod(i,2)==1
       mnozenie=times(sygnal((i-1)*ndt+1:i*100) , sin(2*pi*3/4*t100) );
       calka0=sum(abs(mnozenie));

        mnozenie=times(sygnal((i-1)*ndt+1:i*100) , sin(2*pi*5/4*t100) );
        calka1=sum(abs(mnozenie));
    else
        mnozenie=times(sygnal((i-1)*ndt+1:i*100) , cos(2*pi*3/4*t100) );
        calka0=sum(abs(mnozenie));
       
        mnozenie=times(sygnal((i-1)*ndt+1:i*100) , cos(2*pi*5/4*t100) );
        calka1=sum(abs(mnozenie));
    end
    if calka0>calka1
        demod(i)=0;
    else
        demod(i)=1;
    end
    wyjscie=demod;
=======
function [wyjscie] = msk_demod(sygnal,n)
sygnal_zdemodulowany=zeros(1,n);
probki=100;
time=1/100:1/100:1;
for i=1:n   
    signal=sygnal((i-1)*probki+1:i*100);
    if mod(i,2)==1
        splot=signal.*sin(2*pi*3/4*time);
        zera=sum(abs(splot));

        splot=signal.*sin(2*pi*5/4*time);
        jedynki=sum(abs(splot));
    else
        splot=signal.*cos(2*pi*3/4*time);
        zera=sum(abs(splot));
       
        splot=signal.*cos(2*pi*5/4*time);
        jedynki=sum(abs(splot));
    end
    if zera>jedynki
        sygnal_zdemodulowany(i)=0;
    else
        sygnal_zdemodulowany(i)=1;
    end
    wyjscie=sygnal_zdemodulowany;
>>>>>>> a912083a5e2d050eb43893dc98b57f3ef362cd5d
end