function [syg] = msk_mod(x,n)

t=0:1/n:1-1/n;
syg=zeros(1,n*length(x));

if x(1)==1
    syg(1:n)=sin(2*pi*5/4*t);
end

if x(1)==0
    syg(1:n)=sin(2*pi*3/4*t);
end

for i=2:length(x)
    if round(syg((i-1)*n))==0
        if syg((i-1)*n-1)<0
            if x(i)==1
            syg((i-1)*n+1:i*n)=sin(2*pi*5/4*t);
            else syg((i-1)*n+1:i*n)=sin(2*pi*3/4*t);
            end
        else
            if x(i)==1
            syg((i-1)*n+1:i*n)=-sin(2*pi*5/4*t);
            else syg((i-1)*n+1:i*n)=-sin(2*pi*3/4*t);
            end
        end
    end
    
    if round(syg((i-1)*n))==1
            if x(i)==1
            syg((i-1)*n+1:i*n)=cos(2*pi*5/4*t);
            else syg((i-1)*n+1:i*n)=cos(2*pi*3/4*t);
            end
    end
    
    if round(syg((i-1)*n))==-1
            if x(i)==1
            syg((i-1)*n+1:i*n)=-cos(2*pi*5/4*t);
            else syg((i-1)*n+1:i*n)=-cos(2*pi*3/4*t);
            end
    end
    
    
end

   
end

