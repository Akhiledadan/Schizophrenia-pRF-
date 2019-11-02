function SZ_Addunits(input_ni)
% function to add xyz_units and time_units for the functional data

tmp = niftiRead(input_ni);


output_ni = tmp;
output_ni.xyz_units = 'mm';
output_ni.time_units = 'sec';

% rename the output as '*_U.nii'
tok = strtok(input_ni,'.');
output_ni_name = strcat(tok,'_U','.nii');

niftiWrite(output_ni, output_ni_name);

end