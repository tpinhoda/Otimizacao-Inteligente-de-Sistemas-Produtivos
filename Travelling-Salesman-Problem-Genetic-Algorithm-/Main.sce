clear
//-----------Carregar funcoes --------------------------------------------------
exec("CalculaDist.sce");
exec("Mutation.sce");
exec("Fitness.sce");
exec("Selection.sce");
exec("Crossover.sce");
exec("TSP.sce");

//----------Carrega parametros para os testes-----------------------------------
Tests = read_csv("testes.csv");

nTests = size(Tests,1)-1;
nParams = 8;
ntimes = 10;
times = zeros(nTests, ntimes)
for testIt=1:nTests
    
    for paramsIt=1:nParams
        params(paramsIt) = Tests(testIt+1,paramsIt)
    end
    finalMin = []
    for timesIt=1:ntimes
        printf("Teste %d/%d - Execucao %d/%d\n",testIt,nTests,timesIt,ntimes);
        tic();
        hist = TSP(params(1),strtod(params(2)),strtod(params(3)),strtod(params(4)),strtod(params(5)),params(6),params(7),params(8));
        finalMin = [finalMin min(hist)]
        times(testIt,timesIt) = toc();
        mHist(:,timesIt) = hist(:);
        printf("%f s\n",times(testIt,timesIt));
    end
    standardDeviation(testIt) = stdev(finalMin);
    meanAverage(testIt) = mean(finalMin);
    
    [minTest minInd] = min(finalMin);
    mindist(testIt) = minTest;
    fig = scf(testIt);
    plot2d(mHist(:,minInd));
    filename = "Plotsx/Teste"+string(testIt)+".png";
    xs2png(gcf(),filename);
    
    
    Tests(testIt+1,paramsIt+1) = string(standardDeviation(testIt));
    Tests(testIt+1,paramsIt+2) = string(meanAverage(testIt));
    Tests(testIt+1,paramsIt+3) = string(mindist(testIt));
    
end
csvWrite(Tests,"results.csv");
