function handles=svyazyvanie(handles);

image_object=double(handles.image_object);
level=handles.method3_diapason;
[n1,n2]=size(image_object);
% i0 = round(n1/2);
% j0 = round(n2/2);
j0=handles.method3_centre_x;
i0=handles.method3_centre_y;

k=0;
lab = 0;

segm  = zeros([size(image_object,1) size(image_object,2)]);
sr = image_object(i0,j0);
segm(i0,j0)=1;
rectmax = [1 1 n1 n2];
rect = [i0-1 j0-1 i0+1 j0+1];

while ((rect(1)>=rectmax(1)) | (rect(2)>=rectmax(2)) | (rect(3)<=rectmax(3)) | (rect(4)<=rectmax(4)))
  i = rect(1);
  for fl=1:2
    for j=rect(2):rect(4)
        if (i<rectmax(1) | i>rectmax(3) | j<rectmax(2) | j>rectmax(4))
            continue;
        end
        
        if (abs(image_object(i,j)-sr)<level)
            segm(i,j)=1;
            lab = lab + image_object(i,j);
            k=k+1; 
            sr =lab/k;
        end
    end
    i = rect(3);
  end
  
  j = rect(2);
  for fl=1:2
      for i=rect(1)+1:rect(3)-1
          if (i<rectmax(1) | i>rectmax(3) | j<rectmax(2) | j>rectmax(4))
              continue;
          end
          if (abs(image_object(i,j)-sr)<level)
              segm(i,j)=1;
              lab = lab + image_object(i,j);
              k=k+1;
              sr =lab/k;
          end
      end
  j = rect(4);
  end
  
  rect = rect + [-1 -1 1 1];
end

segm = logical(segm);
handles.segm_image=segm;
guidata(handles.figure1,handles);