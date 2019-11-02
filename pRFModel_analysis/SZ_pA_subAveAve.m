function SZ_pA_subAveAve(modelData,opt,dirPth)
% SZ_pA_subAveAVe - pRF comparison analysis (pA) for schizophrenia (SZ)
% project - 
% 
% pRF size values are averaged across subjects (average of ind
% subjects are calculated first and an average of the averages are computed
% thereafter. 
%
% inputs - modelData : variable containing modelling results 
%          opt       :    
%          dirPth    : 
% 
% 07/10/2019: written by Akhil Edadan (a.edadan@uu.nl)

cur_time = dirPth.saveDirResTime;

% identify prf parameters that has to be compared
[params_comp,opt] = SZ_prfParametersToCompare(modelData,opt,dirPth);

% figures - raw, fit, bin, auc - for individual subjects
[params_comp,opt] = SZ_pA_plotParameters(params_comp,opt,dirPth);

% makeFigure 5A - AUC and central value calculated by fitting
% individual subjects separately and then averaging 

makeFigure5A(params_comp,dirPth,opt);

% figures - raw, fit, bin, auc - average across subjects 
[params_comp,opt] = SZ_pA_plotParameters_aveSub(params_comp,opt,dirPth);

%% save results
if opt.saveRes
        
    dirPth.saveDirPrfParamsComp = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
    saveDir  = dirPth.saveDirPrfParamsComp;
    if ~exist('saveDir','dir')
        mkdir(saveDir);
    end
    
    filename_res = 'params_comp.mat';
    save(fullfile(dirPth.saveDirPrfParamsComp,filename_res),'params_comp','opt');
         
    dirPth.saveDirPrfParamsCompStats = fullfile(dirPth.saveDirRes,'stats',strcat(opt.modelType,'_',opt.plotType));
    saveDir = dirPth.saveDirPrfParamsCompStats;
    if ~exist('saveDir','dir')
        mkdir(saveDir);
    end
    
    filename_res = sprintf('params_comp_stats_%s_%s.mat',opt.modelType,opt.plotType);
    auc = params_comp.auc;
    central = params_comp.cen;
    save(fullfile(dirPth.saveDirPrfParamsCompStats,filename_res),'auc','central');

    
end

end