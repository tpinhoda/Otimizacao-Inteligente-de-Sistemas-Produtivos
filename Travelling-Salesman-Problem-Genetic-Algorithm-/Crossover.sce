
//Order Crossover Operator
function[child] = OrderOperator(parent1Index, parent2Index)
    
    mid = floor(citiesNumber/2);
    //Seleciona um subcaminho a ser mantido nos novos filhos
    crosspoint = [grand(1, 1, "uin", 1, mid) grand(1, 1, "uin", mid+1, citiesNumber-1)];
    parent = population([parent1Index parent2Index],:);
    child = parent;
    for c=1:2
        if c == 1, p = 2; else p = 1; end;
        indP = crosspoint(2);
        indC = indP;
        //A partir do segundo ponto de corte, os filhos recebem as arestas válidas
        // (ainda não presentes) na ordem em que estas aparecem nos pais.
        while indC <> crosspoint(1);
            if isempty(find(child(c, crosspoint(1):crosspoint(2)-1) == parent(p, indP))) then
                child(c,indC) = parent(p,indP);
                indC = modulo(indC, citiesNumber)+1;
            end
            indP = modulo(indP, citiesNumber)+1;
        end
    end
endfunction

//Sequential Construtive Crossover Operator
//Cria um filho a partir de dois pais.
function [child] = SCX(parent1Index, parent2Index)
    parent = population([parent1Index parent2Index],:);
    child(1) = parent(1,1); //O filho recebe a primeira cidade do primeiro pai
    //Para cada nova cidade adicionada no caminho filho, herda-se a aresta de melhor custo
    // que parte desssa cidade em algum dos pais. Se nenhum dos pais possui uma aresta válida
    // (que leva a uma cidade ainda não adicionada no caminho), então a primeira aresta válida
    // encontrada (que não está presente em nenhum dos pais) é adicionada.
    for childIt=1:size(parent,2)-1
        p1id = find(parent(1,:)==child(childIt));
        p2id = find(parent(2,:)==child(childIt));
        
        p1id = modulo(p1id,citiesNumber)+1;
        p2id = modulo(p2id,citiesNumber)+1;
       
        t1 = isempty(find(child==parent(1,p1id)));
        t2 = isempty(find(child==parent(2,p2id)));
        
        if  t1 & t2 then
            if dist(child(childIt),parent(1,p1id)) < dist(child(childIt),parent(2,p2id))  then
                child = [child parent(1,p1id)];
            else
                child = [child parent(2,p2id)];    
            end
        elseif t1
            child = [child parent(1,p1id)];
        elseif t2
            child = [child parent(2,p2id)];
        else
            c = 1;
            while ~isempty(find(child == c))
                c = c +1;
            end    
            child = [child c];
        end
    end
    //pause
endfunction

//Recebe uma lista com os indices dos membros da população a serem utilizados no
// crossover, o numero de filhos a serem gerados, e o tipo do crossover a ser 
// utilizado. Retorna uma lista de novos cromossomos.
function newGeneration = Crossover(selectedIndex, crossoverSize, crossoverType)
    newGeneration = [];
    selectedIndex = grand(1, "prm", selectedIndex)
    select crossoverType
    case "OX"
        for i=1:2:crossoverSize
            newGeneration=[newGeneration;OrderOperator(selectedIndex(i),selectedIndex(i+1))]
        end
    case "SCX"
        newGeneration=parallel_run([1:citiesNumber], [2:citiesNumber 1], "SCX", citiesNumber)'
    else
        printf("Tipo de Crossover inválido\n")
    end
endfunction
