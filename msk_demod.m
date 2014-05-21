function [ sygnal_demod ] = msk_demod( odszum, pocz, koniec )
%Demodulacja bitu    
    step=3;
    liczbaZer=0;
    pocz=pocz+step;
    p=odszum(pocz);
    znak=sign(p);
           
    for i=pocz:step:koniec
       c=odszum(i);
       if sign(c)~=znak
           liczbaZer=liczbaZer+1;
       end
       znak=sign(c);
    end                
    
    licznik=liczbaZer;
    if licznik==1
        sygnal_demod=0;
    else
        sygnal_demod=1;
    end
    
end

