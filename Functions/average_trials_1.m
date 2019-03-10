function Ave = average_trials_1(Struct)
%% ===== AVERAGE =====
% Average over trials
% Adopted from Brainstorm Toolbox
Ave = zeros([size(Struct,1) size(Struct{1})]);
lstr = ones(size(Struct{1},1),1)*size(Struct,2);
for i = 1:size(Struct,1)
    for j = 1:size(Struct,2)
        inann = isnan(Struct{i,j});
        if sum(inann(:)) ~=0
            lstr = lstr-1;
        else
            chans=Struct{i,j} ;
            for k=1:size(chans,1)
                if  sum(isinf(chans(k,:))) == 0
                    Ave(i,k,:) = squeeze(Ave(i,k,:)) + squeeze(chans(k,:))';
                    
                else
                    lstr(k)=lstr(k)-1;
                end
            end
        end
        
    end
end
for k=1:size(size(Struct{1}),1)
    Ave(:,k,:) = Ave(:,k,:)/lstr(k);
end
    
end  