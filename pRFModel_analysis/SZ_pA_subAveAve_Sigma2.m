function SZ_pA_subAveAve_Sigma2()

yAxis = 'sigma2';
yl = [0 6];
yl_auc = [0 25];

x_param_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.ecc;
y_param_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.sigma2;
ve_comp_1 = Cond_model{1,roi_comp}{1,sub_idx}.varexp;

x_param_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.ecc;
y_param_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.sigma2;
ve_comp_2 = Cond_model{2,roi_comp}{1,sub_idx}.varexp;

x_param_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.ecc;
y_param_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.sigma2;
ve_comp_3 = Cond_model{3,roi_comp}{1,sub_idx}.varexp;

end