%% 验证矩阵是否符合条件
disp('请输入判断矩阵A')     
A=input('A=');     
ERROR = 0;  
[r,c]=size(A);
if r ~= c  || r <= 1
    ERROR = 1;
end
if ERROR == 0
    [n,n] = size(A);
    if sum(sum(A <= 0)) > 0
        ERROR = 2;
    end
end
if ERROR == 0
    if n > 15
        ERROR = 3;
    end
end
if ERROR == 0
    if sum(sum(A' .* A ~=  ones(n))) > 0
        ERROR = 4;
    end
end
if ERROR == 1
    disp('请检查矩阵A的维数是否不大于1或不是方阵')
elseif ERROR == 2
    disp('请检查矩阵A中有元素小于等于0')
elseif ERROR == 3
    disp('A的维数n超过了15，请减少准则层的数量')
elseif ERROR == 4
    disp('请检查矩阵A中存在i、j不满足A_ij * A_ji = 1')
else
    %% 一致性检验
    % 先求特征值
    [V,D] = eig(A);
    MAX_EIG = max( max(D) );
    % 求矩阵大小
    [n,n] = size(A);
    % 求CI
    CI = (MAX_EIG - n) / (n - 1);
    RI=[0 0.0001 0.52 0.89 1.12 1.26 1.36 1.41 1.46 1.49 1.52 1.54 1.56 1.58 1.59];
    % 这里n=2时，一定是一致矩阵，所以CI = 0，我们为了避免分母为0，将这里的第二个元素改为了很接近0的正数
    CR = CI / RI(n);
    disp("一致性指标CI=");disp(CI);
    disp("一致性比例CR=");disp(CR);
    if CR<0.10
        disp('因为CR<0.10，所以该判断矩阵A的一致性可以接受!');
    else
        disp('注意：CR >= 0.10，因此该判断矩阵A需要进行修改!');
    end

    %% 方法一：算术平均法求权重
    % 第一步：将判断矩阵按照列归一化（每一个元素除以其所在列的和）
    % 计算每列和
    Sum_A = sum(A);
    %铺开
    SUM_A = repmat(Sum_A,n,1);
    % 归一化
    Stand_A = A ./ SUM_A;
    % 第二步：将归一化的各列相加(按行求和)
    sum(Stand_A,2)
    % 第三步：将相加后得到的向量中每个元素除以n即可得到权重向量
    disp('算术平均法求权重的结果为：');
    disp(sum(Stand_A,2) / n)

    %% 方法2：几何平均法求权重
    % 第一步：将A的元素按照行相乘得到一个新的列向量
    Prduct_A = prod(A,2)
    % prod函数和sum函数类似，一个用于乘，一个用于加  dim = 2 维度是行

    % 第二步：将新的向量的每个分量开n次方
    Prduct_n_A = Prduct_A .^ (1/n)
    % 这里对每个元素进行乘方操作，因此要加.号哦。  ^符号表示乘方哦  这里是开n次方，所以我们等价求1/n次方

    % 第三步：对该列向量进行归一化即可得到权重向量
    % 将这个列向量中的每一个元素除以这一个向量的和即可
    disp('几何平均法求权重的结果为：');
    disp(Prduct_n_A ./ sum(Prduct_n_A))

    %% 方法3：特征值法求权重
    % 第一步：求出矩阵A的最大特征值以及其对应的特征向量
    [V,D] = eig(A)    %V是特征向量, D是由特征值构成的对角矩阵（除了对角线元素外，其余位置元素全为0）
    Max_eig = max(max(D)) %也可以写成max(D(:))哦~
    % 那么怎么找到最大特征值所在的位置了？ 需要用到find函数，它可以用来返回向量或者矩阵中不为0的元素的位置索引。
    % 那么问题来了，我们要得到最大特征值的位置，就需要将包含所有特征值的这个对角矩阵D中，不等于最大特征值的位置全变为0
    % 这时候可以用到矩阵与常数的大小判断运算
    D == Max_eig
    [r,c] = find(D == Max_eig , 1)
    % 找到D中第一个与最大特征值相等的元素的位置，记录它的行和列。

    % 第二步：对求出的特征向量进行归一化即可得到我们的权重
    V(:,c)
    disp('特征值法求权重的结果为：');
    disp( V(:,c) ./ sum(V(:,c)) )
    % 我们先根据上面找到的最大特征值的列数c找到对应的特征向量，然后再进行标准化。
end

