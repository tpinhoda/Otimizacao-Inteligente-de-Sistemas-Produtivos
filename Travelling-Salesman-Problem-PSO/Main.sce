clear;
clc;
//-----------Carregar funcoes --------------------------------------------------
exec("UtilsFiles.sce");
exec("UtilsPso.sce");
exec("PSO.sce");


//----------Carrega parametros para os testes-----------------------------------
Tests = read_csv("testes.csv");

nTests = size(Tests,1)-1; //Quantidade de testes que será executado
nParams = 6;              //Quantidade de parãmetros de cada teste  
ntimes = 10;              //Quantidade de Execuções de cada teste  
times = zeros(nTests, ntimes)

//----------Inicio dos testes--------------------------------------------------
for testIt=1:nTests
    //------------------Carrega os parâmetros dos testes-----------------------
    for paramsIt=1:nParams
        params(paramsIt) = Tests(testIt+1,paramsIt)
    end
    finalMin = []
    //----------------Executa cada testes ntimes vezes-------------------------
    for timesIt=1:ntimes
        printf("Teste %d/%d - Execucao %d/%d\n",testIt,nTests,timesIt,ntimes);
        tic();
        //------------Chamada do PSO com os parametros do teste----------------
        hist = PSO(params(1),strtod(params(2)),strtod(params(3)),strtod(params(4)),strtod(params(5)),strtod(params(6)));
        finalMin = [finalMin min(hist)] //Guarda os melhores valores de cada execução
        times(testIt,timesIt) = toc();  //tempo
        mHist(:,timesIt) = hist(:);     //Guarda os resultados de cada iteração das execuções
        printf("%f s\n",times(testIt,timesIt));
    end
    standardDeviation(testIt) = stdev(finalMin); //calculo do desvio padrão dos melhores resultados obtidos nas ntimes execuções 
    meanAverage(testIt) = mean(finalMin);        //calculo da média dos melhores resultados obtidos nas ntimes execuções
    
    [minTest minInd] = min(finalMin);            //encontra a execução que obteve o melhor resultado
    mindist(testIt) = minTest;                   //quarda a menor distãncia de cada execução
    //---------------Plot da melhor execução-----------------------------------   
    fig = scf(testIt);
    plot2d(mHist(:,minInd));
    filename = "Plotsx/Teste"+string(testIt)+".png";
    xs2png(gcf(),filename);
    
    //--------------Guarda os resultados de cada teste-------------------------
    Tests(testIt+1,paramsIt+1) = string(standardDeviation(testIt));
    Tests(testIt+1,paramsIt+2) = string(meanAverage(testIt));
    Tests(testIt+1,paramsIt+3) = string(mindist(testIt));
    
end
//----------------Salva os resultados em um aquivo results.csv-----------------
csvWrite(Tests,"results.csv");
