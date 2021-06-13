//Testowanie sieci neuronowej w celu znalezienia ukrytych neuronów
//Algorytm działa tylko z wytrenowaną macierzą wag
user =[0,0,0,1,1,0;0,0,0,1,1,0;0,0,0,1,1,0;0,0,0,1,1,0]
//user =[1,1,1,1,1,1;0,0,0,1,1,1;1,0,1,0,1,0;0,0,0,0,0,0]
[num_examples_user, n2] = size(user)

//Zdefiniowanie macierzy ukrytych neurnów, która posiada tyle wierszy ile macierz wejściowa, a tyle kolumn ile liczba ukrytych cech neuronów + wektor biasów
hidden_states = ones(num_examples_user, num_hidden + 1)

//Wprowadzenie wartości biasów do danych testowych w celu poprawnej operacji mnożenia macieżowago z macierzą wag
user=[ones(num_examples_user,1) user]

//Obliczenie aktywacji ukrytych neuronów
hidden_activations = user * weights
//Obliczenie prawdopodobieństwa aktywacji przez funkcję sigmoid
hidden_probs = sigm(hidden_activations)

//Binarne obliczenie wartości ukrytych neuronów zgodnie z prawdopodobieństwem sigmoid
hidden_states(:,:) = hidden_probs > rand(num_examples_user, num_hidden + 1,'uniform')
hidden_states(:,1)=[]

//Poprawa wartości biasów do liczby 1
hidden_states(:,1) = 1

//Wyświetlenie wyników
disp(hidden_states)
