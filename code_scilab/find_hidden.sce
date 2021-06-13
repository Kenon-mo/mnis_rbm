//testowanie sieci neuronowej w celu znalezienia ukrytych neuronów
/*
    Assuming the RBM has been trained (so that weights for the network have been learned),
    run the network on a set of visible units, to get a sample of the hidden units.

    Parameters
    ----------
    data: A matrix where each row consists of the states of the visible units.

    Returns
    -------
    hidden_states: A matrix where each row consists of the hidden units activated from the visible
    units in the data matrix passed in.
*/
user =[0,0,0,1,1,0;0,0,0,1,1,0;0,0,0,1,1,0;0,0,0,1,1,0]
//user =[1,1,1,1,1,1;0,0,0,1,1,1;1,0,1,0,1,0;0,0,0,0,0,0]
[num_examples_user, n2] = size(user)

    /*Create a matrix, where each row is to be the hidden units (plus a bias unit)
    sampled from a training example.*/
hidden_states = ones(num_examples_user, num_hidden + 1)

//Insert bias units of 1 into the first column of data.
user=[ones(num_examples_user,1) user]

//Calculate the activations of the hidden units.
hidden_activations = user * weights
//Calculate the probabilities of turning the hidden units on.
hidden_probs = sigm(hidden_activations)
//Turn the hidden units on with their specified probabilities.
hidden_states(:,:) = hidden_probs > rand(num_examples_user, num_hidden + 1,'uniform')
hidden_states(:,1)=[]
/*  Always fix the bias unit to 1.
    hidden_states(:,1) = 1*/
disp(hidden_states)
