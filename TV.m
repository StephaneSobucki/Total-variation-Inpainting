function [u,N] = TV(input,lambda,mask,T,dt,handles)
    [i,j,~] = size(input);
    mask = double(mask);
    input = double(input);
    input = mask.*input + 255*(1-mask).*rand(size(input));
    u = double(input);
    iterations = 0;
    title(handles.axes5,'Inpainting...');
    f = waitbar(0,'1','Name','Inpainting...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

    setappdata(f,'canceling',0);
    for t = 0:dt:T
        if getappdata(f,'canceling')
            break
        end
        waitbar(t/T,f,sprintf('%0.2f%%',t/T*100));
        u_x = u(:,[2:j,j],:) - u;
        u_y = u([2:i,i],:,:) - u;
        N = sum(sum(sqrt(u_x.^2+u_y.^2)));
        u_xx = u(:,[2:j,j],:) - 2*u + u(:,[1,1:j-1],:);
        u_yy = u([2:i,i],:,:) - 2*u + u([1,1:i-1],:,:); 
        u_xy = ( u([2:i,i],[2:j,j],:)+ u([1,1:i-1],[1,1:j-1],:)- u([1,1:i-1],[2:j,j],:)...
        - u([2:i,i],[1,1:j-1],:) ) / 4;
        deltaE = -(u_xx.*u_y.^2-2*u_x.*u_y.*u_xy+u_yy.*u_x.^2)./(0.1+(u_x.^2+u_y.^2).^(3/2))+...
            2*mask.*(lambda*(u-input));
        u = dt*(-deltaE.*N/(sqrt(sum(N.^2))))+u;
        iterations = iterations + 1;
        if(mod(iterations,100) == 0)
            axes(handles.axes5);
            imshow(u/255);
            title(handles.axes5,sprintf('Inpainting: %u iterations...',iterations));
        end
    end
    delete(f)
    u = uint8(u);
    imshow(u);
    title(handles.axes5,sprintf('Done after %u iterations !',iterations));
end

