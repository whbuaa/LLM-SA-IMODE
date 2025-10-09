% 程序运行之前需要更新 cd 地址，将此程序中result文件夹的地址复制到cd之后进行地址更新
% 程序运行介绍后，每种问题维度会在result文件夹中输出以   求解问题的维度 + med_res 名称的.mat文件 和 求解问题的维度 +
%                                                     avg_res 名称的.mat文件(其它生成的文件不用理会)
% 文件的纵轴代表的是求解问题，横轴为求解算法，每种求解算法对应两列数据（median和IQR）              
clear all
run_N                = 20;
algorithms_name      = {@LLM_SA_IMODE};     %求解算法名称
problem_name         = {@F1,@F2,@F3,@F4,@F5,@F6,@F7};                          %求解问题的名称
%problem_name         = {@F1};                                                  %求解问题的名称
D_N                  = {50};                                                    %求解问题的维度 10---问题的决策变量数量为10.本次需要进行{10,50,100}三种维度实验，由于程序求解时间长，建议每种维度单独运行，最后再组合整理结果。
for i=1:length(D_N)
    for j=1:length(algorithms_name)
        for k=1:length(problem_name)
            avg_res_data                = 0;
            avg_time_data               = 0;
            for h= 1:run_N
                tic;
                [Dec,Obj,Con]          = platemo('algorithm',algorithms_name{j},'problem',problem_name{k},'N',5,'M',1,'D',D_N{i},'maxFE',1000);
                med_res_data(h,k)      = min(Obj); 
                med_time_data(h,k)     = toc; 
                avg_res_data           = avg_res_data + min(Obj);
                avg_time_data          = avg_time_data + toc;
            end
                output_res(run_N*(k-1)+1:run_N*k,2*j-1) = med_res_data(:,k); 
                output_res(run_N*(k-1)+1:run_N*k,2*j)   =  med_time_data(:,k);  
                output_med_res(k,2*j-1)                 = prctile(med_res_data(1:run_N,k),50); 
                output_med_res(k,2*j)                   = prctile(med_res_data(1:run_N,k),75) - prctile(med_res_data(1:run_N,k),25);
                output_avg_res(k,2*j-1)                 = avg_res_data / run_N;
                output_avg_res(k,2*j)                   = std(med_res_data(1:run_N,k));
                 output_avg_time(k,2*j-1)               = avg_time_data / run_N;
                output_avg_time(k,2*j)                  = std(med_time_data(1:run_N,k));
        end 
    end
    cd 'C:\Users\chengzi\Desktop\LLM-SA-IMODE'
    save(['LLM-SA-IMODEF1-F7',num2str(D_N{i}),'sign_res','.mat'],'output_res');     % 用于显著性比较
    save(['LLM-SA-IMODEF1-F7',num2str(D_N{i}),'med_res','.mat'],'output_med_res');
    save(['LLM-SA-IMODEF1-F7',num2str(D_N{i}),'avg_res','.mat'],'output_avg_res');
    save(['LLM-SA-IMODEF1-F7',num2str(D_N{i}),'avg_time','.mat'],'output_avg_time');
end
% 最终结果要求整理出一个表格数据，纵轴为求解问题且每种问题有3种维度{10，50,100}，因此表格总共有21行。(只对output_med_res.mat文件结果进行总结)
% 横轴为求解算法且每种模型具有每列数据（包含2个数据1.01e-10(1.05e-8)：median(IQR)）。