function sortedIdx = traceEdge(edgeMask, endpoint1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given an edge map containing a single contour (possibly closed) return
% the set of contour pixel indices ordered along the contour i.e. such that
% any two pixels adjacent in the sorted list are adjacent in the edge map.
%
% Input:
%       edgeMask,   a logical image containing the edge map
%       endpoint1,  index of the first pixel in the list (OPTIONAL) 
%
% Output:
%       sortedIdx,  array containing indices of sorted contour pixels
%
% ----------------
% Aleksandrs Ecins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reserve space for the sorted index list
sortedIdx = zeros(sum(edgeMask(:)), 1);
[yRes, xRes] = size(edgeMask);

%% Find endpoints
endpointMask = bwmorph(edgeMask, 'endpoints');
endpoints = find(endpointMask ~= 0);

%% Check if contour is closed
if isempty(endpoints)
    edgeIdx = find(edgeMask);
    
    if nargin < 2
        endpoints(1) = edgeIdx(1);
    else
        endpoints(1) = endpoint1;
    end

    [curY, curX] = ind2sub(size(edgeMask), endpoints(1));
    
    maskTmp = zeros(size(edgeMask));
    maskTmp(        max(curY-1, 1)  :   min(curY+1, size(edgeMask, 1)),...
                    max(curX-1, 1)  :   min(curX+1, size(edgeMask, 2))) = 1;
    maskTmp(curY, curX) = 0;
    neighbourMask = maskTmp .* edgeMask;
    
    neighbours = find(neighbourMask);
    endpoints(2) = neighbours(1);
    curIdx = neighbours(2);
    
    sortedIdx(1) = endpoints(1);
    sortedIdx(2) = curIdx;
    edgeMask(endpoints(1)) = 0;
    i = 3;    
else
    curIdx = endpoints(1);
    sortedIdx(1) = curIdx;
    i = 2;
end

%% Look for adjacent pixels unitl the other endpoint is met
while (curIdx~=endpoints(2))

    % Get coordinates of current pixel
    [curY, curX] = ind2sub([yRes, xRes], curIdx);
    
    % Remove current pixel from edge map
    edgeMask(curIdx) = 0;
    
    % Get all neighbours of current pixel. Order them as N,E,S,W,NE,SE,SW,NW (to ensure 4-connected pixels are given priority)
    neighboursX = [curX; curX+1; curX; curX-1; curX+1; curX+1; curX-1; curX-1];
    neighboursY = [curY-1; curY; curY+1; curY; curY-1; curY+1; curY+1; curY-1];
    
    % Loop through the possible neighbours
    curIdx = -1;
    n = 0;
    while curIdx < 0
        n=n+1;        
        y = neighboursY(n);
        x = neighboursX(n);
        
        % Select current neighbour if it is inside the image and is
        % adjacent in the edge map
        if (checkInside(y, x, yRes, xRes)) && (edgeMask(y, x) == 1)
            curIdx = sub2ind([yRes, xRes], y, x);
        end
    end
    if curIdx < 0
        error('Could not find any neighbours!\n');
    end
    
    % Add index to sorted indices
    sortedIdx(i) = curIdx;
    i = i+1;
end

end

function nIdx = checkInside(y, x, yRes, xRes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return 1 if pixel coordinates (x,y) are inside image if size (xRes,
% yRes), otherwise return 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (x<1) || (x>xRes) || (y<1) || (y>yRes)
        nIdx = 0;
    else
        nIdx = 1;
    end
end