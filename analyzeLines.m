function [meanLineSizePx, roughnessPx, hasError] = analyzeLines(img)

%{
Start on first pixel (1,1), march to the right, find all places where 
transition from 0 to 1 or 1 to 0. Repeat this for all rows
​
If 0 to 1, store as “left line edge”, if 1 to 0, store as “right line edge”.  
Make array called leftEdges and rightEdges, for each row, and store transitions there
​
Draw “fences” (boundaries) as line that is in the center of a right edge and left edge.  
Take the midpoint of left and right edges for all row values, average them, and 
this is the location of the fence.Start on first pixel (1,1), march to the right, find all places where 
transition from 0 to 1 or 1 to 0. Repeat this for all rows
​
If 0 to 1, store as “left line edge”, if 1 to 0, store as “right line edge”.  
Make array called leftEdges and rightEdges, for each row, and store transitions there
​
Draw “fences” (boundaries) as line that is in the center of a right edge and left edge.  
Take the midpoint of left and right edges for all row values, average them, and 
this is the location of the fence.
%}

[sr, sc] = size(img);

leftEdges = [];
rightEdges = [];

nominalNumedges = 0;
nominalMeanEdge = 0;
hasWarned = false;
for r = 1:sr
    
    leftEdge = [];
    rightEdge = [];
    
    %IMPERATIVE
    for c = 1:sc - 1
        if img(r,c) == 1 && img(r, c + 1) == 0
            % then this is a left edge of the "space" region
            leftEdge(end+1) = c; %#ok<AGROW>
        end
        if img(r,c) == 0 && img(r, c + 1) == 1
            % then this is a right edge of the "space" region
            rightEdge(end+1) = c; %#ok<AGROW>
        end
    end
    
    if length(leftEdge) ~= length(rightEdge)
        if (~hasWarned)
            warning('Found different number of left and right edges');
        end
        hasWarned = true;
    end
    if (r == 1)
        nominalNumedges = length(leftEdge);
    else
        if (length(leftEdge) ~= nominalNumedges)
            if (~hasWarned)
                warning('Found different number of edges in different rows');
            end
            hasWarned = true;
        end
    end
    
    leftEdges(r, 1:length(leftEdge)) = leftEdge;
    rightEdges(r, 1:length(rightEdge)) = rightEdge;

end

midpoints = (leftEdges + rightEdges)/2;
fences = round(mean(midpoints, 1));


% imagesc(img);
% hold on
% 
% for k = 1:length(fences)
%     line([fences(k), fences(k)], [0, sr], 'color', 'm', 'linewidth', 3);
% end

lineMeanWidths = [];
lineRoughnesses = [];

for k = 1:length(fences)-1
    thisLine = img(:, fences(k):fences(k+1));
    widths = sum(thisLine, 2);
    
    lineMeanWidths(k) = mean(widths);
    lineRoughnesses(k) = std(widths);
end


meanLineSizePx = mean(lineMeanWidths);
roughnessPx = mean(lineRoughnesses);

if hasWarned == 0
    hasError = false;
else
    hasError = true;
end

end
