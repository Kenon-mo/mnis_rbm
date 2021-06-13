/////////////////////////////////////////////////
// Deklaracje używanych funkcji
/////////////////////////////////////////////////

// Funkcja sigmoid
function sigmoid = sigm(x)
    sigmoid=1.0 ./ (1.0 + exp(-x))
endfunction

// Funkcja inicjalizująca macierz wag
function weights = weightsInit(num_hidden, num_visible)

        // Próg dolny
        low =   -0.1 * sqrt(6. / (num_hidden + num_visible))
        // Próg górny
        high=   0.1 * sqrt(6. / (num_hidden + num_visible))

        // Losowanie wag z zakresu <low, high> do macierzy
        weights_start = (high - low) * rand(num_visible, num_hidden, 'uniform') + low * ones(num_visible, num_hidden)

        // Dodanie wierszy / kolumn na bias
        weights = [ones(num_visible, 1) weights_start]
        weights = [ones(1, num_hidden+1); weights]

        // Wypełnianie zerami pierwszego wiersza i kolumny
        weights(:, 1) = 0
        weights(1, :) = 0
        disp(weights)

endfunction

// Funkcja znajdująca ukryte neurony
// Do funkcji przekazywana jest macierz z danymi użytkownika które chcemy przetestować
// Funkcja musi być użyta po wytrenowaniu algorytmu
function states = findHidden(user_input, num_hidden, weights)

    // Określenie ilości danych do przetestowania, które są uporządkowane wierszowo
    [num_examples, n2] = size(user_input)

    // Inicjalizacja macierzy na stany neuronów
    states = ones(num_examples, num_hidden + 1)

    // Dodawanie bias'u do pierwszej kolumny danych
    user_input = [ones(num_examples, 1) user_input]

    // Wyliczenie aktywacji
    activations = user_input * weights

    // Wyliczenie prawdopodobieństwa aktywacji
    probabilities = sigm(activations)

    // Decyzja czy dany neuron jest aktywny
    states(:,:) = probabilities > rand(num_examples, num_hidden + 1, 'uniform')
    hidden_states(:,1) = []

    disp("Hidden states:", states)

endfunction

/////////////////////////////////////////////////
// Przypisane zmiennych
/////////////////////////////////////////////////

// Liczba widocznych węzłów
num_visible = 6

// Liczba ukrytych węzłów
num_hidden = 2

// Macierz trenująca
training_data = [
                    1,1,1,0,0,0;
                    1,0,1,0,0,0;
                    1,1,1,0,0,0;
                    0,0,1,1,1,0;
                    0,0,1,1,0,0;
                    0,0,1,1,1,0
                ]

// Maksymalna ilość iteracji
max_epochs = 5000

// Wzpółczynnik uczenia
learning_rate=0.1

// Przypisywanie macierzy wag
weights = weightsInit(num_hidden, num_visible)

// Inicjalizacja zmiennych do wykresu
x=zeros(1,max_epochs)
y=zeros(1,max_epochs)

// Określenie ilości danych treningowych, które są uporządkowane wierszowo
[num_examples, n2] = size(training_data)

// Inicjalizacja danych treningowych
training_data = [ones(num_examples, 1), training_data]

/////////////////////////////////////////////////
// Trenowanie sieci neuronowej
/////////////////////////////////////////////////


for epoch=1:max_epochs

    // Dodatnia faza

    // Aktywacje węzłów ukrytych przez mnożenie macierzy danych treningowych i wag
    pos_hidden_activations = training_data * weights

    // Prawdopodobieństwo na aktywacje każdego ukrytego węzła
    pos_hidden_probs = sigm(pos_hidden_activations)

    // Poprawa kolumny biasów, żeby nie były zakłócone prawdopodobieństwem sigmoid
    pos_hidden_probs(:,1) = 1

    // Decyzja czy dany neuron jest aktywny
    pos_hidden_states = pos_hidden_probs > rand(num_examples,num_hidden + 1, 'uniform')

    // Mnożenie macierzowe mające na celu uzyskanie wag po dokonaniu obliczeń na postawie danych rzeczywistych
    pos_associations = training_data' * pos_hidden_probs

    // Ujemna faza

    // Aktywacje węzłów widocznych przez mnożenie ukrytych neuronów i transponowanej macierzy wag
    neg_visible_activations = pos_hidden_states * weights'

    // Prawdopodobieństwo na aktywacje każdego widocznego węzła
    neg_visible_probs = sigm(neg_visible_activations)

    // Poprawa kolumny biasów, żeby nie były zakłócone prawdopodobieństwem sigmoid
    neg_visible_probs(:, 1) = 1

    // Aktywacje węzłów ukrytych przez mnożenie wirtualnej macierzy widocznych neuronów i wag
    neg_hidden_activations = neg_visible_probs * weights

    // Prawdopodobieństwo na aktywacje każdego ukrytego węzła
    neg_hidden_probs = sigm(neg_hidden_activations)

    // Mnożenie macierzowe mające na celu uzyskanie wag po dokonaniu obliczeń na postawie danych wirtualnych
    neg_associations = neg_visible_probs' * neg_hidden_probs

    // Rozbierzność kontrastowa mająca na celu zaktualizowanie wag (CD-1)
    weights = weights + learning_rate * ((pos_associations - neg_associations) ./ num_examples)

    //Obliczenie błedu pomiędzy oryginalną widoczną macierzą (danymi treningowymi) a wirtualną widoczną macierzą uzyskąną przez ujemny gradient
    error_ = sum((training_data - neg_visible_probs).^2)

    // Przypisanie danych do wykresu
    x(1,epoch) = epoch
    y(1,epoch) = error_
end

// Wyświetl błąd i wykres
disp(error_)
disp(weights)
plot(x,y)
