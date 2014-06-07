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
end