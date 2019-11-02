function SZ_pA_subAveAve_surroundDog

yAxis = 'DoGs Surround size';
yl = [0 40];

yl_auc = [0 300];

if cond_idx==1
    idx_surSizeGr0_p1 = Cond_model{1,roi_comp}{1,sub_idx}.DoGs_surroundSize ~= 0;
    x_param_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.ecc(idx_surSizeGr0_p1);
    y_param_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.DoGs_surroundSize(idx_surSizeGr0_p1);
    ve_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.varexp(idx_surSizeGr0_p1);
    if opt.verbose
        if opt.plot.dist
            figure(1), subplot(n_rows,n_cols,sub_idx); hold on;
            plot(x_param_comp_1,y_param_comp_1,'.','color',[0.5+(roi_idx/10), 0.5, 1-(roi_idx/10)],'MarkerSize',10);
            xlabel('eccentricity'); ylabel('pRF size');
            ylim([0 inf]);
        end
    end
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
            end
        end
    end
elseif cond_idx==2
    idx_surSizeGr0_p2 = Cond_model{2,roi_comp}{1,sub_idx}.DoGs_surroundSize ~= 0;
    x_param_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.ecc(idx_surSizeGr0_p2);
    y_param_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.DoGs_surroundSize(idx_surSizeGr0_p2);
    ve_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.varexp(idx_surSizeGr0_p2);
    if opt.verbose
        if opt.plot.dist
            figure(10); subplot(n_rows,n_cols,sub_idx);hold on;
            plot(x_param_comp_2,y_param_comp_2,'.','color',[0.5+(roi_idx/10) 1-(roi_idx/10) 0.5+(roi_idx/10)],'MarkerSize',10);
            xlabel('eccentricity'); ylabel('pRF size');
            ylim([0 inf]);
        end
    end
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
        end
    end
elseif cond_idx==3
    idx_surSizeGr0_p3 = Cond_model{3,roi_comp}{1,sub_idx}.DoGs_surroundSize ~= 0;
    x_param_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.ecc(idx_surSizeGr0_p3);
    y_param_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.DoGs_surroundSize(idx_surSizeGr0_p3);
    ve_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.varexp(idx_surSizeGr0_p3);
    if opt.verbose
        if opt.plot.dist
            figure(100); subplot(n_rows,n_cols,sub_idx); hold on;
            plot(x_param_comp_3,y_param_comp_3,'.','color',[1-(roi_idx/10) 0.5+(roi_idx/10) 0.5],'MarkerSize',10);
            xlabel('eccentricity'); ylabel('pRF size');
            ylim([0 inf]);
        end
    end
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
        end
    end
end
