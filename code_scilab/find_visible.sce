//Testowanie sieci neuronowej w celu znalezienia widocznych neuronów
//Algorytm działa tylko z wytrenowaną macierzą wag
user =[0,0;0,1;1,0;1,1]

//Pozyskanie ilości wierszy z macierzy testowej
[num_examples_user, n2] = size(user)

//Zdefiniowanie macierzy widocznych neurnów, która posiada tyle wierszy ile macierz wejściowa, a tyle kolumn ile liczba widocznych cech neuronów + wektor biasów
visible_states = ones(num_examples_user,num_visible + 1)

//Wprowadzenie wartości biasów do danych testowych w celu poprawnej operacji mnożenia macieżowago z transponowaną macierzą wag
user=[ones(num_examples_user,1) user]

//Obliczenie aktywacji widocznych neuronów
visible_activations = user*weights'

//Obliczenie prawdopodobieństwa aktywacji przez funkcję sigmoid
visible_probs = sigm(visible_activations)

//Binarne obliczenie wartości widocznych neuronów zgodnie z prawdopodobieństwem sigmoid
visible_states(:,:) = visible_probs > rand(num_examples_user, num_visible + 1,'uniform')
visible_states(:,1)=[]

//Poprawa wartości biasów do liczby 1
visible_states(:,1) = 1
disp(visible_states)
