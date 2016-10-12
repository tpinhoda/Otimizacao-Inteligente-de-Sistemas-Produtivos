
function [history] = TSP(filename,popSizeMultiplier,elitismRate,mutationRate,iterations,crossoverSelectionType,crossoverType,mutationType)
    
//-----------Calculo das distantcias e carregamento do arquivo ----------------
    
    if isempty(dir("dist"+filename)) then //Verifica se o arquivo existe no diretório
      dist = CalculaDist(filename);
    elseif ~exists("dist" + filename)      //verifica a matrix dist existe no workspace
        load("dist"+filename)        
    end
    
    //----------Inicializacao dos paramêtros---------------------------------------
    citiesNumber = size(dist,1);           //Quantidade de cidades
    populationSize = citiesNumber*popSizeMultiplier;     //Tamanho da amostra populacional
    elitismSizeLimit = round(populationSize*elitismRate);  //Numero de cromossomos que serão copiados diretamente para a próxima geração
    crossoverSizeLimit = populationSize - elitismSizeLimit;  //Numero de filhos que serão gerados por crossover
    crossoverSizeLimit = crossoverSizeLimit + modulo(crossoverSizeLimit,2) //Ajuste do tamanho (mais simples se valor for par)
    elitismSizeLimit = elitismSizeLimit + (populationSize - elitismSizeLimit - crossoverSizeLimit) //Ajuste do t amanho (para preencher a população corretamente)
    
    
    //----------Gera populacao inicial--------------------------------------------
    population = grand(populationSize, "prm", (1:citiesNumber))
    
    history = []
    for it=1:iterations 
        //----------Calcular distancia para cada cromossomo--------------------------
        [fitness, pathDistance] = Fitness(population);
      
        minPath = min(pathDistance);
        history = [history minPath];
        printf("%d - %f\n",it,minPath);
        
        //---------Seleção dos cromossomos que serão mantidos na próxima geração------------
        selected = Selection(fitness, elitismSizeLimit, "Elitism");
        newPop = population(selected,:);
        
        //---------Seleção dos cromossomos que farão parte do cruzamento--------
        selected = Selection(fitness, crossoverSizeLimit, crossoverSelectionType);
        
        //---------Crossover----------------------------------------------------------
        newPop = [newPop;Crossover(selected, crossoverSizeLimit, crossoverType)];
        
        //---------Mutação-----------------------------------------------------
        newPop = Mutation(newPop, mutationType);
        population = newPop;        
    end

endfunction
