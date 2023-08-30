function ExpSymbNeglect_final(participant)
% EXPERIMENT 1 - Experiential Neglect
%
% Pilot Study on Symbolic/Experiential Neglect
% This program is a pilot study to determine the optimal number of
% conditions and trials to use in the main experiment testing the
% hypothesis that the experiential neglect observed by Garcia et al. (2022/23)
% is due to uncertainty in the probability estimation of the experiential
% icons.

set(0,'DefaultFigureVisible','on');
rng('shuffle', 'twister');
PsychDefaultSetup(2);
blankDuration = 0.6;
screens = Screen('Screens');
screenNumber = max(screens);

% colours
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;
green = [35 200 60]/255;
red = [220 30 60]/255;
blue = [70 30 200]/255;
yellowTransp = [220 200 50 175]/255;

% image parameters
imageSize = [200, 200];
separation = 300;

% Generate a random number once
randomNumber = round(rand * 1e4);

% probabilities
allPieChartProbabilities = (1:7)/8;

KbName('UnifyKeyNames');
leftkey = KbName('LeftArrow');
rightkey = KbName('RightArrow');
spacekey = KbName('space');
quitkey = KbName('escape');

% Screen('Preference', 'SkipSyncTests', 1);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[~, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
ifi = Screen('GetFlipInterval', window);
ptbwin = setParams(window);
ListenChar(2);

% Introduction Message
Screen('TextSize', window, 24);
line1 = 'Welcome to this experiment. This experiment is composed of two halves:';
line2 = '\n\n 1) Training Phase: You will get introduced to 3 different tasks.';
line3 = '\n\n\n 2) Experimental Phase: You will play a longer version of the 3 different tasks.';
line5 = '\n\n\n In addition to the fixed compensation of £10 you will be endowed with an additional £2.';
line6 = ' Depending on your choices, you can either lose or double this endowment!';
line7 = '\n\n\n Please press the space bar to continue';
DrawFormattedText(window, [line1 line2 line3 line5 line6 line7],...
    'center', screenYpixels * 0.3, black);
Screen('Flip', window);
KbStrokeWait;

trainingInstr = ['TRAINING: Instructions for the first training task:'...
    '\n\n In each round, you have to choose between one of two symbols displayed on either side of the screen.'...
    '\n\n\n To select the left symbol, use the LEFT arrow; to select the right symbol, use the RIGHT arrow.'...
    '\n\n\n Depending on your choice, you will win/lose the following outcomes:'...
    '\n 1 point = 0.238 pence'...
    '\n -1 point = -0.238 pence'...
    '\n\n\n Remember, in total, you can win up to £4 additional money.'...
    '\n\n\n The outcomes of both possible choices will be displayed after you make your choice.'...
    '\n\n\n Please note, however, that only the outcome of your choice will be considered in the final payoff.'...
    '\n\n\n Importantly, your choices in this training section will not be considered.'...
    ' Only the points won during the Experimental phase will count towards your payoff.'...
    '\n\n\n Please press the space bar to continue.'];
DrawFormattedText(window, trainingInstr, 'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

line19 = 'Here are some example stimuli and their respective outcomes:';
line20 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line19 line20],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

% Loading the images
Neg = imread("Images/-1.png");
Pos = imread("Images/1.png");
Circle = imread("Images/Test_Icons_Additional_Circle.png");
Cursor = imread("Images/Test_Icons_Additional_Cursor.png");
Folder = imread("Images/Test_Icons_Additional_Folder.png");
Magnet = imread("Images/Test_Icons_Additional_Magnet.png");
AI = imread("Images/Test_Icons_AI.png");
At = imread("Images/Test_Icons_At.png");
Cloud = imread("Images/Test_Icons_Cloud.png");
Hazel = imread("Images/Test_Icons_Hazel.png");
Star = imread("Images/Test_Icons_Star.png");

% pos and neg images based on the chosen probability array
posTexture = Screen('MakeTexture', window, Pos);
negTexture = Screen('MakeTexture', window, Neg);

allImagesTEST = {Circle, Cursor, Folder, Magnet, AI, At, Cloud, Hazel, Star};
allImageNamesTEST = {'Circle', 'Cursor', 'Folder', 'Magnet', 'AI', 'At', 'Cloud', 'Hazel', 'Star'};

% probability arrays
C = [0.2, 0.8];
D = [0.8, 0.2];
E = [0.4, 0.6];
allProbabilityArraysTEST = {C, D, E};

trialsInBlockTEST1 = 10; % trials per condition

% Variables Test 1
selectedImagesFromFirstPartTEST = cell(3, 2);
selectedProbabilitiesFromFirstPartTEST = zeros(3, 2);
elapsedTimeTEST1 = zeros(3 * trialsInBlockTEST1, 1);
leftimTEST1 = cell(3, 1);
rightimTEST1 = cell(3, 1);
clicksArrayTEST1 = zeros(3 * trialsInBlockTEST1, 1);
leftOutcomesTEST1 = zeros(1, 3 * trialsInBlockTEST1);
rightOutcomesTEST1 = zeros(1, 3 * trialsInBlockTEST1);
numTrialsTEST1 = 3 * trialsInBlockTEST1;
scoreArrayTEST1 = zeros(numTrialsTEST1, 1);
utility_ArrayTEST1 = zeros(numTrialsTEST1, 1);
Out_LeftTEST1 = zeros(numTrialsTEST1, 1);
Out_RightTEST1 = zeros(numTrialsTEST1, 1);

filename = ['Data',filesep,'participant', num2str(participant),'_dataTEST1_', num2str(randomNumber), '.mat'];

scoreTEST1 = 0;
trialNumTEST1 = 0;
usedProbabilityIndices = [];

for block = 1:3
    repeats = true;
    while repeats
        selectedIndicesTEST = randperm(numel(allImagesTEST), 2);

        name1TEST1 = allImageNamesTEST(selectedIndicesTEST(1));
        name2TEST1 = allImageNamesTEST(selectedIndicesTEST(2));

        % Check if the selected probability index has been used before
        chosenProbabilityIndexTEST = randi(numel(allProbabilityArraysTEST));
        if ~ismember(chosenProbabilityIndexTEST, usedProbabilityIndices)
            if ~any(any(strcmp(selectedImagesFromFirstPartTEST, name1TEST1))) && ~any(any(strcmp(selectedImagesFromFirstPartTEST, name2TEST1)))
                repeats = false;
                usedProbabilityIndices = [usedProbabilityIndices, chosenProbabilityIndexTEST];
            end
        end
    end

    image1TEST1 = allImagesTEST{selectedIndicesTEST(1)};
    image2TEST1 = allImagesTEST{selectedIndicesTEST(2)};

    selectedImagesFromFirstPartTEST(block, 1) = allImageNamesTEST(selectedIndicesTEST(1));
    selectedImagesFromFirstPartTEST(block, 2) = allImageNamesTEST(selectedIndicesTEST(2));

    texture1TEST1 = Screen('MakeTexture', window, image1TEST1);
    texture2TEST1 = Screen('MakeTexture', window, image2TEST1);

    % here we select the probability array randomly for the block
    chosenProbabilityIndexTEST = randi(numel(allProbabilityArraysTEST));
    chosenProbabilityArrayTEST = cell2mat(allProbabilityArraysTEST(chosenProbabilityIndexTEST));
    selectedProbabilitiesFromFirstPartTEST(block, 1) = chosenProbabilityArrayTEST(1);
    selectedProbabilitiesFromFirstPartTEST(block, 2) = chosenProbabilityArrayTEST(2);

    %this here is difficult, but works like this: We create arrays of ones
    %and minus oens that occur in number accoridng to the given probability
    %array and its complement P'. Then, the horzcat will horizontally
    %concatenate these and the randomized selection procedure is gnereated
    %through the shuffle function. We assesss the number of trials where
    %the outcome is minus one and the number of trials where the outcome
    %is one.
    outcomes1TEST1 = Shuffle(horzcat(-1 * ones(1, int32(trialsInBlockTEST1 * (1 - chosenProbabilityArrayTEST(1)))), ones(1, int32(trialsInBlockTEST1 * chosenProbabilityArrayTEST(1)))));
    outcomes2TEST1 = Shuffle(horzcat(-1 * ones(1, int32(trialsInBlockTEST1 * (1 - chosenProbabilityArrayTEST(2)))), ones(1, int32(trialsInBlockTEST1 * chosenProbabilityArrayTEST(2)))));

    % here, we select the position of the images on screen and also store
    % the data for outcomes and images associated with the position
    for trial = 1:trialsInBlockTEST1
        trialNumTEST1 = trialNumTEST1 + 1;
        randomPositionsTEST1 = randperm(2);
        position1TEST1 = randomPositionsTEST1(1);
        position2TEST1 = randomPositionsTEST1(2);

        trialonset = Screen('Flip', window);

        if position1TEST1 == 1
            Screen('DrawTexture', window, texture1TEST1, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            Screen('DrawTexture', window, texture2TEST1, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            outcome1TEST1 = outcomes1TEST1(trial);
            outcome2TEST1 = outcomes2TEST1(trial);
            leftimTEST1{trialNumTEST1} = selectedImagesFromFirstPartTEST{block, 1};
            rightimTEST1{trialNumTEST1} = selectedImagesFromFirstPartTEST{block, 2};
        elseif position2TEST1 == 1
            Screen('DrawTexture', window, texture1TEST1, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            Screen('DrawTexture', window, texture2TEST1, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            outcome1TEST1 = outcomes2TEST1(trial);
            outcome2TEST1 = outcomes1TEST1(trial);
            leftimTEST1{trialNumTEST1} = selectedImagesFromFirstPartTEST{block, 2};
            rightimTEST1{trialNumTEST1} = selectedImagesFromFirstPartTEST{block, 1};
        end
        stimonset = Screen('Flip', window, trialonset + (1 - 0.5) * ifi);

        % Wait for key press to chose image
        selectedImageTEST1 = '';
        while isempty(selectedImageTEST1)
            [keyDown, keyTime, keyCodes] = KbCheck;
            if keyDown
                if keyCodes (quitkey)
                    ListenChar(1);
                    ShowCursor;
                    sca;
                    return;
                elseif keyCodes (leftkey)
                    selectedImageTEST1 = 'left';
                    clicksArrayTEST1(trialNumTEST1) = 1;    %stores left click (1) in the array
                    leftOutcomesTEST1(trialNumTEST1) = outcome1TEST1;
                    rightOutcomesTEST1(trialNumTEST1) = outcome2TEST1;
                elseif keyCodes (rightkey)
                    selectedImageTEST1 = 'right';
                    clicksArrayTEST1(trialNumTEST1) = 0;   %stores right click (2) in the array
                    leftOutcomesTEST1(trialNumTEST1) = outcome2TEST1;
                    rightOutcomesTEST1(trialNumTEST1) = outcome1TEST1;
                end
            end
        end
        elapsedTimeTEST1(trialNumTEST1) = keyTime-stimonset;

        % Calculate utility for the trial based on selected probabilities and outcomes
        if strcmp(selectedImageTEST1, 'left')
            if outcome1TEST1 == 1
                scoreTEST1 = scoreTEST1 + 1;
                utility_ArrayTEST1(trialNumTEST1) = 1;
            else
                scoreTEST1 = scoreTEST1 - 1;
                utility_ArrayTEST1(trialNumTEST1) = -1;
            end
        elseif strcmp(selectedImageTEST1, 'right')
            if outcome2TEST1 == 1
                scoreTEST1 = scoreTEST1 + 1;
                utility_ArrayTEST1(trialNumTEST1) = 1;
            else
                scoreTEST1 = scoreTEST1 - 1;
                utility_ArrayTEST1(trialNumTEST1) = -1;
            end
        end
        scoreArrayTEST1(trialNumTEST1) = scoreTEST1;

        % here, we define the rectangle outline which appears around the
        % clicked image
        if strcmp(selectedImageTEST1, 'left')
            Screen('FrameRect', window, green, [xCenter-separation/2-imageSize(1)-16 yCenter-imageSize(2)/2-16 xCenter-separation/2+16 yCenter+imageSize(2)/2+16], 8);
            if position1TEST1 == 1
                Screen('DrawTexture', window, texture1TEST1, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
                Screen('DrawTexture', window, texture2TEST1, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            else
                Screen('DrawTexture', window, texture2TEST1, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
                Screen('DrawTexture', window, texture1TEST1, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            end
        elseif strcmp(selectedImageTEST1, 'right')
            Screen('FrameRect', window, green, [xCenter+separation/2-16 yCenter-imageSize(2)/2-16 xCenter+separation/2+imageSize(1)+16 yCenter+imageSize(2)/2+16], 8);
            if position1TEST1 == 2
                Screen('DrawTexture', window, texture1TEST1, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
                Screen('DrawTexture', window, texture2TEST1, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            else
                Screen('DrawTexture', window, texture2TEST1, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
                Screen('DrawTexture', window, texture1TEST1, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            end
        end
        stimoffset = Screen('Flip', window);
        Screen('Flip', window, stimoffset+blankDuration);

        %If outcome1TEST is equal to 1, the positive image is drawn on the left side of the screen.
        %If outcome1TEST is not equal to 1, the negative image is drawn on
        %the left side of the screen. The same goes for outcome2TEST
        %initially determiend by the shuffle(horzcat( ...array

        if outcome1TEST1 == 1
            Out_LeftTEST1(trialNumTEST1) = 1;  % here we store the positive outcome for left side
            Screen('DrawTexture', window, posTexture, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
        else
            Out_LeftTEST1(trialNumTEST1) = -1;  % here we store the negative outcome for left side
            Screen('DrawTexture', window, negTexture, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
        end
        if outcome2TEST1 == 1
            Out_RightTEST1(trialNumTEST1) = 1;  % we store the positive outcome for right side
            Screen('DrawTexture', window, posTexture, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
        else
            Out_RightTEST1(trialNumTEST1) = -1;  % we store the negative outcome for right side
            Screen('DrawTexture', window, negTexture, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
        end

        feedbackOnset = Screen('Flip', window);
        Screen('Flip', window, feedbackOnset+blankDuration);

        %saving after every trial
        save(filename, 'selectedImagesFromFirstPartTEST', 'selectedProbabilitiesFromFirstPartTEST', 'elapsedTimeTEST1','leftimTEST1','rightimTEST1', 'numTrialsTEST1', 'scoreArrayTEST1', 'clicksArrayTEST1', 'utility_ArrayTEST1', 'Out_RightTEST1', 'Out_LeftTEST1', 'rightOutcomesTEST1', 'leftOutcomesTEST1', 'scoreTEST1');
    end
    if block < 3
        Screen('DrawText',window,'A new pair of symbols will be shown in the next block',60,60,black);
        Screen('DrawText',window,'Please take a short break',60,150,black);
        Screen('DrawText',window,'Please wait 2 seconds and press space to begin new block.',60,240,black);
        Screen('Flip',window);
        WaitSecs(2);
        while 1
            [keyDown, ~, keyCodes] = KbCheck;
            if keyDown
                if keyCodes(spacekey)
                    break;
                end
            end
        end
        while keyCodes(spacekey)
            [~, ~, keyCodes] = KbCheck;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Testing Phase: ES- Phase  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Instructions for the second training test: ES-Phase
line21 = 'TRAINING: Instructions for the second task:';
line22 = '\n\n  In the second task there will be two kinds of options.';
line23 = '\n\n\n  The first kind of option is the symbols you have already encountered during the previous test.';
line24 = '\n Note: The symbols maintain the same odds of winning/losing a point as in the first test.';
line25 = '\n\n\n  The second kind of option is represented by pie-charts that describe the odds of winning/losing points';
line26 = ' through interleaved segments of specific green/red ratios.';
line27 = '\n\n\n  Specifically, the amount of green area indicates the chance of winning a point;';
line28 = ' \n the amount of red area indicates the chance of losing a point.';
line29 = '\n\n\n  These pie-charts will be of various types';
line31 = '\n\n\n  You will be asked to chose between a pie-chart and an icon.';
line32 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line21 line22 line23 line24 line25 line26 line27 line28 line29 line31 line32],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

line33 = 'TRAINING: Instructions for the second test:';
line34= '\n\n In each round, you have to choose between one of two icons displayed on either side of the screen.';
line35 = '\n\n\n  You can select the left icon by presseing LEFT arrow and the right symbol by pressing RIGHT arrow.';
line36 = '\n\n\n  Please note that in this test, no outcome will be displayed, such that after a choice, the next pair of options will be shown without an intermediate step.';
line38 = '\n\n\n  At the end of the test, you will be shown the final payoff in terms of cumulative points and monetary bonus';
line39 = '\n\n\n  Note: Points won during the training do not count towards the final payoff!';
line40 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line33 line34  line35 line36 line38 line39 line40],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

blockSizeSecondPartTEST = 20;
scoreArraySecondPartTEST = zeros(2 * blockSizeSecondPartTEST, 1);
clicksArrayTEST2 = zeros(2 * blockSizeSecondPartTEST, 1);
elapsedTimeTEST2 = zeros(2 * blockSizeSecondPartTEST, 1);
selectedLeftProbabilitiesTEST2 = zeros(2 * blockSizeSecondPartTEST, 1);
selectedRightProbabilitiesTEST2 = zeros(2 * blockSizeSecondPartTEST, 1);
leftimTEST2 = cell(2 * blockSizeSecondPartTEST, 1);
rightimTEST2 = cell(2 * blockSizeSecondPartTEST, 1);
utility_ArrayTEST2 = zeros(2 * blockSizeSecondPartTEST, 1);
chosenImageArrayTEST2 = cell(2 * blockSizeSecondPartTEST, 1);

filename2 = ['Data',filesep,'participant', num2str(participant),'_dataTEST2_', num2str(num2str(randomNumber)), '.mat'];

scoreTEST2 = 0;
%here, we use 2 for loops, the first iterates through a number of blocks
%adn choses one, the second is assigned to iterate through the trial
%number. We select indices for both that are used to access an image from
%the first task.
%The code enters a conditional statement (if rand() < 0.5) where it generates a random number using rand() and compares it to 0.5.
% If the condition is met, a random index is chosen from allPieCharts array, and the corresponding pie chart image data, name, and probability
% are assigned to image2, image1Name, and probability1, respectively. If the condition is not met, the code follows the else branch,
% similar to how it handled image1.

for block = 1:2
    for trial = 1:blockSizeSecondPartTEST
        selectedBlockIndicesTEST2 = randperm(3, 1);
        selectedIndicesTEST2 = randperm(2);
        image1NameTEST2 = selectedImagesFromFirstPartTEST(selectedBlockIndicesTEST2, selectedIndicesTEST2(1));               % extracts the name of the first image based on the random indices for block and trial form task1
        image1TEST2 = cell2mat(allImagesTEST(strcmp(allImageNamesTEST, image1NameTEST2)));                                                            %converts the image data from a cell array (allImagesTEST) to a regular matrix.
        probability1TEST2 = selectedProbabilitiesFromFirstPartTEST(selectedBlockIndicesTEST2, selectedIndicesTEST2(1));  
        textureTEST2 = Screen('MakeTexture', window, image1TEST2);

        selectedPieChartIndexTEST2 = randi(numel(allPieChartProbabilities));
        probabilityPieTEST2 = allPieChartProbabilities(selectedPieChartIndexTEST2);
        piechartTypeTEST2 = randperm(4, 1);                                  
        image2NameTEST2 = ['Pie' num2str(piechartTypeTEST2)];

        leftPositionTEST2 = [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2];
        rightPositionTEST2 = [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2];

        objLocation = Randi(2)-1;

        if objLocation
            Screen('DrawTexture', window, textureTEST2, [], leftPositionTEST2);
            pieRandVars = generatePieChartPTB(probabilityPieTEST2, piechartTypeTEST2, ptbwin, CenterRect(rightPositionTEST2*0.85,rightPositionTEST2));
            Screen('FrameRect', window, black, rightPositionTEST2, 3);
            probabilityLeftTEST2 = probability1TEST2;
            probabilityRightTEST2 = probabilityPieTEST2;
        else
            Screen('DrawTexture', window, textureTEST2, [], rightPositionTEST2);
            pieRandVars = generatePieChartPTB(probabilityPieTEST2, piechartTypeTEST2, ptbwin, CenterRect(leftPositionTEST2*0.85,leftPositionTEST2));
            Screen('FrameRect', window, black, leftPositionTEST2, 3);
            probabilityLeftTEST2 =probabilityPieTEST2;
            probabilityRightTEST2 = probability1TEST2;
        end

        selectedLeftProbabilitiesTEST2((block-1)*blockSizeSecondPartTEST + trial) = probabilityLeftTEST2;
        selectedRightProbabilitiesTEST2((block-1)*blockSizeSecondPartTEST + trial) = probabilityRightTEST2;

        stimonset = Screen('Flip', window, trialonset + (1 - 0.5) * ifi);                                                                                                      % here, we start mesuring elapsed time again, we also store left and right click in designated arrays to analyse participant's choice
        selectedImageTEST2 = '';
        while isempty(selectedImageTEST2)
            [keyDown, keyTime, keyCodes] = KbCheck;
            if keyDown
                if keyCodes (quitkey)
                    ListenChar(1);
                    ShowCursor;
                    sca;
                    return;
                elseif keyCodes (leftkey)
                    selectedImageTEST2 = 'left';
                    clicksArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = 1;
                elseif keyCodes (rightkey)
                    selectedImageTEST2 = 'right';
                    clicksArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = 0;
                end
            end
        end
        elapsedTimeTEST2((block-1)*blockSizeSecondPartTEST + trial) = keyTime-stimonset;       % Measure the elapsed time for each trial

        if objLocation
            Screen('DrawTexture', window, textureTEST2, [], leftPositionTEST2);
            generatePieChartPTB(probabilityPieTEST2, piechartTypeTEST2, ptbwin, CenterRect(ScaleRect(rightPositionTEST2,0.85,0.85),rightPositionTEST2), pieRandVars);
            Screen('FrameRect', window, black, rightPositionTEST2, 3);
        else
            Screen('DrawTexture', window, textureTEST2, [], rightPositionTEST2);
            generatePieChartPTB(probabilityPieTEST2, piechartTypeTEST2, ptbwin, CenterRect(ScaleRect(leftPositionTEST2,0.85,0.85),leftPositionTEST2), pieRandVars);
            Screen('FrameRect', window, black, leftPositionTEST2, 3);
        end

        if strcmp(selectedImageTEST2, 'left')
            leftimTEST2((block-1)*blockSizeSecondPartTEST + trial) = {image1NameTEST2};
            rightimTEST2((block-1)*blockSizeSecondPartTEST + trial) = {image2NameTEST2};
            chosenImageArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = {image1NameTEST2};
            Screen('FrameRect', window, green, [xCenter-separation/2-imageSize(1)-16 yCenter-imageSize(2)/2-16 xCenter-separation/2+16 yCenter+imageSize(2)/2+16], 8);

            if probabilityLeftTEST2 > probabilityRightTEST2
                scoreTEST2 = scoreTEST2 + 1;                                                                              % Participant wins if they click the left image (higher probability)
                utility_ArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = 1;             % Participant's win is added to the outcomeArray2TEST
            else
                scoreTEST2 = scoreTEST2 - 1;                                                                              % Participant loses if they click the right image (lower probability)
                utility_ArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = -1; % Participant loses if they click the right image (lower probability)
            end
        elseif strcmp(selectedImageTEST2, 'right')
            leftimTEST2((block-1)*blockSizeSecondPartTEST + trial) = {image2NameTEST2};
            rightimTEST2((block-1)*blockSizeSecondPartTEST + trial) = {image1NameTEST2};
            chosenImageArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = {image2NameTEST2};
            Screen('FrameRect', window, green, [xCenter+separation/2-16 yCenter-imageSize(2)/2-16 xCenter+separation/2+imageSize(1)+16 yCenter+imageSize(2)/2+16], 8);

            if probabilityRightTEST2 > probabilityLeftTEST2
                scoreTEST2 = scoreTEST2 + 1;                                                                             % Participant wins if they click the right image (higher probability)
                utility_ArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = 1;                                       % Participant wins if they click the right image (higher probability)
            else
                scoreTEST2 = scoreTEST2 - 1;                                                                             % Participant loses if they click the left image (lower probability)
                utility_ArrayTEST2((block-1)*blockSizeSecondPartTEST + trial) = -1;                                        % Participant loses if they click the left image (lower probability)
            end
        end
        scoreArraySecondPartTEST((block-1)*blockSizeSecondPartTEST + trial) = scoreTEST2;

        stimoffset = Screen('Flip', window);
        Screen('Flip',window,stimoffset+blankDuration);

        save(filename2, 'scoreArraySecondPartTEST', 'clicksArrayTEST2', 'elapsedTimeTEST2', 'selectedLeftProbabilitiesTEST2', 'selectedRightProbabilitiesTEST2', 'leftimTEST2', 'rightimTEST2', 'utility_ArrayTEST2', 'scoreTEST2', 'chosenImageArrayTEST2');
    end
end

% Display the final score
finalScoreMessage = ['Overall you have won ' num2str(scoreTEST2), ' points! Congrats!'...
    '\n\n\n Please press the space bar to continue to the third task.';];
DrawFormattedText(window, finalScoreMessage, 'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;

% This here is an important variable as we need to bea able to access the
% same images used in the first and secodn task for the 3. slider task.
%this line extracts values from the selectedImagesFromFirstPart array and
% puts them into a single column format, the unique function then returns only the unique values

selectedImagesFromPartsTEST = unique(selectedImagesFromFirstPartTEST(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  Testing Phase: Slider - Task  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Slider task
% Instructions
line43 = 'TRAINING: Instructions for the third task:';
line44= '\n\n   In each trial of the third task you will be presented with the symbols and pie-charts you saw in the first and second tasks.';
line46 = '\n\n\n   1. You will be asked to indicate (in percentage), what are the odds that a given symbol or pie-chart makes you win a point.';
line47 = '\n\n\n   2. There will be a scale below the slider through which you can indicate the confidence you have in your estimation of the above probability:';
line48 = '\n\n\n   1 means you are not at all sure what the probability is and 5 means you are absolutely sure.';
line49 = '\n\n\n   You can move the sliders on the screen with the mouse cursor and then click on the confidence rating that feels appropriate';
line50 = '\n\n\n   Once you are satisfied with your response, please press the space bar to continue.';
DrawFormattedText(window, [line43 line44 line46 line47 line48 line49 line50],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

%%%%%%%%% General Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textSize = 18;
sliderLineWidth = 6;
dim = screenYpixels / 50;
hDim = dim / 2;
scaleLineWidth = 6;

%%%%%%%% Slider 1 Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sliderLengthPix = screenYpixels / 1.5;
sliderHLengthPix = sliderLengthPix / 2;
leftEnd = [xCenter - sliderHLengthPix yCenter + sliderHLengthPix * 0.6];
rightEnd = [xCenter + sliderHLengthPix yCenter + sliderHLengthPix * 0.6];
sliderLineCoords = [leftEnd' rightEnd'];
sliderLabels = {'0%', '100%'};
SetMouse(xCenter, yCenter, window);

% Initialize centeredRect for Slider 1 to a random position
baseRect = [0 0 dim dim];
sx = xCenter + (rand * 2 - 1) * sliderHLengthPix;
aboveSliderPosY2 = yCenter + sliderHLengthPix * 0.55; %  value for aboveSliderPosY + textPixGap????
textPixGap = 70;
textPixGap2 = 60;
slider1LeftBound = xCenter - sliderHLengthPix;
slider1RightBound = xCenter + sliderHLengthPix;
slider1TopBound = yCenter + sliderHLengthPix * 0.6 - dim / 2;
slider1BottomBound = yCenter + sliderHLengthPix * 0.6 + dim / 2;

%%%%%%%% Slider 2 Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

leftLabel = 'very uncertain';
rightLabel = 'very confident';
bottomY = screenYpixels * 0.8; % position of Slider 2 (lower 20 percent of the screen)
% textPosY = bottomY - hDim - textPixGap;
scaleLengthPix = screenYpixels / 1.5;
scaleHLengthPix = scaleLengthPix / 2;
leftEnd2 = [xCenter - scaleHLengthPix, bottomY];
rightEnd2 = [xCenter + scaleHLengthPix, bottomY];
scaleLineCoords2 = [leftEnd2', rightEnd2'];
numScalePoints2 = 5;
xPosScalePoints2 = linspace(xCenter - scaleHLengthPix, xCenter + scaleHLengthPix, numScalePoints2);
numScalePoints2Offset = 0;
yPosScalePoints2 = repmat(bottomY + numScalePoints2Offset, 1, numScalePoints2);
xyScalePoints2 = [xPosScalePoints2; yPosScalePoints2];
% labels for '0%' and '100%'
leftTextPosX2 = xCenter - scaleHLengthPix - hDim - textPixGap2 - textSize * 2;
rightTextPosX2 = xCenter + scaleHLengthPix + hDim + textPixGap2 - textSize * 3;
textPosY2 = bottomY + hDim + textPixGap;
numShiftUpPix = 30;
xNumText2 = xPosScalePoints2 - hDim;
yNumText2 = repmat(bottomY - numShiftUpPix, 1, numScalePoints2);

numTrialsSliderTEST3 = 4;
% thisNumSliderTEST3 = 1;

% SliderResponsesTEST3 = cell(numTrialsSliderTEST3, 1);
selectedImageNameSliderTEST3 = cell(numTrialsSliderTEST3, 1);
% confidenceLevelsTEST3 = zeros(numTrialsSliderTEST3, 1);

sliderResponsesArrayTEST3 = cell(numTrialsSliderTEST3, 1);
confidenceLevelsArrayTEST3 = zeros(numTrialsSliderTEST3, 1);
selectedImageNamesArrayTEST3 = cell(numTrialsSliderTEST3, 1);

filenameSliderResponses = ['Data',filesep,'participant', num2str(participant), '_SliderResponsesTEST3_', num2str(randomNumber), '.mat'];

for trial = 1:numTrialsSliderTEST3
    selectedImageIdxSliderTEST3 = randi(numel(selectedImagesFromPartsTEST));                                               %  random index between 1 and the number of elements in the selectedImagesFromPartsTEST cell array, index is used to randomly select an image name.
    selectedImageNameSliderTEST3{trial} = selectedImagesFromPartsTEST{selectedImageIdxSliderTEST3};                         % Assigns the selected image name to the selectedImageNameSliderTEST array at the current trial index.
    selectedImageSliderTEST3 = allImagesTEST{strcmp(allImageNamesTEST, selectedImageNameSliderTEST3{trial})};                                                        % Retrieves the selected image data from the allImagesTEST cell array based on the found index.
    selectedImagesFromPartsTEST(selectedImageIdxSliderTEST3) = [];                                                            % reomves it from the array to avoid repetition of samw image

    [imageHeight, imageWidth, ~] = size(selectedImageSliderTEST3);
    imageRect = [0, 0, imageWidth, imageHeight];
    imageDestinationRect = CenterRectOnPointd(imageRect, xCenter, yCenter - imageHeight/8);                              % imageHeight/8 will move the image slightly up to fit the slider task outline
    imgTex = Screen('MakeTexture', window, selectedImageSliderTEST3);
    centeredRect = CenterRectOnPointd(baseRect, sx, yCenter + sliderHLengthPix * 0.6);

    currentPercentageTEST = -1;
    selectedConfidenceTEST = 0;

    while true
        Screen('DrawTexture', window, imgTex, [], imageDestinationRect);
        [mx, my, buttons] = GetMouse(window);
        if buttons(1)
            while buttons(1)
                [mx, my, buttons] = GetMouse(window);
            end
            if mx >= xCenter - scaleHLengthPix && mx <= xCenter + scaleHLengthPix && my >= slider1TopBound && my <= slider1BottomBound         % condition checks if the mouse cursor is within the bounds, the region where the slider can be interacted with.
                sx = mx;
                if sx > xCenter + sliderHLengthPix
                    sx = xCenter + sliderHLengthPix;
                elseif sx < xCenter - sliderHLengthPix
                    sx = xCenter - sliderHLengthPix;
                end
                centeredRect = CenterRectOnPointd(baseRect, sx, yCenter + sliderHLengthPix * 0.6);
            elseif mx >= slider1LeftBound && mx <= slider1RightBound && my >= bottomY-20 && my <= bottomY+20         % condition checks if the mouse cursor is within the bounds, the region where the slider can be interacted with.
                inCircles = sqrt((xPosScalePoints2 - mx).^2 + (yPosScalePoints2 - my).^2) < hDim;
                weInCircle = sum(inCircles) > 0;
                if weInCircle == 1
                    [~, posCircle] = max(inCircles);
                    coordsCircle = xyScalePoints2(:, posCircle);
                    selectedConfidenceTEST = posCircle;                                                                               % Store the selected confidence level
                end
            end
        end

        % Draw Slider 1
        Screen('DrawLines', window, sliderLineCoords, sliderLineWidth, black);
        Screen('FillRect', window, yellowTransp, centeredRect);
        Screen('FrameRect', window, green, centeredRect);

        DrawFormattedText(window, sliderLabels{1}, leftTextPosX2+50, aboveSliderPosY2, blue);
        DrawFormattedText(window, sliderLabels{2}, rightTextPosX2, aboveSliderPosY2, red);
        DrawFormattedText(window, 'What are the odds that this symbol yields +1 points?', 'center', screenYpixels * 0.25, black);
        currentPercentageTEST = round((sx - (xCenter - sliderHLengthPix)) / sliderLengthPix * 100);
        % DrawFormattedText(window, [num2str(currentPercentageTEST) '%'], 'center', aboveSliderPosY2, black);
        DrawFormattedText2(['<size=30><color=000000><b>',num2str(currentPercentageTEST),'%'], 'win', window,'sx', 'center', 'sy', aboveSliderPosY2-20);

        % Draw Slider 2
        Screen('DrawLines', window, scaleLineCoords2, scaleLineWidth, grey);

        % labels for 'very certain' and 'very uncertain'
        DrawFormattedText(window, leftLabel, xCenter - scaleHLengthPix - textSize * 10, textPosY2, black);
        DrawFormattedText(window, rightLabel, xCenter + scaleHLengthPix, textPosY2, black);

        if selectedConfidenceTEST ~= 0
            Screen('FrameOval', window, grey, [coordsCircle - dim * 0.8; coordsCircle + dim * 0.8], 2);
        end
        for i = 1:numScalePoints2
            Screen('FillOval', window, black, [xPosScalePoints2(i) - hDim, yPosScalePoints2(i) - hDim, xPosScalePoints2(i) + hDim, yPosScalePoints2(i) + hDim]);
        end

        for thisNumSliderTEST3 = 1:numScalePoints2
            DrawFormattedText(window, num2str(thisNumSliderTEST3), xNumText2(thisNumSliderTEST3), yNumText2(thisNumSliderTEST3), black);
        end

        Screen('Flip', window);

        % is space bar pressed
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if keyCodes (quitkey)
                ListenChar(1);
                ShowCursor;
                sca;
                return;
            elseif keyCode(spacekey) && currentPercentageTEST ~= -1 && selectedConfidenceTEST ~= 0
                break;
            end
        end
    end

    sliderResponsesArrayTEST3{trial} = currentPercentageTEST;
    confidenceLevelsArrayTEST3(trial) = selectedConfidenceTEST;
    selectedImageNamesArrayTEST3{trial} = selectedImageNameSliderTEST3{trial};
    save(filenameSliderResponses, 'sliderResponsesArrayTEST3','confidenceLevelsArrayTEST3', 'selectedImageNamesArrayTEST3');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%     % %      %     %    %   %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%    % % %    %%%    %    % % %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%   %     %  %   %   %    %   %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This phase covers creating code for the main task, first we will recreate
%the learning phase, now the blocks are of length 30. - I'll keep them
%shorter for now

Fire = imread("Images/Fire.png");
Menu = imread("Images/Equal.png");
Aperture = imread("Images/Experiment_Icons_Circle.png");
Intersection = imread("Images/Experiment_Icons_Intersection.png");
Cycle = imread("Images/Test_Icons_Cycle.png");
Mark = imread("Images/Test_Icons_Mark.png");

allImagesEXP = {Fire, Menu, Aperture, Intersection, Mark, Cycle};
allImageNamesEXP = {'Fire', 'Menu', 'Aperture', 'Intersection', 'Mark', 'Cycle'};

% probability arrays
I = [1/8, 7/8];
J = [2/8, 6/8];
K = [3/8, 5/8];
allProbabilityArraysEXP = {I, J, K };

% block length
trialsInBlock = 40;

line51 = 'Welcome to the main experiment. This experiment, just as for the practice, is composed of 3 phases:';
line52 = '\n\n 1) Training Phase: You will get introduced to symbols and their probabilities.';
line53 = '\n\n\n 2) Testing Phase of the experiment: You will be asked to choose between these icons and pie charts.';
line54 = '\n\n\n 3)	Knowledge Phase: We will ask you about the symbols and piecharts.';
line57 = '\n\n\n Please press the space bar to continue';
DrawFormattedText(window, [line51 line52 line53 line54 line57],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

line58 = 'MAIN EXPERIMENT: Instructions for the first task:';
line59 = '\n\n In each trial, you have to choose between one of two symbols displayed on either side of the screen.';
line60 = '\n\n\n To select the left symbol, use the LEFT arrow; to select the right symbol, use the RIGHT arrow.';
line61 = '\n\n\n After a choice, you can win/lose the following outcomes:';
line62 = '\n 1 point = 0.238 pence';
line63 = '\n -1 point = -0.238 pence';
line64 = '\n\n\n Remember, in total, you can win up to £4 additional money.';
line65 = '\n\n\n Please note that only the outcome of *your* choice will be considered in the final payoff.';
line66 = '\n\n\n Please also note that the points won during the next phase (not this phase) will count towards your payoff.';
line68 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line58 line59 line60 line61 line62 line63 line64 line65 line66 line68],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

selectedImagesFromEXP = cell(3, 2);
selectedProbabilitiesFromEXP = zeros(3, 2);
elapsedTimeEXP = zeros(3 * trialsInBlock, 1);
leftimEXP = cell(3, 1);
rightimEXP = cell(3, 1);
numTrialsEXP = 3 * trialsInBlock;
clicksArray1EXP = zeros(numTrialsEXP, 1);
scoreArrayEXP = zeros(numTrialsEXP, 1);
outcomeArrayEXP = zeros(numTrialsEXP, 1);
leftProbabilitiesFirstPartEXP = zeros(3, 1);
rightProbabilitiesFirstPartEXP = zeros(3, 1);
utility_ArrayEXP1 = zeros(numTrialsEXP, 1);
left_OutArrayEXP = zeros(numTrialsEXP, 1);
right_OutArrayEXP = zeros(numTrialsEXP, 1);
current_chosenImEXP = cell(numTrialsEXP, 1);
current_leftchosenEXP = zeros(numTrialsEXP, 1);
current_unchosenImEXP = cell(numTrialsEXP, 1);
current_subblogEXP = zeros(numTrialsEXP, 1);

filenameEXPTrain = ['Data',filesep,'participant', num2str(participant),'_dataEXP1_', num2str(randomNumber) '.mat'];

scoreEXP = 0;
trialNumEXP = 0;

% Shuffle the images for this block
% shuffledImageIndices = randperm(numel(allImagesEXP));
% shuffledImageNamesEXP = allImageNamesEXP(shuffledImageIndices);
shuffledProbabilityArrays = Shuffle(allProbabilityArraysEXP);

for block = 1:3
    repeats = true;
    while repeats
        selectedIndicesEXP = randperm(numel(allImagesEXP), 2);
        name1EXP = allImageNamesEXP(selectedIndicesEXP(1));
        name2EXP = allImageNamesEXP(selectedIndicesEXP(2));
        if ~ any(any(strcmp(selectedImagesFromEXP, name1EXP))) && ~ any(any(strcmp(selectedImagesFromEXP, name2EXP)))
            repeats = false;
        end
    end

    % selectedIndices = randperm(numel(allImages), 2);
    image1EXP = allImagesEXP{selectedIndicesEXP(1)};
    image2EXP = allImagesEXP{selectedIndicesEXP(2)};

    selectedImagesFromEXP(block, 1) = allImageNamesEXP(selectedIndicesEXP(1));
    selectedImagesFromEXP(block, 2) = allImageNamesEXP(selectedIndicesEXP(2));

    texture1EXP = Screen('MakeTexture', window, image1EXP);
    texture2EXP = Screen('MakeTexture', window, image2EXP);

    %     chosenProbabilityIndexEXP = randi(numel(allProbabilityArraysEXP));
    chosenProbabilityArrayEXP = shuffledProbabilityArrays{block};
    selectedProbabilitiesFromEXP(block, 1) = chosenProbabilityArrayEXP(1);
    selectedProbabilitiesFromEXP(block, 2) = chosenProbabilityArrayEXP(2);

    outcomes1EXP = Shuffle(horzcat(-1 * ones(1, int32(trialsInBlock * (1 - chosenProbabilityArrayEXP(1)))), ones(1, int32(trialsInBlock * chosenProbabilityArrayEXP(1)))));
    outcomes2EXP = Shuffle(horzcat(-1 * ones(1, int32(trialsInBlock * (1 - chosenProbabilityArrayEXP(2)))), ones(1, int32(trialsInBlock * chosenProbabilityArrayEXP(2)))));

    for trial = 1:trialsInBlock
        trialNumEXP = trialNumEXP + 1;
        randomPositionsEXP = randperm(2);
        position1EXP = randomPositionsEXP(1);
        position2EXP = randomPositionsEXP(2);

        if position1EXP == 1
            leftProbabilityEXP = chosenProbabilityArrayEXP(1);
            rightProbabilityEXP = chosenProbabilityArrayEXP(2);
        else
            leftProbabilityEXP = chosenProbabilityArrayEXP(2);
            rightProbabilityEXP = chosenProbabilityArrayEXP(1);
        end

        trialonset = Screen('Flip', window);
        if position1EXP == 1
            Screen('DrawTexture', window, texture1EXP, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            Screen('DrawTexture', window, texture2EXP, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            outcome1EXP = outcomes1EXP(trial);
            outcome2EXP = outcomes2EXP(trial);
            leftimEXP{trialNumEXP} = selectedImagesFromEXP{block, 1};
            rightimEXP{trialNumEXP} = selectedImagesFromEXP{block, 2};

        elseif position2EXP == 1
            Screen('DrawTexture', window, texture1EXP, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            Screen('DrawTexture', window, texture2EXP, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            outcome1EXP = outcomes2EXP(trial);
            outcome2EXP = outcomes1EXP(trial);
            leftimEXP{trialNumEXP} = selectedImagesFromEXP{block, 2};
            rightimEXP{trialNumEXP} = selectedImagesFromEXP{block, 1};
        end

        stimonset = Screen('Flip', window, trialonset + (1 - 0.5) * ifi);

        % Wait for key press to chose image
        selectedImageEXP = '';
        while isempty(selectedImageEXP)
            [keyDown, keyTime, keyCodes] = KbCheck;
            if keyDown
                if keyCodes (quitkey)
                    ListenChar(1);
                    ShowCursor;
                    sca;
                    return;
                elseif keyCodes (leftkey)
                    selectedImageEXP = 'left';
                    clicksArray1EXP(trialNumEXP) = 1;                                                              %stores left click (1) in the array
                    current_leftchosenEXP(trialNumEXP) = 1;
                    current_chosenImEXP{trialNumEXP} = leftimEXP{trialNumEXP};
                    current_unchosenImEXP{trialNumEXP} = rightimEXP{trialNumEXP};
                elseif keyCodes (rightkey)
                    selectedImageEXP = 'right';
                    clicksArray1EXP(trialNumEXP) = 0;                                                             %stores right click (0) in the array
                    current_leftchosenEXP(trialNumEXP) = 0;
                    current_chosenImEXP{trialNumEXP} = rightimEXP{trialNumEXP};
                    current_unchosenImEXP{trialNumEXP} = leftimEXP{trialNumEXP};
                end
            end
        end
        elapsedTimeEXP(trialNumEXP) = keyTime-stimonset;

        % rectangle outline
        if strcmp(selectedImageEXP, 'left')
            if position1EXP == 1
                Screen('DrawTexture', window, texture1EXP, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
                Screen('FrameRect', window, green, [xCenter-separation/2-imageSize(1)-16 yCenter-imageSize(2)/2-16 xCenter-separation/2+16 yCenter+imageSize(2)/2+16], 8);
                Screen('DrawTexture', window, texture2EXP, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            else
                Screen('DrawTexture', window, texture2EXP, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
                Screen('FrameRect', window, green, [xCenter-separation/2-imageSize(1)-16 yCenter-imageSize(2)/2-16 xCenter-separation/2+16 yCenter+imageSize(2)/2+16], 8);
                Screen('DrawTexture', window, texture1EXP, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
            end
        elseif strcmp(selectedImageEXP, 'right')
            if position1EXP == 2
                Screen('DrawTexture', window, texture1EXP, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
                Screen('FrameRect', window, green, [xCenter+separation/2-16 yCenter-imageSize(2)/2-16 xCenter+separation/2+imageSize(1)+16 yCenter+imageSize(2)/2+16], 8);
                Screen('DrawTexture', window, texture2EXP, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            else
                Screen('DrawTexture', window, texture2EXP, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
                Screen('FrameRect', window, green, [xCenter+separation/2-16 yCenter-imageSize(2)/2-16 xCenter+separation/2+imageSize(1)+16 yCenter+imageSize(2)/2+16], 8);
                Screen('DrawTexture', window, texture1EXP, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
            end
        end

        % Inside the loop for the first part of the experiment
        leftProbabilitiesFirstPartEXP(block) = leftProbabilityEXP;
        rightProbabilitiesFirstPartEXP(block) = rightProbabilityEXP;

        trialend = Screen('Flip', window);

        if outcome1EXP == 1
            Screen('DrawTexture', window, posTexture, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
        else
            Screen('DrawTexture', window, negTexture, [], [xCenter-separation/2-imageSize(1) yCenter-imageSize(2)/2 xCenter-separation/2 yCenter+imageSize(2)/2]);
        end
        if outcome2EXP == 1
            Screen('DrawTexture', window, posTexture, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
        else
            Screen('DrawTexture', window, negTexture, [], [xCenter+separation/2 yCenter-imageSize(2)/2 xCenter+separation/2+imageSize(1) yCenter+imageSize(2)/2]);
        end
        feedbackOnset = Screen('Flip', window, trialend+blankDuration);
        Screen('Flip', window, feedbackOnset+blankDuration);

        % Calculate utility for the trial based on selected probabilities and outcomes
        if strcmp(selectedImageEXP, 'left')
            if outcome1EXP == 1
                scoreEXP = scoreEXP + 1;
                utility_ArrayEXP1(trialNumEXP) = 1;
                left_OutArrayEXP(trialNumEXP) = 1;  % Positive left
                outcomeArrayEXP(trialNumEXP) = 1;  % Participant chose left and outcome was positive
            else
                scoreEXP = scoreEXP - 1;
                utility_ArrayEXP1(trialNumEXP) = -1;
                left_OutArrayEXP(trialNumEXP) = -1; % Negative left
                outcomeArrayEXP(trialNumEXP) = -1; % Participant chose left and outcome was negative
            end
            if outcome2EXP == 1
                right_OutArrayEXP(trialNumEXP) = 1; % Positive right
            else
                right_OutArrayEXP(trialNumEXP) = -1; % Negative right
            end
        elseif strcmp(selectedImageEXP, 'right')
            if outcome2EXP == 1
                scoreEXP = scoreEXP + 1;
                utility_ArrayEXP1(trialNumEXP) = 1;
                right_OutArrayEXP(trialNumEXP) = 1; % Positive  right
                outcomeArrayEXP(trialNumEXP) = 1; % Participant chose right and outcome was positive
            else
                scoreEXP = scoreEXP - 1;
                utility_ArrayEXP1(trialNumEXP) = -1;
                right_OutArrayEXP(trialNumEXP) = -1; % Negative right
                outcomeArrayEXP(trialNumEXP) = -1; % Participant chose right and outcome was negative
            end
            if outcome1EXP == 1
                left_OutArrayEXP(trialNumEXP) = 1;  % Positive left
            else
                left_OutArrayEXP(trialNumEXP) = -1; % Negative left
            end
        end
        scoreArrayEXP(trialNumEXP) = scoreEXP;
        current_subblogEXP(trialNumEXP) = block;

        save(filenameEXPTrain, 'selectedImagesFromEXP', 'selectedProbabilitiesFromEXP', 'elapsedTimeEXP', 'leftimEXP','rightimEXP','numTrialsEXP','scoreArrayEXP', 'outcomeArrayEXP', 'scoreEXP', 'leftProbabilitiesFirstPartEXP', 'rightProbabilitiesFirstPartEXP', 'utility_ArrayEXP1', 'clicksArray1EXP', 'left_OutArrayEXP', 'right_OutArrayEXP', 'current_chosenImEXP', 'current_leftchosenEXP', 'current_unchosenImEXP', 'current_subblogEXP');
    end
    if block < 3
        Screen('DrawText',window,'A new pair of symbols will be shown in the next block',60,60,black);
        Screen('DrawText',window,'Please take a short break',60,150,black);
        Screen('DrawText',window,'Please wait 2 seconds and press space to begin new block.',60,240,black);
        Screen('Flip',window);
        WaitSecs(2);
        while 1
            [keyDown, ~, keyCodes] = KbCheck;
            if keyDown
                if keyCodes(spacekey)
                    break;
                end
            end
        end
        while keyCodes(spacekey)
            [~, ~, keyCodes] = KbCheck;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Second Phase of Main Experiment

% Instructions for the second training test: ES-Phase
line69 = 'MAIN EXPERIMENT: Instructions for the second task:';
line70 = '\n\n  In the second task there will be two kinds of options.';
line71 = '\n\n\n  The first kind of option is represented by the symbols you already encountered during the previous task.';
line72 = '\n\n\n  Note: The symbols maintain the same odds of winning/losing a point as in the first test.';
line73 = '\n\n\n  The second kind of options is represented by pie-charts that describe the odds of winning/losing points';
line75 = '\n\n\n  Specifically, the amount of green area indicates the chance of winning a point;';
line76 = '\n\n\n  the amount of red area indicates the chance of losing a point.';
line77 = '\n\n\n  These pie-charts will be of various types';
line79 = '\n\n\n  You will always be asked to chose between a pie-chart and an icon.';
line80 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line69 line70 line71 line72 line73 line75 line76 line77 line79 line80],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

line81 = 'MAIN EXPERIMENT: Instructions for the second task:';
line82= '\n\n In each trial, you have to choose between one of two symbols displayed on either side of the screen.';
line83 = '\n\n\n  You can select the left symbol by pressing the LEFT arrow and the right symbol by pressing the RIGHT arrow.';
line84 = '\n\n\n  Please note that in this test, the outcome will NOT be displayed,';
line85 = '\n\n\n  such that after a choice, the next pair of options will be shown without an intermediate step.';
line86 = '\n\n\n  At the end of the block, you will be shown the final payoff in terms of cumulative points and monetary bonus';
line87 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line81 line82  line83 line84 line85 line86 line87],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

line88 = 'Note: This task is like the second task of the training half!';
line89 = 'This is the actual game, every point here will count towards the final payoff. Ready?';
line90 = '\n\n\n Please press the space bar to continue.';
DrawFormattedText(window, [line88 line89 line90],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

runsEXP2 = {1 2 3 4 5};
iconsEXP2 = allImageNamesEXP; % {1 2 3 4 5 6};
piechartTypesEXP2 = {1 2 3 4};

totalTrialsEXP2 = length(runsEXP2) * length(iconsEXP2) * length(allPieChartProbabilities) * length(piechartTypesEXP2);

elapsed_timeEXP2 = zeros(totalTrialsEXP2, 1);
left_imagesEXP2 = cell(totalTrialsEXP2, 1);
right_imagesEXP2 = cell(totalTrialsEXP2, 1);
left_probabilityEXP2 = cell(totalTrialsEXP2, 1);
right_probabilityEXP2 = cell(totalTrialsEXP2, 1);
selected_probabilityEXP2 = cell(totalTrialsEXP2, 1);
selected_imageEXP2 = cell(totalTrialsEXP2, 1);
selected_sideEXP2 = cell(totalTrialsEXP2, 1);

trialRunsEXP2 = cell(totalTrialsEXP2, 1);
trialIconsEXP2 = cell(totalTrialsEXP2, 1);
trialPiechartProbsEXP2 = cell(totalTrialsEXP2, 1);
trialPiechartTypesEXP2 = cell(totalTrialsEXP2, 1);
outcomeArrayEXP2 = zeros(totalTrialsEXP2, 1);
leftOutcomesEXP2 = zeros(totalTrialsEXP2, 1);
rightOutcomesEXP2 = zeros(totalTrialsEXP2, 1);
clicksArrayEXP2 = zeros(totalTrialsEXP2, 1);
utility_ArrayEXP2 = zeros(totalTrialsEXP2, 1);
scoreArrayEXP2 = zeros(totalTrialsEXP2, 1);

filenameEXP2MAIN = ['Data',filesep,'participant', num2str(participant),'_dataEXP2_', num2str(randomNumber) '.mat'];

trialNumEXP2 = 1;
scoreEXP2 = 0;

for i = 1:length(runsEXP2)
    for j = 1:length(iconsEXP2)
        for k = 1:length(allPieChartProbabilities)
            for l = 1:length(piechartTypesEXP2)
                trialRunsEXP2{trialNumEXP2} = runsEXP2{i};
                trialIconsEXP2{trialNumEXP2} = iconsEXP2{j};
                trialPiechartProbsEXP2{trialNumEXP2} = allPieChartProbabilities{k};
                trialPiechartTypesEXP2{trialNumEXP2} = piechartTypesEXP2{l};
                trialNumEXP2 = trialNumEXP2 + 1;
            end
        end
    end
end

shuffle_indexEXP2 = randperm(totalTrialsEXP2);

trialRunsEXP2 = trialRunsEXP2(shuffle_indexEXP2);
trialIconsEXP2 = trialIconsEXP2(shuffle_indexEXP2);
trialPiechartProbsEXP2 = trialPiechartProbsEXP2(shuffle_indexEXP2);
trialPiechartTypesEXP2 = trialPiechartTypesEXP2(shuffle_indexEXP2);

for trialEXP2 = 1:totalTrialsEXP2
    iconNameEXP2 = trialIconsEXP2{trialEXP2};
    iconImageEXP2 = allImagesEXP{strcmp(allImageNamesEXP, iconNameEXP2)};
    textureEXP2 = Screen('MakeTexture', window, iconImageEXP2);

    iconProbabilityEXP2 = selectedProbabilitiesFromEXP(strcmp(selectedImagesFromEXP, iconNameEXP2));
    piechartProbEXP2 = trialPiechartProbsEXP2{trialEXP2};
    piechartTypeEXP2 = trialPiechartTypesEXP2{trialEXP2};

    leftPositionEXP2 = [xCenter-separation/2-imageSize(1), yCenter-imageSize(2)/2, xCenter-separation/2, yCenter+imageSize(2)/2];
    rightPositionEXP2 = [xCenter+separation/2, yCenter-imageSize(2)/2, xCenter+separation/2+imageSize(1), yCenter+imageSize(2)/2];

    objLocation = Randi(2)-1;
    if objLocation
       leftProbabilityEXP2 = iconProbabilityEXP2;
       leftImageNameEXP2 = iconNameEXP2;
       Screen('DrawTexture', window, textureEXP2, [], leftPositionEXP2);
       pieRandVars = generatePieChartPTB(piechartProbEXP2, piechartTypeEXP2, ptbwin, rightPositionEXP2);
       rightProbabilityEXP2 = piechartProbEXP2;
       rightImageNameEXP2 = ['Pie' num2str(piechartTypeEXP2)];
    else
       rightProbabilityEXP2 = iconProbabilityEXP2;
       rightImageNameEXP2 = iconNameEXP2;
       Screen('DrawTexture', window, textureEXP2, [], rightPositionEXP2);
       pieRandVars = generatePieChartPTB(piechartProbEXP2, piechartTypeEXP2, ptbwin, leftPositionEXP2);
       leftProbabilityEXP2 = piechartProbEXP2;
       leftImageNameEXP2 = ['Pie' num2str(piechartTypeEXP2)];
    end

    trialonset = Screen('Flip', window);

    selectedImageEXP2 = '';
    while isempty(selectedImageEXP2)
        [keyDown, keyTime, keyCodes] = KbCheck;
        if keyDown
            if keyCodes (quitkey)
                ListenChar(1);
                ShowCursor;
                sca;
                return;
            elseif keyCodes (leftkey)
                selectedImageEXP2 = 'left';
            elseif keyCodes (rightkey)
                selectedImageEXP2 = 'right';
            end
        end
    end

    elapsed_timeEXP2(trialEXP2) = keyTime-trialonset;
    selected_sideEXP2{trialEXP2} = selectedImageEXP2;
    left_imagesEXP2{trialEXP2} = leftImageNameEXP2;
    right_imagesEXP2{trialEXP2} = rightImageNameEXP2;
    left_probabilityEXP2{trialEXP2} = leftProbabilityEXP2;
    right_probabilityEXP2{trialEXP2} = rightProbabilityEXP2;

    if objLocation
        Screen('DrawTexture', window, textureTEST2, [], leftPositionTEST2);
        generatePieChartPTB(probabilityPieTEST2, piechartTypeTEST2, ptbwin, rightPositionTEST2, pieRandVars);
    else
        Screen('DrawTexture', window, textureTEST2, [], rightPositionTEST2);
        generatePieChartPTB(probabilityPieTEST2, piechartTypeTEST2, ptbwin, leftPositionTEST2, pieRandVars);
    end

    if strcmp(selectedImageEXP2, 'left')
        selected_probabilityEXP2{trialEXP2} = leftProbabilityEXP2;
        selected_imageEXP2{trialEXP2} = leftImageNameEXP2;
        clicksArrayEXP2(trialEXP2) = 1;                          % Store left click (1) in the array
        Screen('FrameRect', window, green, [xCenter-separation/2-imageSize(1)-16 yCenter-imageSize(2)/2-16 xCenter-separation/2+16 yCenter+imageSize(2)/2+16], 8);
        if leftProbabilityEXP2 > rightProbabilityEXP2
            scoreEXP2 = scoreEXP2 + 1;
            outcomeArrayEXP2(trialEXP2)= 1;
            leftOutcomesEXP2(trialEXP2) = 1;
            utility_ArrayEXP2(trialEXP2) = 1;
        else
            scoreEXP2 = scoreEXP2 - 1;
            outcomeArrayEXP2(trialEXP2)= 0;
            leftOutcomesEXP2(trialEXP2) = 0;
            utility_ArrayEXP2(trialEXP2) = -1;
        end
    elseif strcmp(selectedImageEXP2, 'right')
        selected_probabilityEXP2{trialEXP2} = rightProbabilityEXP2;
        selected_imageEXP2{trialEXP2} = rightImageNameEXP2;
        clicksArrayEXP2(trialEXP2) = 0;                                          % Store right click (0) in the array
        Screen('FrameRect', window, green, [xCenter+separation/2-16 yCenter-imageSize(2)/2-16 xCenter+separation/2+imageSize(1)+16 yCenter+imageSize(2)/2+16], 8);
        if leftProbabilityEXP2 < rightProbabilityEXP2
            scoreEXP2 = scoreEXP2 + 1;
            outcomeArrayEXP2(trialEXP2) = 1;
            rightOutcomesEXP2(trialEXP2) = 1;
            utility_ArrayEXP2(trialEXP2) = 1;
        else
            scoreEXP2 = scoreEXP2 - 1;
            outcomeArrayEXP2(trialEXP2) = 0;
            rightOutcomesEXP2(trialEXP2) = 0;
            utility_ArrayEXP2(trialEXP2) = -1;
        end
    end
    scoreArrayEXP2(trialEXP2) = scoreEXP2;

    trialend = Screen('Flip', window);
    Screen('Flip', window, trialend+blankDuration);

    %saving after every trial
    save(filenameEXP2MAIN, 'scoreEXP2', 'elapsed_timeEXP2', 'left_imagesEXP2', 'right_imagesEXP2', 'left_probabilityEXP2', 'right_probabilityEXP2', 'selected_probabilityEXP2', 'selected_imageEXP2', 'selected_sideEXP2', 'trialRunsEXP2', 'trialIconsEXP2', 'trialPiechartProbsEXP2', 'trialPiechartTypesEXP2', 'outcomeArrayEXP2', 'leftOutcomesEXP2', 'rightOutcomesEXP2', 'clicksArrayEXP2', 'utility_ArrayEXP2', 'scoreArrayEXP2')

    if ~mod(trialEXP2,40)
        Screen('DrawText',window,'Please take a short break',60,60,black);
        Screen('DrawText',window,'Please wait 2 seconds and press space to begin new block.',60,180,black);
        Screen('Flip',window);
        WaitSecs(2);
        while 1
            [keyDown, ~, keyCodes] = KbCheck;
            if keyDown
                if keyCodes(spacekey)
                    break;
                end
            end
        end
        while keyCodes(spacekey)
            [~, ~, keyCodes] = KbCheck;
        end
    end
end

% Display the final score
finalScoreMessage = ['Overall you won', num2str(scoreEXP2), 'points! Congrats! \n Press space to continue to the final task'];
DrawFormattedText(window, finalScoreMessage, 'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;

selectedImagesFromPartsEXP2 = iconsEXP2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  Experiment Phase: Slider - Task  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Slider task
% Instructions
line91 = 'MAIN EXPERIMENT: Instructions for the third task:';
line92= '\n\n  In each trial of the third task you will be presented with the symbols and pie-charts you met in the first and second tasks.';
line94 = '\n\n\n   1.You will be asked to indicate (in percentage), what are the odds that a given symbol or pie-chart makes you win a point.';
line95 = '\n\n\n   2.There will be a scale below the slider through which you can indicate the confidence you have in your estimation of the above probability:';
line96 = '\n\n\n   1 means you are not at all sure what the probability is and 5 means you are absolutely sure,';
line97 = '\n\n\n   You can move the sliders on screen with the mouse cursor and then click on the confidence rating that feels appropriate';
line98 = '\n\n\n   Once you are satisfied with your response, please press the space bar to continue..';
DrawFormattedText(window, [line91 line92 line94 line95 line96 line97 line98],...
    'center', screenYpixels * 0.25, black);
Screen('Flip', window);
KbStrokeWait;

% Initialize centeredRect for Slider 1 to a random position
sx = xCenter + (rand * 2 - 1) * sliderHLengthPix;
centeredRect = CenterRectOnPointd(baseRect, sx, yCenter + sliderHLengthPix * 0.6);

numTrialsSliderEXP = 6;
selectedImageNameSliderEXP = cell(numTrialsSliderEXP, 1);
sliderResponsesArrayEXP = cell(numTrialsSliderEXP, 1);
confidenceLevelsArrayEXP = zeros(numTrialsSliderEXP, 1);
selectedImageNamesArrayEXP = cell(numTrialsSliderEXP, 1);

filenameSliderResponsesEXP = ['Data', filesep, 'participant', num2str(participant), '_SliderResponsesEXP_', num2str(randomNumber), '.mat'];

for trial = 1:numTrialsSliderEXP
    selectedImageIdxSliderEXP = randi(numel(selectedImagesFromPartsEXP2));                                               %  random index between 1 and the number of elements in the selectedImagesFromPartsTEST cell array, index is used to randomly select an image name.
    selectedImageNameSliderEXP{trial} = selectedImagesFromPartsEXP2{selectedImageIdxSliderEXP};                         % Assigns the selected image name to the selectedImageNameSliderTEST array at the current trial index.
    selectedImageSliderEXP = allImagesEXP{strcmp(allImageNamesEXP, selectedImageNameSliderEXP{trial})};                                                        % Retrieves the selected image data from the allImagesTEST cell array based on the found index.
    selectedImagesFromPartsEXP2(selectedImageIdxSliderEXP) = [];                                                         % reomves it from the array to avoid repetition of samw image
    imgTex = Screen('MakeTexture', window, selectedImageSliderEXP);

    [imageHeight, imageWidth, ~] = size(selectedImageSliderEXP);
    imageRect = [0, 0, imageWidth, imageHeight];
    imageDestinationRect = CenterRectOnPointd(imageRect, xCenter, yCenter - imageHeight/8);                               % imageHeight/8 will move the image slightly up to fit the slider task outline

    currentPercentageEXP = -1;
    selectedConfidenceEXP = 0;

    while true
        Screen('DrawTexture', window, imgTex, [], imageDestinationRect);
        [mx, my, buttons] = GetMouse(window);
        if buttons(1)
            while buttons(1)
                [mx, my, buttons] = GetMouse(w);
            end
            if mx >= slider1LeftBound && mx <= slider1RightBound && my >= slider1TopBound && my <= slider1BottomBound         % condition checks if the mouse cursor is within the bounds, the region where the slider can be interacted with.
                % Draw Slider 1
                sx = mx;
                if sx > xCenter + sliderHLengthPix
                    sx = xCenter + sliderHLengthPix;
                elseif sx < xCenter - sliderHLengthPix
                    sx = xCenter - sliderHLengthPix;
                end
                centeredRect = CenterRectOnPointd(baseRect, sx, yCenter + sliderHLengthPix * 0.6);
            elseif mx >= slider1LeftBound && mx <= slider1RightBound && my >= bottomY-20 && my <= bottomY+20         % condition checks if the mouse cursor is within the bounds, the region where the slider can be interacted with.
                inCircles = sqrt((xPosScalePoints2 - mx).^2 + (yPosScalePoints2 - my).^2) < hDim;
                weInCircle = sum(inCircles) > 0;
                if weInCircle == 1
                    [~, posCircle] = max(inCircles);
                    coordsCircle = xyScalePoints2(:, posCircle);
                    selectedConfidenceEXP = posCircle;                                                                               % Store the selected confidence level
                end
            end
        end
        Screen('DrawLines', window, sliderLineCoords, sliderLineWidth, black);
        Screen('FillRect', window, yellowTransp, centeredRect);
        Screen('FrameRect', window, green, centeredRect);

        DrawFormattedText(window, sliderLabels{1}, leftTextPosX2+50, aboveSliderPosY2, blue);
        DrawFormattedText(window, sliderLabels{2}, rightTextPosX2, aboveSliderPosY2, red);
        DrawFormattedText(window, 'What are the odds that this symbol yields +1 points?', 'center', screenYpixels * 0.25, black);
        currentPercentageEXP = round((sx - (xCenter - sliderHLengthPix)) / sliderLengthPix * 100);
        DrawFormattedText2(['<size=30><color=000000><b>',num2str(currentPercentageTEST),'%'], 'win',window,'sx','center', 'sy', aboveSliderPosY2-20);

        % Draw Slider 2
        Screen('DrawLines', window, scaleLineCoords2, scaleLineWidth, grey);

        % labels for 'very certain' and 'very uncertain'
        DrawFormattedText(window, leftLabel, xCenter - scaleHLengthPix - textSize * 10, textPosY2, black);
        DrawFormattedText(window, rightLabel, xCenter + scaleHLengthPix, textPosY2, black);

        if selectedConfidenceEXP ~= 0
            Screen('FrameOval', window, grey, [coordsCircle - dim * 0.8; coordsCircle + dim * 0.8], 2);
        end
        for i = 1:numScalePoints2
            Screen('FillOval', window, black, [xPosScalePoints2(i) - hDim, yPosScalePoints2(i) - hDim, xPosScalePoints2(i) + hDim, yPosScalePoints2(i) + hDim]);
        end
        for thisNumSliderEXP = 1:numScalePoints2
            DrawFormattedText(window, num2str(thisNumSliderEXP), xNumText2(thisNumSliderEXP), yNumText2(thisNumSliderEXP), black);
        end
        Screen('Flip', window);

        % is space bar pressed
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if keyCodes (quitkey)
                ListenChar(1);
                ShowCursor;
                sca;
                return;
            elseif keyCode(spacekey) && currentPercentageEXP ~= -1 && selectedConfidenceEXP ~= 0
                break;
            end
        end
    end

    sliderResponsesArrayEXP{trial} = currentPercentageEXP;
    confidenceLevelsArrayEXP(trial) = selectedConfidenceEXP;
    selectedImageNamesArrayEXP{trial} = selectedImageNameSliderEXP{trial};
    %     WaitSecs(blankDuration);
    save(filenameSliderResponsesEXP, 'sliderResponsesArrayEXP', 'confidenceLevelsArrayEXP', 'selectedImageNamesArrayEXP');
end

%Let's say goodbye :)
endMessage = 'You survived! Thanks for participating. Please contact the experimenter.';
DrawFormattedText(window, endMessage, 'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
ListenChat(1);
sca;
