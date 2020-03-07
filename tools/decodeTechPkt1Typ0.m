clear all
file='/Users/pvb/Downloads/4.sbd';
fid=fopen(file);
bytes=fread(fid);
u.gps_lat_deg = bytes(79);
u.gps_lat_min  = bytes(80);
u.gps_lat_minfrac = bytes(81)*256 + bytes(82);
u.gps_lat_orientation = bytes(83);
u.gps_lon_deg  = bytes(84);
u.gps_lon_min  = bytes(85);
u.gps_lon_minfrac = bytes(86)*256 + bytes(87);
u.gps_lon_orientation = bytes(88);
u.gps_valid = bytes(89);
fclose(fid);