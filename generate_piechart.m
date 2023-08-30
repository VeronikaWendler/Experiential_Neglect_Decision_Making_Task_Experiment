function pieChartImg = generate_piechart(probability, type)
    figure('visible', 'off');
    colorIntensity = 0.7;
    colors = [colorIntensity,0,0; 0,colorIntensity,0];

    switch type
        case 1  % Garcia pie chart
            elements = 2;
            pieChart = pie([probability, 1-probability]);
            for el = 1:2:2*elements
                pieChart(el).FaceColor = colors(mod((el + 1) / 2, 2) + 1, :);
                pieChart(el).EdgeAlpha = 0;
            end
        case 2 % 3 win and 3 lose wedges of same size and equidistant
            elements = 6;
            wedgeWin = probability / 3;
            wedgeLose = (1 - probability) / 3;
            pieChart = pie(repmat([wedgeWin, wedgeLose], [1, 3]));
            for el = 1:2:2*elements
                pieChart(el).FaceColor = colors(mod((el + 1) / 2, 2) + 1, :);
                pieChart(el).EdgeAlpha = 0;
            end
        case 3 % 3 win and 3 lose wedges of different sizes and different distances
            elements = 6;

            proportionsWin = [0 0 0];
            proportionsLose = [0 0 0];

            while min(proportionsWin) < 0.2 | max(proportionsWin) > 0.8
                proportionsWin = rand(1, 3);
                proportionsWin = proportionsWin / sum(proportionsWin);
            end

            while min(proportionsLose) < 0.2 | max(proportionsLose) > 0.8
                proportionsLose = rand(1, 3);
                proportionsLose = proportionsLose / sum(proportionsLose);
            end

            probabilityWin1 = proportionsWin(1) * probability;
            probabilityLose1 = proportionsLose(1) * (1 - probability);

            probabilityWin2 = proportionsWin(2) * probability;
            probabilityLose2 = proportionsLose(2) * (1 - probability);

            probabilityWin3 = proportionsWin(3) * probability;
            probabilityLose3 = proportionsLose(3) * (1 - probability);

            pieChart = pie([probabilityWin1, probabilityLose1, probabilityWin2, probabilityLose2, probabilityWin3, probabilityLose3]);
            

            for el = 1:2:2*elements
                pieChart(el).FaceColor = colors(mod((el + 1) / 2, 2) + 1, :);
                pieChart(el).EdgeAlpha = 0;
            end
        case 4 % 3 nested pie charts of type 3
            pieChartImg1 = generate_piechart(probability, 3);
            pieChartImg2 = generate_piechart(probability, 3);
            pieChartImg = generate_piechart(probability, 3);

            pieChartImg1 = imresize(pieChartImg1, 0.75);
            pieChartImg2 = imresize(pieChartImg2, 0.5);

            width1 = length(pieChartImg1(1,:,1));
            height1 = length(pieChartImg1(:,1,1));

            width2 = length(pieChartImg2(1,:,1));
            height2 = length(pieChartImg2(:,1,1));

            width3 = length(pieChartImg(1,:,1));
            height3 = length(pieChartImg(:,1,1));


            pieChartImg1R = pieChartImg1(:,:,1);
            pieChartImg1G = pieChartImg1(:,:,2);
            pieChartImg1B = pieChartImg1(:,:,3);
            pieChartImg1IsWhite = uint8(pieChartImg1R > colorIntensity * 255 & pieChartImg1G > colorIntensity * 255 & pieChartImg1B > colorIntensity * 255);
            pieChartImg1IsNotWhite = uint8(pieChartImg1IsWhite == 0);

            pieChartImg2R = pieChartImg2(:,:,1);
            pieChartImg2G = pieChartImg2(:,:,2);
            pieChartImg2B = pieChartImg2(:,:,3);
            pieChartImg2IsWhite = uint8(pieChartImg2R > colorIntensity * 255 & pieChartImg2G > colorIntensity * 255 & pieChartImg2B > colorIntensity * 255);
            pieChartImg2IsNotWhite = uint8(pieChartImg2IsWhite == 0);


            pieChartImgMediumSquare = pieChartImg(height3 / 2 - height1 / 2:height3 / 2 + height1 / 2 - 1, width3 / 2 - width1 / 2:width3/ 2 + width1 / 2 - 1,:);
            pieChartImg(height3 / 2 - height1 / 2:height3 / 2 + height1 / 2 - 1, width3 / 2 - width1 / 2:width3/ 2 + width1 / 2 - 1,:) = pieChartImg1IsNotWhite.*pieChartImg1 + pieChartImg1IsWhite.*pieChartImgMediumSquare;

            pieChartImgSmallSquare = pieChartImg(height3 / 2 - height2 / 2:height3 / 2 + height2 / 2 - 1, width3 / 2 - width2 / 2:width3/ 2 + width2 / 2 - 1,:);
            pieChartImg(height3 / 2 - height2 / 2:height3 / 2 + height2 / 2 - 1, width3 / 2 - width2 / 2:width3/ 2 + width2 / 2 - 1,:) = pieChartImg2IsNotWhite.*pieChartImg2 + pieChartImg2IsWhite.*pieChartImgSmallSquare;
    end

    if type ~= 4

        delete(findobj(pieChart,'Type','text'));
        pieChartImg = print('-RGBImage');

        pieChartImgR = pieChartImg(:,:,1);
        pieChartImgG = pieChartImg(:,:,2);
        pieChartImgB = pieChartImg(:,:,3);

        pieChartIndices = (pieChartImgR < colorIntensity * 255 & pieChartImgG < colorIntensity * 255 & pieChartImgB < colorIntensity * 255);

        pieChartImgR(pieChartIndices) = 255;
        pieChartImgG(pieChartIndices) = 255;
        pieChartImgB(pieChartIndices) = 255;

        pieChartImg(:,:,1) = pieChartImgR;
        pieChartImg(:,:,2) = pieChartImgG;
        pieChartImg(:,:,3) = pieChartImgB;

        % find upper and lower limits of pieChart

        rowMinR = min(pieChartImgR, [], 2);
        rowMinG = min(pieChartImgG, [], 2);
        rowMinB = min(pieChartImgB, [], 2);

        rowNotWhite = ~(rowMinR == 255 & rowMinG == 255 & rowMinB == 255);
        notWhiteRows = find(rowNotWhite);
        upper_y = min(notWhiteRows);
        lower_y = max(notWhiteRows);


        colMinR = min(pieChartImgR, [], 1);
        colMinG = min(pieChartImgG, [], 1);
        colMinB = min(pieChartImgB, [], 1);

        colNotWhite = ~(colMinR == 255 & colMinG == 255 & colMinB == 255);
        notWhiteCols = find(colNotWhite);
        upper_x = min(notWhiteCols);
        lower_x = max(notWhiteCols);

        % crop the piechart to the limits
        pieChartImg = pieChartImg(upper_y:lower_y, upper_x:lower_x, :);

    end


    height = length(pieChartImg(:,1,1));
    width = length(pieChartImg(1,:,1));

    centreX = width / 2;
    centreY = height / 2;

    circleRadius = width / 8;

    for y = 1:height
        for x = 1:width
            if sqrt((x - centreX)^2 + (y - centreY)^2) <= circleRadius
                pieChartImg(y,x,:) = [255, 255, 255];
            end
        end
    end

    pieChartImg = imresize(pieChartImg, [400, 400]);
end