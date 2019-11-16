function pred = SZ_computePredictedResponse(params,model,opt)
% SZ_getPredictedResponse - calculate predicted response for every voxel
% from the given roi and condition
%
% input : stim  - stimulus parameters
%         model - model parameters - should have sigma, x,y and beta
% output: pred  - predicted reponse (eg: 240 x #voxels timeseries)
%
% Author: Akhil Edadan <a.edadan@uu.nl>, 2019

if strcmpi(opt.modelType,'2DGaussian')
    
    X  = params.analysis.X;
    Y  = params.analysis.Y;
    sigma  = model.sigma;
    theta  = 0;
    x      = model.x;
    y      = model.y;
    gauss  = rfGaussian2d(X,Y,sigma,sigma,theta,x,y); % make the gaussian from the model
    beta   = model.beta;
    betaDC = model.betaDC;
    % first scale all the pRFs with their betas and then convolve it with the
    % stimulus
    pRFs         = gauss(:,:);
    scaledPrfs   = repmat(beta, [size(pRFs, 1) 1]) .* pRFs;
    pred         = ((scaledPrfs' * params.analysis.allstimimages')) + repmat(betaDC', [1 size(params.analysis.allstimimages', 2)]);
    
    
elseif strcmpi(opt.modelType,'DoGs')
       
    X  = params.analysis.X;
    Y  = params.analysis.Y;
    sigma1  = model.sigma;
    sigma2  = model.sigma2;
    theta  = 0;
    x      = model.x;
    y      = model.y;

    RFs     = RFs * (beta(1:2).*M.params.analysis.HrfMaxResponse);
    
    beta1   = model.beta;
    beta2   = model.beta2;
    betaDC  = model.betaDC;
    
    
    % positive gaussian
    gauss1  = rfGaussian2d(X,Y,sigma1,sigma1,theta,x,y); % make the gaussian from the model
    gauss2  = rfGaussian2d(X,Y,sigma2,sigma2,theta,x,y); % make the gaussian from the model
     
    %y = beta1(k).*exp((x.^2)./(-2*(sigma(k).^2)))+beta2(k).*exp((x.^2)./(-2*(sigma2(k).^2)));
    
    % first scale all the pRFs with their betas and then convolve it with the
    % stimulus
    pRFs1         = gauss1(:,:);
    pRFs2         = gauss2(:,:);
    
    pred1 = (pRFs1' * params.analysis.allstimimages');
    pred2 = (pRFs2' * params.analysis.allstimimages');
    
    pred = [pred1 pred2 ones(size(pred1))] * [beta1 beta2];
    
    scaledPrfs1   = (repmat(beta1, [size(pRFs1, 1) 1]) .* pRFs1);
    scaledPrfs2   = (repmat(beta2, [size(pRFs2, 1) 1]) .* pRFs2);
    
    
    
    pred         = ((pRFs1' * params.analysis.allstimimages') + ((pRFs2' * params.analysis.allstimimages')));
    
    
end

end