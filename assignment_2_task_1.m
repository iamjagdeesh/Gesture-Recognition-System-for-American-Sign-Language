filenames = dir('DM07/About*.csv');
for i=1:20
    x = filenames(i);
    name = x.name;
    about = readtable(strcat('DM07/',name));
    x1 = about(:,1:67);
    A = table2array(x1);
    B_temp = A.';
    if i==1
        B = B_temp; 
    else
        B = cat(1, B, B_temp);
    end
    %B = [B , B_temp];
    %B = cat(1, B, B_temp); 
end