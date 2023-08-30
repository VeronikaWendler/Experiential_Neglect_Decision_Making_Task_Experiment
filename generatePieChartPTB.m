function pieRandVars = generatePieChartPTB(probability, type, ptbwin, rectPosition, pieRandVars)

if nargin==4
    splitArcLengthRandomWins = [];splitArcLengthRandomLosses=[];startoffsets=[];
else
    splitArcLengthRandomWins = pieRandVars.wins;
    splitArcLengthRandomLosses = pieRandVars.losses;
    startoffsets = pieRandVars.offsets;
end
symbolicProb = probability*360;

Screen('FillOval',ptbwin.w,ptbwin.colours.red, rectPosition);
switch type
    case 1 % simple pie chart
        Screen('FillArc',ptbwin.w,ptbwin.colours.green, rectPosition, ptbwin.startangleSingleArc, symbolicProb);
        Screen('FrameArc',ptbwin.w,ptbwin.colours.white, rectPosition, ptbwin.startangleSingleArc, symbolicProb);
    case 2 % pie chart split into equal and equidistant segments
        splitArcLengthWins = symbolicProb/ptbwin.numWinSegments;
        for currArc = 1:ptbwin.numWinSegments
            Screen('FillArc',ptbwin.w,ptbwin.colours.green, rectPosition, ptbwin.startangleSplitArcs(currArc), splitArcLengthWins);
            Screen('FrameArc',ptbwin.w,ptbwin.colours.white, rectPosition, ptbwin.startangleSplitArcs(currArc), splitArcLengthWins);
        end
    case 3 % pie chart split into unequal and non-equidistant segments
        if isempty(splitArcLengthRandomWins)
            splitArcLengthRandomWins = round(randfixedsum(ptbwin.numWinSegments,1,symbolicProb,ptbwin.minArcLength,ptbwin.maxArcLength));
            splitArcLengthRandomWins(ptbwin.numWinSegments)=splitArcLengthRandomWins(ptbwin.numWinSegments)+(symbolicProb-sum(splitArcLengthRandomWins)); % adjust the value of the last segment so that the sum is exactly currwinprob(2);
            splitArcLengthRandomLosses = 360/ptbwin.numWinSegments-splitArcLengthRandomWins;
        end
        startAngle = ptbwin.startangleSingleArc;
        for currArc = 1:ptbwin.numWinSegments
            Screen('FillArc',ptbwin.w,ptbwin.colours.green, rectPosition, startAngle, splitArcLengthRandomWins(currArc));
            Screen('FrameArc',ptbwin.w,ptbwin.colours.white, rectPosition, startAngle, splitArcLengthRandomWins(currArc));
            startAngle = startAngle+splitArcLengthRandomWins(currArc)+splitArcLengthRandomLosses(currArc);
        end
    case 4 % pie chart split into unequal and non-equidistant segments with disjointed wedges
        if isempty(splitArcLengthRandomWins)
            r = rand(1,ptbwin.numWinSegments);
            r = r/sum(r);
            while min(r)<ptbwin.minPropotion
                r = rand(1,ptbwin.numWinSegments);
                r = r/sum(r);
            end
            splitArcLengthRandomWins = round(r*symbolicProb);
            s = rand(1,ptbwin.numWinSegments);
            s = s/sum(s);
            while min(s)<ptbwin.minPropotion
                s = rand(1,ptbwin.numWinSegments);
                s = s/sum(s);
            end
            splitArcLengthRandomLosses = round(s*(360-symbolicProb));

            startoffsets = [0 randsample(15:15:360,2)];
        end
        for currcir = 1:ptbwin.numCirclesinPie
            scaleFactor = ((ptbwin.numCirclesinPie+1-currcir)/ptbwin.numCirclesinPie);
            currRect = CenterRect(ScaleRect(rectPosition,scaleFactor,scaleFactor),rectPosition);
            startAngle = ptbwin.startangleSingleArc+startoffsets(currcir);
            for currArc = 1:ptbwin.numWinSegments
                Screen('FillArc',ptbwin.w,ptbwin.colours.green, currRect, startAngle, splitArcLengthRandomWins(currArc));
                Screen('FillArc',ptbwin.w,ptbwin.colours.red, currRect, startAngle+splitArcLengthRandomWins(currArc),splitArcLengthRandomLosses(currArc));
                startAngle = startAngle+splitArcLengthRandomWins(currArc)+splitArcLengthRandomLosses(currArc);
            end
        end
end
pieRandVars.wins = splitArcLengthRandomWins;
pieRandVars.losses = splitArcLengthRandomLosses;
pieRandVars.offsets = startoffsets;