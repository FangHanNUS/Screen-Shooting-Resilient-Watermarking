function A = find_area_extract(im,loc_x,loc_y)
J(:,1) = loc_x;
J(:,2) = loc_y;
nn = size(J,1);
% figure;imshow(im);hold on
for i= 1 : nn
%        plot(J(i,1),J(i,2),'o','LineWidth',5,'MarkerEdgeColor','r');
       for a = 1:3
           for b = 1:3
                Area(:,:,i,a,b)=im(J(i,2)-2+a-31:J(i,2)-2+a+32,J(i,1)-2+b-31:J(i,1)-2+b+32); 
           end
       end
end

for i = 1:nn
    A(:,:,1,i) = Area(:,:,i,2,2);
    A(:,:,2,i) = Area(:,:,i,2,1);
    A(:,:,3,i) = Area(:,:,i,2,3);
    A(:,:,4,i) = Area(:,:,i,1,2);
    A(:,:,5,i) = Area(:,:,i,3,2);
    A(:,:,6,i) = Area(:,:,i,1,1);
    A(:,:,7,i) = Area(:,:,i,1,3);
    A(:,:,8,i) = Area(:,:,i,3,1);
    A(:,:,9,i) = Area(:,:,i,3,3);
end
% A(:,:,1,2) = Area(:,:,2,2,2);
% A(:,:,2,2) = Area(:,:,2,2,1);
% A(:,:,3,2) = Area(:,:,2,2,3);
% A(:,:,4,2) = Area(:,:,2,1,2);
% A(:,:,5,2) = Area(:,:,2,3,2);
% A(:,:,6,2) = Area(:,:,2,1,1);
% A(:,:,7,2) = Area(:,:,2,1,3);
% A(:,:,8,2) = Area(:,:,2,3,1);
% A(:,:,9,2) = Area(:,:,2,3,3);


