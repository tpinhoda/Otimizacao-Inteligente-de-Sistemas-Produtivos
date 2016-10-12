//Retorna o indide dos "selectionSize" cromossomos com melhor aptidão.
function [selectedIndex] = ElitismSelection(fitness, selectionSize)
    [rankedPaths index] = gsort(fitness);
    selectedIndex = matrix(index(1:selectionSize),1,selectionSize);
endfunction

//Roleta.
//Fitness representa chance de parada na posição, e points são as posições de parada.
// Retorna length(points) indices onde a roleta parou.
function luckyOnes = Roulette(fitness, points)
    luckyOnes = [];
    for p = points
        ind = 1;
        sumFit = fitness(ind);
        while sumFit < p
            ind = ind+1;
            sumFit = sumFit + fitness(ind);
        end
        luckyOnes = [luckyOnes ind];
    end
endfunction

//Roulette Selection
function selectedIndex = RouletteSelection(fitness, selectionSize)
    sumFit = sum(fitness);
    selectedIndex = [];
    i = 1;
    while i <= selectionSize,
        r = grand(1, 1, "unf", 1, sumFit);
        ind = Roulette(fitness, r);
        if isempty(find(selectedIndex==ind)) then
            selected = [selectedIndex ind];
            i = i + 1;
        end    
    end
endfunction

//Stochastic Universal Sampling
function selectedIndex = StochasticUniversalSampl(fitness, selectionSize)
    sumFit = sum(fitness);
    pointsDist = sumFit/selectionSize;
    start = grand(1, 1, "unf", 0, pointsDist);
    points = ([0:selectionSize-1]*pointsDist)+start;
    selectedIndex = Roulette(fitness, points);
endfunction


function [selectedIndex] = Selection(fitness, selectionSize, selectionType)
    select selectionType
    case "Elitism"
        selectedIndex = ElitismSelection(fitness, selectionSize)
    case "Roulette"
        selectedIndex = RouletteSelection(fitness, selectionSize)
    case "Stochastic"
        selectedIndex = StochasticUniversalSampl(fitness, selectionSize)
    else
        printf("Tipo de seleção inválido. As opções disponíveis são:")
    end
    
endfunction
