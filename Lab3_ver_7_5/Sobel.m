function handles=Sobel(handles);

image_object=handles.image_object;

if ~isa(image_object, 'double')
    image_object = im2double(image_object);
end;

filter1=[1 2 1; 0 0 0;-1 -2 -1];
filter2=[1 0 -1; 2 0 -2;1 0 -1];

HorisontalEdges = imfilter(image_object,filter1,'symmetric');
VerticalEdges   = imfilter(image_object,filter2,'symmetric');

image_gradient = sqrt(HorisontalEdges.*HorisontalEdges + VerticalEdges.*VerticalEdges);

image_gradient=mat2gray(image_gradient)*255;
image_gradient=uint8(image_gradient);

handles.image_gradient=image_gradient;
guidata(handles.figure1,handles);
