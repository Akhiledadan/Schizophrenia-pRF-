function SZ_NWayAnova(params,opt,stats_folder,verbose)
% SZ_repeatedMeasuresAnova - one way ANOVA to comapre between groups
% folder containing results

if ~exist('stats_folder','var')
    stats_folder = '/mnt/storage_2/projects/Schizophrenia/data/results/stats';
end

if ~exist('verbose','var')
    verbose = false;
end


numSub_ptH  = length(opt.subjects.ptH);
numSub_ptNH = length(opt.subjects.ptNH);
numSub_HC   = length(opt.subjects.HC);


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
    patient = [zeros(1,numSub_ptH),ones(1,numSub_ptNH),ones(1,numSub_HC)+1];
elseif strcmp(opt.compare,'patientsTogether')
    patient = [zeros(1,numSub_ptH),zeros(1,numSub_ptNH),ones(1,numSub_HC)];% if patients vs controls:
elseif strcmp(opt.compare,'patientsOnly')
    patient = [zeros(1,14),ones(1,14)];% if only patients:
end

if strcmp(opt.compare,'patientsOnly')
    get = ~isnan([D(1,:,1),D(2,:,1)]);
    % separate paremeter values into different rois
    V1 = [D(1,get(1:14),1),D(2,get(15:28),1)];
    V2 = [D(1,get(1:14),2),D(2,get(15:28),2)];
    V3 = [D(1,get(1:14),3),D(2,get(15:28),3)];
    V4 = [D(1,get(1:14),4),D(2,get(15:28),4)];
    
    
elseif strcmp(opt.compare,'patientsTogether')
    
    V1_data = [D(1,1:numSub_ptH,1)';D(2,1:numSub_ptNH,1)';D(3,1:numSub_HC,1)'];
    V2_data = [D(1,1:numSub_ptH,2)';D(2,1:numSub_ptNH,2)';D(3,1:numSub_HC,2)'];
    V3_data = [D(1,1:numSub_ptH,3)';D(2,1:numSub_ptNH,3)';D(3,1:numSub_HC,3)'];
    V4_data = [D(1,1:numSub_ptH,4)';D(2,1:numSub_ptNH,4)';D(3,1:numSub_HC,4)'];
    
    label = patient';    
    
    
    V1 = [V1_data, label];
    V2 = [V2_data, label];
    V3 = [V3_data, label];
    V4 = [V4_data, label];
    
    [p,table,stats,terms] = anovan(V1(:,1), V1(:,2), 'model','interaction', 'display','on')
    fprintf('\n roi: %s, p: %f','V1',p);
    [p,table,stats,terms] = anovan(V2(:,1), V2(:,2), 'model','interaction', 'display','off');
    fprintf('\n roi: %s, p: %f','V2',p);
    [p,table,stats,terms] = anovan(V3(:,1), V3(:,2), 'model','interaction', 'display','off');
    fprintf('\n roi: %s, p: %f','V3',p);
    [p,table,stats,terms] = anovan(V4(:,1), V4(:,2), 'model','interaction', 'display','off');
    fprintf('\n roi: %s, p: %f','V4',p);
    
elseif strcmp(opt.compare,'patientsSeparate')
    
    V1_data = [D(1,1:numSub_ptH,1)';D(2,1:numSub_ptNH,1)';D(3,1:numSub_HC,1)'];
    V2_data = [D(1,1:numSub_ptH,2)';D(2,1:numSub_ptNH,2)';D(3,1:numSub_HC,2)'];
    V3_data = [D(1,1:numSub_ptH,3)';D(2,1:numSub_ptNH,3)';D(3,1:numSub_HC,3)'];
    V4_data = [D(1,1:numSub_ptH,4)';D(2,1:numSub_ptNH,4)';D(3,1:numSub_HC,4)'];
    
    label = patient';
    
    
    V1 = [V1_data, label];
    V2 = [V2_data, label];
    V3 = [V3_data, label];
    V4 = [V4_data, label];
    
    [p,table,stats,terms] = anovan(V1(:,1), V1(:,2), 'model','interaction', 'display','on');
    fprintf('\n roi: %s, p: %f','V1',p);
    [p,table,stats,terms] = anovan(V2(:,1), V2(:,2), 'model','interaction', 'display','off');
    fprintf('\n roi: %s, p: %f','V2',p);
    [p,table,stats,terms] = anovan(V3(:,1), V3(:,2), 'model','interaction', 'display','off');
    fprintf('\n roi: %s, p: %f','V3',p);
    [p,table,stats,terms] = anovan(V4(:,1), V4(:,2), 'model','interaction', 'display','off');
    fprintf('\n roi: %s, p: %f','V4',p);
    
    
    
    % separate paremeter values into different rois
    V1 = [D(1,:,1)',D(2,:,1)',D(3,:,1)'];
    V2 = [D(1,:,2)',D(2,:,2)',D(3,:,2)'];
    V3 = [D(1,:,3)',D(2,:,3)',D(3,:,3)'];
    V4 = [D(1,:,4)',D(2,:,4)',D(3,:,4)'];
    
end
% 
% 
% fprintf('\n V1 \n');
% 
% p = anova1(V1)
% 
% if p < 0.05
%     % t test for individual rois
%     [~,p,~,stats]= ttest2(V1(:,1),V1(:,2))
%     [~,p,~,stats]= ttest2(V1(:,2),V1(:,3))
%     [~,p,~,stats]= ttest2(V1(:,1),V1(:,3))
% end
% 
% 
% 
% fprintf('\n V2 \n');
% 
% if p < 0.05
%     % t test for individual rois
%     [~,p,~,stats]= ttest2(V2(:,1),V2(:,2))
%     [~,p,~,stats]= ttest2(V2(:,2),V2(:,3))
%     [~,p,~,stats]= ttest2(V2(:,1),V2(:,3))
% end
% 
% 
% 
% p = anova1(V2)
% 
% fprintf('\n V3 \n');
% 
% if p < 0.05
%     % t test for individual rois
%     [~,p,~,stats]= ttest2(V3(:,1),V3(:,2))
%     [~,p,~,stats]= ttest2(V3(:,2),V3(:,3))
%     [~,p,~,stats]= ttest2(V3(:,1),V3(:,3))
% end
% 
% 
% 
% p = anova1(V3)
% 
% fprintf('\n V4 \n');
% 
% p = anova1(V4)
% 
% if p < 0.05
%     % t test for individual rois
%     [~,p,~,stats]= ttest2(V4(:,1),V4(:,2))
%     [~,p,~,stats]= ttest2(V4(:,2),V4(:,3))
%     [~,p,~,stats]= ttest2(V4(:,1),V4(:,3))
% end
% 
% 
% 
% if verbose
%     % to plot the figures
%     figure;
%     plot(V1','o-r')
%     hold on
%     plot(V2','o-g')
%     plot(V3','o-b')
%     plot((mean(V1)/3)*patient(get)','o-k')
% end



end
