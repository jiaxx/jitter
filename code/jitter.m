function output = jitter(data,l)
%  By zandvakili@gmail.com 
%  Jittering multidemntational logical data where 
%  0 means no spikes in that time bin and 1 indicates 
%  a spike in that time bin.
%  First dimention should be time and second should be the trial number.

data = single(data);
if length(size(data))>3
    flag = 1;
    sd = size(data);
    data = reshape(data,size(data,1),size(data,2),length(data(:))/(size(data,1)*size(data,2)));
else
    flag = 0;
end


psth = squeeze(mean(data,2));
len = size(data,1);


if mod(-size(data,1),l)
    data(end+mod(-size(data,1),l),:,:) = 0;
    psth(end+mod(-size(psth,1),l),:)   = 0;
end

if size(psth,2)>1
    dataj = squeeze(sum(reshape(data,l,size(data,1)/l,size(data,2),size(data,3))));
    psthj = squeeze(sum(reshape(psth,l,size(psth,1)/l,size(psth,2))));
else
    dataj = squeeze(sum(reshape(data,l,size(data,1)/l,size(data,2))));
    psthj = sum(reshape(psth,l,size(psth,1)/l))';
end

if size(data,1) == l
    dataj = reshape(dataj,1,size(dataj,1),size(dataj,2));
    psthj = reshape(psthj,1,size(psthj,1));
end

psthj = reshape(psthj,size(psthj,1),1,size(psthj,2));
psthj(psthj==0) = 10e-10;

corr = dataj./repmat(psthj,[1 size(dataj,2) 1]);
corr = reshape(corr,1,size(corr,1),size(corr,2),size(corr,3));
corr = repmat(corr,[l 1 1 1]);
corr = reshape(corr,size(corr,1)*size(corr,2),size(corr,3),size(corr,4));

psth = reshape(psth,size(psth,1),1,size(psth,2));
output = repmat(psth,[1 size(corr,2) 1]).*corr;

output = output(1:len,:,:);
if flag ==1
    output = reshape(output,sd);
end