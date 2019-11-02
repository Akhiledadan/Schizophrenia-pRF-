function opt = SZ_getOpts(varargin)
% Function to get struct with default analysis pipeline options for MEG
% Retinotopy project. In case you want to change the default, use following
% example:
%
% Example 1:
%   opt = getOpts('verbose', false)
% Example 2:
%   opt = getOpts('foo', true)


% --- GENERAL ---
opt.verbose                = true;          % General
opt.doSaveData             = true;           % General
opt.saveFig                = true;           % General
opt.saveRes                = true;          % General
opt.extractPrfParams       = false;
opt.expAnalysis            = false;
opt.excludeSub             = false;

opt.getTimeSeries          = true;
opt.getPredictedResponse   = true;
opt.plotTimeSeries         = true;
opt.recomputeTimeSeries    = false;

opt.saveFigTseries         = true;
opt.plotSigRatio           = false;
opt.detailedPlot           = false;

opt.saveMsFigures          = true;


opt.subjectsToExclude.ptH  = [];
opt.subjectsToExclude.ptNH = [];
opt.subjectsToExclude.HC   = [{'304','305','314'}]; % determined by r

% opt.subjectsToExclude.ptH        = [{'100','101','102','103','104','106','109','110','111','112','114'}];
% opt.subjectsToExclude.ptNH       = [{'200','201','202','203','204','205','206','207','208','209','210','211','212','218'}];
% opt.subjectsToExclude.HC         = [{'301','304','305','306','307','309','310','312','313','314','315','316'}]; % determined by r


opt.subjects.ptHAll        = [{'100','101','102','103','104','106','109','110','111','112','114'}];
opt.subjects.ptNHAll       = [{'200','201','202','203','204','205','206','207','208','209','210','211','212','218'}];
opt.subjects.HCAll         = [{'301','302','304','305','306','307','309','310','312','313','314','315','316'}];

opt.subjects.ptH        = setdiff(opt.subjects.ptHAll,opt.subjectsToExclude.ptH);
opt.subjects.ptNH       = setdiff(opt.subjects.ptNHAll,opt.subjectsToExclude.ptNH);
opt.subjects.HC         = setdiff(opt.subjects.HCAll,opt.subjectsToExclude.HC);


% Select the ROIs
%opt.rois = {'V1';'V2';'V3'};
opt.rois = {'V1';'V2';'V3';'WangAtlas_hV4'};
%rois = {'WangAtlas_V1v';'WangAtlas_V2v';'WangAtlas_V3v'};

% Define the different conditions to be compared
opt.conditions = [{'SZ-VH'};{'SZ-nVH'};{'HC'}];

opt.dataType = 'Averages';

opt.modelDoG = 'DoGs_V1234_limitSigRatioSigMaxVal-fFit-combined.mat';
opt.model2DG = 'SZ_1G-fFit.mat';

% --- model parameters ---
opt.modelType = '2DGaussian';
%opt.modelType = 'DoGs';
opt.varExpThr = 0.3;
opt.eccThr = [1 9.21];
opt.meanMapThr = 80;
opt.sig2Lim = true;

opt.cenEcc     = (opt.eccThr(2) - opt.eccThr(1))./2;

% --- plot types ---
%opt.plotType = 'Ecc_Sig';
opt.plotType = 'Ecc_Sig_fwhm_DoGs';
%opt.plotType = 'Ecc_SurSiz_DoGs';

% --- plot params ---
opt.plot.dist = true;
opt.plot.fitComp = true;
opt.plot.auc = true;

% --- analysis types ---
opt.analysis = 'subave_Ave';


opt.binType = 'Eq_size';


opt.AUC           = true;
opt.aucDifference = false;
opt.aucBootstrap  = false;

opt.CEN           = true;
opt.cenDifference = false;
opt.cenBootstrap  = false;


% figure axis limits
% for figure 2
opt.yLimTs = [-6 6];
opt.xLimTs = [0 200];

% for figure 4
opt.xLimAve = [0 10];
opt.yLimAve = [0 5];

% for figure 5 
opt.yaxislimCen = [-inf inf]; % in percentage
%opt.yaxislimCen = [0 0.2].*100; % in percentage
opt.xaxislimCen = [0 length(opt.rois)+1];


%% Check for extra inputs in case changing the default options
if exist('varargin', 'var')
    
    % Get fieldnames
    fns = fieldnames(opt);
    for ii = 1:2:length(varargin)
        % paired parameter and value
        parname = varargin{ii};
        val     = varargin{ii+1};
        
        % check whether this parameter exists in the defaults
        idx = cellfind(fns, parname);
        
        % if so, replace it; if not add it to the end of opt
        if ~isempty(idx), opt.(fns{idx}) = val;
        else, opt.(parname) = val; end
        
        
    end
end

%% exclude subjects if asked to 

if opt.excludeSub
    dirPth = SZ_loadPaths;
    
    modelData = SZ_getModelParams(opt,dirPth);
    
    % To remove subjects who are outliers.
    exclusionCriteria = SZ_pRFsizeEcc(modelData,opt,dirPth);


    
    opt = SZ_excludeSub(opt,exclusionCriteria);
    
    opt.subjects.ptHAll        = [{'100','101','102','103','104','106','109','110','111','112','114'}];
    opt.subjects.ptNHAll       = [{'200','201','202','203','204','205','206','207','208','209','210','211','212','218'}];
    opt.subjects.HCAll         = [{'301','302','304','305','306','307','309','310','312','313','314','315','316'}];
    
    opt.subjects.ptH           = [];
    opt.subjects.ptNH          = [];
    opt.subjects.HC            = [];
    
    opt.subjects.ptH        = setdiff(opt.subjects.ptHAll,opt.subjectsToExclude.ptH);
    opt.subjects.ptNH       = setdiff(opt.subjects.ptNHAll,opt.subjectsToExclude.ptNH);
    opt.subjects.HC         = setdiff(opt.subjects.HCAll,opt.subjectsToExclude.HC);
    
%     opt.subjects.ptH           = opt.subjects.ptHAll(opt.subjects.ptHIds);
%     opt.subjects.ptNH          = opt.subjects.ptNHAll(opt.subjects.ptNHIds);
%     opt.subjects.HC            = opt.subjects.HCAll(opt.subjects.HCIds);

       
end

end