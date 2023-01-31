function [gx] = g_SubjUtil(x,P,u,in)
% Fitting linear/nonlienar utility and probability weighting functions

prob = u(in.ind.prob);
R = u(in.ind.R);

switch in.model
    case 'EP_ER'
        %needs: util_weight
        probX = prob;
        rewardX = R;
    case 'SP_ER'
        %needs: util_weight
        probX = prelec(prob,P(in.ind.gamma)); %Weighted probability using prelect functions
        rewardX = R;
    case 'EP_SR'
        %needs: util_weight
        probX = prob; %Weighted probability using prelect functions
        rewardX = R.^P(in.ind.util_weight);
        
        
    case 'SP_SR'
        %needs: util_weight, gamma
        
        probX = prelec(prob,P(in.ind.gamma)); %Weighted probability using prelect functions
        rewardX=R.^P(in.ind.util_weight);
        
    case 'empty'
        
end

%which type of value computation, pure or not
if strcmp(in.val_type,'optimal')
    v=probX.*rewardX;
elseif strcmp(in.val_type,'additive')
    v=probX+rewardX;
elseif strcmp(in.val_type,'weighted')
    v=P(in.ind.integration_weight).*(probX.*rewardX)+(1-P(in.ind.integration_weight)).*(probX+rewardX);
end

%Compute value difference
dv = v(1) - v(2);

%% which type of choice model to use
if strcmp(in.choice_model,'temperature')
    b = exp(-P(in.ind.logb)); % exp: [-Inf,Inf] -> [0 Inf] for -log temperature (sigma of softmax)
    gx = VBA_sigmoid(b.*dv);
    
else
    
end
end

function [pw]=prelec(prob,gamma)
%local private to g_SubjUtil
pw=exp(-(-log(prob)).^gamma);
end