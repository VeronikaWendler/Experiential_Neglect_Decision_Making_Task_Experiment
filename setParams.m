function ptbwin = setParams(window)
ptbwin.w = window;
ptbwin.colours.green = [35 200 60]/255;
ptbwin.colours.red = [220 30 60]/255;
ptbwin.colours.white = 1;
ptbwin.colours.black = 0;

ptbwin.numWinSegments = 3;
ptbwin.minPropotion = 0.1;
ptbwin.numCirclesinPie = 3;
ptbwin.startangleSingleArc = 90;
circlepoints = linspace(0,360,ptbwin.numWinSegments+1);
ptbwin.startangleSplitArcs = mod(circlepoints(1:end-1)+90,360);
ptbwin.minArcLength = 5; % degrees
ptbwin.maxArcLength = 360/ptbwin.numWinSegments-ptbwin.minArcLength;
end