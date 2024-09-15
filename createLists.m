%% Read the google spreadsheet with the ArgoEs and ArgoIn floats and make a list

%% ArgoEs
URL='https://docs.google.com/spreadsheets/d/e/2PACX-1vQN9hcdt5zQ9_B3_X045LCuq4pMrNZHnErfdGUf4E6ZEczAyYqrOhFR8H2dCU6MwqphwGFRLx7p1V5c/pub?gid=1868814582&single=true&output=csv';
data=webread(URL);
DACs=table2array(data(:,2));
WMOs=table2array(data(:,3));
fid = fopen('floatsArgoSpain.dat','w');
i2=1;
for i1=1:length(WMOs)
        if ~isnan(WMOs(i1)) && ~isempty(DACs{1})
            sprintf('%s/%d',DACs{i1},WMOs(i1));
            fprintf(fid,'%s/%d\n',DACs{i1},WMOs(i1));
            i2=i2+1;
        end
    end
fclose(fid);
clear data DACs WMOs


%% ArgoIn
URLArgoIn="https://docs.google.com/spreadsheets/d/e/2PACX-1vQN9hcdt5zQ9_B3_X045LCuq4pMrNZHnErfdGUf4E6ZEczAyYqrOhFR8H2dCU6MwqphwGFRLx7p1V5c/pub?gid=1110659211&single=true&output=csv";
data=webread(URLArgoIn);
DACs=table2array(data(:,1));
WMOs=table2array(data(:,2));
fid = fopen('floatsArgoInterest.dat','w');
i2=1;
for i1=1:length(WMOs)
        if ~isnan(WMOs(i1)) && ~isempty(DACs{1})
            sprintf('%s/%d',DACs{i1},WMOs(i1));
            fprintf(fid,'%s/%d\n',DACs{i1},WMOs(i1));
            i2=i2+1;
        end
    end
fclose(fid);

