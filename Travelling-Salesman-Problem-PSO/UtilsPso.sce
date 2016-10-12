function[particlesPosition, localBestf,localBestParticles,globalBest,globalBestInd] = Initialize()
//  inicializa a população inicial, os melhores locais e o melhor global
    particlesPosition = grand(particlesNumber, "prm", (1:citiesNumber)); //Inicialização das posicoes inicias de cada partícula de forma aleatória
    localBestParticles = particlesPosition; //inicialização das posições dos melhores locais 
    localBestf = Fitness(particlesPosition);//inicialização das aptidões dos melhores locais
    [globalBest globalBestInd] = min(localBestf); //inicializaçcao da aptidao do melhor global e seu indice na matriz de posições dos melhores locais
endfunction

function[movedParticle] = MoveParticle(Xp,Lp,Gp,c1,c2,c3)
//    esta função recebe como parâmetros de entrada as posições de partícula x_p,pbest_p,gbest_p, e as probabilidades pr_1,pr_2,pr_3 
//    retorna a particula movimentada;
    Y1 = Invertion(Xp,c1); //Meta-Heristica para a partícula seguir o próprio caminho
    Y1 = removeCrossovers(Y1); //Busca local, remove os sub-caminhos que se intersectam
    Y2 = PathRelinking(Y1,Gp,c3); //Meta-heuristica para a particula seguir em direção ao melhor global
    movedParticle = PathRelinking(Y2,Lp,c2); //Meta-heurística para a particula seguir em direção ao melhor local
endfunction 
//--------------------Meta-Herísticas------------------------------------------
function [X] = Invertion(X,c1)
//    Faz sucessivas inversões em uma dada partícula x_p com uma probabilidade pr_1 dessas inversões serem feitas, 
//    além de sempre checar a aptidão das novas partículas geradas a fim de sempre manter a  que possui melhor aptidão
    xFitness = Fitness(X); 
    for i=1:citiesNumber
        j = 1;
        while j+i <= citiesNumber
            if(rand() < c1) then
                newX = reverse(X,[j;j+i])
                newFitness = Fitness(newX);
                if(newFitness < xFitness) then
                    X = newX;
                    xFitness = newFitness;
                end    
            end    
            j = j+i+1;
        end         
    end
endfunction

function [Origin]= PathRelinking(Origin,Target,c)
//    Faz sucessivas trocas em uma partícula x_p, afim de movimentá-la em direção à uma particula x_best. 
//    Entretanto as trocas só são realizadas com base em uma probabilidade pr_2 e se a aptidão do novo x_p melhorar
    originFitness = Fitness(Origin);
    for indTarget=1:citiesNumber
        indOrigin = find(Origin == Target(indTarget));
        if(rand() < c) then
            newOrigin = Swap(Origin,[indTarget indOrigin]);
            newFitness = Fitness(newOrigin);
            if(newFitness < originFitness) then
                Origin = newOrigin;
                originFitness = newFitness;
            end    
        end    
    end    
endfunction

//------------------Funções Operacionais---------------------------------------
function swappedX = Swap(X,basicSwapSequence)
//Faz sucessivas trocas em uma partícula x_p baseadas em uma sequência de trocas dadas como parâmetro;    
    swappedX = X;
   
    for i=1:size(basicSwapSequence,1);
        aux = swappedX(basicSwapSequence(i,1));
        swappedX(basicSwapSequence(i,1)) = swappedX(basicSwapSequence(i,2));
        swappedX(basicSwapSequence(i,2)) = aux; 
    end
endfunction

function pathDistance = CalculatePathDistance(path)
//Calculo do fitness Recebe um caminho e retorna seu custo (somatório das distâncias
//entre as cidades)    
    pathDistance = 0;
        for i=1:citiesNumber-1;
            pathDistance = pathDistance + dist(path(i),path(i+1));           
        end  
        pathDistance = pathDistance + dist(path(1),path($));   
endfunction



function [fitness] = Fitness(population)
//Recebe uma matriz 'population' n x m (numero de cidades x tamanho da população)
// e retorna um vetor 'fitness' com tamanho //tamanho da população x 1    
    fitness = parallel_run(population', "CalculatePathDistance", 1);
endfunction

//-----------------Funcoes para remocao das linhas que intersectam-------------
function x = reverse(x, pairs)
//    Realiza um inversão em um sub-caminho de índices pairs = [i,j] de uma partícula x_p
    for p=pairs
        if p(1) > p(2) then
            p([1 2]) = p([2 1]);
        end
        x([p(1):p(2)]) = x([p(2):-1:p(1)]);
    end
endfunction

function on = onSegment(p, q, r)
// Verifica se um dado ponto r se encontra em uma reta limitada pelos pontos p e q
    if q(1)<=max([p(1) r(1)]) & q(1)>=min([p(1) r(1)]) & q(2)<=max([p(2) r(2)]) & q(2)>=min([p(2) r(2)]) then
        on=%T; //Se encontra na reta
    else
        on=%F; //Não se encontra na reta
    end
endfunction

function orientation = pointsOrientation(p, q, r)
// Verifica a orientação de três pontos $p,q,r$ se são colineares, ou estão em uma orientação horária ou anti-horária
    val = ((q(2)-p(2))*(r(1)-q(1)))-((q(1)-p(1))*(r(2)-q(2)));
    if val == 0 then
        orientation = 0; //colinear
    elseif val>0 then
        orientation = 1; //horário
    else
        orientation = 2; //anti-horário
    end
endfunction

function result = linesIntersect(p1, q1, p2, q2)
// Verifica se duas linhas cada uma limitada respectivamente pelos pares de pontos p1,q1, e p2,q2 se intersectam.
    o1 = pointsOrientation(p1, q1, p2);
    o2 = pointsOrientation(p1, q1, q2);
    o3 = pointsOrientation(p2, q2, p1);
    o4 = pointsOrientation(p2, q2, q1);
    result = %F; //Não se intersectam
    if (o1 <> o2 & o3 <> o4) then result = %T; end 
    if (o1 == 0 & onSegment(p1, p2, q1)) then result = %T; end
    if (o2 == 0 & onSegment(p1, q2, q1)) then result = %T; end
    if (o3 == 0 & onSegment(p2, p1, q2)) then result = %T; end
    if (o4 == 0 & onSegment(p2, q1, q2)) then result = %T; end
endfunction

function [path] = removeCrossovers(path)
// Dado uma partícula, esta função verifica se existem sub-caminhos que se 
// intersectam e então os remove fazendo uma inversão entre o segundo desse sub-caminho e o penúltimo.
    crossesFound = 0;
    for i=1:citiesNumber-4 //Começando da cidade I
        for j=i+2:citiesNumber-1 //até a cidade j
            if linesIntersect(coords(:,path(i)),coords(:,path(i+1)),coords(:,path(j)),coords(:,path(j+1))) then //verifica se os caminhos se intersectam
                path = reverse(path,[i+1;j]); //inverte o sub-caminho i+1 ate j para remover a intersecção
            end
        end
    end
    path = path([i:citiesNumber 1:i-1]);
endfunction
   
