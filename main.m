function[calcscatteringout,Energysol,solution,bestchi,eigenvector,Jplus,Jminus,Jx,Jy,Jz,allsol,chi,bestsol] = main(C20,C40,C44,C60,C64,h_mf,v_mf)
%KyleNd-LSCO
%calling the function


%total angular momentum found by Hund's rule for Er3+
J=9/2;

%iteration = length(C20).*length(C40).*length(C44).*length(C60).*length(C64);

%set down the temperature (in K)
%T = 5;

%boltzman constant in meV*K-1
%k=8.6173324*10^(-2);

[O20,O40,O44,O60,O64,Jx,Jy,Jz,Jplus,Jminus] = OperatorCuprate(J);

%experimental value for the energies of Nd-LSCO
Expenergy =        [12.21, 25.74, 46.88, 85.48];
UncExpenergy  =    [0.09 ,  0.06,  0.24,  1.26];
Expscattering =    [0.73 ,  1.00,  0.46, 0.045];
UncExpscattering = [0.02 ,  0.00,  0.04, 0.003];
%mean field switch
%h=0;
%compteur = 0;


bestchi = 1e99; %make sure that the first one will be lower than that.


counter=0;
step=1;
k20=-284/0.912;
k40=-344/(1.25e-2);
k60=-88/(2.09e-4);
k44=93/(-2.82e-2);
k64=104/(-2.77e-3);
allsol=[1,2,3,4,5,6,7];
chi=[0];
bestsol=[1,2,3,4,5,6,7];


 for B20 = min(C20):step:max(C20)
     for B40 = min(C40):step:max(C40)
         for B60 = min(C60):step:max(C60)
             for B44 = min(C44):step:max(C44)
                 for B64 = min(C64):step:max(C64)
                     for h=min(h_mf):0.1:(h_mf)
                         for v=min(v_mf):0.01:max(v_mf)
                        
                         counter=counter+1;
                            %compteur = compteur +1;
                            %if compteur == 1000000
                            %compteur = 0;
                            %bestchiMerlinlmao
                            %end
                            D20=B20/k20;
                            D40=B40/k40;
                            D60=B60/k60;
                            D44=B44/k44;
                            D64=B64/k64;
                            H=D20*O20+D40*O40+D60*O60+D44*O44+D64*O64+h*(Jx+Jy)/(sqrt(2))+v*Jz;

                            [eigenvector,SolveEnergy] = eig(H,'vector');
                            Energytemp = sort(SolveEnergy);
                            Energy = Energytemp + abs(min(SolveEnergy(:,1)));
                            CalcEnergy = [Energy(3,1),Energy(5,1),Energy(7,1),Energy(9,1)];
                            
                             scattering1=scattering_CEF(eigenvector(:,1),eigenvector(:,3),Jx,Jy,Jz)...
                                        +scattering_CEF(eigenvector(:,1),eigenvector(:,4),Jx,Jy,Jz);
                            
                            scattering2=scattering_CEF(eigenvector(:,1),eigenvector(:,5),Jx,Jy,Jz)...
                                        +scattering_CEF(eigenvector(:,1),eigenvector(:,6),Jx,Jy,Jz);
                            
                            scattering3=scattering_CEF(eigenvector(:,1),eigenvector(:,7),Jx,Jy,Jz)...
                                        +scattering_CEF(eigenvector(:,1),eigenvector(:,8),Jx,Jy,Jz); 
        
                            scattering4=scattering_CEF(eigenvector(:,1),eigenvector(:,9),Jx,Jy,Jz)...
                                       +scattering_CEF(eigenvector(:,1),eigenvector(:,10),Jx,Jy,Jz);
                            
                            %scattering6=scattering_CEF(eigenvector(:,1),eigenvector(:,9),Jx,Jy,Jz)...
                            %           +scattering_CEF(eigenvector(:,1),eigenvector(:,10),Jx,Jy,Jz);
                            
                            %scattering6=scattering_CEF(eigenvector(:,1),eigenvector(:,9),Jx,Jy,Jz)...
                            %            +scattering_CEF(eigenvector(:,1),eigenvector(:,10),Jx,Jy,Jz);%24meV
                            
                            %scattering7=scattering_CEF(eigenvector(:,1),eigenvector(:,9),Jx,Jy,Jz)...
                            %           +scattering_CEF(eigenvector(:,1),eigenvector(:,10),Jx,Jy,Jz);%26.76meV
                            
                            %scattering7=scattering_CEF(eigenvector(:,1),eigenvector(:,9),Jx,Jy,Jz)...
                            %           +scattering_CEF(eigenvector(:,1),eigenvector(:,10),Jx,Jy,Jz);  %93meV
                            
                             N=scattering2;        
                             s1=scattering1/N;
                             s2=scattering2/N;
                             s3=scattering3/N;
                             s4=scattering4/N;
                             %s5=scattering5/N;
                             %s6=scattering6/N;
                             %s7=scattering7/(scattering4+scattering3);
                             
                             
                             calcscattering=[s1,s2,s3,s4];
                             
                             chi2=0;
                             %Intensity
                             i=1;
                             while i<=4
                                 if UncExpscattering(1,i)==0
                                     i=i+1;       
                                 else
                                     chi2=chi2+((abs(calcscattering(1,i)-Expscattering(1,i))).^2)/(UncExpscattering(1,i).^2);
                                         i=i+1;
                                 end
                                 
                             end
                             %Energy
                             i=1;
                             while i<=4
                                 if UncExpenergy(1,i)==0
                                     i=i+1;       
                                 else
                                     chi2=chi2+((abs(CalcEnergy(1,i)-Expenergy(1,i))).^2)./(UncExpenergy(1,i).^2);
                                         i=i+1;
                                 end
                                 
                             end
                                 if chi2< bestchi
                                     solution(1,1)=B20;
                                     solution(1,2)=B40;
                                     solution(1,3)=B60;
                                     solution(1,4)=B44;
                                     solution(1,5)=B64;
                                     solution(1,6)=h;
                                     solution(1,7)=v;
                                     bestchi=chi2;
                                     bestsol=solution;
                                     Energysol=Energytemp+abs(min(SolveEnergy(:,1)));
                                     calcscatteringout=[s1,s2,s3,s4];                                     
                                 end
                                 if chi2 <2
                                     solution(1,1)=B20;
                                     solution(1,2)=B40;
                                     solution(1,3)=B60;
                                     solution(1,4)=B44;
                                     solution(1,5)=B64;
                                     solution(1,6)=h;
                                     solution(1,7)=v;
                                     allsol=[allsol;solution];
                                     chi=[chi;chi2];
                                 end
                                


                               
                         end
                     end
                 end
             end
         end
     end
 end
                                 
                                     
