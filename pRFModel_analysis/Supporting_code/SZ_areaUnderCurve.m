function auc = SZ_areaUnderCurve(ii,x,y,ve)
% function that fits a line from the     
if isstruct(x) || isstruct(y) || isstruct(ve) 
    x_b = []; y_b = []; ve_b = [];
    for idx = 1:length(ii)
        x_b = [x_b x(ii(idx)).data];
        y_b = [y_b y(ii(idx)).data];
        ve_b = [ve_b ve(ii(idx)).data];
    end
    B = linreg(x_b,y_b,ve_b);
else
    B1 = linreg(x,y(ii,1),ve(ii,1));
 %   B2 = linreg(x(ii,2),y(ii,2),ve(ii,2));
end
    
%B = linreg(x(ii),y(ii),ve(ii));
B1(:);
yHat1 = [ones(size(x,1),1) x] * B1';
auc = trapz(x,yHat1);

% B2(:);
% yHat2 = [ones(size(x,1),1) x(:,2)] * B2';
% auc2 = trapz(x(:,2),yHat2);

%auc_diff = auc1 - auc2;

%if auc_diff<0
 
%   hold on;  plot(x,yHat1); 
   %hold on; plot(x(:,2),yHat2(:,1),'r');
%end

% this function should take y1 and y2; compute (auc1)-(auc2)
% for every iteration (1000 values)

end