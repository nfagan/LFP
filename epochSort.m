function [epochS,epochB,epochO,epochN] = epochSort(folders,trialVarData,plexonTime);
% Function reads in trial variables and sorts epochs by choice outcome
epochS{1}=[]; epochB{1}=[]; epochO{1}=[]; epochN{1}=[];
for b=1:length(folders), %repeat n times for number of data files
    for c=1:length(trialVarData{b}(:,1)), %repeat n times for number of trials per data file
        if trialVarData{b}(c,2)==1 % if choice trial
            if trialVarData{b}(c,5)==0 %if self as "target" trial
                if trialVarData{b}(c,8)==0 % no choice made or fixation fail
                    %selfBothError(b,trialVarData{b}(c,9))=selfBothError(b,trialVarData{b}(c,9))+1;                 
                elseif trialVarData{b}(c,8)==1 % monkey chooses target (SELF)                    
                    epochS{b} = epochS{b}( length(epochS{b}(:,1))+1 , [LFP(plexonTime{b}(c(1)) : plexonTime{b}(c(4)) )]); %Add new row containing epoch for self choice
                elseif trialVarData{b}(c,8)==2 % monkey chooses "opposite" (BOTH)                    
                    epochB{b} = epochB{b}( length(epochB{b}(:,1))+1 , [LFP(plexonTime{b}(c(1)) : plexonTime{b}(c(4)) )]); %Add new row containing epoch for both choice
                end                
            elseif trialVarData{b}(c,5)==1 %if both as "target" trial                
                if trialVarData{b}(c,8)==0 % no choice made or fixation fail
                    %selfBothError(b,trialVarData{b}(c,9))=selfBothError(b,trialVarData{b}(c,9))+1;
                elseif trialVarData{b}(c,8)==1 % monkey chooses target (BOTH)   
                    %both(b,trialVarData{b}(c,9))=both(b,trialVarData{b}(c,9))+1;
                elseif trialVarData{b}(c,8)==2 % monkey chooses "opposite" (SELF)
                    %self(b,trialVarData{b}(c,9))=self(b,trialVarData{b}(c,9))+1;
                end                                
            elseif trialVarData{b}(c,5)==2 %if other as "target" trial
                if trialVarData{b}(c,8)==0 % no choice made or fixation fail
                    %otherNeitherError(b,trialVarData{b}(c,9))=otherNeitherError(b,trialVarData{b}(c,9))+1;
                elseif trialVarData{b}(c,8)==1 % monkey chooses target (OTHER)                   
                    epochO{b} = epochO{b}( length(epochO{b}(:,1))+1 , [LFP(plexonTime{b}(c(1)) : plexonTime{b}(c(4)) )]); %Add new row containing epoch for other choice
                elseif trialVarData{b}(c,8)==2 % monkey chooses "opposite" (NEITHER)                    
                    epochN{b} = epochN{b}( length(epochN{b}(:,1))+1 , [LFP(plexonTime{b}(c(1)) : plexonTime{b}(c(4)) )]); %Add new row containing epoch for neither choice
                end          
            elseif trialVarData{b}(c,5)==3 %if neither as "target" trial 
                 if trialVarData{b}(c,8)==0 % no choice made or fixation fail
                    %otherNeitherError(b,trialVarData{b}(c,9))=otherNeitherError(b,trialVarData{b}(c,9))+1;
                elseif trialVarData{b}(c,8)==1 % monkey chooses target (NEITHER)
                    %neither(b,trialVarData{b}(c,9))=neither(b,trialVarData{b}(c,9))+1;
                elseif trialVarData{b}(c,8)==2 % monkey chooses "opposite" (OTHER)
                    %other(b,trialVarData{b}(c,9))=other(b,trialVarData{b}(c,9))+1;
                 end   
            end
        end
    end
end
