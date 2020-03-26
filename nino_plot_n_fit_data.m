clear, close all
data_cases = csvread('covid19_cases_switzerland.csv',1,1);
data_deaths = csvread('covid19_fatalities_switzerland.csv',1,1);

cases = data_cases(:,end);
deaths = data_deaths(:,end);
days = 1:size(data_cases,1);


%% Fit exponential curve to cases
[xData, yData] = prepareCurveData( days, (cases)' );

% Set up fittype and options.
ft = fittype( '(a*2^(x/Td))' );
excludedPoints = excludedata( xData, yData, 'Domain', [1 15] );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [xData(1) 3];
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
fitresult.Td
CI = predint(fitresult,xData,0.95);

% Plot fit with data.
h=figure(1);
clf
subplot(2,1,1)
hold on
plot( fitresult, xData, yData,'ok', excludedPoints,'xk');
plot(  xData, CI,'k--' );
xlabel Days
ylabel Cases
grid on
title('Cases')
legend off

%% Fit exponential curve to deaths
[xData, yData] = prepareCurveData( days, deaths' );

% Set up fittype and options.
ft = fittype( 'a*2^(x/Td)' );
excludedPoints = excludedata( xData, yData, 'Range', [eps Inf] );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [xData(1) 3];
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
fitresult.Td
CI = predint(fitresult,xData,0.95);

% Plot fit with data.
subplot(2,1,2)
hold on
plot( fitresult, xData, yData,'ok', excludedPoints,'xk');
plot(  xData, CI,'k--' );
xlabel Days
ylabel Deaths
title('Deaths')
grid on
legend off