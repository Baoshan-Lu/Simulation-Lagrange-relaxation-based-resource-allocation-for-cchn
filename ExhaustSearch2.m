function [Action,num]=ExhaustSearch2(V2Inum,V2Vnum)
% function ExhaustSearch()
% V2Inum=2
% V2Vnum=5


%V2V分簇函数：将V2V分配给V2I
tic
%% 生成所有可能的簇
C=cell(1,V2Vnum);%定义V2V个数
for i=1:V2Vnum
    C{1,i}=1:V2Inum;%V2I个数,每个cell里面加入V2I的序列
end


% 把每维的坐标写成向量，然后放在一个cell数组中
% 这里按照你给的例子示范（三个坐标）
% C = { 1:3 1:3 1:3 };
% 使用ndgrid生成N维网格数据

n = length(C);
S=arrayfun(@(i)sprintf('x%i ',i),1:n,'UniformOutput',false);
eval(['[' S{:} ']=ndgrid(C{:});'])
S1=arrayfun(@(i)sprintf('x%i(:) ',i),1:n,'UniformOutput',false);

% 把网格数据转换为坐标组合
Action=eval(['[' S1{:} ']']);
num=size(Action,1);

save Action.mat Action