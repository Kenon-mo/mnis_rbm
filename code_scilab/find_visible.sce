//testowanie sieci neuronowej w celu znalezienia widocznych neuronów
/*    """
    Assuming the RBM has been trained (so that weights for the network have been learned),
    run the network on a set of hidden units, to get a sample of the visible units.
    Parameters
    ----------
    data: A matrix where each row consists of the states of the hidden units.
    Returns
    -------
    visible_states: A matrix where each row consists of the visible units activated from the hidden
    units in the data matrix passed in.
    """*/
user =[0,0;0,1;1,0;1,1]
[num_examples_user, n2] = size(user)

/*  Create a matrix, where each row is to be the visible units (plus a bias unit)
    sampled from a training example.*/
visible_states = ones(num_examples_user,num_visible + 1)

//Insert bias units of 1 into the first column of data.
user=[ones(num_examples_user,1) user]

//Calculate the activations of the visible units.
visible_activations = user*weights'

//Calculate the probabilities of turning the visible units on.
visible_probs = sigm(visible_activations)

//Turn the visible units on with their specified probabilities.
visible_states(:,:) = visible_probs > rand(num_examples_user, num_visible + 1,'uniform')
visible_states(:,1)=[]
/*
    # Always fix the bias unit to 1.
    # visible_states(:,1) = 1*/
disp(visible_states)
