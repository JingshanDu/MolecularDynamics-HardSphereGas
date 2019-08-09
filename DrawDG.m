function  yy = DrawDG( V, delta, IfDraw )
%DRAWDG Draw distribution graph
%   Draw a distribution bar graph. Gives distribution function as well.
global graphpause
ymax=1.1;


ymin=-ymax;
y=V';
x=linspace(ymin,ymax,2*ymax/delta);  
yy=hist(y,x);
yy=yy/length(y); 

if IfDraw == 1
    subplot(122);
    bar(x,yy)
    pause(graphpause)
end

end

