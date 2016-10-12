
function[hist] = PSO(filename,particlesNumber,iterationNumber,pr1,pr2,pr3)
//responsável pela execução do PSO, recebe como entrada o nome do cojunto de dados a quantidade de partículas no enxame, a
// quantidadede iterações e as constantes de probabilidade pr1,pr2,pr3. Retorna os resultados obtidos em cada iteração

    //-----------Calculo das distantcias e carregamento do arquivo -------------   
    [coords dist citiesNumber] = LoadFiles(filename);   
    //---------- Inicializacao dos paramêtros----------------------------------- 
    [particlesPosition,localBestf,localBestParticles, globalBest, globalBestInd] = Initialize();
    //-----------Inicio das iterações-------------------------------------------
    for it=1:iterationNumber
    //-----------Calculo da velocidade e movimento da particula------------------    
        for particle = 1:particlesNumber
            movedParticle = MoveParticle(particlesPosition(particle,:),localBestParticles(particle,:),localBestParticles(globalBestInd,:),pr1,pr2,pr3);
            particlesPosition(particle,:) = movedParticle;
        end
    //----------Calculo do fitness das novas posições--------------------------    
        fitness = Fitness(particlesPosition);
    //----------Verificacao dos locais e do global-----------------------------    
        for particle = 1:particlesNumber
            if fitness(particle) < localBestf(particle) then
               localBestf(particle) = fitness(particle);
               localBestParticles(particle,:)= particlesPosition(particle,:);
               if fitness(particle) < globalBest then
                   globalBest = fitness(particle);
                   globalBestInd = particle;
               end
            end       
        end    
   //-----------Atualizacao das probabilidades---------------------------------     
//        pr1 = pr1*0.95; pr2 = pr2*1.01; pr3 = 1-(pr1+pr2);
        printf("it - %d - best - %f\n",it,globalBest);
        hist(it) = globalBest;           
    end
endfunction     



