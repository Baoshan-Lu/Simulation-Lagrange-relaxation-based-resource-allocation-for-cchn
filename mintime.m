function A = mintime(w,gu,gd,gu_d,gd_bs,ru,rd) 
%     function y = fun1(t)
%        y = gu - (2^(ru/(t*w))-1)*(2^(rd/(t*w))-1)*gu_d*gd_bs/gd;
%     end
%     t0 = 0.01;
%     A = fsolve(@fun1,t0);  
%     syms t;
%     f1 = gu - (2^(ru_all(1)/(t*w))-1)*(2^(rd_all(1)/(t*w))-1)*gu_d(1)*gd_bs(1)/gd(1);
%     B = slove(f1==0,t,'Real',true);
%     A = double(B);
    flag = 0;
    temp = (gu*gd)/(gu_d*gd_bs);
    for t = 0.0001:0.0002:1;
        if temp > (2^(ru/(t*w))-1)*(2^(rd/(t*w))-1);
            flag = 1;
            A = t;
            break;
        end
    end
    if flag == 0;
        A = 1;
    end 
end
