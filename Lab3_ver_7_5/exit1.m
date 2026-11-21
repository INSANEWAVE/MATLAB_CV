global processing;
global tracking;

if (processing==1)
    button = questdlg('Прервать обработку','Остановка алгоритма','Да','Нет','Да');
    button=cellstr(button);
    temp=cellstr('Да');
    if (isequal(button,temp)==1)
        tracking=0;
        processing=0;
    end    
else
    button = questdlg('Выйти из программы?','Выход из программы','Да','Нет','Да');
    button=cellstr(button);
    temp=cellstr('Да');
    if (isequal(button,temp)==1)
        delete(gcf);
    end 
end