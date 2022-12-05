function [Area,P] = find_area(im,loc_x,loc_y,num)
N = size(loc_x,2);
[m,n] = size(im);
j = 1;
for i = 1:N
    if (loc_x(i) >= 32) & (m - loc_x(i) >= 32) & (loc_y(i) >= 32) & (n - loc_y(i)) >= 32
        J(j,1) = loc_x(i);
        J(j,2) = loc_y(i);
        j = j+1;
    end
end
nn = size(J,1);
% dig = double(64*64*2);
for i = 1:nn-1
    if J(i,1) ~= 0
       xc = J(i,1);
       yc = J(i,2);
       for j = i + 1:nn
%            if ( J(j,1) - xc )^2 +  J(j,2) - yc ^2 < dig
             if abs(( J(j,1) - xc )) < 64 & abs( J(j,2) - yc) <64 
               J(j,1) = 0;
             end
       end
    end
end
count = 1;
% figure;imshow(im);hold on;
for i= 1 : nn
    if J(i,1)~=0 && count <= num
%        plot(J(i,1),J(i,2),'o','LineWidth',5,'MarkerEdgeColor','k');
       P(count,1) = J(i,1);
       P(count,2) = J(i,2);
       Area(:,:,count)=im(J(i,2)-31: J(i,2)+32, J(i,1)-31:J(i,1)+32);   
       count = count + 1;
    end
end
% for i = 1:count-1
%     figure;
%     imshow(Area(:,:,i));
% end
