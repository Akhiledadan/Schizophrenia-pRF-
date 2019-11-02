function SZ_pA_allTog(Cond_model,ROI_params,opt,dirPth)


%conditions = {'Averages'};
conditions = opt.conditions;
numCond = length(conditions);

% Plot params
MarkerSize = 3;

rois = opt.rois;
num_roi = length(rois);
roi_fname = cell(num_roi,numCond,1);

cur_time = dirPth.saveDirResTime;

%% Plots
% Plot raw data and the fits
param_comp_diff_data_cen_allroi = nan(num_roi,1);
param_comp_diff_data_cen_allroi_up = nan(num_roi,1);
param_comp_diff_data_cen_allroi_lo = nan(num_roi,1);
param_comp_diff_data_cen_allroi_bin = nan(num_roi,1);

param_comp_diff_data_auc_allroi = nan(num_roi,1);

for roi_idx = 1:num_roi
    
    roi_comp = ROI_params.rois{roi_idx};
    
    data_comp_1 = Cond_model{1,1}{1};
    data_comp_2 = Cond_model{2,1}{1};
    data_comp_3 = Cond_model{3,1}{1};
    
    %   data_comp_1(data_comp_1 == '_') = ' ';
    %data_comp_2(data_comp_2 == '_') = ' ';
    
    % Choose the pRF parameters to compare
    switch plotType
        
        case 'Ecc_Sig'
            x_param_comp_1 = [];
            x_param_comp_2 = [];
            x_param_comp_3 = [];
            
            y_param_comp_1 = [];
            y_param_comp_2 = [];
            y_param_comp_3 = [];
            
            ve_comp_1 = [];
            ve_comp_2 = [];
            ve_comp_3 = [];
            
            
            num_sub_comp_1 = Cond_model.numSubjects(1);
            for sub_idx= 1:num_sub_comp_1
                x_param_comp_1 = [x_param_comp_1 Cond_model{1,roi_comp}{1,sub_idx}.ecc];
                y_param_comp_1 = [y_param_comp_1 Cond_model{1,roi_comp}{1,sub_idx}.sigma];
                
                ve_comp_1 = [ve_comp_1 Cond_model{1,roi_comp}{1,sub_idx}.varexp];
            end
            
            num_sub_comp_2 = Cond_model.numSubjects(2);
            for sub_idx= 1:num_sub_comp_2
                x_param_comp_2 = [x_param_comp_2 Cond_model{2,roi_comp}{1,sub_idx}.ecc];
                y_param_comp_2 = [y_param_comp_2 Cond_model{2,roi_comp}{1,sub_idx}.sigma];
                
                ve_comp_2 = [ve_comp_2 Cond_model{2,roi_comp}{1,sub_idx}.varexp];
            end
            
            num_sub_comp_3 = Cond_model.numSubjects(3);
            for sub_idx= 1:num_sub_comp_3
                x_param_comp_3 = [x_param_comp_3 Cond_model{3,roi_comp}{1,sub_idx}.ecc];
                y_param_comp_3 = [y_param_comp_3 Cond_model{3,roi_comp}{1,sub_idx}.sigma];
                
                ve_comp_3 = [ve_comp_3 Cond_model{3,roi_comp}{1,sub_idx}.varexp];
            end
            
            % Axis limits for plotting
            xaxislim = [0 10.21];
            yaxislim = [0 6];
            
            % x range values for fitting
            xfit_range = opt.eccThr;
            
        case 'Ecc_SurSize_DoGs'
            x_param_comp_1 = [];
            x_param_comp_2 = [];
            x_param_comp_3 = [];
            
            y_param_comp_1 = [];
            y_param_comp_2 = [];
            y_param_comp_3 = [];
            
            ve_comp_1 = [];
            ve_comp_2 = [];
            ve_comp_3 = [];
            
            
            num_sub_comp_1 = Cond_model.numSubjects(1);
            for sub_idx= 1:num_sub_comp_1
                idx_surSizeGr0_p1 = Cond_model{1,roi_comp}{1,sub_idx}.DoGs_surroundSize ~= 0;
                
                x_param_comp_1 = [x_param_comp_1 Cond_model{1,roi_comp}{1,sub_idx}.ecc(idx_surSizeGr0_p1)];
                y_param_comp_1 = [y_param_comp_1 Cond_model{1,roi_comp}{1,sub_idx}.DoGs_surroundSize(idx_surSizeGr0_p1)];
                
                ve_comp_1 = [ve_comp_1 Cond_model{1,roi_comp}{1,sub_idx}.varexp(idx_surSizeGr0_p1)];
            end
            
            num_sub_comp_2 = Cond_model.numSubjects(2);
            for sub_idx= 1:num_sub_comp_2
                idx_surSizeGr0_p2 = Cond_model{2,roi_comp}{1,sub_idx}.DoGs_surroundSize ~= 0;
                
                x_param_comp_2 = [x_param_comp_2 Cond_model{2,roi_comp}{1,sub_idx}.ecc(idx_surSizeGr0_p2)];
                y_param_comp_2 = [y_param_comp_2 Cond_model{2,roi_comp}{1,sub_idx}.DoGs_surroundSize(idx_surSizeGr0_p2)];
                
                ve_comp_2 = [ve_comp_2 Cond_model{2,roi_comp}{1,sub_idx}.varexp(idx_surSizeGr0_p2)];
            end
            
            num_sub_comp_3 = Cond_model.numSubjects(3);
            for sub_idx= 1:num_sub_comp_3
                idx_surSizeGr0_p3 = Cond_model{3,roi_comp}{1,sub_idx}.DoGs_surroundSize ~= 0;
                
                x_param_comp_3 = [x_param_comp_3 Cond_model{3,roi_comp}{1,sub_idx}.ecc(idx_surSizeGr0_p3)];
                y_param_comp_3 = [y_param_comp_3 Cond_model{3,roi_comp}{1,sub_idx}.DoGs_surroundSize(idx_surSizeGr0_p3)];
                
                ve_comp_3 = [ve_comp_3 Cond_model{3,roi_comp}{1,sub_idx}.varexp(idx_surSizeGr0_p3)];
            end
            
            % Axis limits for plotting
            xaxislim = [0 inf];
            yaxislim = [0 inf];
            
            % x range values for fitting
            xfit_range = opt.eccThr;
            
        case 'Pol_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.pol;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.pol;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            
            % Axis limits for plotting
            xaxislim = [0 2*pi];
            yaxislim = [0 10];
            
            % x range values for fitting
            Pol_Thr_low = 0;
            Pol_Thr = 2*pi;
            xfit_range = [Pol_Thr_low Pol_Thr];
            
        case 'X_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.x;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.x;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
        case 'Y_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.y;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.y;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
    end
    
    %%
    %---------- plot Raw data----------------%
    
    fprintf('\n Plotting raw data for roi %d \n',roi_idx);
    figName = 'prf size vs eccentricity';
    figPoint_raw = figure;set(gcf, 'Color', 'w', 'Position',[100 100 1920/2 1080/2], 'Name', figName);hold on;
    plot(x_param_comp_1,y_param_comp_1,'.','color',[0.3010, 0.7450, 0.9330]);
    hold on; plot(x_param_comp_2,y_param_comp_2,'.','color',[0.4 1 0.4]);
    hold on; plot(x_param_comp_3,y_param_comp_3,'.','color',[1 0.4 0.4]);
    % figure attributes
    %titleName = strcat(Cond_model{1,1},'and',Cond_model{2,1});
    titleall = sprintf('%s', roi_comp) ;
    title(titleall);
    %legend([{data_comp_1},{data_comp_2},{data_comp_3}]);
    xlabel('eccentricity (degrees)');
    ylabel('pRF size (degrees)');
    
    ylim(yaxislim);
    xlim(xaxislim);
    
    %hold off;
    fprintf('\n Done \n');
    
    %%
    
    %---------- Plot the fit line and mean values in the bins -----------%
    
    fprintf('\n Calculating slope and intercept for the best fitting line for the conditions for roi %d \n',roi_idx)
    
    % Do a linear regression of the two parameters weighted with the variance explained
    
    xfit = linspace(xfit_range(1),xfit_range(2),8)';
    [param_comp_1_yfit] = NP_fit(x_param_comp_1,y_param_comp_1,ve_comp_1,xfit);
    [param_comp_2_yfit] = NP_fit(x_param_comp_2,y_param_comp_2,ve_comp_2,xfit);
    [param_comp_3_yfit] = NP_fit(x_param_comp_3,y_param_comp_3,ve_comp_3,xfit);
    
    
    % Plot the fit line
    figPoint_fit = figure; set(gcf, 'Color', 'w', 'Position',[100 100 1920/2 1080/2], 'Name', figName);hold on;
    plot(xfit,param_comp_1_yfit','b','LineWidth',3); hold on;
    plot(xfit,param_comp_2_yfit','g','LineWidth',3);hold on;
    plot(xfit,param_comp_3_yfit','r','LineWidth',3);
    
    fprintf('Binning and bootstrapping the data for roi: %s \n',roi_comp)
    
    % Bootstrap the data and bin the x parameter
    [param_comp_1_data,param_comp_1_b_xfit,param_comp_1_b_upper,param_comp_1_b_lower] = NP_bin_param(x_param_comp_1,y_param_comp_1,ve_comp_1,xfit_range);
    [param_comp_2_data,param_comp_2_b_xfit,param_comp_2_b_upper,param_comp_2_b_lower] = NP_bin_param(x_param_comp_2,y_param_comp_2,ve_comp_2,xfit_range);
    [param_comp_3_data,param_comp_3_b_xfit,param_comp_3_b_upper,param_comp_3_b_lower] = NP_bin_param(x_param_comp_3,y_param_comp_3,ve_comp_3,xfit_range);
    
    %     % Plot the fit line
    %     figPoint_fit = figure;
    %     plot(param_comp_1_b_xfit,param_comp_1_data.y,'b'); hold on;
    %     plot(param_comp_2_b_xfit,param_comp_2_data.y,'g');hold on;
    %     plot(param_comp_3_b_xfit,param_comp_3_data.y,'r');
    
    hold on;
    % Plot the confidence intervals as patch
    patch([param_comp_1_b_xfit, fliplr(param_comp_1_b_xfit)], [param_comp_1_b_lower', fliplr(param_comp_1_b_upper')], [0.3010, 0.7450, 0.9330], 'FaceAlpha', 0.5, 'LineStyle','none');
    patch([param_comp_2_b_xfit, fliplr(param_comp_2_b_xfit)], [param_comp_2_b_lower', fliplr(param_comp_2_b_upper')], [0.4 1 0.4], 'FaceAlpha', 0.5, 'LineStyle','none');
    patch([param_comp_3_b_xfit, fliplr(param_comp_3_b_xfit)], [param_comp_3_b_lower', fliplr(param_comp_3_b_upper')], [1 0.4 0.4], 'FaceAlpha', 0.5, 'LineStyle','none');
    %
    %             plot(param_comp_1_b_xfit,param_comp_1_b_upper,'b--');
    %             plot(param_comp_1_b_xfit,param_comp_1_b_lower,'b--');
    %
    %             plot(param_comp_2_b_xfit,param_comp_2_b_upper,'g--');
    %             plot(param_comp_2_b_xfit,param_comp_2_b_lower,'g--');
    %
    %             plot(param_comp_3_b_xfit,param_comp_3_b_upper,'r--');
    %             plot(param_comp_3_b_xfit,param_comp_3_b_lower,'r--');
    
    hold on;
    errorbar(param_comp_1_data.x,param_comp_1_data.y,param_comp_1_data.ysterr,'bo','MarkerFaceColor','b','MarkerSize',MarkerSize);
    errorbar(param_comp_2_data.x,param_comp_2_data.y,param_comp_2_data.ysterr,'go','MarkerFaceColor','g','MarkerSize',MarkerSize);
    errorbar(param_comp_2_data.x,param_comp_3_data.y,param_comp_3_data.ysterr,'ro','MarkerFaceColor','r','MarkerSize',MarkerSize);
    
    titleall = sprintf('%s', roi_comp) ;
    title(titleall);
    legend([{data_comp_1},{data_comp_2},{data_comp_3}]);
    ylim(yaxislim);
    xlim(xaxislim);
    
    %hold off;
    
    %%
    
    %------- Plot the central values------------%
    % Calculate the central value from the fit
    % Bootstrap the data and bin the x parameter
    
    fprintf('\n Binning the data, bootstrapping the bins and caluculating the median, 97.5 and 2.5 percent confidence interval for roi %d \n',roi_idx)
    %
    fprintf('\n ************************** \n  Not finished yet \n ************************** \n');
    
    
    
    %     param_comp_1_data_cen = NP_central_val(param_comp_1_b_xfit,param_comp_1_yfit,param_comp_1_b_upper,param_comp_1_b_lower,xfit);
    % %    param_comp_2_data_cen = NP_central_val(param_comp_2_b_xfit,param_comp_2_yfit,param_comp_2_b_upper,param_comp_2_b_lower,xfit);
    %
    %     figPoint_cen = figure(3);
    %     h = bar([param_comp_1_data_cen.y,nan],'FaceColor',[0 0 1]);hold on;
    % %    bar([nan,param_comp_2_data_cen.y],'FaceColor',[0 1 0]);hold on;
    %  %   errorbar([1,2],[param_comp_1_data_cen.y,param_comp_2_data_cen.y],[param_comp_1_data_cen.y-param_comp_1_data_cen.lo,param_comp_2_data_cen.y-param_comp_2_data_cen.lo],[param_comp_1_data_cen.up-param_comp_1_data_cen.y,param_comp_2_data_cen.up-param_comp_2_data_cen.y],'k','LineStyle','none');
    %     xlim([0 3]);
    %     ylim(yaxislim);
    %     titleall = sprintf('%s', roi_comp) ;
    %     title(titleall);
    %     hold off;
    %  %   set(h.Parent,'XTickLabel',[{data_comp_1},{data_comp_2}]);
    %
    %     % Scrambled - Natural (all rois)
    %     param_comp_diff_data_cen_allroi(roi_idx) = param_comp_2_data_cen.y - param_comp_1_data_cen.y;
    %
    %
    %
    %     % Calculate the difference between sigma values, bin them and bootstrap across bins
    %     assertEqual(x_param_comp_1,x_param_comp_2);
    %     x_param_comp = x_param_comp_1;
    %
    %     [~,param_comp_b_xfit_diff,param_comp_b_upper_diff,param_comp_b_lower_diff,param_comp_b_y] = NP_bin_param(x_param_comp,((y_param_comp_2-y_param_comp_1)./((y_param_comp_2+y_param_comp_1)./2)),[],xfit);
    %
    %     param_comp_data_diff_cen = NP_central_val(param_comp_b_xfit_diff,param_comp_b_y,param_comp_b_upper_diff,param_comp_b_lower_diff,xfit);
    %     param_comp_diff_data_cen_allroi_bin(roi_idx,1) = param_comp_data_diff_cen.y;
    %     param_comp_diff_data_cen_allroi_up(roi_idx,1) = param_comp_data_diff_cen.up;
    %     param_comp_diff_data_cen_allroi_lo(roi_idx,1) = param_comp_data_diff_cen.lo;
    
    %%
    %---------Plot the Area under curve-----------%
    
    fprintf('\n Calculating the area under the curve for roi %d \n',roi_idx);
    
    fprintf('\n ************************** \n  Not finished yet \n ************************** \n');
    
    %     param_comp_1_auc = trapz(xfit_plot,param_comp_1_yfit);
    %     param_comp_2_auc = trapz(xfit_plot,param_comp_2_yfit);
    %
    %     figPoint_auc = figure(4);
    %     h = bar([param_comp_1_auc,nan],'FaceColor',[0 0 1]);hold on;
    %     bar([nan,param_comp_2_auc],'FaceColor',[0 1 0]);hold on;
    %     xlim([0 3]);
    %     ylim([0 15]);
    %     titleall = sprintf('%s', roi_comp) ;
    %     title(titleall);
    %     hold off;
    %     set(h.Parent,'XTickLabel',[{data_comp_1},{data_comp_2}]);
    %
    %     % Scrambled - Natural (all rois)
    %     param_comp_diff_data_auc_allroi(roi_idx) = param_comp_2_auc - param_comp_1_auc;
    
    
    %%
    
    %-----------------------------------------
    fprintf('\n Saving the plots for roi %d \n',roi_idx)
    
    if opt.saveFig == 1
        filename_raw = strcat(save_dir, '/', 'plot', roi_comp,'raw', '.png');
        saveas(figPoint_raw,filename_raw);
        
        filename_fit = strcat(save_dir, '/', 'plot', roi_comp,'fit', '.png');
        saveas(figPoint_fit,filename_fit);
        
        filename_cen = strcat(save_dir, '/', 'plot', roi_comp,'central', '.png');
        saveas(figPoint_cen,filename_cen);
        
        filename_auc = strcat(save_dir, '/', 'plot', roi_comp,'auc', '.png');
        saveas(figPoint_auc,filename_auc);
        
    end
    
end

% close all;
% fprintf('Plotting the difference in central values');
%
% % Scrambled - Natural
% figPoint_cen_diff = figure(31);
% h = bar(param_comp_diff_data_cen_allroi_bin,'FaceColor',[0 0 1]);hold on;
% errorbar([1:num_roi]',param_comp_diff_data_cen_allroi_bin,param_comp_diff_data_cen_allroi_bin-param_comp_diff_data_cen_allroi_lo,param_comp_diff_data_cen_allroi_up-param_comp_diff_data_cen_allroi_bin,'k','LineStyle','none');
% %xlim([0 3]);
% ylim([-0.25 0.5]);
% titleall = sprintf('Central value difference') ;
% title(titleall);
% set(h.Parent,'XTickLabel',rois);
% hold off;
%
%
% % Scrambled - Natural
% figPoint_auc_diff = figure(41);
% h = bar(param_comp_diff_data_auc_allroi,'FaceColor',[0 0 1]);
% %xlim([0 3]);
% ylim([-0.2 0.5]);
% titleall = sprintf('AUC difference') ;
% title(titleall);
% hold off;
% set(h.Parent,'XTickLabel',rois);

if opt.saveFig == 1
    filename_cen_diff = strcat(save_dir, '/', 'plot','cen_diff', '.png');
    saveas(figPoint_cen_diff,filename_cen_diff);
    
    filename_auc_diff = strcat(save_dir, '/', 'plot','auc_diff', '.png');
    saveas(figPoint_auc_diff,filename_auc_diff);
end
%% Save the plots and results

if opt.saveRes == 1
    % save the results
    save(strcat(save_dir,'/','results.mat'),'Cond_model','ROI_params');
    
end

%close all;
end