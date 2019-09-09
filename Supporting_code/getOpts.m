function opt = getOpts(varargin)
% Function to get struct with default analysis pipeline options for MEG
% Retinotopy project. In case you want to change the default, use following
% example:
%
% Example 1:
%   opt = getOpts('verbose', false)
% Example 2:
%   opt = getOpts('foo', true)


% --- GENERAL ---
opt.verbose               = true;          % General
opt.doSaveData            = true;           % General
opt.saveFig               = true;           % General
opt.saveRes               = true;          % General
opt.extractPrfParams      = false;

% --- model parameters ---
opt.modelType = '2DGaussian';
%opt.modelType = 'DoGs';
opt.varExpThr = 0.2;
opt.eccThr = [1 9.21];
opt.meanMapThr = 80;

% --- plot types ---
opt.plotType = 'Ecc_Sig';
%opt.plotType = 'Ecc_Sig_fwhm_DoGs';
%opt.plotType = 'Ecc_SurSiz_DoGs';

% --- plot params ---
opt.plot.dist = true;
opt.plot.fitComp = true;
opt.plot.auc = true;

% --- analysis types ---
opt.analysis = 'subave_Ave';


opt.AUC = true;

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

end