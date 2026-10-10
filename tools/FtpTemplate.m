%This is the function used to create the FtpArgoespana
%Edit and save in a 'private' folder
function ftpobj=FtpTemplate
    ftpobj=ftp('host','user', 'passwword');
