% Make pRF illustrations if required

fH1 =  figure(1);
set(gcf,'position',[66,1,1855,1001],'PaperPositionMode', 'auto');
plot([fliplr(y) y],'color',[1 0.25 0.25],'lineWidth',10);
axis off;

dirPth.saveDirMSFigures = fullfile(SZ_rootPath,'data','MS');
saveDirMS = fullfile(dirPth.saveDirMSFigures,'pRFsizeillustrations');
if ~exist(saveDirMS,'dir')
    mkdir(saveDirMS);
end
fullFileName = 'cs';
print(fH1, fullfile(saveDirMS,fullFileName), '-depsc2');

% 2D gaussian illustration

