

//--------------Recebe um caminho e retorna seu custo (somatório das distâncias
//--------------entre as cidades)----------------------------------------------
function pathDistance = CalculatePathDistance(path)
    pathDistance = 0;
        for i=1:citiesNumber-1;
            pathDistance = pathDistance + dist(path(i),path(i+1));           
        end  
        pathDistance = pathDistance + dist(path(1),path($));   
endfunction

//--------------Recebe uma matriz 'population' n x m (numero de cidades x 
//--------------tamanho da população) e retorna um vetor 'fitness' com tamanho
//--------------tamanho da população x 1 -------------------------------------
function [fitness, cost] = Fitness(population)
    cost = parallel_run(population', "CalculatePathDistance", 1);
    //fitness = 1 ./cost        //Inverso
    fitness = 1 ./cost
endfunction
