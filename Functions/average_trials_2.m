function Ave = average_trials_2(Struct)
Ave = zeros(size(Struct{1}));
lstr = ones(size(Struct{1},1),1)*length(Struct);
for i = 1:length(Struct)
    inann = isnan(Struct{i});
    if sum(inann(:)) ~=0
        lstr = lstr-1;
    else
        chans=Struct{i} ;
        for k=1:size(chans,1)
            if  sum(isinf(chans(k,:))) == 0
                Ave(k,:) = squeeze(Ave(k,:)) + squeeze(chans(k,:));
                
            else
                lstr(k)=lstr(k)-1;
            end
        end
        
    end
end
for k=1:size(size(Struct{1}),1)
    Ave(k,:) = Ave(k,:)/lstr(k);
end
end
