function SZ_repeatedMeasuresAnova(params,opt,stats_folder,verbose)
% SZ_repeatedMeasuresAnova - repeated measures anova to compare auc or
% central values of pRF size between different groups (here, schizophrenic
% population with hallucination, schizophrenic population without
% hallucination and healthy controls

% folder containing results
if ~exist('stats_folder','var')
    stats_folder = '/mnt/storage_2/projects/SZ/data/results/stats';
end

if ~exist('verbose','var')
    verbose = false;
end

% opt.compare = 'patientsSeparate';
% opt.compare = 'patientsTogether';

filename_res = sprintf('params_comp_stats_%s_%s.mat',opt.modelType,opt.plotType);

switch params
    case 'sigma_1G'
        load(fullfile(stats_folder,'2DGaussian_Ecc_Sig',filename_res));   
        
    case 'FWHM'
        load(fullfile(stats_folder,'DoGs_Ecc_Sig_fwhm_DoGs',filename_res));
        
    case 'sigma1'
        load(fullfile(stats_folder,'DoGs_Ecc_Sig1_DoGs',filename_res));
         
    case 'sigma2'   
        load(fullfile(stats_folder,'DoGs_Ecc_Sig2_DoGs',filename_res));
        
    case 'surroundSize'
        load(fullfile(stats_folder,'DoGs_Ecc_SurSize_DoGs',filename_res));
                
    case 'suppressionIndex'
        load(fullfile(stats_folder,'DoGs_Ecc_SuppressionIndex_DoGs',filename_res));
        
end

% parameter to compare. Can be either area under curve or central value

if strcmpi(opt.paramToCompare,'central')
    D=central;
elseif strcmpi(opt.paramToCompare,'auc')
    D=auc;
end

% either patients put together or separate
if strcmp(opt.compare,'patientsSeparate')
    patient = [zeros(1,14),ones(1,14),ones(1,14)+1];
elseif strcmp(opt.compare,'patientsTogether')
    patient = [zeros(1,14),zeros(1,14),ones(1,14)+1];% if patients vs controls:
end

get = ~isnan([D(1,:,1),D(2,:,1),D(3,:,1)]); 


% separate paremeter values into different rois
V1 = [D(1,get(1:14),1),D(2,get(15:28),1),D(3,get(29:42),1)];
V2 = [D(1,get(1:14),2),D(2,get(15:28),2),D(3,get(29:42),2)];
V3 = [D(1,get(1:14),3),D(2,get(15:28),3),D(3,get(29:42),3)];
V4 = [D(1,get(1:14),4),D(2,get(15:28),4),D(3,get(29:42),4)];

t=table(patient(get)',V1',V2',V3',V4','VariableNames',{'patient','Y1','Y2','Y3','Y4'});
within = table({'V1';'V2';'V3';'V4'},'VariableNames',{'roi'});

% fit repeated measures model
rm = fitrm(t,'Y1-Y4~patient','WithinDesign',within);

% perform a repeated measures anova using the rm model from above
ranova(rm, 'WithinModel','roi')

if verbose
    % to plot the figures
    figure;
    plot(V1','o-r')
    hold on
    plot(V2','o-g')
    plot(V3','o-b')
    plot((mean(V1)/3)*patient(get)','o-k')
end

% t test for individual rois
[p,stats]= ttest2(V1(patient(get)==0),V1(patient(get)==2));
[p,stats]= ttest2(V2(patient(get)==0),V2(patient(get)==2));
[p,stats]= ttest2(V3(patient(get)==0),V3(patient(get)==2));


end