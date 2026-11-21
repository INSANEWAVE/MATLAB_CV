function handles=compute_parameter(handles);

label_object=handles.label_object;
count=handles.count;
image_object=handles.image_object;

parametr_object = repmat(struct('square',0,'size_x',0,'size_y',0,'centre_x',0,'centre_y',0,'left_edge',10000,'right_edge',0,'top_edge',10000,'bottom_edge',0,'mean_brightness',0,'density',0),1,count);
[n,m]=size(label_object);
for i=1:n
  for j=1:m
    if (label_object(i,j)>0)
      member=label_object(i,j);
      parametr_object(member).square   = parametr_object(member).square   +1;
      parametr_object(member).centre_x = parametr_object(member).centre_x +j;
      parametr_object(member).centre_y = parametr_object(member).centre_y +i;
                  
      if (j<parametr_object(member).left_edge)
        parametr_object(member).left_edge=j;
      end
      if (j>parametr_object(member).right_edge)
        parametr_object(member).right_edge=j;
      end
      if (i<parametr_object(member).top_edge)
        parametr_object(member).top_edge=i;
      end
      if (i>parametr_object(member).bottom_edge)
        parametr_object(member).bottom_edge=i;
      end

      parametr_object(member).mean_brightness = parametr_object(member).mean_brightness + double(image_object(i,j));
           
    end
  end
end

for i=1:count
    parametr_object(i).size_x          = parametr_object(i).right_edge-parametr_object(i).left_edge+1;
    parametr_object(i).size_y          = parametr_object(i).bottom_edge-parametr_object(i).top_edge+1;
    parametr_object(i).centre_x        = round(parametr_object(i).centre_x/parametr_object(i).square);
    parametr_object(i).centre_y        = round(parametr_object(i).centre_y/parametr_object(i).square);
    parametr_object(i).mean_brightness = round(parametr_object(i).mean_brightness/parametr_object(i).square);
    parametr_object(i).density         = parametr_object(i).square/(parametr_object(i).size_x*parametr_object(i).size_y);
end

% x1=round(n/2);
% y1=round(m/2);
% 
% member=1;
% x=parametr_object(1).centre_x;
% y=parametr_object(1).centre_y;
% 
% distance=sqrt((x-x1)^2+(y-y1)^2);
% 
% if (count>1)
%   for i=2:count
%     x=parametr_object(i).centre_x;
%     y=parametr_object(i).centre_y;
%     dist=sqrt((x-x1)^2+(y-y1)^2);
%     
%     if (dist<distance)
%       member=i;
%       distance=dist;      
%     end
%   end
% end



% =======================================

member=1;
s=parametr_object(member).square;

if (count>1)
  for i=2:count
    s1=parametr_object(i).square;
    
    if (s<s1)
      member=i;
      s=s1;      
    end
  end
end

% =======================================



for i=1:n
  for j=1:m
    if (label_object(i,j)==member)
      main_object(i,j)=1;
    else
      main_object(i,j)=0;
    end
  end
end
                
handles.parametr_object=parametr_object;
handles.member=member;
handles.main_object=main_object;
guidata(handles.figure1,handles);