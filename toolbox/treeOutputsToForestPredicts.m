function [forestPredicts, forestProbs] = treeOutputsToForestPredicts(CCF,treeOutputs)

if CCF.bReg
    forestPredicts = squeeze(mean(treeOutputs,2));
    forestProbs = [];
else
    forestProbs = squeeze(mean(treeOutputs,2));
    if CCF.bSepPred
        forestPredicts = forestProbs>0.5;
    else
        forestPredicts = NaN(size(forestProbs,1),numel(CCF.task_ids));
        for nO = 1:(numel(CCF.task_ids)-1)
            [~,forestPredicts(:,nO)] = max(forestProbs(:,CCF.task_ids(nO):CCF.task_ids(nO+1)-1),[],2);
        end
        [~,forestPredicts(:,end)] = max(forestProbs(:,CCF.task_ids(end):end),[],2);
    end
    if isnumeric(CCF.classNames)
        if islogical(forestPredicts)
            assert(size(forestPredicts,2)==1,'Class names should have been a cell if multiple outputs');
            forestPredicts = CCF.classNames(forestPredicts+1);
        else
            forestPredicts = CCF.classNames(forestPredicts);
        end
    elseif iscell(CCF.classNames) && any(cellfun(@(x) isnumeric(x)&&numel(x)>1,CCF.classNames))
        assert(numel(CCF.classNames)==size(forestPredicts,2),'Number of predicts does not match the number of outputs in classNames')
        for nO = 1:numel(CCF.classNames)
           if isnumeric(CCF.classNames{nO}) && numel(CCF.classNames{nO})>1
              if islogical(forestPredicts)
                  assert(numel(CCF.classNames{nO})==2,'Should have two class names on logical tasks');
                  forestPredicts(:,nO) = CCF.classNames{nO}(forestPredicts(:,nO)+1);
              else
                  forestPredicts(:,nO) = CCF.classNames{nO}(forestPredicts(:,nO));
              end
           end
        end
    elseif islogical(CCF.classNames) && numel(CCF.classNames)
        forestPredicts = forestPredicts==2;
    end
end

end
    