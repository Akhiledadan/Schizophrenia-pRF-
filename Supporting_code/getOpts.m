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
opt.verbose               = false;          % General
opt.doSaveData            = true;           % General
opt.saveFig               = true;           % General
opt.saveRes               = false;            % General

% --- model parameters ---
opt.modelType = 'DoGs';
opt.varExpThr = 0.2;
opt.eccThr = [1 9.21];
opt.meanMapThr = 80;

% --- plot types ---
%opt.plotType = 'Ecc_Sig';
%opt.plotType = 'Ecc_Sig_fwhm_DoGs';
opt.plotType = 'Ecc_SurSiz_DoGs';

% --- analysis types ---
opt.analysis = 'subave_Ave';

end