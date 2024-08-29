URL='https://docs.google.com/spreadsheets/d/1-KRIy3dEmTC-bhn2vCWpcE3Ny4-tHqk_xUw5NT9pKLA/edit?gid=0#gid=0';
code='1-KRIy3dEmTC-bhn2vCWpcE3Ny4-tHqk_xUw5NT9pKLA';

result = GetGoogleSpreadsheet(code);
DACs=result(:,2);
WMOTexts=result(:,3);

fid = fopen('floatsArgoSpain.dat','w');

i2=1;
for i1=2:length(WMOTexts)
    try
        valor=WMOTexts{i1};
        if valor > 0
            WMOs(i2)=str2num(WMOTexts{i1});
            sprintf('%s/%d',DACs{i1},WMOs(i2));
            fprintf(fid,'%s/%d\n',DACs{i1},WMOs(i2));
            i2=i2+1;
        end
    catch ME;
        ME
        fide = fopen('ERRORfloatsArgoSpain.dat','w');
        fprintf(fide,'%s \n',WMOTexts{i1});
        fprintf(fide,'%s \n',ME.identifier);
        fprintf(fide,'%s \n',ME.message);
        fprintf(fide,'%s line %d\n',ME.stack.file,ME.stack.line);
        fclose(fide);
        return
   end
end

fclose(fid);

%% -----------------------------------------------------------------------
%% -----------------------------------------------------------------------

function result = GetGoogleSpreadsheet(DOCID)
% result = GetGoogleSpreadsheet(DOCID)
% Download a google spreadsheet as csv and import into a Matlab cell array.
%
% [DOCID] see the value after 'key=' in your spreadsheet's url
%           e.g. '0AmQ013fj5234gSXFAWLK1REgwRW02hsd3c'
%
% [result] cell array of the the values in the spreadsheet
%
% IMPORTANT: The spreadsheet must be shared with the "anyone with the link" option
%
% This has no error handling and has not been extensively tested.
% Please report issues on Matlab FX.
%
% DM, Jan 2013
%

loginURL = 'https://www.google.com';
csvURL = ['https://docs.google.com/spreadsheet/ccc?key=' DOCID '&output=csv&pref=2'];

%Step 1: go to google.com to collect some cookies
cookieManager = java.net.CookieManager([], java.net.CookiePolicy.ACCEPT_ALL);
java.net.CookieHandler.setDefault(cookieManager);
handler = sun.net.www.protocol.https.Handler;
connection = java.net.URL([],loginURL,handler).openConnection();
connection.getInputStream();

%Step 2: go to the spreadsheet export url and download the csv
connection2 = java.net.URL([],csvURL,handler).openConnection();
result = connection2.getInputStream();
result = char(readstream(result));

%Step 3: convert the csv to a cell array
result = parseCsv(result);

end

function data = parseCsv(data)
% splits data into individual lines
data = textscan(data,'%s','whitespace','\n');
data = data{1};
for ii=1:length(data)
    %for each line, split the string into its comma-delimited units
    %the '%q' format deals with the "quoting" convention appropriately.
    tmp = textscan(data{ii},'%q','delimiter',',');
    data(ii,1:length(tmp{1})) = tmp{1};
end

end

function out = readstream(inStream)
%READSTREAM Read all bytes from stream to uint8
%From: http://stackoverflow.com/a/1323535

import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;
byteStream = java.io.ByteArrayOutputStream();
isc = InterruptibleStreamCopier.getInterruptibleStreamCopier();
isc.copyStream(inStream, byteStream);
inStream.close();
byteStream.close();
out = typecast(byteStream.toByteArray', 'uint8');

end

