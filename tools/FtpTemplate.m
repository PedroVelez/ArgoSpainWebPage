%This is the fucntione used to create te FtpArgoespana
%Edit and save in a 'private' folder
function ftpobj=FtpTemplate
    ftpobj=ftp('host','user', 'passwword');
