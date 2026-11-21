function handles=criterion_segmentation(handles);

% Критерий сегментации
Im_object=handles.Image_test_object;
pos=handles.object_position;
[n1, n2, n3]=size(Im_object);

% [x,y,delta_x,delta_y] - координаты известного начального объекта на
% фоновом изображении
rect_1=[pos(1) pos(2) n2 n1];
rect_1(3)=rect_1(3)-1;
rect_1(4)=rect_1(4)-1;

% [x,y,delta_x,delta_y] - координаты сегментированного выделенного объекта на
% фоновом изображении
rect_2=handles.rect_object;

rect=[min(rect_1(1),rect_2(1)) min(rect_1(2),rect_2(2)) max(rect_1(1)+rect_1(3),rect_2(1)+rect_2(3)) max(rect_1(2)+rect_1(4),rect_2(2)+rect_2(4))];
rect(3)=rect(3)-rect(1)+1;
rect(4)=rect(4)-rect(2)+1;

% handles.criterion_rect=rect;
% guidata(handles.figure1,handles);

% rect=handles.criterion_rect;
% Im_object=handles.Image_object;
% [n1, n2, n3]=size(Im_object);
% pos=handles.object_position;
transparency=Im_object(n1,1);

im1=zeros(576,768);
im2=zeros(576,768);

for i=1:n1
    for j=1:n2
        if (Im_object(i,j)~=transparency)
            im1(pos(2)+i-1,pos(1)+j-1)=1;
        end
    end
end

if (handles.ObjectFound==1)
    main_object=handles.main_object;
else
    [n1, n2, n3]=size(Im_object);
    main_object=zeros(n1,n2);
end
[n1, n2, n3]=size(main_object);
pos=handles.rect_object;
transparency=0;

for i=1:n1
    for j=1:n2
        if (main_object(i,j)~=transparency)
            im2(pos(2)+i-1,pos(1)+j-1)=1;
        end
    end
end

% figure;
% subplot(2,2,1);
% imshow(uint8(255*im1));
% subplot(2,2,2);
% imshow(uint8(255*im2));
% 
im3=imcrop(im1,rect);
im4=imcrop(im2,rect);
% subplot(2,2,3);
% imshow(uint8(255*im3));
% subplot(2,2,4);
% imshow(uint8(255*im4));

[n1, n2]=size(im3);
im5  = zeros(n1, n2);
meet = zeros(n1, n2);
union= zeros(n1, n2);

im5=im3+im4;

[n1, n2, n3]=size(im3);
for i=1:n1
    for j=1:n2
        if (im5(i,j)>1)
            meet(i,j)=1;
        end       
        if (im5(i,j)>0)
            union(i,j)=1;
        end       
    end
end

% subplot(2,2,1);
% imshow(uint8(255*meet));
% subplot(2,2,2);
% imshow(uint8(255*union));

s=sum(sum(meet));
p=sum(sum(union));
false_alarm=p-sum(sum(im3));
miss=sum(sum(im3))-s;
criterion=s/p;

handles.im1=im3;
handles.im2=im4;
handles.false_alarm=false_alarm;
handles.miss=miss;
handles.criterion_segm=criterion;
guidata(handles.figure1,handles);

