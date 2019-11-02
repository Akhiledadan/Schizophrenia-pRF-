function SZ_pA_subAveAve_surroundDepthDog()

yAxis = 'DoGs Surround depth';
yl = [0 1];

yl_auc = [0 inf];

if cond_idx==1
    idx_surDepthGr0_p1 = Cond_model{1,roi_comp}{1,sub_idx}.DoGs_surr_depth ~= 0;
    x_param_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.ecc(idx_surDepthGr0_p1);
    y_param_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.DoGs_surr_depth(idx_surDepthGr0_p1);
    ve_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.varexp(idx_surDepthGr0_p1);
    
    % remove outliers for the surround depth,
    % (surDepth > mean + 2*std) should be
    % removed ?
    y_param_1_avg = mean(y_param_comp_1);
    y_param_1_std = std(y_param_comp_1);
    outL_idx = y_param_comp_1 > y_param_1_avg + 2*y_param_1_std;
    y_param_comp_1 = y_param_comp_1(~outL_idx);
    x_param_comp_1 = x_param_comp_1(~outL_idx);
    ve_comp_1 = ve_comp_1(~outL_idx);
    
    if opt.verbose
        if opt.plot.dist
            figure(1), subplot(n_rows,n_cols,sub_idx); hold on;
            plot(x_param_comp_1,y_param_comp_1,'.','color',[0.5+(roi_idx/10), 0.5, 1-(roi_idx/10)],'MarkerSize',10);
            xlabel('eccentricity'); ylabel('pRF surround depth');
            ylim([0 1]);
        end
    end
    
    
    % average the surround depth across the
    % whole subjects and eccentricities
    % weighted with variance explained
    y_param_comp_1_avg = wstat(y_param_comp_1,ve_comp_1);
    y_param_comp_1_avg_all.val(:,sub_idx,roi_idx) = y_param_comp_1_avg.mean;
    
    [param_comp_1_yfit,b] = NP_fit(x_param_comp_1,y_param_comp_1,ve_comp_1,xfit);
    param_comp_1_yfit_all.val(:,sub_idx,roi_idx) = param_comp_1_yfit;
    
    % Bootstrap the data and bin the x parameter
    [param_comp_1_data,param_comp_1_b_xfit,param_comp_1_b_upper,param_comp_1_b_lower] = NP_bin_param(x_param_comp_1,y_param_comp_1,ve_comp_1,xfit_range);
    param_comp_1_b_xfit_all.val(:,sub_idx,roi_idx) = param_comp_1_data.x'  ; param_comp_1_data_all.val(:,sub_idx,roi_idx) = param_comp_1_data.y;
    if opt.verbose
        if opt.plot.fitComp
            figure(1000+roi_idx);
            plot(xfit,param_comp_1_yfit,'color',[0.4 0.4 1],'LineWidth',1); hold on;
            if b.p(1)<0
                fprintf('sub: %d cond: %d roi: %d \n',sub_idx,cond_idx,roi_idx);
                plot(xfit,param_comp_1_yfit,'k','LineWidth',1); hold on;
                ylim([0 1]);
            end
        end
    end
elseif cond_idx==2
    idx_surDepthGr0_p2 = Cond_model{2,roi_comp}{1,sub_idx}.DoGs_surr_depth ~= 0;
    x_param_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.ecc(idx_surDepthGr0_p2);
    y_param_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.DoGs_surr_depth(idx_surDepthGr0_p2);
    ve_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.varexp(idx_surDepthGr0_p2);
    
    % remove outliers for the surround depth,
    % (surDepth > mean + 2*std) should be
    % removed ?
    y_param_2_avg = mean(y_param_comp_2);
    y_param_2_std = std(y_param_comp_2);
    outL_idx = y_param_comp_2 > y_param_2_avg + 2*y_param_2_std;
    y_param_comp_2 = y_param_comp_2(~outL_idx);
    x_param_comp_2 = x_param_comp_2(~outL_idx);
    ve_comp_2 = ve_comp_2(~outL_idx);
    
    if opt.verbose
        if opt.plot.dist
            figure(10); subplot(n_rows,n_cols,sub_idx);hold on;
            plot(x_param_comp_2,y_param_comp_2,'.','color',[0.5+(roi_idx/10) 1-(roi_idx/10) 0.5+(roi_idx/10)],'MarkerSize',10);
            xlabel('eccentricity'); ylabel('pRF surround depth');
            ylim([0 1]);
        end
    end
    
    % average the surround depth across the
    % whole subjects and eccentricities
    % weighted with variance explained
    y_param_comp_2_avg = wstat(y_param_comp_2,ve_comp_2);
    y_param_comp_2_avg_all.val(:,sub_idx,roi_idx) = y_param_comp_2_avg.mean;
    
    [param_comp_2_yfit,b] = NP_fit(x_param_comp_2,y_param_comp_2,ve_comp_2,xfit);
    param_comp_2_yfit_all.val(:,sub_idx,roi_idx) = param_comp_2_yfit;
    
    [param_comp_2_data,param_comp_2_b_xfit,param_comp_2_b_upper,param_comp_2_b_lower] = NP_bin_param(x_param_comp_2,y_param_comp_2,ve_comp_2,xfit_range);
    param_comp_2_b_xfit_all.val(:,sub_idx,roi_idx) = param_comp_2_data.x'  ; param_comp_2_data_all.val(:,sub_idx,roi_idx) = param_comp_2_data.y;
    if opt.verbose
        if opt.plot.fitComp
            figure(1000+roi_idx);
            plot(xfit,param_comp_2_yfit,'color',[0.4 1 0.4],'LineWidth',1); hold on;
            if b.p(1)<0
                fprintf('sub: %d cond: %d roi: %d \n',sub_idx,cond_idx,roi_idx);
                plot(xfit,param_comp_2_yfit,'k','LineWidth',1); hold on;
            end
            ylim([0 1]);
        end
    end
elseif cond_idx==3
    idx_surDepthGr0_p3 = Cond_model{3,roi_comp}{1,sub_idx}.DoGs_surr_depth ~= 0;
    x_param_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.ecc(idx_surDepthGr0_p3);
    y_param_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.DoGs_surr_depth(idx_surDepthGr0_p3);
    ve_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.varexp(idx_surDepthGr0_p3);
    
    % remove outliers for the surround depth,
    % (surDepth > mean + 2*std) should be
    % removed ?
    y_param_3_avg = mean(y_param_comp_3);
    y_param_3_std = std(y_param_comp_3);
    outL_idx = y_param_comp_3 > y_param_3_avg + 2*y_param_3_std;
    y_param_comp_3 = y_param_comp_3(~outL_idx);
    x_param_comp_3 = x_param_comp_3(~outL_idx);
    ve_comp_3 = ve_comp_3(~outL_idx);
    
    if opt.verbose
        if opt.plot.dist
            figure(100); subplot(n_rows,n_cols,sub_idx); hold on;
            plot(x_param_comp_3,y_param_comp_3,'.','color',[1-(roi_idx/10) 0.5+(roi_idx/10) 0.5],'MarkerSize',10);
            xlabel('eccentricity'); ylabel('pRF surround depth');
            ylim([0 1]);
        end
    end
    
    % average the surround depth across the
    % whole subjects and eccentricities
    % weighted with variance explained
    y_param_comp_3_avg = wstat(y_param_comp_3,ve_comp_3);
    y_param_comp_3_avg_all.val(:,sub_idx,roi_idx) = y_param_comp_3_avg.mean;
    
    [param_comp_3_yfit,b] = NP_fit(x_param_comp_3,y_param_comp_3,ve_comp_3,xfit);
    param_comp_3_yfit_all.val(:,sub_idx,roi_idx) = param_comp_3_yfit;
    
    [param_comp_3_data,param_comp_3_b_xfit,param_comp_3_b_upper,param_comp_3_b_lower] = NP_bin_param(x_param_comp_3,y_param_comp_3,ve_comp_3,xfit_range);
    param_comp_3_b_xfit_all.val(:,sub_idx,roi_idx) = param_comp_3_data.x'  ; param_comp_3_data_all.val(:,sub_idx,roi_idx) = param_comp_3_data.y;
    if opt.verbose
        if opt.plot.fitComp
            figure(1000+roi_idx);
            plot(xfit,param_comp_3_yfit,'color',[1 0.4 0.4],'LineWidth',1); hold on;
            
            if b.p(1)<0
                fprintf('sub: %d cond: %d roi: %d \n',sub_idx,cond_idx,roi_idx);
                plot(xfit,param_comp_3_yfit,'k','LineWidth',1); hold on;
            end
            ylim([0 1]);
        end
    end
end
