##################################################################
#### Um Roteiro para An�lise Discriminante no R #####
##################################################################

# Instalando Pacotes (Caso voce ainda n�o tenha no seu computador)
#install.packages("MASS")

## Carregando pacote na mem�ria do R Studio
library(MASS)



################### EXEMPLO 1 #################################
#Exemplo 1 - Aula 1 - Slide 24 - duas popula��es
# Prop : Grupos de interesse : Propriet�rios (1) N�o Proprier�rios (2)
# Vari�veis dispon�veis: Renda e Area da propridade
Renda = c(90.0,115.5,94.8,91.5,117.0,140.1,138.0,112.8,99.0,123.0,81.0,111.0,
          105.0,82.8,94.8,73.2,114.0,79.2,89.4,96.0,77.4,63.0,81.0,93.0)
Area = c(18.4,16.8,21.6,20.8,23.6,19.2,17.6,22.4,20.0,20.8,22.0,20.0,
         19.6,20.8,17.2,20.4,17.6,17.6,16.0,18.4,16.4,18.8,14.0,14.8)
Prop = c(rep(1, 12), rep(0, 12))
Ex1 = data.frame(renda, area, prop)



# Estimando a fun��o discriminante linear de Fischer
AD1 = lda(Prop ~ Area + Renda, data=Ex1) # Fun��o q calcula (supondo q os grupos tem a mesmas matrizes de var-cov)
AD1
# a fun�ao discriminate sera -0.3795*Area - 0.0484*renda
plot(AD1)

# como fazer predi��o (classifica��o)
library("tidyverse")
#install.packages("caret")
library("caret")

# Fazendo a previs�o 
P1 = AD1 %>% predict(Ex1) # previs�o 1
P1

P1$class      # Onde cada uma das observa��es de Ex1 foi classificada
P1$posterior  # Probabilidade da observa��o ser classficada nos grupos
P1$x          # Valor de cada observa��o na fun��o discriminante

# Da para selecionar casos de dificil classifica��o utilizando as propabilidades da P1$posteriori 


# Classificando as observa��es em teste
P1T = AD1 %>% predict(Teste1)  # TEste1 = dados que nao usou no modelo


# Avaliando a qualidade do modelo (AD1)
P1$class == Ex1$prop # Mostra quais casos houve um m�-classifica��o, FALSE = a primeira obs foi classificada de forma incorreta

Av = mean(P1$class == Ex1$prop)
print(Av)                       # Porcentagem de observa��e classificadas de forma corretas

# Tabela de classifica��o
table(Ex1$prop, P1$class, dnn = c("REAL", "Classifica��o"))
# interpreta��o da tabela: das 12 obseva��es do grupo 0, 10 foram classificadas corretamente, e 2 que eram do grupo 0 e foram classificadas erradas no grupo 1,
# interpreta��o da tabela: das 12 obseva��es do grupo 1, 11 foram classificadas corretamente, e 1 que eram do grupo 1 e foi classificada erradas no grupo 0,



## Matriz de Confus�o

Pr = P1$class
Obs = as.factor(Ex1$prop)

C1 = confusionMatrix(Pr, Obs)
print(C1)                       # medidas interessantes

#####################################################################################

# Calculando a fun�ao de discriminate quadratica (Caso as matrizes var-cov n�o sejem iguais)

DQ = qda(Prop ~ Area + Renda, data=Ex1)
print(DQ)

# n�o vai ter uma fun��o discriminate explicita
# Pode continuar com tudo oq foi apresentado na lda

#####################################################################################

########   EXEMPLO 2     #######
# Dados 
