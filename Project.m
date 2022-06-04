A = imread('spur2.jpg');
fixednum = 12; 
B = rgb2gray(A);
C = imbinarize(B);
CC = imcomplement(C);


subplot(3,4,1); imshow(A) ; title('Raw Image')
subplot(3,4,2); imshow(B) ; title('Gray scaled image')
subplot(3,4,3); imshow(C) ; title('Binary image')
subplot(3,4,4); imshow(CC) ; title('Complement image')

%%Filling the holes
CCF = imfill(CC,'holes');
subplot(3,4,5); imshow(CCF) ; title('Filled Image')

%%Creating a Convex Hull Image, Addendum circle.
CCH = bwconvhull(CC,'objects');
[r,c]= size(CCH);
[X1,X2,Y1,Y2]= distance(CCH,r,c);
x=[X1,Y1];
y=[X2,Y2];
od =norm(x-y);
subplot(3,4,6); imshow(CCH) ;  hold on 
imdistline(gca,[X1,X2],[Y1,Y2])
title('Convex Hull Image:Addendum circle dia');


%%[centreBright, radiiBright] = imfindcircles(CCH,[200 300],'ObjectPolarity','bright','Sensitivity',0.92);
%%viscircles(centreBright, radiiBright, 'LineStyle','--');

%% Eroding the hull image with a disk lesser than 5 pixels
CCM = imerode(CCH, strel('disk',5));
CCT = imsubtract(CCF,CCM);
CCL = im2bw(CCT);
subplot(3,4,7); imshow(CCL) ; title('Subtracted image')

%%Removing less than 48 pixel blocks
CCA = bwareaopen(CCL,48);

[L num]= bwlabel(CCA);
subplot(3,4,8); imshow(CCA) ; title(['Total No. of Teeth : ',num2str(num)]);
subplot(3,4,9); imshow(A) ; title(['Total No. of Teeth : ',num2str(num)]);
if num == fixednum
    text(0,0,'Passed','Color','green','FontSize',14);
else
    text(0,0,'Rejected','Color','red','FontSize',14);
end

%% Creating Dedendum circle, base circle .
for x=5:100
    CCM1 = imerode(CCH, strel('disk',x));
    CCT1 = imsubtract(CCF,CCM1);
    CCL1 = im2bw(CCT1);
    CCA1 = bwareaopen(CCL1,8);
    [L num1]= bwlabel(CCA1);
    if num1 == 1;
        break;
    end
end
[s,t]= size(CCM1);
[X3,X4,Y3,Y4]= distance(CCM1,s,t)
p=[X3,Y3];
q=[X4,Y4];
id=norm(p-q)
subplot(3,4,10); imshow(CCM1) ; hold on
imdistline(gca,[X3,X4],[Y3,Y4])
title('Base Circle,Dedendum circle dia');


Diametrical_pitch= (fixednum+2)/od
Pitch_diameter = fixednum/Diametrical_pitch
Addendum_value = (od-Pitch_diameter)/2
Dedendum_value = (Pitch_diameter-id)/2
Module = Pitch_diameter/fixednum
Pressure_angle = acosd(id/Pitch_diameter)
subplot(3,4,11); imshow('whitenew.png') ; title('Calculations');
text(0,50,['Diametrical Pitch  :  ',num2str(Diametrical_pitch)],'Color','black','FontSize',12);
text(0,200,['Pitch Diameter     :  ',num2str(Pitch_diameter)],'Color','black','FontSize',12);
text(0,350,['Module                 :  ',num2str(Module)],'Color','black','FontSize',12);
text(0,500,['Addendum Value :  ',num2str(Addendum_value)],'Color','black','FontSize',12);
text(0,650,['Dedendum Value : ',num2str(Dedendum_value)],'Color','black','FontSize',12);
text(0,800,['Pressure angle    :  ',num2str(Pressure_angle)],'Color','black','FontSize',12);

subplot(3,4,12); imshow(CCT1) ;
function [X1,X2,Y1,Y2] = distance(image,r,c)
    e1 = find(image~=0,1,'first')
    e2 = find(image~=0,1,'last')
    X1 = ceil(e1/r);
    X2 = ceil(e2/r);
    Y1 = rem(e1,r);
    Y2 = rem(e2,r); 
end



%%,'FontSize',10,'Colour','green'
%%,'FontSize',10,'Colour','red'