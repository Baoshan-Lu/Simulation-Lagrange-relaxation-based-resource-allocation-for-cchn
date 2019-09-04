function  IntentionTable_new=AdjustIntenTablesBaseConditions(IntentionTable,UnableLink)

% load SNRmat.mat SNRmat
% 
% 
% SNRmat(UnableLink,uablefthRB)=-2;
% 
% save SNRmat.mat SNRmat
% 
% for i=1:size(SNRmat,1)
%     
%      [a,b]=sort(SNRmat(i,:),'descend');
%      IntentionTable(i,:)=b;
%      
% end

temp=IntentionTable(UnableLink,:);
temp(:,1)=[];
temp=[temp 0];
IntentionTable(UnableLink,:)=temp;
IntentionTable_new=IntentionTable;