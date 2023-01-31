
function [pos,ot]=MyFit(y,vars,val_type,model_type)

u=vars';



% initialize simulations
ntrials = size(u,2);
g_fname = @g_SubjUtil;
phi = [1;0.5;-1]; %For sim/not fit


% Build options and dim structures for model inversion
dim.n_theta = 0; %number of evoluation model parameters
dim.n_phi = 0; %number of observation model parameters **
dim.n = 0; %number of hidden states
dim.p = 1; %number of expected observations
dim.n_t = ntrials;
options.sources = struct('type',1 ,'out', 1); % one binomial observation;
options.DisplayWin = 0;

%% ALL MODELS INPUT:
in.ind.prob = [1;3]; % index of offer probability left and right (u)
in.ind.R = [2;4]; % index of expected reward  for offer left and right (u)

in.model=model_type;
in.val_type=val_type;
%% model specific input: %Switch around based on model

if strcmp(in.model,'EP_ER')
    
    if strcmp(in.val_type,'weighted')
        in.ind.logb=1;
        in.ind.integration_weight=2;

        dim.n_phi=2;
    else
        in.ind.logb=1;
        dim.n_phi=1;
    end
    
elseif strcmp(in.model,'SP_SR')
    in.ind.util_weight=1; %Index of slope for utility weighting
    in.ind.gamma=2; %index of gamma term for prelec probability weighting
    if strcmp(in.val_type,'weighted')
        in.ind.logb=3;
        in.ind.integration_weight=4;

        dim.n_phi=4;
        
    else
        in.ind.logb=3;
        
        dim.n_phi=3;
        
    end
elseif strcmp(in.model,'SP_ER')
        in.ind.gamma=1; %index of gamma term for prelec probability weighting
        if strcmp(in.val_type,'weighted')
            in.ind.logb=2;
            in.ind.integration_weight=3;
            
            dim.n_phi=3;
            
        else
            in.ind.logb=2;
            
            dim.n_phi=2;
            
        end
        
elseif strcmp(in.model,'EP_SR')
    in.ind.util_weight=1; %Index of slope for utility weighting
    
    if strcmp(in.val_type,'weighted')
        in.ind.logb=2;
        in.ind.integration_weight=3;
        
        dim.n_phi=3;
        
    else
        in.ind.logb=2;
        
        dim.n_phi=2;
        
    end
    
end

in.choice_model='temperature';


options.inG = in;
options.dim = dim;

%             [posterior,out] = VBA_PRESS(y',u,[],g_fname,dim,options)
            
[pos,ot] = VBA_NLStateSpaceModel(y',u,[],g_fname,dim,options);
end