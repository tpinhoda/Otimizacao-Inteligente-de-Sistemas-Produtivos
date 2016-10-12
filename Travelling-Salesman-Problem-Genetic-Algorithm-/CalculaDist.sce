
function [dist] = CalculaDist(filename)
    dataset = fscanfMat(filename +".tsp"); 
    dadosoriginais = dataset;
    
    //---Calculo da matriz de adjacencia baseada nas distancias entre as cidades --
    [l,c]=size(dadosoriginais);
    d = zeros(l,l);
    for i=1:l;
       for j=1:l;
        d(i,j) = ((dadosoriginais(i,2)-dadosoriginais(j,2))^2+(dadosoriginais(i,3)-dadosoriginais(j,3))^2);
        dist(i,j) = sqrt(d(i,j));
        end
    end
    
    //--------------------Salva a matrix em um arquivo----------------------------
    filename = "dist"+ filename; 
    save (filename,dist);

endfunction
