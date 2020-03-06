function EnviaCorreoArgo(recipient,subject,message)
% set mail preferences
setpref('Internet','SMTP_Server','smtp.gmail.com')
setpref('Internet','E_mail','XXX')
setpref('Internet','SMTP_Username','XXX')
setpref('Internet','SMTP_Password','XXX')

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
    'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email

% send the message
sendmail(recipient,subject,message)

% and erase the record
setpref('Internet','SMTP_Server','')
setpref('Internet','E_mail','')
setpref('Internet','SMTP_Username','')
setpref('Internet','SMTP_Password','')
