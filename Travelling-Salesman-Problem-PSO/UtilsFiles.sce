function [coords, dist, citiesNumber] = LoadFiles(filename)
     if isempty(dir("dist"+filename)) | isempty(dir("coords"+filename)) then //Verifica se o arquivo existe no diretório
      [dist coords] = CalculaDist(filename);
    else 
        load("dist"+filename);
        load("coords"+filename);        
    end
    citiesNumber = size(dist,1); // Quantidade de Cidades
    coords = coords(:,2:3)';
endfunction

function [dist, coords] = CalculaDist(filename)
    dataset = fscanfMat(filename +".tsp"); 
    coords = dataset;
    
    //---Calculo da matriz de adjacencia baseada nas distancias entre as cidades --
    [l,c]=size(coords);
    d = zeros(l,l);
    for i=1:l;
       for j=1:l;
        d(i,j) = ((coords(i,2)-coords(j,2))^2+(coords(i,3)-coords(j,3))^2);
        dist(i,j) = sqrt(d(i,j));
        end
    end
    
    //--------------------Salva a matrix e as coordenadas em um arquivo ----------------------------
    filename = "dist"+ filename; 
    save (filename,dist);
    filename = "coords"+ filename; 
    save (filename,coords);

endfunction
