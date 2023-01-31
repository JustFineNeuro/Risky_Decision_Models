prelec=@(prob,gamma) exp(-(-log(prob)).^gamma)


areas={'OFC','PCC','pgACC','vmPFC','VS'}
for bd=1:length(areas)
    clearvars -except bd areas prelec
    load(strcat('/Users/zlab/Gdrive/Data_Sources/StagOps_Data/Behave_Neural/',areas{bd},'_Trial_Vars.mat'))
    sjname=fields(Trial_Vars.subj_ID);
    
    for sj=1:length(sjname)
        eval(['vars=Trial_Vars.subj_ID.',sjname{sj}]);
        tr=[];
        for i=1:length(vars)
            tr(i)=size(vars{i}.vars,1);
        end
        un=unique(tr);
        for nn=1:length(un)
            ners=find(tr==un(nn),1,'first'); %Find the first one in that series and fit it
            vvars=vars{ners}.vars(:,1:21);
            %Shiva estimates
            pGEst=2.95; %utility function param (power)
            gammaEst=1.57; % probability weighting param (power)
            
            
            A=prelec(vvars(:,1),gammaEst);
            B=vvars(:,2).^pGEst;
            C=A.*B;
            D=prelec(vvars(:,4),gammaEst);
            E=vvars(:,5).^pGEst;
            F=D.*E;
            
            
            y=vvars(:,9);
            
            vvars=[vvars,[A,B,C,D,E,F]];
            
            
%             rm=[find(vvars(:,[2])==1);find(vvars(:,[4])==1)];
%             y(rm)=[];
%             vvars(rm,:)=[];
            pos=MyFit(y,vvars(:,[1 2 4 5]));
            pGEst=pos.muPhi(1);
            gammaEst=pos.muPhi(2);
            
            
            A=prelec(vvars(:,1),gammaEst);
            B=vvars(:,2).^pGEst;
            C=A.*B;
            D=prelec(vvars(:,4),gammaEst);
            E=vvars(:,5).^pGEst;
            F=D.*E;
            vvars=[vvars,[A,B,C,D,E,F]];
            
            
            vidx=find(tr==un(nn));
            for vd=1:length(vidx)
                
                eval(['Trial_Vars.subj_ID.',sjname{sj},'{',num2str(vidx(vd)),'}','.vars=vvars;'])
            end
            
        end
        
    end

    
    
    save(strcat('/Users/zlab/Gdrive/Data_Sources/StagOps_Data/Behave_Neural/',areas{bd},'_Trial_Vars.mat'),'Trial_Vars')
    
    
end