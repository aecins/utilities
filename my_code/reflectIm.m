function imReflected = reflectIm(im,width)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given an image reflect the pixels around the boundary of the image.
%
% Input
%   im,             input image
%   width,          width of the refleted part
%
% Output
%   imReflected,    reflected image
%
% Comments:
% brute force doing all 8 cases separately, since that is really faster
% than a clean solution using coordinates...
%
% ----------------
% Aleksandrs Ecins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get dimensions of an input image
[ly, lx, lz] = size(im);
imReflected = zeros(ly+2*width, lx+2*width, lz);

% For each channel of an image
for z=1:lz
    
    % original im
    imReflected(width+1:end-width,width+1:end-width,z) = im(:,:,z);

    % top
    imReflected(1:width,width+1:end-width,z) = flipud(im(1:width,:,z));

    % bot
    imReflected(end-width+1:end,width+1:end-width,z) = flipud(im(end-width+1:end,:,z));

    % left
    imReflected(width+1:end-width,1:width,z) = fliplr(im(:,1:width,z));

    % right
    imReflected(width+1:end-width,end-width+1:end,z) = fliplr(im(:,end-width+1:end,z));

    % top-left
    imReflected(1:width,1:width,z) = rot90(im(1:width,1:width,z),2);

    % top-right
    imReflected(1:width,end-width+1:end,z) = rot90(im(1:width,end-width+1:end,z),2);

    % bot-left
    imReflected(end-width+1:end,1:width,z) = rot90(im(end-width+1:end,1:width,z),2);

    % bot-right
    imReflected(end-width+1:end,end-width+1:end,z) = rot90(im(end-width+1:end,end-width+1:end,z),2);
end