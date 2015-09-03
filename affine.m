function [newI] = affine(gray,A)

    %% Inverse transformation   
    x_step = A(1,1);
    y_step = A(2,2);
    
    B = [0;0];
    P = [0 0 1];
    M = [A,B;P];
    
    %%
    [X,Y] = size(gray);
    
    %%
    for x=1:X
        for y=1:Y
            cur_pos = [x;y;1];
            cur_px = gray(x,y);
            new_pos = M*cur_pos;
            newI(ceil(abs(new_pos(1))+1),ceil(abs(new_pos(2))+1)) = cur_px;
        end
    end
    
    %% Refine new image
    newI = newI(2:end, 2:end);
    for i=1:x_step:X*x_step-1
        for j=1:y_step:Y*y_step-1
            for ii=1:x_step
                for jj = 1:y_step
                    newI(i+ii-1,j+jj-1) = newI(i+x_step-1,j+y_step-1);
                end
            end
        end
    end
    
    end