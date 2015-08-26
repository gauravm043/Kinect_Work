Infile= './Dataset_v1/Gaurav_3';
load(strcat(Infile,'_outptcloud'));
A = bodylabel;
for i=14:100
    PT = A{i}{1};
    Co = A{i}{2};
    figure(1),showPointCloud(PT,Co,'VerticalAxis','y','VerticalAxisDir','down');
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    pause(5);
    disp(i);
end
