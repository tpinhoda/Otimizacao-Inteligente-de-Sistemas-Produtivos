

//Reciprocal Exchange Mutation
//Sorteia duas cidades e as troca de lugar
function mutatedChromosome = ExchangeMutation(chromosome)
    if rand() <= mutationRate then
        cities = grand(1, 2, "uin", 1, citiesNumber);
        chromosome(cities) = chromosome([cities(1) cities(2)]);
    end
    mutatedChromosome = chromosome;
endfunction


//Inversion Mutation
//Sorteia dois pontos do caminho e inverte a ordem das cidades entre os dois pontos.
function mutatedChromosome = InversionMutation(chromosome)
    if rand() <= mutationRate then
        in = grand(1, 2, "uin", 1, citiesNumber);
        if in(2) < in(1) then in = in([2 1]); end
        chromosome(in(1):in(2)) = chromosome(in(2):-1:in(1));
     end
     mutatedChromosome = chromosome;
endfunction

function [mutatedGeneration] = Mutation(generation, mutationType)
    select mutationType
    case "Exchange"
        mutatedGeneration = parallel_run(generation', "ExchangeMutation", citiesNumber)'
    case "Inversion"
        mutatedGeneration = parallel_run(generation', "InversionMutation", citiesNumber)'
    end
endfunction
